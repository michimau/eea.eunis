package ro.finsiel.eunis.search.habitats.legal;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for habitats->Legal instruments.
 * @author finsiel
 */
public class LegalBean extends AbstractFormBean {

    /** Type drop box.*/
    private String habitatType = null;

    /** Scientific name search string. */
    private String searchString = null;

    /** Lagal text. */
    private String legalText = null;

    /** Show level column. */
    private String showLevel = null;

    /** Show code column. */
    private String showCode = null;

    /** Show Scientific name column. */
    private String showScientificName = null;

    /** Show Legal Instrumentation column. */
    private String showLegalText = null;

    /**
     * Get the main search criteria for this search.
     * @return null if search criteria object or null if cannot be constructed
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        LegalSearchCriteria ret = null;

        if (null == searchString) {
            searchString = "%";
        }
        if (null != habitatType && null != legalText) {
            Integer queryType = LegalSearchCriteria.TYPE_A_HAB_A_TEXT;

            // A HABITAT, ANY TEXT
            if (legalText.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_A_HAB_ANY_TEXT;
            }
            // ANY HABITAT, A TEXT
            if (habitatType.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_ANY_HAB_A_TEXT;
            }
            // ANY HABITAT, ANY TEXT
            if (habitatType.equalsIgnoreCase("any") && legalText.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_ANY_HAB_ANY_TEXT;
            }
            ret = new LegalSearchCriteria(habitatType, searchString, legalText, queryType);
        }
        return ret;
    }

    /**
     * Retrieve subsequent search criterias used for searching.
     * @return Subsequent search criteria from main page.
     */
    public AbstractSearchCriteria[] getMainSearchCriteriasExtra() {
        return new AbstractSearchCriteria[0];
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null == searchString) {
            searchString = "%";
        }
        // Main search criteria
        if (null != habitatType && null != legalText) {
            Integer queryType = LegalSearchCriteria.TYPE_A_HAB_A_TEXT;

            // A HABITAT, ANY TEXT
            if (legalText.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_A_HAB_ANY_TEXT;
            }
            // ANY HABITAT, A TEXT
            if (habitatType.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_ANY_HAB_A_TEXT;
            }
            // ANY HABITAT, ANY TEXT
            if (habitatType.equalsIgnoreCase("any") && legalText.equalsIgnoreCase("any")) {
                queryType = LegalSearchCriteria.TYPE_ANY_HAB_ANY_TEXT;
            }
            criterias.addElement(new LegalSearchCriteria(habitatType, searchString, legalText, queryType));
        }
        // Search in results criterias
        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new LegalSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return objects which are used for sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            LegalSortCriteria criteria = new LegalSortCriteria(
                    Utilities.checkedStringToInt(sort[i], LegalSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], LegalSortCriteria.ASCENDENCY_NONE));

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
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            url.append(aSearch.toURLParam());
        }
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", AbstractFormBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showLegalText && showLegalText.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLegalText", AbstractFormBean.SHOW.toString()));
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
        if (null == searchString) {
            searchString = "%";
        }
        StringBuffer form = new StringBuffer();

        form.append(toFORMParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            form.append(aSearch.toFORMParam());
        }
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", AbstractFormBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showLegalText && showLegalText.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLegalText", AbstractFormBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for habitatType property - Type of EUNIS habitat we're searching in.
     * @return value of habitatType.
     */
    public String getHabitatType() {
        return habitatType;
    }

    /**
     * Setter for habitatType property - Type of EUNIS habitat we're searching in.
     * @param habitatType new value for habitatType
     */
    public void setHabitatType(String habitatType) {
        this.habitatType = habitatType;
    }

    /**
     * Getter for searchString property - Searched string.
     * @return value of searchString property
     */
    public String getSearchString() {
        return searchString;
    }

    /**
     * Setter for searchString property - Searched string.
     * @param searchString new value for searchString property.
     */
    public void setSearchString(String searchString) {
        this.searchString = searchString;
    }

    /**
     * Getter for legalText property - Legal text we're searching in.
     * @return value of legalText
     */
    public String getLegalText() {
        return legalText;
    }

    /**
     * Setter for legalText property - Legal text we're searching in.
     * @param legalText new value for legalText
     */
    public void setLegalText(String legalText) {
        this.legalText = legalText;
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
     * Getter for showCode property - Show / Hide Code column.
     * @return value of showCode
     */
    public String getShowCode() {
        return showCode;
    }

    /**
     * Setter for showCode property - Show / Hide Code column.
     * @param showCode new value for showCode
     */
    public void setShowCode(String showCode) {
        this.showCode = showCode;
    }

    /**
     * Getter for showScientificName property - Show / Hide Scientific name column.
     * @return value of showScientificName
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property - Show / Hide Scientific name column.
     * @param showScientificName new value for showScientificName
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showLegalText property - Show / Hide Legal text column.
     * @return value of showLegalText
     */
    public String getShowLegalText() {
        return showLegalText;
    }

    /**
     * Setter for showLegalText property - Show / Hide Legal text column.
     * @param showLegalText new value for showLegalText
     */
    public void setShowLegalText(String showLegalText) {
        this.showLegalText = showLegalText;
    }
}
