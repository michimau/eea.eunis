/**
 * Date: Apr 4, 2003
 * Time: 2:19:24 PM
 */
package ro.finsiel.eunis.search.habitats.advanced;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.jrfTables.*;
import ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryDomain;

import java.util.Vector;
import java.util.List;


/**
 * Form bean used in adv. search.
 * @author finsiel.
 */
public class DictionaryBean extends AbstractFormBean {

    /**
     * Define EUNIS database.
     */
    public static final int DATABASE_EUNIS = 0;

    /**
     * Define ANNEX I database.
     */
    public static final int DATABASE_ANNEX = 1;

    /**
     * Dictionary : altitude.
     */
    public static final int DICT_ALTITUDE = 0;

    /**
     * Dictionary : chemistry.
     */
    public static final int DICT_CHEMISTRY = 1;

    /**
     * Dictionary : climate.
     */
    public static final int DICT_CLIMATE = 2;

    /**
     * Dictionary : coverage.
     */
    public static final int DICT_COVERAGE = 3;

    /**
     * Dictionary : humidity.
     */
    public static final int DICT_HUMIDITY = 4;

    /**
     * Dictionary : impact.
     */
    public static final int DICT_IMPACT = 5;

    /**
     * Dictionary : light.
     */
    public static final int DICT_LIGHT = 6;

    /**
     * Dictionary : ph.
     */
    public static final int DICT_PH = 7;

    /**
     * Dictionary : life form.
     */
    public static final int DICT_LIFEFORM = 8;

    /**
     * Dictionary : temperature.
     */
    public static final int DICT_TEMPERATURE = 9;

    /**
     * Dictionary : usage.
     */
    public static final int DICT_USAGE = 10;

    /**
     * Dictionary : water.
     */
    public static final int DICT_WATER = 11;

    /**
     * Dictionary : substrate.
     */
    public static final int DICT_SUBSTRATE = 12;

    private String dictionary0 = null;
    private String selectOp0 = null;
    private String searchValueMin0 = null;
    private String searchValueMax0 = null;

    private String showLevel = null;
    private String showCode = null;
    private String showScientificName = null;
    private String showEnglishName = null;
    private String showOtherInfo = null;
    // Database where to search: DictionaryDomain.SEARCH_EUNIS, DictionaryDomain.SEARCH_ANNEX_I
    private String database = null;

    /**
     * This method is used to retrieve the basic criteria used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        Integer _selectOp0 = Utilities.checkedStringToInt(selectOp0, Utilities.OPERATOR_IS);
        Integer _dictionary0 = Utilities.checkedStringToInt(dictionary0, new Integer(0));
        Integer _database = Utilities.checkedStringToInt(database, DictionaryDomain.SEARCH_EUNIS);

        return new DictionarySearchCriteria(_dictionary0, _selectOp0, searchValueMin0, searchValueMax0, _database);
    }

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector results = new Vector();
        Integer _selectOp0 = Utilities.checkedStringToInt(selectOp0, Utilities.OPERATOR_IS);
        Integer _dictionary0 = Utilities.checkedStringToInt(dictionary0, new Integer(0));
        Integer _database = Utilities.checkedStringToInt(database, DictionaryDomain.SEARCH_EUNIS);

        results.addElement(new DictionarySearchCriteria(_dictionary0, _selectOp0, searchValueMin0, searchValueMax0, _database));
        // Search in results criterias
        Integer database = Utilities.checkedStringToInt(this.database, DictionaryDomain.SEARCH_EUNIS);

        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i],
                        DictionarySearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                results.addElement(new DictionarySearchCriteria(criteriaSearch[i], _criteriaType, _oper, database));
            }
        }
        AbstractSearchCriteria[] criterias = new AbstractSearchCriteria[results.size()];

        for (int i = 0; i < criterias.length; i++) {
            criterias[i] = (AbstractSearchCriteria) results.get(i);
        }
        return criterias;
    }

    /**
     * Get the possible list of values from a dictionary.
     * @param dictionary Type of dictionary.
     * @return Values as Persist objects.
     */
    public List getDictionaryValues(int dictionary) {
        List results = new Vector();

        try {
            switch (dictionary) {
            case DICT_ALTITUDE:
                results = new Chm62edtAltitudeDomain().findAll();
                break;

            case DICT_CHEMISTRY:
                results = new Chm62edtChemistryDomain().findAll();
                break;

            case DICT_CLIMATE:
                results = new Chm62edtClimateDomain().findAll();
                break;

            case DICT_COVERAGE:
                results = new Chm62edtCoverDomain().findAll();
                break;

            case DICT_HUMIDITY:
                results = new Chm62edtHumidityDomain().findAll();
                break;

            case DICT_IMPACT:
                results = new Chm62edtImpactDomain().findAll();
                break;

            case DICT_LIGHT:
                results = new Chm62edtLightIntensityDomain().findAll();
                break;

            case DICT_PH:
                results = new Chm62edtPhDomain().findAll();
                break;

            case DICT_LIFEFORM:
                results = new Chm62edtLifeFormDomain().findAll();
                break;

            case DICT_TEMPERATURE:
                results = new Chm62edtTemperatureDomain().findAll();
                break;

            case DICT_USAGE:
                results = new Chm62edtUsageDomain().findAll();
                break;

            case DICT_WATER:
                results = new Chm62edtWaterDomain().findAll();
                break;

            case DICT_SUBSTRATE:
                results = new Chm62edtSubstrateDomain().findAll();
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(System.err);
            results = new Vector();
        } finally {
            if (null == results) {
                results = new Vector();
            }
            return results;
        }
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again...
     * @return objects which are used for sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        Integer database = Utilities.checkedStringToInt(this.database, DictionaryDomain.SEARCH_EUNIS);

        for (int i = 0; i < sort.length; i++) {
            DictionarySortCriteria criteria = new DictionarySortCriteria(
                    Utilities.checkedStringToInt(sort[i], DictionarySortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], DictionarySortCriteria.ASCENDENCY_NONE), database);

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
        }
        if (null != database) {
            url.append(Utilities.writeURLParameter("database", database));
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", DictionaryBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", DictionaryBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", DictionaryBean.SHOW.toString()));
        }
        if (null != showEnglishName && showEnglishName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showEnglishName", DictionaryBean.SHOW.toString()));
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
        if (null != database) {
            form.append(Utilities.writeFormParameter("database", database));
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", DictionaryBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", DictionaryBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", DictionaryBean.SHOW.toString()));
        }
        if (null != showEnglishName && showEnglishName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showEnglishName", DictionaryBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for dictionary0 property.
     * @return dictionary0.
     */
    public String getDictionary0() {
        return dictionary0;
    }

    /**
     * Setter for dictionary0 property.
     * @param dictionary0 dictionary0.
     */
    public void setDictionary0(String dictionary0) {
        this.dictionary0 = dictionary0;
    }

    /**
     * Getter for searchValueMax0 property.
     * @return searchValueMax0.
     */
    public String getSearchValueMax0() {
        return searchValueMax0;
    }

    /**
     * Setter for searchValueMax0 property.
     * @param searchValueMax0 searchValueMax0.
     */
    public void setSearchValueMax0(String searchValueMax0) {
        this.searchValueMax0 = searchValueMax0;
    }

    /**
     * Getter for searchValueMin0 property.
     * @return searchValueMin0.
     */
    public String getSearchValueMin0() {
        return searchValueMin0;
    }

    /**
     * Setter for searchValueMin0 property.
     * @param searchValueMin0 searchValueMin0.
     */
    public void setSearchValueMin0(String searchValueMin0) {
        this.searchValueMin0 = searchValueMin0;
    }

    /**
     * Getter for selectOp0 property.
     * @return selectOp0.
     */
    public String getSelectOp0() {
        return selectOp0;
    }

    /**
     * Setter for selectOp0 property.
     * @param selectOp0 selectOp0.
     */
    public void setSelectOp0(String selectOp0) {
        this.selectOp0 = selectOp0;
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
     * Getter for showEnglishName property.
     * @return showEnglishName.
     */
    public String getShowEnglishName() {
        return showEnglishName;
    }

    /**
     * Setter for showEnglishName property.
     * @param showEnglishName showEnglishName.
     */
    public void setShowEnglishName(String showEnglishName) {
        this.showEnglishName = showEnglishName;
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
     * Getter for showOtherInfo property.
     * @return showOtherInfo.
     */
    public String getShowOtherInfo() {
        return showOtherInfo;
    }

    /**
     * Setter for showOtherInfo property.
     * @param showOtherInfo showOtherInfo.
     */
    public void setShowOtherInfo(String showOtherInfo) {
        this.showOtherInfo = showOtherInfo;
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
}
