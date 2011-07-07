package eionet.eunis.stripes.actions;


import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;
import org.dozer.DozerBeanMapperSingletonWrapper;
import org.dozer.Mapper;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DatatypeDto;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SiteFactsheetDto;
import eionet.eunis.util.Pair;
import eionet.eunis.util.SimpleFrameworkUtils;


/**
 * Action bean to handle sites-factsheet functionality.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/sites/{idsite}/{tab}")
public class SitesFactsheetActionBean extends AbstractStripesAction implements RdfAware {

    private static final String HEADER = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
            + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
            + "xmlns:geo=\"http://www.w3.org/2003/01/geo/wgs84_pos#\"\n"
            + "xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">\n";

    private static final String FOOTER = "\n</rdf:RDF>";

    private String idsite = "";
    private String mapType = "";
    private String zoom = "";

    private static final String[] tabs = {
        "General information", "Fauna and Flora", "Designation information",
        "Habitat types", "Related sites", "Other Info"
    };

    private static final String[][] dbtabs = {
        { "GENERAL_INFORMATION", "general"}, { "FAUNA_FLORA", "faunaflora"},
        { "DESIGNATION", "designations"}, { "HABITATS", "habitats"},
        { "SITES", "sites"}, { "OTHER", "other"}
    };

    private String btrail;
    private String pageTitle = "";
    private String metaDescription = "";

    private SiteFactsheet factsheet;

    private String sdb;

    // selected tab
    private String tab;
    // tabs to display
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();

    /**
     * This action bean only serves RDF through {@link RdfAware}.
     * @return Resolution
     */
    @DefaultHandler
    public Resolution defaultAction() {

        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        String eeaHome = getContext().getInitParameter("EEA_HOME");

        btrail = "eea#" + eeaHome
                + ",home#index.jsp,species#species.jsp,factsheet";
        factsheet = new SiteFactsheet(idsite);
        // set metadescription and page title
        if (factsheet.getIDNatureObject() != null) {
            metaDescription = factsheet.getDescription();
            pageTitle = getContext().getInitParameter("PAGE_TITLE")
                    + getContentManagement().cms("sites_factsheet_title") + " "
                    + factsheet.getSiteObject().getName();
        } else {
            pageTitle = getContext().getInitParameter("PAGE_TITLE")
                    + getContentManagement().cmsPhrase(
                            "No data found in the database for the site with ID = ")
                            + "'"
                            + factsheet.getIDSite()
                            + "'";
            try {
                getContext().getResponse().setStatus(
                        HttpServletResponse.SC_NOT_FOUND);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (factsheet.exists()) {

            for (int i = 0; i < tabs.length; i++) {
                if (!getContext().getSqlUtilities().TabPageIsEmpy(
                        factsheet.getSiteObject().getIdNatureObject().toString(),
                        "SITES", dbtabs[i][0])) {
                    tabsWithData.add(
                            new Pair<String, String>(dbtabs[i][1],
                            getContentManagement().cmsPhrase(tabs[i])));
                }
            }

            sdb = SitesSearchUtility.translateSourceDB(
                    factsheet.getSiteObject().getSourceDB());
        }
        return new ForwardResolution("/stripes/sites-factsheet.layout.jsp");
    }

    /**
     * @see eionet.eunis.stripes.actions.RdfAware#generateRdf()
     */
    public Resolution generateRdf() {
        SiteFactsheet factsheet = new SiteFactsheet(idsite);

        if (factsheet.exists()) {
            Mapper mapper = DozerBeanMapperSingletonWrapper.getInstance();
            SiteFactsheetDto dto = mapper.map(factsheet, SiteFactsheetDto.class);

            dto.setAttributes(
                    DaoFactory.getDaoFactory().getSitesDao().getAttributes(
                            factsheet.getSiteObject().getIdSite()));

            dto.setDcmitype(new ResourceDto("", "http://purl.org/dc/dcmitype/Text"));
            if (dto.getIdDc() != null && !"-1".equals(dto.getIdDc().getId())) {
                dto.getIdDc().setPrefix("http://eunis.eea.europa.eu/documents/");
            } else {
                dto.setIdDc(null);
            }
            if (dto.getIdDesignation() != null
                    && dto.getIdDesignation().getId() != null
                    && factsheet.getSiteObject().getIdGeoscope() != null) {
                String idDesig = dto.getIdDesignation().getId();
                Integer idGeo = factsheet.getSiteObject().getIdGeoscope();
                String newId = idGeo.toString() + ":" + idDesig;

                dto.getIdDesignation().setId(newId);
                dto.getIdDesignation().setPrefix(
                        "http://eunis.eea.europa.eu/designations/");
            } else {
                dto.setIdDesignation(null);
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getArea())) {
                dto.setArea(new DatatypeDto(factsheet.getSiteObject().getArea(), "http://www.w3.org/2001/XMLSchema#decimal"));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLength())) {
                dto.setLength(new DatatypeDto(factsheet.getSiteObject().getLength(), "http://www.w3.org/2001/XMLSchema#decimal"));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLatitude())) {
                dto.setLatitude(new DatatypeDto(factsheet.getSiteObject().getLatitude(), "http://www.w3.org/2001/XMLSchema#decimal"));
            }
            if (!StringUtils.isBlank(factsheet.getSiteObject().getLongitude())) {
                dto.setLongitude(new DatatypeDto(factsheet.getSiteObject().getLongitude(), "http://www.w3.org/2001/XMLSchema#decimal"));
            }
            return new StreamingResolution("application/rdf+xml",
                    SimpleFrameworkUtils.convertToString(HEADER, dto, FOOTER));
        } else {
            return new ErrorResolution(404);
        }
    }

    /**
     * @return the idsite
     */
    public String getIdsite() {
        return idsite;
    }

    /**
     * @param idsite the idsite to set
     */
    public void setIdsite(String idsite) {
        this.idsite = idsite;
    }

    /**
     * @return the factsheet
     */
    public SiteFactsheet getFactsheet() {
        return factsheet;
    }

    /**
     * @return the tabs
     */
    public String[] getTabs() {
        return tabs;
    }

    /**
     * @return the dbtabs
     */
    public String[][] getDbtabs() {
        return dbtabs;
    }

    /**
     * @return the sdb
     */
    public String getSdb() {
        return sdb;
    }

    /**
     * @return the btrail
     */
    public String getBtrail() {
        return btrail;
    }

    /**
     * @return the pageTitle
     */
    public String getPageTitle() {
        return pageTitle;
    }

    /**
     * @return the metaDescription
     */
    public String getMetaDescription() {
        return metaDescription;
    }

    /**
     * @return the tab
     */
    public String getTab() {
        return tab;
    }

    /**
     * @param tab the tab to set
     */
    public void setTab(String tab) {
        this.tab = tab;
    }

    /**
     * @return the tabsWithData
     */
    public List<Pair<String, String>> getTabsWithData() {
        return tabsWithData;
    }

    public String getMapType() {
        return mapType;
    }

    public void setMapType(String mapType) {
        this.mapType = mapType;
    }

    public String getZoom() {
        return zoom;
    }

    public void setZoom(String zoom) {
        this.zoom = zoom;
    }

}
