/*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is Content Registry 3
 *
 * The Initial Owner of the Original Code is European Environment
 * Agency. Portions created by TripleDev or Zero Technologies are Copyright
 * (C) European Environment Agency.  All Rights Reserved.
 *
 * Contributor(s):
 *        jaanus
 */

package eionet.eunis.stripes.actions;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import net.sourceforge.stripes.action.Before;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;

import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist;
import ro.finsiel.eunis.jrfTables.sites.statistics.CountrySitesFactsheetDomain;
import ro.finsiel.eunis.jrfTables.sites.statistics.CountrySitesFactsheetPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.statistics.StatisticsBean;
import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.utilities.TableColumns;

/**
 * Stripes action bean for a country factsheet.
 *
 * @author jaanus
 */
@UrlBinding("/countries/{eunisAreaCode}/{tab}")
@SuppressWarnings({"rawtypes", "unchecked"})
public class CountryFactsheetActionBean extends AbstractStripesAction {

    /**  */
    private static final String FACTSHEET_LAYOUT_JSP = "/stripes/country-factsheet.layout.jsp";

    /** The tables listed on this factsheet. */
    public static final Tab[] TABS = {Tab.GENERAL, Tab.DESIG_TYPES, Tab.SPECIES, Tab.HABITAT_TYPES};

    /** The country code coming from URL binding. */
    private String eunisAreaCode;

    /** The current tab of the factsheet. */
    private Tab currTab = Tab.GENERAL;

    /** The persistent country object representing the country requested. */
    private Chm62edtCountryPersist country;

    /** Regions found in this country. */
    private Vector countryRegions;

    /** Looks like a record in CHM62EDT_COUNTRY is not always a country, so this flag is true if it's indeed a country. */
    private boolean isIndeedCountry;

    /** List of designations found for this country. */
    private List designations;

    /** Values for the designations listed in {@link #designations}, exactly in the same order. */
    private ArrayList designationsValues = new ArrayList();

    /** An instance of {@link StatisticsBean} that is populated from request parameters. Used as helper for various stuff below. */
    private StatisticsBean statisticsBean = new StatisticsBean();

    /** List of the country's sites factsheets. */
    private List countrySitesFactsheets = new ArrayList();

    /** Number of sites in this country. */
    private int nrOfSites;

    /** HTML that lists the country's sites factsheets. */
    private String sitesCountryFactsheetRowsHtml;

    /** The current tab's friendly name. */
    private String tab = Tab.GENERAL.getDisplayName();

    /**
     * Default action handler.
     *
     * @return
     */
    @DefaultHandler
    public Resolution view() {

        return new ForwardResolution(FACTSHEET_LAYOUT_JSP);
    }

    @Before(on = {"view"})
    public void beforeView() {

        // Ensure the tab is set.
        if (tab == null){
            tab = Tab.GENERAL.getDisplayName();
        }

        // Set the current tab from its friendly string representation.
        for (int i = 0; i < TABS.length; i++) {
            if (TABS[i].getDisplayName().equals(tab)){
                currTab = TABS[i];
                break;
            }
        }

        // If the country's area-code not given, return right away, as we have nothing to do here.
        if (StringUtils.isBlank(eunisAreaCode)) {
            return;
        }

        // Find country object by this area-code, return right away if it's not found.
        country = CountryUtil.findCountryByAreaCode(eunisAreaCode);
        if (country == null) {
            return;
        }

        // Necessary assignments for the "general" and "desig-types" tabs.
        if (currTab.equals(Tab.GENERAL) || currTab.equals(Tab.DESIG_TYPES)) {

            populateStatisticsBean();
            countryRegions = CountryUtil.findRegionsFromCountry(country.getEunisAreaCode());
            isIndeedCountry = Utilities.isCountry(country.getAreaNameEnglish());
            if (isIndeedCountry) {
                loadDesignations();
            }

            loadCountrySitesFactsheets();
        }
    }

    /**
     * Loads the country's sites factsheets.
     */
    private void loadCountrySitesFactsheets() {

        StringBuffer sql = new StringBuffer();
        sql.append(" AREA_NAME_EN = '").append(country.getAreaNameEnglish()).append("'");

        boolean[] source =
            {getContext().getRequest().getParameter("DB_NATURA2000") != null,
            getContext().getRequest().getParameter("DB_CORINE") != null,
            getContext().getRequest().getParameter("DB_DIPLOMA") != null,
            getContext().getRequest().getParameter("DB_CDDA_NATIONAL") != null,
            getContext().getRequest().getParameter("DB_CDDA_INTERNATIONAL") != null,
            getContext().getRequest().getParameter("DB_BIOGENETIC") != null, false,
            getContext().getRequest().getParameter("DB_EMERALD") != null};

        if (source[0] == false && source[1] == false && source[2] == false && source[3] == false && source[4] == false
                && source[5] == false && source[6] == false && source[7] == false) {
            source[0] = true;
            source[1] = true;
            source[2] = true;
            source[3] = true;
            source[4] = true;
            source[5] = true;
            source[6] = false;
            source[7] = true;
        }

        String[] db =
            {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic", "NatureNet", "Emerald"};

        sql = Utilities.getConditionForSourceDB(sql, source, db, "CHM62EDT_COUNTRY_SITES_FACTSHEET");

        try {
            countrySitesFactsheets = new CountrySitesFactsheetDomain().findWhere(sql.toString());
            if (countrySitesFactsheets != null && !countrySitesFactsheets.isEmpty()) {
                for (Iterator iter = countrySitesFactsheets.iterator(); iter.hasNext();) {
                    CountrySitesFactsheetPersist sitesFactsheet = (CountrySitesFactsheetPersist) iter.next();
                    nrOfSites = nrOfSites + NumberUtils.toInt(sitesFactsheet.getNumberOfSites());
                }
            }

            sitesCountryFactsheetRowsHtml =
                    Utilities.getSitesCountryFactsheetInTable(countrySitesFactsheets, getContentManagement());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Populates from request parameters the statistics bean that will be used as helper for various operations.
     */
    private void populateStatisticsBean() {

        try {
            Map map = new HashMap();
            map.putAll(getContext().getRequest().getParameterMap());
            map.put("country", country.getAreaNameEnglish());

            putIfNotExists(map, "yearMin", "null");
            putIfNotExists(map, "yearMax", "null");
            putIfNotExists(map, "designationCat", "null");
            putIfNotExists(map, "designation", "null");
            putIfNotExists(map, "DB_NATURA2000", "null");
            putIfNotExists(map, "DB_CORINE", "null");
            putIfNotExists(map, "DB_DIPLOMA", "null");
            putIfNotExists(map, "DB_CDDA_NATIONAL", "null");
            putIfNotExists(map, "DB_BIOGENETIC", "null");
            putIfNotExists(map, "DB_EMERALD", "null");
            putIfNotExists(map, "DB_CDDA_INTERNATIONAL", "null");

            BeanUtils.populate(statisticsBean, map);

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @param map
     * @param key
     * @param value
     */
    private void putIfNotExists(Map map, Object key, Object value) {
        if (!map.containsKey(key)) {
            map.put(key, value);
        }
    }

    /**
     * Returns the country's name as should be for display in the page title.
     *
     * @return
     */
    public String getNameForTitle() {
        if (currTab.equals(Tab.GENERAL) || currTab.equals(Tab.DESIG_TYPES)) {
            return statisticsBean == null ? "" : statisticsBean.toHumanString();
        } else {
            return country == null ? "" : country.getAreaNameEnglish();
        }
    }

    /**
     *
     * @return
     */
    private void loadDesignations() {

        String sql =
                " SELECT DISTINCT A.ID_SITE FROM CHM62EDT_COUNTRY AS C "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON C.ID_GEOSCOPE = B.ID_GEOSCOPE "
                        + " INNER JOIN CHM62EDT_SITES AS A ON B.ID_NATURE_OBJECT=A.ID_NATURE_OBJECT WHERE "
                        + statisticsBean.prepareSQLForFindSites();

        SQLUtilities sqlUtilities = getContext().getSqlUtilities();
        List queryResultList = sqlUtilities.ExecuteSQLReturnList(sql, 1);
        List siteIds = new ArrayList();
        if (queryResultList != null && queryResultList.size() > 0) {
            for (int i = 0; i < queryResultList.size(); i++) {
                siteIds.add(((TableColumns) queryResultList.get(i)).getColumnsValues().get(0));
            }
        }

        designations = statisticsBean.getDesignationsList(siteIds);
        if (designations != null && !designations.isEmpty()) {
            for (Iterator iter = designations.iterator(); iter.hasNext();) {
                Chm62edtDesignationsPersist designation = (Chm62edtDesignationsPersist) iter.next();
                designationsValues.add(statisticsBean.getValueForDesignations(siteIds, designation.getIdDesignation(),
                        designation.getIdGeoscope(), sqlUtilities));
            }
        }
    }

    /**
     *
     * @return
     */
    public String getEunisAreaCode() {
        return eunisAreaCode;
    }

    /**
     *
     * @param eunisAreaCode
     */
    public void setEunisAreaCode(String eunisAreaCode) {
        this.eunisAreaCode = eunisAreaCode;
    }

    /**
     *
     * @return
     */
    public Tab[] getTabs() {
        return CountryFactsheetActionBean.TABS;
    }

    /**
     *
     * @return
     */
    public Tab getCurrTab() {
        return currTab;
    }

    /**
     * @return the country
     */
    public Chm62edtCountryPersist getCountry() {
        return country;
    }

    /**
     * @return the countryRegions
     */
    public Vector getCountryRegions() {
        return countryRegions;
    }

    /**
     * @return the isIndeedCountry
     */
    public boolean isIndeedCountry() {
        return isIndeedCountry;
    }

    /**
     * @return the designations
     */
    public List getDesignations() {
        return designations;
    }

    /**
     * @return the statisticsBean
     */
    public StatisticsBean getStatisticsBean() {
        return statisticsBean;
    }

    /**
     * @return the designationsValues
     */
    public ArrayList getDesignationsValues() {
        return designationsValues;
    }

    /**
     *
     * @return
     */
    public List getCountrySitesFactsheets() {
        return countrySitesFactsheets;
    }

    /**
     *
     * @return
     */
    public int getNrOfSites() {
        return nrOfSites;
    }

    /**
     * @return the sitesCountryFactsheetRowsHtml
     */
    public String getSitesCountryFactsheetRowsHtml() {
        return sitesCountryFactsheetRowsHtml;
    }

    /**
     *
     * @param tab
     */
    public void setTab(String tab) {
        this.tab = tab;
    }


    /**
     * @author jaanus
     */
    public enum Tab {

        /** Enumerations. */
        GENERAL("General information"), DESIG_TYPES("Sites designation types"), SPECIES("Species"), HABITAT_TYPES("Habitat types");

        /** The tab's displayed title. */
        String title;

        /** The enum's camel-case name where underscores replaced by empty string, and the very first letter is lower case. */
        String displayName;

        /**
         * Constructor.
         *
         * @param title
         */
        Tab(String title) {
            this.title = title;
            displayName = name().toLowerCase().replaceAll("_","");
        }

        /**
         * @return the title
         */
        public String getTitle() {
            return title;
        }

        /**
         *
         * @return
         */
        public String getDisplayName(){
            return displayName;
        }
    }
}
