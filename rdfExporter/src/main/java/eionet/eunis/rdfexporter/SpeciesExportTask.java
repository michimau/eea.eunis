package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import eionet.eunis.dto.SpeciesFactsheetDto;
import eionet.eunis.rdf.GenerateSpeciesRDF;

/**
 * Species export task.
 *
 */
public class SpeciesExportTask implements Runnable {
    private static final Logger logger = Logger.getLogger(SpeciesExportTask.class);

    private static AtomicInteger speciesExported = new AtomicInteger();

    private String idspecies;
    private QueuedFileWriter fileWriter;

    public SpeciesExportTask(String idspecies, QueuedFileWriter fileWriter) {
        this.idspecies = idspecies;
        this.fileWriter = fileWriter;
    }

    public void run() {

        GenerateSpeciesRDF genRdf = new GenerateSpeciesRDF(new Integer(idspecies).intValue());
        SpeciesFactsheetDto dto = genRdf.getSpeciesRdf();
        if (dto != null) {
            Persister persister = new Persister(new AnnotationStrategy(), new Format(4));
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            try {
                persister.write(dto, buffer, "UTF-8");
                buffer.write("\n".getBytes("UTF-8"));
                ByteBuffer writeTask = ByteBuffer.wrap(buffer.toByteArray());
                buffer.close();

                fileWriter.addTaskToWrite(writeTask);
                speciesExported.incrementAndGet();

                if (logger.isDebugEnabled()) {
                    logger.debug("Exporting species #" + speciesExported.get() + " (ID_SPECIES = " + idspecies + ")");
                }
            } catch (Exception e) {
                logger.error(e);
            }
        } else {
            logger.error("Species " + idspecies + " not found");
            fileWriter.countDown();
        }
    }

    public static int getNumberOfExportedSpecies() {
        return speciesExported.get();
    }

}
