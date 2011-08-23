package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.TaxonomyDto;

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

        List<Chm62edtTaxcodePersist> list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + idtaxonomy + "'");
        if (list != null && list.size() > 0) {
            Chm62edtTaxcodePersist taxonomy = list.get(0);

            TaxonomyDto dto = new TaxonomyDto();
            dto.setTaxonomyId(taxonomy.getIdTaxcode());
            dto.setLevel(taxonomy.getTaxonomicLevel());
            dto.setName(taxonomy.getTaxonomicName());
            dto.setLink(new ResourceDto(taxonomy.getIdTaxcodeLink(), "http://eunis.eea.europa.eu/taxonomy/"));
            dto.setParent(new ResourceDto(taxonomy.getIdTaxcodeParent(), "http://eunis.eea.europa.eu/taxonomy/"));
            dto.setSource(new ResourceDto(taxonomy.getIdDc().toString(), "http://eunis.eea.europa.eu/references/"));
            dto.setNotes(taxonomy.getNotes());

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
