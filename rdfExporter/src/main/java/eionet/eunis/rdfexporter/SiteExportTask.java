package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import eionet.eunis.dto.SiteFactsheetDto;
import eionet.eunis.rdf.GenerateSiteRDF;

/**
 * Site export task.
 * @author Risto Alt
 */
public class SiteExportTask implements Runnable {
    private static final Logger logger = Logger.getLogger(SiteExportTask.class);

    private static AtomicInteger sitesExported = new AtomicInteger();

    private String idsite;
    private QueuedFileWriter fileWriter;

    public SiteExportTask(String idsite, QueuedFileWriter fileWriter) {
        this.idsite = idsite;
        this.fileWriter = fileWriter;
    }

    public void run() {

        GenerateSiteRDF genRdf = new GenerateSiteRDF(idsite);
        SiteFactsheetDto dto = genRdf.getSiteRdf();
        if (dto != null) {
            Persister persister = new Persister(new AnnotationStrategy(), new Format(4));
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            try {
                persister.write(dto, buffer, "UTF-8");
                buffer.write("\n".getBytes("UTF-8"));
                ByteBuffer writeTask = ByteBuffer.wrap(buffer.toByteArray());
                buffer.close();

                fileWriter.addTaskToWrite(writeTask);
                sitesExported.incrementAndGet();

                if (logger.isDebugEnabled()) {
                    logger.debug("Exporting site #" + sitesExported.get() + " (ID_SITE = " + idsite + ")");
                }
            } catch (Exception e) {
                logger.error(e);
            }
        } else {
            logger.error("Site " + idsite + " not found");
            fileWriter.countDown();
        }
    }

    public static int getNumberOfExportedSites() {
        return sitesExported.get();
    }

}
