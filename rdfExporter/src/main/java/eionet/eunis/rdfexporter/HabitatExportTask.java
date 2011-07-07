package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;

import eionet.eunis.rdf.GenerateHabitatRDF;

/**
 * Habitat export task.
 * @author Risto Alt
 */
public class HabitatExportTask implements Runnable {

    private static final Logger logger = Logger.getLogger(HabitatExportTask.class);

    private static AtomicInteger habitatsExported = new AtomicInteger();

    private String idhabitat;
    private QueuedFileWriter fileWriter;
    private StringBuffer rdf;

    public HabitatExportTask(String idhabitat, QueuedFileWriter fileWriter) {
        this.idhabitat = idhabitat;
        this.fileWriter = fileWriter;
    }

    public void run() {

        try {
            rdf = new StringBuffer();
            GenerateHabitatRDF genRdf = new GenerateHabitatRDF(idhabitat);
            rdf.append(genRdf.getHabitatRdf());

            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            buffer.write("\n".getBytes("UTF-8"));
            ByteBuffer writeTask = ByteBuffer.wrap(rdf.toString().getBytes("UTF-8"));
            buffer.close();

            fileWriter.addTaskToWrite(writeTask);

            habitatsExported.incrementAndGet();

            if (logger.isDebugEnabled()) {
                logger.debug("Exporting habitat #" + habitatsExported.get() + " (ID_HABITAT = " + idhabitat + ")");
            }
        } catch (Exception e) {
            logger.error(e);
        }
    }

    public static int getNumberOfExportedHabitats() {
        return habitatsExported.get();
    }

}
