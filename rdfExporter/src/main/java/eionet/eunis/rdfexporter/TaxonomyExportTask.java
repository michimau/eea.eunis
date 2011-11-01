package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import eionet.eunis.dto.TaxonomyDto;
import eionet.eunis.rdf.GenerateTaxonomyRDF;

/**
 * Taxonomy export task.
 *
 * @author altnyris
 */
public class TaxonomyExportTask implements Runnable {
    private static final Logger logger = Logger.getLogger(TaxonomyExportTask.class);

    private static AtomicInteger taxonomiesExported = new AtomicInteger();

    private String idtaxonomy;
    private QueuedFileWriter fileWriter;

    public TaxonomyExportTask(String idtaxonomy, QueuedFileWriter fileWriter) {
        this.idtaxonomy = idtaxonomy;
        this.fileWriter = fileWriter;
    }

    public void run() {

        GenerateTaxonomyRDF genRdf = new GenerateTaxonomyRDF(idtaxonomy);
        TaxonomyDto dto = genRdf.getTaxonomyRdf();

        if (dto != null) {
            Persister persister = new Persister(new AnnotationStrategy(), new Format(4));
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            try {
                persister.write(dto, buffer, "UTF-8");
                buffer.write("\n".getBytes("UTF-8"));
                ByteBuffer writeTask = ByteBuffer.wrap(buffer.toByteArray());
                buffer.close();

                fileWriter.addTaskToWrite(writeTask);
                taxonomiesExported.incrementAndGet();

                if (logger.isDebugEnabled()) {
                    logger.debug("Exporting taxonomy #" + taxonomiesExported.get() + " (ID_TAXONOMY = " + idtaxonomy + ")");
                }
            } catch (Exception e) {
                logger.error(e);
            }
        } else {
            logger.error("Taxonomy " + idtaxonomy + " not found");
            fileWriter.countDown();
        }
    }

    public static int getNumberOfExportedTaxonomies() {
        return taxonomiesExported.get();
    }

}
