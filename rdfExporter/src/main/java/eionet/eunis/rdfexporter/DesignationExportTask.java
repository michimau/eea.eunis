package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;

import eionet.eunis.rdf.GenerateDesignationRDF;

/**
 * Designation export task.
 * @author Risto Alt
 */
public class DesignationExportTask implements Runnable {

    private static final Logger logger = Logger.getLogger(DesignationExportTask.class);

    private static AtomicInteger designationsExported = new AtomicInteger();

    private String idDesig;
    private String idGeo;
    private QueuedFileWriter fileWriter;
    private StringBuffer rdf;

    public DesignationExportTask(String idDesig, String idGeo, QueuedFileWriter fileWriter) {
        this.idDesig = idDesig;
        this.idGeo = idGeo;
        this.fileWriter = fileWriter;
    }

    public void run() {

        try {
            rdf = new StringBuffer();
            GenerateDesignationRDF genRdf = new GenerateDesignationRDF(idDesig, idGeo);
            rdf.append(genRdf.getDesignationRdf());

            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            buffer.write("\n".getBytes("UTF-8"));
            ByteBuffer writeTask = ByteBuffer.wrap(rdf.toString().getBytes("UTF-8"));
            buffer.close();

            fileWriter.addTaskToWrite(writeTask);

            designationsExported.incrementAndGet();

            if (logger.isDebugEnabled()) {
                logger.debug("Exporting designation #" + designationsExported.get()
                        + " (ID_DESIGNATION = " + idDesig + ", ID_GEOSCOPE = " + idGeo + ")");
            }
        } catch (Exception e) {
            logger.error(e);
        }
    }

    public static int getNumberOfExportedDesignations() {
        return designationsExported.get();
    }

}
