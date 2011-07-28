package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dozer.DozerBeanMapperSingletonWrapper;
import org.dozer.Mapper;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DatatypeDto;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SiteFactsheetDto;

/**
 * Site export task.
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SiteExportTask implements Runnable {
    private static final Logger logger = Logger.getLogger(SiteExportTask.class);

    private static AtomicInteger sitesExported = new AtomicInteger();

    private String idsite;
    private QueuedFileWriter fileWriter;

    private static final String XSD_DECIMAL = "http://www.w3.org/2001/XMLSchema#decimal";
    private static final String XSD_INTEGER = "http://www.w3.org/2001/XMLSchema#integer";

    public SiteExportTask(String idsite, QueuedFileWriter fileWriter) {
        this.idsite = idsite;
        this.fileWriter = fileWriter;
    }

    public void run() {
        SiteFactsheet factsheet = new SiteFactsheet(idsite);
        if (factsheet.exists()) {
            Mapper mapper = DozerBeanMapperSingletonWrapper.getInstance();
            SiteFactsheetDto dto = mapper.map(factsheet, SiteFactsheetDto.class);

            dto.setAttributes(DaoFactory.getDaoFactory().getSitesDao().getAttributes(factsheet.getSiteObject().getIdSite()));

            dto.setDcmitype(new ResourceDto("", "http://purl.org/dc/dcmitype/Text"));
            if (dto.getIdDc() != null && !"-1".equals(dto.getIdDc().getId())) {
                dto.getIdDc().setPrefix("http://eunis.eea.europa.eu/documents/");
            } else {
                dto.setIdDc(null);
            }
            if (dto.getIdDesignation() != null && dto.getIdDesignation().getId() != null
                    && factsheet.getSiteObject().getIdGeoscope() != null) {
                String idDesig = dto.getIdDesignation().getId();
                Integer idGeo = factsheet.getSiteObject().getIdGeoscope();
                String newId = idGeo.toString() + ":" + idDesig;

                dto.getIdDesignation().setId(newId);
                dto.getIdDesignation().setPrefix("http://eunis.eea.europa.eu/designations/");
            } else {
                dto.setIdDesignation(null);
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getArea())) {
                dto.setArea(new DatatypeDto(factsheet.getSiteObject().getArea(), XSD_DECIMAL));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLength())) {
                dto.setLength(new DatatypeDto(factsheet.getSiteObject().getLength(), XSD_DECIMAL));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLatitude())) {
                dto.setLatitude(new DatatypeDto(factsheet.getSiteObject().getLatitude(), XSD_DECIMAL));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLongitude())) {
                dto.setLongitude(new DatatypeDto(factsheet.getSiteObject().getLongitude(), XSD_DECIMAL));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMin())) {
                dto.setAltMin(new DatatypeDto(factsheet.getSiteObject().getAltMin(), XSD_INTEGER));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMax())) {
                dto.setAltMax(new DatatypeDto(factsheet.getSiteObject().getAltMax(), XSD_INTEGER));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMean())) {
                dto.setAltMean(new DatatypeDto(factsheet.getSiteObject().getAltMean(), XSD_INTEGER));
            }
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
        }
    }

    public static int getNumberOfExportedSites() {
        return sitesExported.get();
    }

}
