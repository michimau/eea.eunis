package ro.finsiel.eunis.search.habitats.country;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain;

import java.util.Vector;


/**
 * Form bean used for habitats->country.
 * @author finsiel
 */
public class CountryBean extends AbstractFormBean {
    private String[] country = null;
    private String[] region = null;

    /** Search type: can be 'eunis' or 'annex'. */
    private String database = null;

    // These are the show columns fields...Determines which columns are displayed or hidden in the result page.
    /** Display / Hide Level column. */
    private String showLevel = null;

    /** Display / Hide Code column.*/
    private String showCode = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Common name column. */
    private String showVernacularName = null;

    /** Display / Hide Region column. */
    private String showRegion = null;

    /** Display / Hide country column. */
    private String showCountry = null;

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        // Translate null searches for country / biogeoregion in '*' in order to exclude them from search
        if (null != country && null != region) {
            for (int i = 0; i < country.length; i++) {
                if (null == country[i]) {
                    country[i] = "*";
                }
                if (null != country[i] && country[i].equalsIgnoreCase("")) {
                    country[i] = "*";
                }
            }

            for (int i = 0; i < region.length; i++) {
                if (null == region[i]) {
                    region[i] = "*";
                }
                if (null != region[i] && region[i].equalsIgnoreCase("")) {
                    region[i] = "*";
                }
            }

            for (int i = 0; i < country.length; i++) {
                Integer _database = Utilities.checkedStringToInt(database, CountryDomain.SEARCH_EUNIS);

                criterias.addElement(new CountrySearchCriteria(country[i], region[i], _database));
            }
            // Search in results criterias
            if (null != criteriaSearch && null != oper && null != criteriaType) {
                Integer database = Utilities.checkedStringToInt(this.database, CountryDomain.SEARCH_EUNIS);

                for (int i = 0; i < criteriaSearch.length; i++) {
                    Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i],
                            CountrySearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                    Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                    criterias.addElement(new CountrySearchCriteria(criteriaSearch[i], _criteriaType, _oper, database));
                }
            }
        }
        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        Integer database = Utilities.checkedStringToInt(this.database, CountryDomain.SEARCH_EUNIS);

        for (int i = 0; i < sort.length; i++) {
            CountrySortCriteria criteria = new CountrySortCriteria(
                    Utilities.checkedStringToInt(sort[i], CountrySortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], CountrySortCriteria.ASCENDENCY_NONE), database);

            criterias[i] = criteria;
        }
        return criterias; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that
     * one should not manually write the URL.
     * @param classFields Fields to be included in parameters.
     * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
     */
    public String toURLParam(Vector classFields) {
        StringBuffer url = new StringBuffer();

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        if (classFields.contains("criteriaSearch")) {
            AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

            for (int i = 0; i < searchCriterias.length; i++) {
                AbstractSearchCriteria aSearch = searchCriterias[i];

                url.append(aSearch.toURLParam());
            }
            // Add also the extra criterias
            AbstractSearchCriteria[] mainCriterias = getMainSearchCriteriasExtra();

            for (int i = 0; i < mainCriterias.length; i++) {
                AbstractSearchCriteria criteria = mainCriterias[i];

                url.append(criteria.toURLParam());
            }
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", CountryBean.SHOW));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", CountryBean.SHOW));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", CountryBean.SHOW));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularName", CountryBean.SHOW));
        }
        return url.toString();
    }

    /**
     * This method will transform the request parameters into a form compatible hidden input parameters, for example.
     * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
     * @param classFields Fields to be included in parameters.
     * @return An form compatible type of representation of request parameters.
     */
    public String toFORMParam(Vector classFields) {
        StringBuffer form = new StringBuffer();

        form.append(toFORMParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        if (classFields.contains("criteriaSearch")) {
            AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

            for (int i = 0; i < searchCriterias.length; i++) {
                AbstractSearchCriteria aSearch = searchCriterias[i];

                form.append(aSearch.toFORMParam());
            }
            // Add also the extra criterias
            AbstractSearchCriteria[] mainCriterias = getMainSearchCriteriasExtra();

            for (int i = 0; i < mainCriterias.length; i++) {
                AbstractSearchCriteria criteria = mainCriterias[i];

                form.append(criteria.toFORMParam());
            }
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", CountryBean.SHOW));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", CountryBean.SHOW));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", CountryBean.SHOW));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularName", CountryBean.SHOW));
        }
        return form.toString();
    }

    /**
     * Getter for country property.
     * @return country.
     */
    public String[] getCountry() {
        return country;
    }

    /**
     * Setter for country property.
     * @param country country.
     */
    public void setCountry(String[] country) {
        this.country = country;
    }

    /**
     * Getter for region property.
     * @return region.
     */
    public String[] getRegion() {
        return region;
    }

    /**
     * Setter for region property.
     * @param region region.
     */
    public void setRegion(String[] region) {
        this.region = region;
    }

    /**
     * Getter for database property.
     * @return database.
     */
    public String getDatabase() {
        return database;
    }

    /**
     * Setter for database property.
     * @param database database.
     */
    public void setDatabase(String database) {
        this.database = database;
    }

    /**
     * Getter for showLevel property.
     * @return showLevel.
     */
    public String getShowLevel() {
        return showLevel;
    }

    /**
     * Setter for showLevel property.
     * @param showLevel showLevel.
     */
    public void setShowLevel(String showLevel) {
        this.showLevel = showLevel;
    }

    /**
     * Getter for showCode property.
     * @return showCode.
     */
    public String getShowCode() {
        return showCode;
    }

    /**
     * Setter for showCode property.
     * @param showCode showCode.
     */
    public void setShowCode(String showCode) {
        this.showCode = showCode;
    }

    /**
     * Getter for showScientificName property.
     * @return showScientificName.
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property.
     * @param showScientificName showScientificName.
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showVernacularName property.
     * @return showVernacularName.
     */
    public String getShowVernacularName() {
        return showVernacularName;
    }

    /**
     * Setter for showVernacularName property.
     * @param showVernacularName showVernacularName.
     */
    public void setShowVernacularName(String showVernacularName) {
        this.showVernacularName = showVernacularName;
    }

    /**
     * Getter for showRegion property.
     * @return showRegion.
     */
    public String getShowRegion() {
        return showRegion;
    }

    /**
     * Setter for showRegion property.
     * @param showRegion showRegion.
     */
    public void setShowRegion(String showRegion) {
        this.showRegion = showRegion;
    }

    /**
     * Getter for showCountry property.
     * @return showCountry.
     */
    public String getShowCountry() {
        return showCountry;
    }

    /**
     * Setter for showCountry property.
     * @param showCountry showCountry.
     */
    public void setShowCountry(String showCountry) {
        this.showCountry = showCountry;
    }
}
