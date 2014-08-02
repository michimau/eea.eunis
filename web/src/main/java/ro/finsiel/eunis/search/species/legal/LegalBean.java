package ro.finsiel.eunis.search.species.legal;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for species->legal instruments.
 * @author finsiel
 */
public class LegalBean extends AbstractFormBean {

    /** Bean field for Group name (groupID in fact). */
    private String groupName = null;

    /** Bean field used for Scientific name. */
    private String scientificName = null;

    /** Bean field for Legal text. */
    private String legalText = null;

    /** Bean field for annex (used in conjuction with legal text).*/
    private String annex = null;

    /** Type of search (legal texts or species referenced by legal texts).*/
    private String typeForm = null;

    /** Show or hide Group column. */
    private String showGroup = null;

    /** Show or hide Scientific name column. */
    private String showScientificName = null;

    /** Show or hide Legal Text column. */
    private String showLegalText = null;

    /** Show or hide URL column. */
    private String showURL = null;

    /** Show or hide COMMENT column. */
    private String showComment = null;

    /** Show or hide Abbreviation column. */
    private String showAbbreviation = null;

    private String dcId = null;

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        // Form 1
        if (null != groupName && null != scientificName) {
            // Note that here annex can be null 'cause it's not used for this search
            criterias.addElement(new LegalSearchCriteria(groupName, scientificName, annex, LegalSearchCriteria.CRITERIA_SPECIES));
        }
        // Form 2
        if (null != groupName && null != dcId) {
            criterias.addElement(new LegalSearchCriteria(groupName, legalText, dcId, LegalSearchCriteria.CRITERIA_LEGAL));
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper & null != typeForm) {
            Integer _typeForm = Utilities.checkedStringToInt(typeForm, LegalSearchCriteria.CRITERIA_SPECIES);

            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new LegalSearchCriteria(criteriaSearch[i], _criteriaType, _oper, _typeForm));
            }
        }

        LegalSearchCriteria[] ret = new LegalSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (LegalSearchCriteria) criterias.get(i);
        }
        return ret;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again.
     * @return A list of AbstractSearchCriteria objects used to do the sorting
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
        // Added automatically
        if (null != typeForm) {
            url.append(Utilities.writeURLParameter("typeForm", typeForm.toString()));
        }
        if (null != groupName) {
            url.append(Utilities.writeURLParameter("groupName", groupName));
        }
        // Columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showLegalText && showLegalText.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLegalText", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showURL && showURL.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showURL", AbstractFormBean.SHOW.toString()));
        }
        if (null != showComment && showComment.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showComment", AbstractFormBean.SHOW.toString()));
        }
        if (null != showAbbreviation && showAbbreviation.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showAbbreviation", AbstractFormBean.SHOW.toString()));
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

        form.append(toFORMParamSuper(classFields));
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            form.append(aSearch.toFORMParam());
        }
        // Added automatically
        form.append(Utilities.writeFormParameter("groupName", groupName));
        form.append(Utilities.writeFormParameter("typeForm", typeForm.toString()));

        // Columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showLegalText && showLegalText.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLegalText", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showURL && showURL.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showURL", AbstractFormBean.SHOW.toString()));
        }
        if (null != showComment && showComment.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showComment", AbstractFormBean.SHOW.toString()));
        }
        if (null != showAbbreviation && showAbbreviation.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showAbbreviation", AbstractFormBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for scientificName property - The scientific name used for primary search.
     * @return value of scientificName
     */
    public String getScientificName() {
        return scientificName;
    }

    /**
     * Setter for scientificName property - The scientific name used for primary search.
     * @param scientificName new value for scientificName
     */
    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    /**
     * Getter for groupName property - Used for group selected in search.
     * @return value of groupName
     */
    public String getGroupName() {
        return groupName;
    }

    /**
     * Setter for groupName property - Used for group selected in search.
     * @param groupName new value for groupName
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    /**
     * Getter for legalText property - The legal text used to search for.
     * @return value of legalText.
     */
    public String getLegalText() {
        return legalText;
    }

    /**
     * Setter for legalText property - The legal text used to search for.
     * @param legalText new value for legalText
     */
    public void setLegalText(String legalText) {
        this.legalText = legalText;
    }

    /**
     * Getter for typeForm property - The form we came from.
     * @return value of typeForm
     */
    public String getTypeForm() {
        return typeForm;
    }

    /**
     * Setter for typeForm property - The form we came from.
     * @param typeForm new value for typeForm
     */
    public void setTypeForm(String typeForm) {
        this.typeForm = typeForm;
    }

    /**
     * Getter for annex property - Legal text (Annex) where we search in.
     * @return value of annex
     */
    public String getAnnex() {
        return annex;
    }

    /**
     * Setter for annex property - Legal text (Annex) where we search in.
     * @param annex new value for annex
     */
    public void setAnnex(String annex) {
        this.annex = annex;
    }

    /**
     * Getter for showGroup - Show / Hide group column.
     * @return value of showGroup
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter for showGroup property - Show / Hide group column.
     * @param showGroup new value for showGroup
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
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

    /**
     * Getter for showURL property - Show / Hide URL column.
     * @return value of showURL
     */
    public String getShowURL() {
        return showURL;
    }

    /**
     * Setter for showURL property - Show / Hide URL column.
     * @param showURL new value for URL
     */
    public void setShowURL(String showURL) {
        this.showURL = showURL;
    }

    /**
     * Getter.
     * @return showComment
     */
    public String getShowComment() {
        return showComment;
    }

    /**
     * Setter.
     * @param showComment New value
     */
    public void setShowComment(String showComment) {
        this.showComment = showComment;
    }

    /**
     * Getter.
     * @return showAbbreviation
     */
    public String getShowAbbreviation() {
        return showAbbreviation;
    }

    /**
     * Setter.
     * @param showAbbreviation new value
     */
    public void setShowAbbreviation(String showAbbreviation) {
        this.showAbbreviation = showAbbreviation;
    }

    public String getDcId() {
        return dcId;
    }

    public void setDcId(String dcId) {
        this.dcId = dcId;
    }
}
