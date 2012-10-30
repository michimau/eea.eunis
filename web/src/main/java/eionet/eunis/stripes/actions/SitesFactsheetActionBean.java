package eionet.eunis.stripes.actions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletResponse;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.dto.PictureDTO;
import eionet.eunis.util.Pair;

/**
 * Action bean to handle sites-factsheet functionality.
 *
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/sites/{idsite}/{tab}")
public class SitesFactsheetActionBean extends AbstractStripesAction {

    /** Tab titles as displayed to the user. */
    private static final String[] TAB_TITLES = {"General information", "Fauna and Flora", "Designation information",
        "Habitat types", "Related sites", "Geographical information", "Other Info"};

    /**
     * The types of tabs this factsheet can have. Each tab has a name and the tab title displayed to the user.
     */
    private static final Map<String, String[]> TAB_TYPES = new LinkedHashMap<String, String[]>();

    /**
     * Static initializations block.
     */
    static {
        // Initialize the tab types. The value-arrays represent tab name-title pairs.
        TAB_TYPES.put("GENERAL_INFORMATION", new String[] {"general", TAB_TITLES[0]});
        TAB_TYPES.put("FAUNA_FLORA", new String[] {"faunaflora", TAB_TITLES[1]});
        TAB_TYPES.put("DESIGNATION", new String[] {"designations", TAB_TITLES[2]});
        TAB_TYPES.put("HABITATS", new String[] {"habitats", TAB_TITLES[3]});
        TAB_TYPES.put("SITES", new String[] {"sites", TAB_TITLES[4]});
        TAB_TYPES.put("GEO", new String[] {"geo", TAB_TITLES[5]});
        TAB_TYPES.put("OTHER", new String[] {"other", TAB_TITLES[6]});
    }

    /** The id of the site in question. */
    private String idsite = "";

    /** */
    private String mapType = "";
    private String zoom = "";

    /** Navigation breadcrumb trail. */
    private String btrail;

    /** */
    private String pageTitle = "";
    private String metaDescription = "";

    /** The factsheet data object. */
    private SiteFactsheet factsheet;

    /** The name of the source DB. */
    private String sourceDbName;

    /** The currently selected tab's name. */
    private String tab;

    /** Tabs to display. */
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();

    /** The site's main picture displayed on the "general" tab. A site may or may not have such a picture. */
    private PictureDTO pic;

    /** This site's compilation date and format that are displayed on the general tab. */
    private String compilationDateDisplayValue;
    private String compilationDateFormat;

    /** This site's update date and format that are displayed on the general tab. */
    private String updateDateDisplayValue;
    private String updateDateFormat;

    /** The site's proposed-date as displayed on the general tab */
    private String dateProposedDisplayValue;

    /** The site's confirmed-date as displayed on the general tab */
    private String dateConfirmedDisplayValue;

    /** The site's designation date as displayed on the general tab */
    private String siteDesignationDateDisplayValue;

    /** The site's designations list. May be null or empty. */
    private List designations;

    /** The site's designations if is Natura2000 site and type "C". */
    private List chm62edtDesignations;

    /** The available region codes. */
    private List regionCodes;

    /** The site's external links. */
    private ArrayList<LinkDTO> links;

    /**
     * The map indicating the bio-regions that this site belongs into. If the map has a key-value pair where the key is a
     * bio-region name and the value is not null, it means the site belongs into that bio-region.
     */
    private Map<String, Object> bioRegionsMap;

    /** The site's longitude and latitude formatted for display. */
    private String longitudeFormatted;
    private String latitudeFormatted;

    /** */
    private Chm62edtCountryPersist countryObject;

    /**
     * The default event handler of this action bean. Note that this action bean only serves RDF through {@link RdfAware}.
     *
     * @return Resolution
     */
    @DefaultHandler
    public Resolution defaultAction() {

        // If not currently selected tab name provided, assign the default.
        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        // Get EEA's home page URL from servlet context.
        String eeaHomePageUrl = getContext().getInitParameter("EEA_HOME");

        // Initialize the navigation breadcrumb trail.
        btrail = "eea#" + eeaHomePageUrl + ",home#index.jsp,species#species.jsp,factsheet";

        // Construct the factsheet data object for the given site.
        factsheet = new SiteFactsheet(idsite);

        // Set the site's meta-description and page title.
        if (factsheet.getIDNatureObject() != null) {
            metaDescription = factsheet.getDescription();
            pageTitle =
                    getContext().getInitParameter("PAGE_TITLE") + getContentManagement().cmsPhrase("Site factsheet for") + " "
                            + factsheet.getSiteObject().getName();
        } else {
            pageTitle =
                    getContext().getInitParameter("PAGE_TITLE")
                    + getContentManagement().cmsPhrase("No data found in the database for the site with ID = ") + "'"
                    + factsheet.getIDSite() + "'";
            try {
                getContext().getResponse().setStatus(HttpServletResponse.SC_NOT_FOUND);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // If the given site exists in the database.
        if (factsheet.exists()) {

            // Get the tab pages existing for this site object.
            SQLUtilities sqlUtilities = getContext().getSqlUtilities();
            String siteNatureObjectId = factsheet.getSiteObject().getIdNatureObject().toString();
            List<String> existingTabs = sqlUtilities.getExistingTabPages(siteNatureObjectId, "SITES");

            // Should it be that no tabs were found from database, ensure that at least the currently requested tab
            // header is shown.
            if (existingTabs.isEmpty()){
                existingTabs.add(getCurrentTabType());
            }

            // Decide which of the existing tabs to actually display to the user.
            for (String tabType : TAB_TYPES.keySet()) {
                if (existingTabs.contains(tabType) || (tabType.equals("GEO") && isTypeNatura2000())) {

                    String[] tabNameTitlePair = TAB_TYPES.get(tabType);
                    String tabName = tabNameTitlePair[0];
                    String tabTitle = tabNameTitlePair[1];

                    tabsWithData.add(new Pair<String, String>(tabName, getContentManagement().cmsPhrase(tabTitle)));
                }
            }

            // Initialize the source DB name of this site object.
            sourceDbName = SitesSearchUtility.translateSourceDB(factsheet.getSiteObject().getSourceDB());

            // Populates the data that the selected tab needs to display.
            prepareSelectedTabData();

        }

        // Forward to the factsheet layout page.
        return new ForwardResolution("/stripes/sites-factsheet.layout.jsp");
    }

    /**
     *
     * @return
     */
    private String getCurrentTabType(){

        String currentTab = tab == null ? "general" : tab;
        for (Entry<String, String[]> entry : TAB_TYPES.entrySet()) {
            String[] value = entry.getValue();
            if (value[0].equals(currentTab)){
                return entry.getKey();
            }
        }

        return null;
    }

    /**
     * Prepares the data that the selected tab needs to display.
     */
    private void prepareSelectedTabData() {

        if (tab != null && tab.equals("general")) {
            prepareGeneralTab();
        }
    }

    /**
     * Prepares the data displayed on the general tab.
     */
    private void prepareGeneralTab() {

        // Prepare country object
        String countryNameEnglish = factsheet.getCountry();
        if (countryNameEnglish != null && countryNameEnglish.length() > 0){
            countryObject = CountryUtil.findCountry(countryNameEnglish);
        }

        // Set the site's "main" picture displayed in the factsheet's general tab.
        // A site may or may not have such a picture.
        String picturePath = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SITES");
        pic = factsheet.getMainPicture(picturePath, getContext().getInitParameter("DOMAIN_NAME"));

        // Set the site's update and compilation date display values.
        setUpdateAndCompilationDates();

        // Set the site's proposed-date display value.
        setDateProposedDisplayValue();

        // Set the site's proposed-date display value.
        setDateConfirmedDisplayValue();

        // Set the site's designation date display value.
        setSiteDesignationDateDisplayValue();

        // Set the list of this site's designations.
        if (!isNatura2000SiteAndTypeC()) {
            designations = SitesSearchUtility.findDesignationsForSitesFactsheet(factsheet.getSiteObject().getIdSite());
        } else {
            chm62edtDesignations = new Chm62edtDesignationsDomain().findWhere("ID_DESIGNATION='INBD' OR ID_DESIGNATION='INHD'");
        }

        // Set the available region codes.
        regionCodes = factsheet.findAdministrativeRegionCodes();

        // Set the site's longitude and latitude formatted for display.
        setCoordinates();

        // Set the site's external links.
        links = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectLinks(factsheet.getIDNatureObject());
    }

    /**
     * Set the site's longitude and latitude formatted for display.
     */
    private void setCoordinates() {
        if (!isTypeCorine())
        {
            latitudeFormatted = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLatNS(),
                    factsheet.getSiteObject().getLatDeg(),
                    factsheet.getSiteObject().getLatMin(),
                    factsheet.getSiteObject().getLatSec());
            longitudeFormatted = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLongEW(),
                    factsheet.getSiteObject().getLongDeg(),
                    factsheet.getSiteObject().getLongMin(),
                    factsheet.getSiteObject().getLongSec());
        }
        else
        {
            latitudeFormatted = SitesSearchUtility.formatCoordinates("N", factsheet.getSiteObject().getLatDeg(),
                    factsheet.getSiteObject().getLatMin(),
                    factsheet.getSiteObject().getLatSec());
            longitudeFormatted = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLongEW(),
                    factsheet.getSiteObject().getLongDeg(),
                    factsheet.getSiteObject().getLongMin(),
                    factsheet.getSiteObject().getLongSec());
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
    public String[] getTabTitles() {
        return TAB_TITLES;
    }

    /**
     * @return the source-db name
     */
    public String getSourceDbName() {
        return sourceDbName;
    }

    /**
     * @return the btrail
     */
    @Override
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
    @Override
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

    /**
     * Returns the given site's "main picture" Data Transfer Object.
     *
     * @return the pic
     */
    public PictureDTO getPic() {
        return pic;
    }

    /**
     * Returns true if "length" is an applicable property to the given site.
     *
     * @return
     */
    public boolean isLengthApplicable() {

        int type = factsheet.getType();
        return type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD
                || type == SiteFactsheet.TYPE_BIOGENETIC;
    }

    /**
     * Sets the site's update and compilation dates as displayed on the general tab.
     */
    private void setUpdateAndCompilationDates() {

        // If update and compilation dates not applicable to this site, return without setting anything.
        int type = factsheet.getType();
        if (SiteFactsheet.TYPE_CDDA_NATIONAL == type || SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type) {
            return;
        }

        // First, set the compilation date.

        this.compilationDateFormat = "";
        String timestampConversionFormat = "";
        String compilationDate = factsheet.getSiteObject().getCompilationDate();

        if (SiteFactsheet.TYPE_NATURA2000 != type || type == SiteFactsheet.TYPE_EMERALD) {
            if (compilationDate.length() == 4) {
                this.compilationDateFormat = "(yyyy)";
            }
            if (compilationDate.length() == 6) {
                this.compilationDateFormat = "(yyyyMM)";
            }
            if (compilationDate.length() == 8) {
                this.compilationDateFormat = "(yyyyMMdd)";
            }
        } else {
            if (compilationDate.length() == 4) {
                timestampConversionFormat = "yyyy";
            }
            if (compilationDate.length() == 6) {
                timestampConversionFormat = "yyyyMM";
            }
            if (compilationDate.length() == 8) {
                timestampConversionFormat = "yyyyMMdd";
            }
        }

        if (SiteFactsheet.TYPE_NATURA2000 != type) {
            this.compilationDateDisplayValue = compilationDate;
        } else {
            Timestamp timestamp = Utilities.stringToTimeStamp(compilationDate, timestampConversionFormat);
            String dateFormatted = Utilities.formatDate(timestamp, "MMM yyyy");
            String refinementString = "";
            if (StringUtils.isNotBlank(compilationDate)) {
                String cmsPhrase = getContentManagement().cmsPhrase("entered in original database as");
                refinementString = " (" + cmsPhrase + " " + compilationDate + ")";
            }
            this.compilationDateDisplayValue = dateFormatted + refinementString;
        }

        // Second, set the update date.

        this.updateDateFormat = "";
        timestampConversionFormat = "";
        String updateDate = factsheet.getSiteObject().getUpdateDate();

        if (SiteFactsheet.TYPE_NATURA2000 != type || type == SiteFactsheet.TYPE_EMERALD) {
            if (updateDate.length() == 4) {
                this.updateDateFormat = "(yyyy)";
            }
            if (updateDate.length() == 6) {
                this.updateDateFormat = "(yyyyMM)";
            }
            if (updateDate.length() == 8) {
                this.updateDateFormat = "(yyyyMMdd)";
            }
        } else {
            if (updateDate.length() == 4) {
                timestampConversionFormat = "yyyy";
            }
            if (updateDate.length() == 6) {
                timestampConversionFormat = "yyyyMM";
            }
            if (updateDate.length() == 8) {
                timestampConversionFormat = "yyyyMMdd";
            }
        }

        if (SiteFactsheet.TYPE_NATURA2000 != type) {
            this.updateDateDisplayValue = updateDate;
        } else {
            Timestamp timestamp = Utilities.stringToTimeStamp(updateDate, timestampConversionFormat);
            String dateFormatted = Utilities.formatDate(timestamp, "MMM yyyy");
            String refinementString = "";
            if (StringUtils.isNotBlank(updateDate)) {
                String cmsPhrase = getContentManagement().cmsPhrase("entered in original database as");
                refinementString = " (" + cmsPhrase + " " + updateDate + ")";
            }
            this.updateDateDisplayValue = dateFormatted + refinementString;
        }
    }

    /**
     * Sets the site's proposed-date as displayed on the general tab.
     */
    private void setDateProposedDisplayValue() {

        // If proposed-date not applicable to this site, return without setting anything.
        int type = factsheet.getType();
        if (SiteFactsheet.TYPE_CDDA_NATIONAL == type || SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type
                || SiteFactsheet.TYPE_CORINE == type) {
            return;
        }

        String proposedDate = factsheet.getSiteObject().getProposedDate();
        if (SiteFactsheet.TYPE_NATURA2000 != type) {
            this.dateProposedDisplayValue = proposedDate;
        } else {
            Timestamp timestamp = Utilities.stringToTimeStamp(proposedDate, "yyyyMM");
            String dateFormatted = Utilities.formatDate(timestamp, "MMM yyyy");
            String refinementString = "";
            if (StringUtils.isNotBlank(proposedDate)) {
                String cmsPhrase = getContentManagement().cmsPhrase("entered in original database as");
                refinementString = " (" + cmsPhrase + " " + proposedDate + ")";
            }
            this.dateProposedDisplayValue = dateFormatted + refinementString;
        }
    }

    /**
     * Sets the site's proposed-date as displayed on the general tab.
     */
    private void setDateConfirmedDisplayValue() {

        // If confirmed-date not applicable to this site, return without setting anything.
        int type = factsheet.getType();
        if (SiteFactsheet.TYPE_NATURA2000 != type && SiteFactsheet.TYPE_DIPLOMA != type && SiteFactsheet.TYPE_EMERALD != type) {
            return;
        }

        String confirmedDate = factsheet.getSiteObject().getConfirmedDate();
        if (SiteFactsheet.TYPE_NATURA2000 != type) {
            this.dateConfirmedDisplayValue = confirmedDate;
        } else {
            Timestamp timestamp = Utilities.stringToTimeStamp(confirmedDate, "yyyyMM");
            String dateFormatted = Utilities.formatDate(timestamp, "MMM yyyy");
            String refinementString = "";
            if (StringUtils.isNotBlank(confirmedDate)) {
                String cmsPhrase = getContentManagement().cmsPhrase("entered in original database as");
                refinementString = " (" + cmsPhrase + " " + confirmedDate + ")";
            }
            this.dateConfirmedDisplayValue = dateFormatted + refinementString;
        }
    }

    /**
     * Sets the site's designation date as displayed on the general tab.
     */
    private void setSiteDesignationDateDisplayValue() {

        // Set it only when it's applicable to this site.
        if (factsheet.getType() != SiteFactsheet.TYPE_CORINE) {

            String spaDate = factsheet.getSiteObject().getSpaDate();
            String sacDate = factsheet.getSiteObject().getSacDate();
            String desigDate = factsheet.getSiteObject().getDesignationDate();

            StringBuilder bld = new StringBuilder();
            if (StringUtils.isNotBlank(spaDate)) {
                bld.append(spaDate);
            }
            if (StringUtils.isNotBlank(sacDate)) {
                if (bld.length() > 0) {
                    bld.append(", ");
                }
                bld.append(sacDate);
            }
            if (StringUtils.isNotBlank(desigDate)) {
                if (bld.length() > 0) {
                    bld.append("/ ");
                }
                bld.append(desigDate);
            }

            this.siteDesignationDateDisplayValue = bld.toString();
        }
    }

    /**
     * @return the compilationDateDisplayValue
     */
    public String getCompilationDateDisplayValue() {
        return compilationDateDisplayValue;
    }

    /**
     * @return the compilationDateFormat
     */
    public String getCompilationDateFormat() {
        return compilationDateFormat;
    }

    /**
     * @return the updateDateDisplayValue
     */
    public String getUpdateDateDisplayValue() {
        return updateDateDisplayValue;
    }

    /**
     * @return the updateDateFormat
     */
    public String getUpdateDateFormat() {
        return updateDateFormat;
    }

    /**
     * @return the dateProposedDisplayValue
     */
    public String getDateProposedDisplayValue() {
        return dateProposedDisplayValue;
    }

    /**
     * @return the dateConfirmedDisplayValue
     */
    public String getDateConfirmedDisplayValue() {
        return dateConfirmedDisplayValue;
    }

    /**
     *
     * @return
     */
    public boolean isDateFirstDesignationApplicable() {
        return factsheet.getType() == SiteFactsheet.TYPE_DIPLOMA;
    }

    /**
     * @return the siteDesignationDateDisplayValue
     */
    public String getSiteDesignationDateDisplayValue() {
        return siteDesignationDateDisplayValue;
    }

    /**
     *
     * @return
     */
    public boolean isNatura2000SiteAndTypeC() {
        return factsheet.getType() == SiteFactsheet.TYPE_NATURA2000 && factsheet.getSiteType().equalsIgnoreCase("C");
    }

    /**
     * @return the designations
     */
    public List getDesignations() {
        return designations;
    }

    /**
     * @return the chm62edtDesignations
     */
    public List getChm62edtDesignations() {
        return chm62edtDesignations;
    }

    /**
     *
     * @return
     */
    public boolean isTypeCDDA() {
        return SiteFactsheet.TYPE_CDDA_INTERNATIONAL == factsheet.getType()
                || SiteFactsheet.TYPE_CDDA_NATIONAL == factsheet.getType();
    }

    /**
     *
     * @return
     */
    public boolean isTypeCDDAInternational() {
        return SiteFactsheet.TYPE_CDDA_INTERNATIONAL == factsheet.getType();
    }

    /**
     *
     * @return
     */
    public boolean isTypeNatura2000(){
        return SiteFactsheet.TYPE_NATURA2000 == factsheet.getType();
    }

    /**
     * @return the regionCodes
     */
    public List getRegionCodes() {
        return regionCodes;
    }

    /**
     * @return the bioRegionsMap
     */
    public Map<String, Object> getBioRegionsMap() {

        if (bioRegionsMap == null){

            bioRegionsMap = new HashMap<String, Object>();
            if (factsheet.getType() == SiteFactsheet.TYPE_NATURA2000 || factsheet.getType() == SiteFactsheet.TYPE_EMERALD){

                boolean alpine = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ALPINE"), false);
                boolean anatol1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ANATOL"), false);
                boolean anatol2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ANATOLIAN"), false);
                boolean anatol = anatol1 || anatol2;
                boolean arctic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ARCTIC"), false);
                boolean atlantic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ATLANTIC"), false);
                boolean boreal = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("BOREAL"), false);
                boolean continent1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("CONTINENT"), false);
                boolean continent2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("CONTINENTAL"), false);
                boolean continent = continent1 || continent2;
                boolean macarones1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MACARONES"), false);
                boolean macarones2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MACARONESIAN"), false);
                boolean macarones = macarones1 || macarones2;
                boolean mediterranean1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MEDITERRANIAN"), false);
                boolean mediterranean2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MEDITERRANEAN"), false);
                boolean mediterranean = mediterranean1 || mediterranean2;
                boolean pannonic1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PANNONIC"), false);
                boolean pannonic2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PANNONIAN"), false);
                boolean pannonic = pannonic1 || pannonic2;
                boolean pontic1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PONTIC"), false);
                boolean pontic2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("BLACK SEA"), false);
                boolean pontic = pontic1 || pontic2;
                boolean steppic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("STEPPIC"), false);

                if (alpine){
                    bioRegionsMap.put("alpine", "");
                }
                if (anatol){
                    bioRegionsMap.put("anatol", "");
                }
                if (arctic){
                    bioRegionsMap.put("arctic", "");
                }
                if (atlantic){
                    bioRegionsMap.put("atlantic", "");
                }
                if (boreal){
                    bioRegionsMap.put("boreal", "");
                }
                if (continent){
                    bioRegionsMap.put("continent", "");
                }
                if (macarones){
                    bioRegionsMap.put("macarones", "");
                }
                if (mediterranean){
                    bioRegionsMap.put("mediterranean", "");
                }
                if (pannonic){
                    bioRegionsMap.put("pannonic", "");
                }
                if (pontic){
                    bioRegionsMap.put("pontic", "");
                }
                if (steppic){
                    bioRegionsMap.put("steppic", "");
                }
            }
        }
        return bioRegionsMap;
    }

    /**
     *
     * @return
     */
    public boolean isTypeCorine(){
        return factsheet.getType() == SiteFactsheet.TYPE_CORINE;
    }

    /**
     * @return the longitudeFormatted
     */
    public String getLongitudeFormatted() {
        return longitudeFormatted;
    }

    /**
     * @return the latitudeFormatted
     */
    public String getLatitudeFormatted() {
        return latitudeFormatted;
    }

    /**
     * @return the biogeoRegions
     */
    public boolean isBiogeoRegionsApplicable() {

        int type = factsheet.getType();
        return SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_CORINE == type;
    }

    /**
     *
     * @return
     */
    public boolean isUploadPicturesPermission(){

        SessionManager sessionManager = getContext().getSessionManager();
        return sessionManager.isAuthenticated() && sessionManager.isUpload_pictures_RIGHT();
    }

    /**
     * @return the links
     */
    public ArrayList<LinkDTO> getLinks() {
        return links;
    }

    public Chm62edtCountryPersist getCountryObject() {
        return countryObject;
    }
}
