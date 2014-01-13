package eionet.eunis.stripes.actions;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletResponse;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import ro.finsiel.eunis.search.Utilities;

/**
 * Action bean to handle sites-factsheet functionality.
 * 
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/sites/{idsite}")
public class SitesFactsheetActionBean extends AbstractStripesAction {

    static final Map<String, String> biogeographicRegionTitles = new HashMap<String, String>();
    static final Map<String, String> sourceDBTitles = new HashMap<String, String>();

    static {
        biogeographicRegionTitles.put("alpine", "Alpine");
        biogeographicRegionTitles.put("anatol", "Anatolian");
        biogeographicRegionTitles.put("arctic", "Arctic");
        biogeographicRegionTitles.put("atlantic", "Atlantic");
        biogeographicRegionTitles.put("boreal", "Boreal");
        biogeographicRegionTitles.put("continent", "Continental");
        biogeographicRegionTitles.put("macarones", "Macaronesia");
        biogeographicRegionTitles.put("mediterranean", "Mediterranean");
        biogeographicRegionTitles.put("pannonic", "Pannonian");
        biogeographicRegionTitles.put("pontic", "Black Sea");
        biogeographicRegionTitles.put("steppic", "Steppic");

        sourceDBTitles.put("NATURA2000", "Natura 2000");
        sourceDBTitles.put("CORINE", "Corine");
        sourceDBTitles.put("CDDA_NATIONAL", "CDDA National");
        sourceDBTitles.put("EMERALD", "Emerald");
        sourceDBTitles.put("DIPLOMA", "Diploma");
        sourceDBTitles.put("BIOGENETIC", "Biogenetic");

    }

    /** The id of the site in question. */
    private String idsite = "";

    /** */
    private String pageTitle = "";

    /** The factsheet data object. */
    private SiteFactsheet factsheet;
    private String metaDescription;

    private String siteName;
    private String country;

    /** The site's designation date */
    private String siteDesignationDateDisplayValue;

    private String surfaceAreaKm2;

    private String biogeographicRegion;
    private Map<String, Object> bioRegionsMap;

    private int protectedSpeciesCount;
    private int totalSpeciesCount;
    private int habitatsCount;

    private String regionCode;
    private String regionName;

    /**
     * The default event handler of this action bean. Note that this action bean only serves RDF through {@link RdfAware}.
     * 
     * @return Resolution
     */
    @DefaultHandler
    public Resolution defaultAction() {

        // Get EEA's home page URL from servlet context.
        String eeaHomePageUrl = getContext().getInitParameter("EEA_HOME");

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

            siteName = factsheet.getSiteObject().getName();
            country = factsheet.getCountry();
            setSiteDesignationDateDisplayValue();
            surfaceAreaKm2 = Math.round(Double.parseDouble(factsheet.getSiteObject().getArea()) / 100) + "";

            protectedSpeciesCount = factsheet.findEunisSpeciesListedAnnexesDirectivesForSitesNatura2000().size();
            totalSpeciesCount = protectedSpeciesCount + factsheet.findEunisSpeciesOtherMentionedForSitesNatura2000().size();

            calculateHabitatsCount();
            prepareBiogeographicRegion();
        }

        // Forward to the factsheet layout page.
        return new ForwardResolution("/stripes/site-factsheet/site-factsheet.layout.jsp");
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

            try {
                String rawDate = bld.toString();
                
                String sourceFormat = "yyyyMMdd";
                String targetFormat = "d MMM yyyy";
                
                DateFormat formatter = new SimpleDateFormat(sourceFormat);
                Date date = formatter.parse(rawDate);
                
                formatter = new SimpleDateFormat(targetFormat);
                this.siteDesignationDateDisplayValue = formatter.format(date);
            } catch (Exception ex) {
                this.siteDesignationDateDisplayValue = bld.toString();
            }
        }
    }

    private void calculateHabitatsCount() {

        habitatsCount = 0;

        if (factsheet.getType() == SiteFactsheet.TYPE_NATURA2000 || factsheet.getType() == SiteFactsheet.TYPE_EMERALD) {
            habitatsCount += factsheet.findHabit1Eunis().size();
            habitatsCount += factsheet.findHabit1NotEunis().size();
            habitatsCount += factsheet.findHabit2Eunis().size();
            habitatsCount += factsheet.findHabit2NotEunis().size();
        } else {
            habitatsCount += factsheet.findSitesHabitatsByIDNatureObject().size();
            habitatsCount += factsheet.findSitesSpecificHabitats().size();
        }
    }

    private void prepareBiogeographicRegion() {
        getBioRegionsMap();
    }

    /**
     * @return the bioRegionsMap
     */
    public Map<String, Object> getBioRegionsMap() {

        if (bioRegionsMap == null) {

            bioRegionsMap = new HashMap<String, Object>();
            if (factsheet.getType() == SiteFactsheet.TYPE_NATURA2000 || factsheet.getType() == SiteFactsheet.TYPE_EMERALD) {

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

                if (alpine) {
                    bioRegionsMap.put("alpine", "");
                    biogeographicRegion = biogeographicRegionTitles.get("alpine");
                }
                if (anatol) {
                    bioRegionsMap.put("anatol", "");
                    biogeographicRegion = biogeographicRegionTitles.get("anatol");
                }
                if (arctic) {
                    bioRegionsMap.put("arctic", "");
                    biogeographicRegion = biogeographicRegionTitles.get("arctic");
                }
                if (atlantic) {
                    bioRegionsMap.put("atlantic", "");
                    biogeographicRegion = biogeographicRegionTitles.get("atlantic");
                }
                if (boreal) {
                    bioRegionsMap.put("boreal", "");
                    biogeographicRegion = biogeographicRegionTitles.get("boreal");
                }
                if (continent) {
                    bioRegionsMap.put("continent", "");
                    biogeographicRegion = biogeographicRegionTitles.get("continent");
                }
                if (macarones) {
                    bioRegionsMap.put("macarones", "");
                    biogeographicRegion = biogeographicRegionTitles.get("macarones");
                }
                if (mediterranean) {
                    bioRegionsMap.put("mediterranean", "");
                    biogeographicRegion = biogeographicRegionTitles.get("mediterranean");
                }
                if (pannonic) {
                    bioRegionsMap.put("pannonic", "");
                    biogeographicRegion = biogeographicRegionTitles.get("pannonic");
                }
                if (pontic) {
                    bioRegionsMap.put("pontic", "");
                    biogeographicRegion = biogeographicRegionTitles.get("pontic");
                }
                if (steppic) {
                    bioRegionsMap.put("steppic", "");
                    biogeographicRegion = biogeographicRegionTitles.get("steppic");
                }
            }
        }
        return bioRegionsMap;
    }

    public boolean isTypeCorine() {
        return factsheet.getType() == SiteFactsheet.TYPE_CORINE;
    }

    public boolean isTypeNatura2000(){
        return factsheet.getType() == SiteFactsheet.TYPE_NATURA2000;
    }

    public String getTypeName(){
        return factsheet.getSiteObject().getSourceDB();
    }

    /**
     * The title of the site type / source_db, using the sourceDBTitles list
     * @return The site type title
     */
    public String getTypeTitle(){
        return sourceDBTitles.get(getTypeName());
    }

    public String getIdsite() {
        return idsite;
    }

    public void setIdsite(String idsite) {
        this.idsite = idsite;
    }

    public String getPageTitle() {
        return pageTitle;
    }

    public void setPageTitle(String pageTitle) {
        this.pageTitle = pageTitle;
    }

    public String getMetaDescription() {
        return metaDescription;
    }

    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public SiteFactsheet getFactsheet() {
        return factsheet;
    }

    public void setFactsheet(SiteFactsheet factsheet) {
        this.factsheet = factsheet;
    }

    public String getSiteDesignationDateDisplayValue() {
        return siteDesignationDateDisplayValue;
    }

    public void setSiteDesignationDateDisplayValue(String siteDesignationDateDisplayValue) {
        this.siteDesignationDateDisplayValue = siteDesignationDateDisplayValue;
    }

    public String getSurfaceAreaKm2() {
        return surfaceAreaKm2;
    }

    public void setSurfaceAreaKm2(String surfaceAreaKm2) {
        this.surfaceAreaKm2 = surfaceAreaKm2;
    }

    public String getBiogeographicRegion() {
        return biogeographicRegion;
    }

    public void setBiogeographicRegion(String biogeographicRegion) {
        this.biogeographicRegion = biogeographicRegion;
    }

    public int getProtectedSpeciesCount() {
        return protectedSpeciesCount;
    }

    public void setProtectedSpeciesCount(int protectedSpeciesCount) {
        this.protectedSpeciesCount = protectedSpeciesCount;
    }

    public int getTotalSpeciesCount() {
        return totalSpeciesCount;
    }

    public void setTotalSpeciesCount(int totalSpeciesCount) {
        this.totalSpeciesCount = totalSpeciesCount;
    }

    public int getHabitatsCount() {
        return habitatsCount;
    }

    public void setHabitatsCount(int habitatsCount) {
        this.habitatsCount = habitatsCount;
    }

    /**
     * The percentage of marine area in the site
     * @return Zero for now, as there is no DB field for this data
     */
    public int getMarineAreaPercentage(){
        // todo: implement after the field is added to DB, see http://taskman.eionet.europa.eu/issues/17767
        return 0;
    }

    /**
     * The IUCN category (IUCNAT DB field)
     * @return The IUCN category
     */
    public String getIucnCategory(){
        return factsheet.getSiteObject().getIucnat();
    }

    /**
     * Read the region fields (NUTS code, Region name) from the factsheet
     */
    private void prepareRegion(){
        this.regionCode = factsheet.getSiteObject().getNuts();
        this.regionName = factsheet.getRegionName();
    }

    /**
     * NUTS code
     * @return The code of the region
     */
    public String getRegionCode(){
        return regionCode;
    }

    /**
     *
     * @return The name of the region
     */
    public String getRegionName(){
        return regionName;
    }

}
