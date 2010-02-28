package eionet.eunis.rdfexporter;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.util.concurrent.CountDownLatch;

import junit.framework.TestCase;

import org.junit.Test;

/**
 * File writer test.
 * 
 * @author Aleksandr Ivanov <ahref="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class QueuedFileWriterTest extends TestCase {
	private static final String FILE_NAME = "test.txt";
	private QueuedFileWriter fileWriter;
	private CountDownLatch doneSignal;

	
	public void setUp(){
		doneSignal = new CountDownLatch(1);
		fileWriter = new QueuedFileWriter(FILE_NAME, "", "", doneSignal);
	}
	
	@Test
	public void testWrite() throws Exception {
		String testString = "testString11111)*(&";
		

		new Thread(fileWriter).start();

		ByteBuffer writeTask = ByteBuffer.wrap(testString.getBytes("UTF-8"));

		fileWriter.addTaskToWrite(writeTask);
		
		doneSignal.await();
		fileWriter.shutdown();

		File file = new File(FILE_NAME);

		FileChannel inChannel = new FileInputStream(file).getChannel();
		BufferedReader reader=new BufferedReader(Channels.newReader(inChannel, "UTF-8"));
		
		String line;
		while ((line = reader.readLine()) != null) {
		     assertEquals(testString, line);
		}
		reader.close();


		inChannel.close();
		file.delete();

	}

}
