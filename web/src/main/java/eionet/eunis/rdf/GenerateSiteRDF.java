package eionet.eunis.rdf;

import org.apache.commons.lang.StringUtils;
import org.dozer.DozerBeanMapperSingletonWrapper;
import org.dozer.Mapper;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DatatypeDto;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SiteFactsheetDto;
import eionet.eunis.util.Constants;

public class GenerateSiteRDF {

    /** RDF header with namespaces. */
    public static final String HEADER = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:geo=\"http://www.w3.org/2003/01/geo/wgs84_pos#\"\n"
        + "xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"\n"
        + "xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">\n";

    private SiteFactsheet factsheet;
    private SiteFactsheetDto dto;

    public GenerateSiteRDF(String idsite) {
        this.factsheet = new SiteFactsheet(idsite);
    }

    public SiteFactsheetDto getSiteRdf() {
        try {
            if (factsheet != null && factsheet.exists()) {
                Mapper mapper = DozerBeanMapperSingletonWrapper.getInstance();
                dto = mapper.map(factsheet, SiteFactsheetDto.class);

                dto.setAttributes(DaoFactory.getDaoFactory().getSitesDao().getAttributes(factsheet.getSiteObject().getIdSite()));

                dto.setDcmitype(new ResourceDto("", "http://purl.org/dc/dcmitype/Text"));
                if (dto.getIdDc() != null && !"-1".equals(dto.getIdDc().getId())) {
                    dto.getIdDc().setPrefix("http://eunis.eea.europa.eu/references/");
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
                    dto.setArea(new DatatypeDto(factsheet.getSiteObject().getArea(), Constants.XSD_DECIMAL));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getLength())) {
                    dto.setLength(new DatatypeDto(factsheet.getSiteObject().getLength(), Constants.XSD_DECIMAL));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getLatitude())) {
                    dto.setLatitude(new DatatypeDto(factsheet.getSiteObject().getLatitude(), Constants.XSD_DECIMAL));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getLongitude())) {
                    dto.setLongitude(new DatatypeDto(factsheet.getSiteObject().getLongitude(), Constants.XSD_DECIMAL));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMin())) {
                    dto.setAltMin(new DatatypeDto(factsheet.getSiteObject().getAltMin(), Constants.XSD_INTEGER));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMax())) {
                    dto.setAltMax(new DatatypeDto(factsheet.getSiteObject().getAltMax(), Constants.XSD_INTEGER));
                }
                if (!StringUtils.isBlank(factsheet.getSiteObject().getAltMean())) {
                    dto.setAltMean(new DatatypeDto(factsheet.getSiteObject().getAltMean(), Constants.XSD_INTEGER));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }
}
