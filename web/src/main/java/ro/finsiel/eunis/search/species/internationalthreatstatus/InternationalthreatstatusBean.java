package ro.finsiel.eunis.search.species.internationalthreatstatus;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for species->international-threat-status.
 *
 * @author finsiel.
 */
public class InternationalthreatstatusBean extends AbstractFormBean {

    /**
     * First/Second form operator (starts with, is, contains).
     */
    private String idGroup = null;
    private String idCountry = null;

    /**
     * First form - Scientific name.
     */
    private String idConservation = null;

    private Long indice = new Long(-1);

    /**
     * Expand collapse common names.
     */
    private String expand = null;

    // Columns that will be displayed in the result window
    /**
     * Display / Hide Status column.
     */
    private String showStatus = null;

    /**
     * Display / Hide Geographic region column.
     */
    private String showGeo = null;

    /**
     * Display / Hide Group column.
     */
    private String showGroup = null;

    /**
     * Display / Hide Order column.
     */
    private String showOrder = null;

    /**
     * Display / Hide Family column.
     */
    private String showFamily = null;

    /**
     * Display / Hide Scientific name column.
     */
    private String showScientificName = null;

    /**
     * Display / Hide Common names column.
     */
    private String showVernacularNames = null;

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     *
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null != idGroup && null != idCountry && null != idConservation) {
            Integer idGroup = Utilities.checkedStringToInt(this.idGroup, new Integer(-1));
            Integer idCountry = Utilities.checkedStringToInt(this.idCountry, new Integer(-1));
            Integer idConservation = Utilities.checkedStringToInt(this.idConservation, new Integer(-1));

            criterias.addElement(new InternationalthreatstatusSearchCriteria(idGroup, idCountry, idConservation));
        }

        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[ i ],
                        InternationalthreatstatusSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[ i ], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new InternationalthreatstatusSearchCriteria(criteriaSearch[ i ], _criteriaType, _oper));
            }
        }

        InternationalthreatstatusSearchCriteria[] ret = new InternationalthreatstatusSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[ i ] = (InternationalthreatstatusSearchCriteria) criterias.get(i);
        }
        return ret;
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again...
     *
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            InternationalthreatstatusSortCriteria criteria = new InternationalthreatstatusSortCriteria(
                    Utilities.checkedStringToInt(sort[ i ], InternationalthreatstatusSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[ i ], InternationalthreatstatusSortCriteria.ASCENDENCY_NONE));

            criterias[ i ] = criteria;
        }
        return criterias; // Note the upcast done here.
    }

    /**
     * This method is used to retrieve the basic criteria used to do the first search.
     *
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        Integer idGroup = Utilities.checkedStringToInt(this.idGroup, new Integer(-1));
        Integer idCountry = Utilities.checkedStringToInt(this.idCountry, new Integer(-1));
        Integer idConservation = Utilities.checkedStringToInt(this.idConservation, new Integer(-1));

        return new InternationalthreatstatusSearchCriteria(idGroup, idCountry, idConservation);
    }

    /**
     * Transform main search criteria.
     *
     * @return Searched criteria in human language.
     */
    public String getStringMain() {
        String result = "";

        if (idGroup != null && idCountry != null && idConservation != null) {
            String namegroup = Utilities.getGroupName(idGroup);
            String namecountry = Utilities.getCountryName(idCountry);
            String conserv = Utilities.getConservationName(idConservation);

            if (conserv != null) {
                result += " '" + conserv + "'";
            } else {
                result += "any";
            }
            if (namegroup != null) {
                result += " from group '" + namegroup + "'";
            } else {
                result += " from any group";
            }

            if (namecountry != null && namecountry.trim().length() > 0) {
                result += " and area '" + namecountry + "'";
            }
        }
        return result;
    }

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that
     * one should not manually write the URL.
     *
     * @param classFields Fields to be included in parameters.
     * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
     */
    public String toURLParam(Vector classFields) {
        StringBuffer url = new StringBuffer();

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[ i ];

            url.append(aSearch.toURLParam());
        }

        if (null != expand) {
            url.append(Utilities.writeURLParameter("expand", expand));
        }
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
     *
     * @param classFields Fields to be included in parameters.
     * @return An form compatible type of representation of request parameters.
     */
    public String toFORMParam(Vector classFields) {
        StringBuffer form = new StringBuffer();

        form.append(toFORMParamSuper(classFields));
        if (classFields.contains("criteriaSearch")) {
            AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

            for (int i = 0; i < searchCriterias.length; i++) {
                AbstractSearchCriteria aSearch = searchCriterias[ i ];

                form.append(aSearch.toFORMParam());
            }
        }
        if (null != idGroup) {
            form.append(Utilities.writeFormParameter("idGroup", idGroup));
        }
        if (null != idCountry) {
            form.append(Utilities.writeFormParameter("idCountry", idCountry));
        }
        if (null != idConservation) {
            form.append(Utilities.writeFormParameter("idConservation", idConservation));
        }
        if (null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        if (null != showStatus && showStatus.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showStatus", AbstractFormBean.SHOW.toString()));
        }
        if (null != showGeo && showGeo.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGeo", AbstractFormBean.SHOW.toString()));
        }
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
     * Getter for idGroup property.
     *
     * @return idGroup.
     */
    public String getIdGroup() {
        return idGroup;
    }

    /**
     * Setter for idGroup property.
     *
     * @param idGroup idGroup.
     */
    public void setIdGroup(String idGroup) {
        this.idGroup = idGroup;
    }

    /**
     * Getter for idConservation property.
     *
     * @return idConservation.
     */
    public String getIdConservation() {
        return idConservation;
    }

    /**
     * Setter for idConservation property.
     *
     * @param idConservation idConservation.
     */
    public void setIdConservation(String idConservation) {
        this.idConservation = idConservation;
    }

    /**
     * Getter for expand property.
     *
     * @return expand.
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Setter for expand property.
     *
     * @param expand expand.
     */
    public void setExpand(String expand) {
        this.expand = expand;
    }

    /**
     * Getter for indice property.
     *
     * @return indice.
     */
    public Long getIndice() {
        return indice;
    }

    /**
     * Setter for indice property.
     *
     * @param indice indice.
     */
    public void setIndice(Long indice) {
        this.indice = indice;
    }

    /**
     * Getter for showGroup property - Specifies if Group column will be displayed in resulted table.
     *
     * @return value of showGroup
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter for showGroup property - Specifies if Group column will be displayed in resulted table.
     *
     * @param showGroup new value for showGroup
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
    }

    /**
     * Getter for showStatus property - Specifies if Status column will be displayed in resulted table.
     *
     * @return value of showStatus
     */
    public String getShowStatus() {
        return showGroup;
    }

    /**
     * Setter for showStatus property - Specifies if Status column will be displayed in resulted table.
     *
     * @param showStatus new value for showStatus
     */
    public void setShowStatus(String showStatus) {
        this.showStatus = showStatus;
    }

    /**
     * Getter for showOrder property - Specifies if Order column will be displayed in resulted table.
     *
     * @return value of showOrder
     */
    public String getShowOrder() {
        return showOrder;
    }

    /**
     * Setter for showOrder property - Specifies if Order column will be displayed in resulted table.
     *
     * @param showOrder new value for showOrder
     */
    public void setShowOrder(String showOrder) {
        this.showOrder = showOrder;
    }

    /**
     * Getter for showFamily property - Specifies if Family column will be displayed in resulted table.
     *
     * @return value of showFamily
     */
    public String getShowFamily() {
        return showFamily;
    }

    /**
     * Setter for showFamily property - Specifies if Family column will be displayed in resulted table.
     *
     * @param showFamily new value for showFamily
     */
    public void setShowFamily(String showFamily) {
        this.showFamily = showFamily;
    }

    /**
     * Getter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
     *
     * @return value of showScientificName
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
     *
     * @param showScientificName value of showScientificName
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showVernacularNames property - Specifies if Common Names column will be displayed in resulted table.
     * Note that if this is true, then expand/collapse will be available in page.
     *
     * @return value of showVernacularNames
     */
    public String getShowVernacularNames() {
        return showVernacularNames;
    }

    /**
     * Setter for showVernacularNames property - Specifies if Common Names column will be displayed in resulted table.
     * Note that if this is true, then expand/collapse will be available in page.
     *
     * @param showVernacularNames new value for showVernacularNames
     */
    public void setShowVernacularNames(String showVernacularNames) {
        this.showVernacularNames = showVernacularNames;
    }

    /**
     * Getter.
     * @return idCountry
     */
    public String getIdCountry() {
        return idCountry;
    }

    /**
     * Setter.
     * @param idCountry New value
     */
    public void setIdCountry(String idCountry) {
        this.idCountry = idCountry;
    }

    /**
     * Getter.
     * @return showGeo
     */
    public String getShowGeo() {
        return showGeo;
    }

    /**
     * Setter.
     * @param showGeo New value
     */
    public void setShowGeo(String showGeo) {
        this.showGeo = showGeo;
    }
}

