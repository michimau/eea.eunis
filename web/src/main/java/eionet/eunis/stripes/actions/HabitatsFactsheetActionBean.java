package eionet.eunis.stripes.actions;


import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectDomain;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.Utilities;
import eionet.eunis.dto.HabitatFactsheetOtherDTO;
import eionet.eunis.util.Pair;


/**
 * Action bean to handle habitats-factsheet functionality.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tietoenator.com">contact</a>
 */
@UrlBinding("/habitats/{idHabitat}/{tab}")
public class HabitatsFactsheetActionBean extends AbstractStripesAction {
	
    private String idHabitat = "";
		
    private static final String[] tabs = {
        "General information", "Geographical distribution", "Legal instruments", "Habitat types", "Sites", "Species", "Other info"
    };

    private static final String[][] dbtabs = {
        { "GENERAL_INFORMATION", "general"}, { "GEOGRAPHICAL_DISTRIBUTION", "distribution"}, { "LEGAL_INSTRUMENTS", "instruments"},
        { "HABITATS", "habitats"}, { "SITES", "sites"}, { "SPECIES", "species"}, { "OTHER", "other"}
    };
    
    private static final Integer[] dictionary = {
        HabitatsFactsheet.OTHER_INFO_ALTITUDE, HabitatsFactsheet.OTHER_INFO_DEPTH, HabitatsFactsheet.OTHER_INFO_CLIMATE,
        HabitatsFactsheet.OTHER_INFO_GEOMORPH, HabitatsFactsheet.OTHER_INFO_SUBSTRATE, HabitatsFactsheet.OTHER_INFO_LIFEFORM,
        HabitatsFactsheet.OTHER_INFO_COVER, HabitatsFactsheet.OTHER_INFO_HUMIDITY, HabitatsFactsheet.OTHER_INFO_WATER,
        HabitatsFactsheet.OTHER_INFO_SALINITY, HabitatsFactsheet.OTHER_INFO_EXPOSURE, HabitatsFactsheet.OTHER_INFO_CHEMISTRY,
        HabitatsFactsheet.OTHER_INFO_TEMPERATURE, HabitatsFactsheet.OTHER_INFO_LIGHT, HabitatsFactsheet.OTHER_INFO_SPATIAL,
        HabitatsFactsheet.OTHER_INFO_TEMPORAL, HabitatsFactsheet.OTHER_INFO_IMPACT, HabitatsFactsheet.OTHER_INFO_USAGE
    };
    private int dictionaryLength;
    
    private String btrail;
    private String pageTitle = "";
    private String metaDescription = "";
	
    private HabitatsFactsheet factsheet;
    private List<HabitatFactsheetOtherDTO> otherInfo = new ArrayList<HabitatFactsheetOtherDTO>();
	
    // selected tab
    private String tab;
    private boolean isMini;
    // tabs to display
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();
	
    // Sites tab variables
    private List<SitesByNatureObjectPersist> sites;
    private List<SitesByNatureObjectPersist> sitesForSubtypes;
    private String mapIds;
	
    /**
     * This action bean only serves RDF through {@link RdfAware}.
     */
    @DefaultHandler
    public Resolution defaultAction() {
		
        if (tab == null || tab.length() == 0) {
            tab = "general";
        }
		
        String eeaHome = getContext().getInitParameter("EEA_HOME");

        btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,factsheet";
        factsheet = new HabitatsFactsheet(idHabitat);
        // check if the habitat exists.
        if (factsheet.getHabitat() == null) {
            pageTitle = getContext().getInitParameter("PAGE_TITLE")
                    + getContentManagement().cmsPhrase(
                            "Sorry, no habitat type has been found in the database with Habitat type ID = ")
                            + "'"
                            + idHabitat
                            + "'";

            getContext().getResponse().setStatus(HttpServletResponse.SC_NOT_FOUND);
            return new ForwardResolution("/stripes/habitats-factsheet.layout.jsp");
        }
		
        // set metadescription and page title
        metaDescription = factsheet.getMetaHabitatDescription();
        pageTitle = getContext().getInitParameter("PAGE_TITLE") + getContentManagement().cmsPhrase("Factsheet for") + " "
                + factsheet.getHabitat().getScientificName();

        for (int i = 0; i < tabs.length; i++) {
            if (!getContext().getSqlUtilities().TabPageIsEmpy(factsheet.idNatureObject.toString(), "HABITATS", dbtabs[i][0])) {
                tabsWithData.add(new Pair<String, String>(dbtabs[i][1], tabs[i]));
            }
        }
		
        if (tab != null && tab.equals("sites")) {
            sitesTabActions();
        }
		
        if (tab != null && tab.equals("other")) {
            dictionaryLength = dictionary.length;
            if (factsheet.isEunis()) {
                for (int i = 0; i < dictionary.length; i++) {
                    try {
                        Integer dictionaryType = dictionary[i];
                        String title = factsheet.getOtherInfoDescription(dictionaryType);
                        String SQL = factsheet.getSQLForOtherInfo(dictionaryType);
                        String noElements = getContext().getSqlUtilities().ExecuteSQL(SQL);

                        if (title != null) {
                            HabitatFactsheetOtherDTO dto = new HabitatFactsheetOtherDTO();

                            dto.setTitle(title);
                            dto.setDictionaryType(dictionaryType);
                            dto.setNoElements(noElements);
                            otherInfo.add(dto);
                        }
						
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
		
        return new ForwardResolution("/stripes/habitats-factsheet.layout.jsp");
    }
	
    private void sitesTabActions() {
        String isGoodHabitat = " IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ";

        // Sites for which this habitat is recorded.
        sites = new SitesByNatureObjectDomain().findCustom(
                "SELECT DISTINCT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN "
                        + " FROM CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                        + " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT "
                        + " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " + " WHERE   " + isGoodHabitat
                        + " AND A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() + " AND C.SOURCE_DB <> 'EMERALD'"
                        + " ORDER BY C.ID_SITE");
	    
        // Sites for habitat subtypes.
        sitesForSubtypes = new SitesByNatureObjectDomain().findCustom(
                "SELECT DISTINCT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN "
                        + " FROM CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                        + " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT "
                        + " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " + " WHERE A.ID_NATURE_OBJECT ="
                        + factsheet.getHabitat().getIdNatureObject()
                        + (factsheet.isAnnexI()
                                ? " and right(A.code_2000,2) <> '00' and length(A.code_2000) = 4 AND if(right(A.code_2000,1) = '0',left(A.code_2000,3),A.code_2000) like '"
                                        + factsheet.getCode2000() + "%' and A.code_2000 <> '" + factsheet.getCode2000() + "'"
                                        : " AND A.EUNIS_HABITAT_CODE like '" + factsheet.getEunisHabitatCode()
                                        + "%' and A.EUNIS_HABITAT_CODE<> '" + factsheet.getEunisHabitatCode() + "'")
                                        + " AND C.SOURCE_DB <> 'EMERALD'"
                                        + " ORDER BY C.ID_SITE");
	    
        if ((null != sites && !sites.isEmpty()) || (null != sitesForSubtypes && !sitesForSubtypes.isEmpty())) {
            mapIds = "";
            int maxSitesPerMap = Utilities.checkedStringToInt(getContext().getInitParameter("MAX_SITES_PER_MAP"), 2000);

            if (sites.size() < maxSitesPerMap) {
                for (int i = 0; i < sites.size(); i++) {
                    SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sites.get(i);

                    mapIds += "'" + site.getIDSite() + "'";
                    if (i < sites.size() - 1) {
                        mapIds += ",";
                    }
                }
            }
        }
	    
    }
	
    public String getIdHabitat() {
        return idHabitat;
    }

    public void setIdHabitat(String idHabitat) {
        this.idHabitat = idHabitat;
    }

    public HabitatsFactsheet getFactsheet() {
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

    public boolean isMini() {
        return isMini;
    }

    public void setMini(boolean isMini) {
        this.isMini = isMini;
    }

    /**
     * @return the tabsWithData
     */
    public List<Pair<String, String>> getTabsWithData() {
        return tabsWithData;
    }

    public List<HabitatFactsheetOtherDTO> getOtherInfo() {
        return otherInfo;
    }

    public Integer[] getDictionary() {
        return dictionary;
    }

    public int getDictionaryLength() {
        return dictionaryLength;
    }

    public void setDictionaryLength(int dictionaryLength) {
        this.dictionaryLength = dictionaryLength;
    }

    public List<SitesByNatureObjectPersist> getSites() {
        return sites;
    }

    public void setSites(List<SitesByNatureObjectPersist> sites) {
        this.sites = sites;
    }

    public List<SitesByNatureObjectPersist> getSitesForSubtypes() {
        return sitesForSubtypes;
    }

    public void setSitesForSubtypes(
            List<SitesByNatureObjectPersist> sitesForSubtypes) {
        this.sitesForSubtypes = sitesForSubtypes;
    }

    public String getMapIds() {
        return mapIds;
    }

    public void setMapIds(String mapIds) {
        this.mapIds = mapIds;
    }

}
