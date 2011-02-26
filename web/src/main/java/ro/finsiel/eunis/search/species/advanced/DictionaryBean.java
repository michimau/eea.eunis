package ro.finsiel.eunis.search.species.advanced;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.AbstractSortCriteria;

import java.util.Vector;


/**
 * Form bean used in Advanced search.
 * @author finsiel
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
     * Scientific name.
     */
    public static final int DICT_SCIENTIFIC_NAME = 0;

    /**
     * Vernacular name.
     */
    public static final int DICT_VERNACULAR_NAME = 1;

    /**
     * National threat status.
     */
    public static final int DICT_NATIONAL_THREAT_STATUS = 2;

    /**
     * International threat status.
     */
    public static final int DICT_INTERNATIONAL_THREAT_STATUS = 3;

    /**
     * Region.
     */
    public static final int DICT_BIOGEOREGION = 4;

    /**
     * Abundance.
     */
    public static final int DICT_ABUNDANCE = 5;

    /**
     * Legal status.
     */
    public static final int DICT_LEGAL_STATUS = 6;

    /**
     * Trends.
     */
    public static final int DICT_TREND = 7;

    /**
     * Distribution status.
     */
    public static final int DICT_DISTRIBUTION_STATUS = 8;

    /**
     * Species status.
     */
    public static final int DICT_SPECIES_STATUS = 9;

    /**
     * Info quality attribute.
     */
    public static final int DICT_INFO_QUALITY = 10;

    /**
     * Contry dictionary.
     */
    public static final int DICT_COUNTRY = 11;

    /**
     * Species group.
     */
    public static final int DICT_GROUP = 12;

    private String dictionary0 = null;
    private String selectOp0 = null;
    private String searchValueMin0 = null;
    private String searchValueMax0 = null;

    // Columns that will be displayed in the result window
    /** Display / Hide Group column. */
    private String showGroup = null;

    /** Display / Hide Order column. */
    private String showOrder = null;

    /** Display / Hide Family column. */
    private String showFamily = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Vernacular names column. */
    private String showVernacularNames = null;

    /** Expand collapse vernacular names. */
    private String expand = null;

    /**
     * Get main search criteria used for searching.
     * @return Search criteria.
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        Integer _selectOp0 = Utilities.checkedStringToInt(selectOp0, Utilities.OPERATOR_IS);
        Integer _dictionary0 = Utilities.checkedStringToInt(dictionary0, new Integer(0));

        return new DictionarySearchCriteria(_dictionary0, _selectOp0, searchValueMin0, searchValueMax0);
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector results = new Vector();
        Integer _selectOp0 = Utilities.checkedStringToInt(selectOp0, Utilities.OPERATOR_IS);
        Integer _dictionary0 = Utilities.checkedStringToInt(dictionary0, new Integer(0));

        results.addElement(new DictionarySearchCriteria(_dictionary0, _selectOp0, searchValueMin0, searchValueMax0));
        // Search in results criterias
        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i],
                        DictionarySearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                results.addElement(new DictionarySearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        AbstractSearchCriteria[] criterias = new AbstractSearchCriteria[results.size()];

        for (int i = 0; i < criterias.length; i++) {
            criterias[i] = (AbstractSearchCriteria) results.get(i);
        }
        return criterias;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return objects which are used for sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            DictionarySortCriteria criteria = new DictionarySortCriteria(
                    Utilities.checkedStringToInt(sort[i], DictionarySortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], DictionarySortCriteria.ASCENDENCY_NONE));

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
        // Write columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showOrder", AbstractFormBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showFamily", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));
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
        // Column to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showOrder", AbstractFormBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showFamily", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));
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
     * Getter for showFamily property.
     * @return showFamily.
     */
    public String getShowFamily() {
        return showFamily;
    }

    /**
     * Setter for showFamily property.
     * @param showFamily showFamily.
     */
    public void setShowFamily(String showFamily) {
        this.showFamily = showFamily;
    }

    /**
     * Getter for showGroup property.
     * @return showGroup.
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter for showGroup property.
     * @param showGroup showGroup.
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
    }

    /**
     * Getter for showOrder property.
     * @return showOrder.
     */
    public String getShowOrder() {
        return showOrder;
    }

    /**
     * Setter for showOrder property.
     * @param showOrder showOrder.
     */
    public void setShowOrder(String showOrder) {
        this.showOrder = showOrder;
    }

    /**
     * Getter for showVernacularNames property.
     * @return showVernacularNames.
     */
    public String getShowVernacularNames() {
        return showVernacularNames;
    }

    /**
     * Setter for showVernacularNames property.
     * @param showVernacularNames showVernacularNames.
     */
    public void setShowVernacularNames(String showVernacularNames) {
        this.showVernacularNames = showVernacularNames;
    }

    /**
     * Getter for expand property.
     * @return expand.
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Setter for expand property.
     * @param expand expand.
     */
    public void setExpand(String expand) {
        this.expand = expand;
    }
}
