package eionet.eunis.rdfexporter;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

import org.apache.log4j.Logger;

/**
 * Worker for queued file writing.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class QueuedFileWriter implements Runnable {
    private static final Logger logger = Logger.getLogger(QueuedFileWriter.class);

    private List<ByteBuffer> queue = new LinkedList<ByteBuffer>();

    private String fileName;
    private String header;
    private String footer;
    private CountDownLatch doneSignal;

    private FileChannel channel;
    private Object finishedWriting = new Object();
    private boolean done;

    public QueuedFileWriter(String fileName, String header, String footer, CountDownLatch doneSignal) {
        this.fileName = fileName;
        this.header = header;
        this.footer = footer;
        this.doneSignal = doneSignal;

        init();
    }

    /**
     * Open new {@link FileChannel} and write header.
     */
    private void init() {
        try {
            channel = new RandomAccessFile(fileName, "rw").getChannel();
            channel.truncate(0L);
            channel.write(ByteBuffer.wrap(header.getBytes("UTF-8")));
        } catch (Exception e) {
            logger.error(e);
        }
    }

    /**
     * Add new write task to queue.
     *
     * @param task to write
     */
    public void addTaskToWrite(ByteBuffer task) {
        synchronized (queue) {
            queue.add(task);
            queue.notify();
        }
    }

    /**
     * Wait for new tasks in queue and write them to the file as they are added.
     */
    public void run() {
        ByteBuffer task;

        while(!done) {
            synchronized (queue) {
                if(queue.isEmpty()) {
                    try {
                        queue.wait();
                    } catch (InterruptedException e) {
                        logger.error(e);
                    }
                }

                if(done){
                    break;
                }

                task = queue.remove(0);
            }

            try {
                channel.write(task);
                synchronized (finishedWriting) {
                    //try to shutdown if needed
                    finishedWriting.notify();
                }
            } catch (IOException e) {
                logger.error(e);
            }

            doneSignal.countDown();
        }
    }

    /**
     * Count down
     */
    public void countDown() {
        doneSignal.countDown();
    }

    /**
     * Write footer and stop listening to the queue.
     */
    public void shutdown() {
        try {
            synchronized (finishedWriting) {
                while(!queue.isEmpty()) {
                    //there are unwritten tasks in queue, wait
                    finishedWriting.wait();
                }
            }

            channel.write(ByteBuffer.wrap(footer.getBytes("UTF-8")));
            channel.close();

            done = true;
            synchronized (queue) {
                //stop listening to the queue
                queue.notify();
            }
        } catch (Exception e) {
            logger.error(e);
        }
    }

}
