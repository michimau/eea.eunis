package ro.finsiel.eunis.search.species.country;


import java.util.Vector;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;


/**
 * This is the form bean used in Species->Country/Region type of search.
 * @author finsiel
 */
public final class CountryBean extends AbstractFormBean {

    /** country request parameter in ID geoscope.*/
    private String[] country = null;

    /** region request parameter in ID geoscope.*/
    private String[] region = null;

    /** country name - in human language.*/
    private String countryName = null;

    /** region name - in human language.*/
    private String regionName = null; // Region name in clear

    /** Used to show/hide the common names. */
    private String expand = null;

    /** Show / Hide Group column. */
    private String showGroup = null;

    /** Show / Hide Order column. */
    private String showOrder = null;

    /** Show / Hide Family column. */
    private String showFamily = null;

    /** Show / Hide Scientific name column. */
    private String showScientificName = null;

    /**
     * This method will transform the request parameters used for search into search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    @Override
    public AbstractSearchCriteria[] toSearchCriteria() {
        if (null == country || null == region) {
            return new AbstractSearchCriteria[0];
        }
        Vector criterias = new Vector();

        for (int i = 0; i < country.length; i++) {
            if (country[i].equals("any")) {
                CountrySearchCriteria cCriteria = new CountrySearchCriteria(country[i], region[i], countryName, regionName,
                        CountrySearchCriteria.CRITERIA_REGION_GEOSCOPE);

                criterias.addElement(cCriteria);
            }
            if (region[i].equals("any")) {
                CountrySearchCriteria rCriteria = new CountrySearchCriteria(country[i], region[i], countryName, regionName,
                        CountrySearchCriteria.CRITERIA_COUNTRY_GEOSCOPE);

                criterias.addElement(rCriteria);
            }
            if (!country[i].equalsIgnoreCase("any") && (!region[i].equalsIgnoreCase("any"))) {
                CountrySearchCriteria rCriteria = new CountrySearchCriteria(country[i], region[i], countryName, regionName,
                        CountrySearchCriteria.CRITERIA_BOTH_COUNTRY_REGION);

                criterias.addElement(rCriteria);
            }
        }
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer op = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_IS);
                Integer type = Utilities.checkedStringToInt(criteriaType[i], CountrySearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                CountrySearchCriteria criteria = new CountrySearchCriteria(criteriaSearch[i], type, op);

                criterias.addElement(criteria);
            }
        }
        CountrySearchCriteria[] ret = new CountrySearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (CountrySearchCriteria) criterias.get(i);
        }
        return ret; // Note the upcast done here.
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again...
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    @Override
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            CountrySortCriteria criteria = new CountrySortCriteria(Utilities.checkedStringToInt(sort[i], 0),
                    Utilities.checkedStringToInt(ascendency[i], 0));

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
    @Override
    public String toURLParam(Vector classFields) {

        StringBuffer url = new StringBuffer();

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        if (classFields.contains("country") && null != country) {
            url.append(Utilities.writeURLParameter("country", country));
        }
        if (classFields.contains("region") && null != region) {
            url.append(Utilities.writeURLParameter("region", region));
        }
        if (classFields.contains("criteriaSearch") && null != criteriaSearch) {
            url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
        }
        if (classFields.contains("oper") && null != oper) {
            url.append(Utilities.writeURLParameter("oper", oper));
        }
        if (classFields.contains("criteriaType") && null != criteriaType) {
            url.append(Utilities.writeURLParameter("criteriaType", criteriaType));
        }
        if (classFields.contains("expand") && null != expand) {
            url.append(Utilities.writeURLParameter("expand", expand));
        }
        // Write countryName unconditionately (only if non-null)
        if (null != countryName) {
            url.append(Utilities.writeURLParameter("countryName", countryName));
        }
        // Write regionName unconditionately (only if non-null)
        if (null != regionName) {
            url.append(Utilities.writeURLParameter("regionName", regionName));
        }
        // Columns to be displayed
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

        return url.toString();
    }

    /**
     * This method will transform the request parameters into a form compatible hidden input parameters, for example.
     * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
     * @param classFields Fields to be included in parameters.
     * @return An form compatible type of representation of request parameters.
     */
    @Override
    public String toFORMParam(Vector classFields) {
        StringBuffer form = new StringBuffer();

        form.append(super.toFORMParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        // Add the rest of the fields of this class
        if (classFields.contains("country") && null != country) {
            form.append(Utilities.writeFormParameter("country", country));
        }
        if (classFields.contains("region") && null != region) {
            form.append(Utilities.writeFormParameter("region", region));
        }
        if (classFields.contains("criteriaSearch") && null != criteriaSearch) {
            form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
        }
        if (classFields.contains("oper") && null != oper) {
            form.append(Utilities.writeFormParameter("oper", oper));
        }
        if (classFields.contains("criteriaType") && null != criteriaType) {
            form.append(Utilities.writeFormParameter("criteriaType", criteriaType));
        }
        if (classFields.contains("expand") && null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        // Write countryName unconditionately (only if non-null)
        if (null != countryName) {
            form.append(Utilities.writeFormParameter("countryName", countryName));
        }
        // Write regionName unconditionately (only if non-null)
        if (null != regionName) {
            form.append(Utilities.writeFormParameter("regionName", regionName));
        }
        // Write columns to be displayed
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

        return form.toString();
    }

    /** Getter for country property.
     * @return Value of country property
     */
    public String[] getCountry() {
        return country;
    }

    /** Setter for country property.
     * @param country New value for country property
     */
    public void setCountry(String[] country) {
        this.country = country;
    }

    /** Getter for region property.
     * @return Value of region property
     */
    public String[] getRegion() {
        return region;
    }

    /** Setter for region property.
     * @param region New value for region property
     */
    public void setRegion(String[] region) {
        this.region = region;
    }

    /** Getter for countryName property.
     * @return The value of countryName
     */
    public String getCountryName() {
        return countryName;
    }

    /** Setter for countryName property.
     * @param countryName New value for countryName property
     */
    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    /** Getter for regionName property.
     * @return The value of regionName
     */
    public String getRegionName() {
        return regionName;
    }

    /** Setter for regionName property.
     * @param regionName New value for regionName property
     */
    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    /**
     * Getter for expand property - Expand / Collapse Common names column.
     * @return value of expand
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Setter for expand property - Expand / Collapse Common names column.
     * @param expand new value for expand
     */
    public void setExpand(String expand) {
        this.expand = expand;
    }

    /**
     * Getter for showGroup property - Show / Hide Group column.
     * @return value of showGroup property
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter for showGroup property - Show / Hide Group column.
     * @param showGroup new value for showGroup
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
    }

    /**
     * Getter for showOrder property - Show / Hide Order column.
     * @return value of showOrder
     */
    public String getShowOrder() {
        return showOrder;
    }

    /**
     * Setter for showOrder property - Show / Hide Order column.
     * @param showOrder new value for showOrder
     */
    public void setShowOrder(String showOrder) {
        this.showOrder = showOrder;
    }

    /**
     * Getter for showFamily property - Show / Hide Family column.
     * @return value of showFamily
     */
    public String getShowFamily() {
        return showFamily;
    }

    /**
     * Setter for showFamily property - Show / Hide Family column.
     * @param showFamily new value for showFamily
     */
    public void setShowFamily(String showFamily) {
        this.showFamily = showFamily;
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
     * Testing method.
     * @param args Command line args
     */
    public static void main(String[] args) {
        CountryBean thisClass = new CountryBean();
        String[] someCountries = { "Romania", "Italia"};
        String[] someRegions = { "mountain", "sea"};
        String currentPage = "12";
        String pageSize = "200";

        thisClass.setCountry(someCountries);
        thisClass.setRegion(someRegions);
        thisClass.setCurrentPage(currentPage);
        thisClass.setPageSize(pageSize);
        Vector fields = new Vector();

        // fields.addElement("country");
        fields.addElement("region");
        fields.addElement("currentPage");
        fields.addElement("pageSize");
        // System.out.println(thisClass.toFORMParam(fields));
    }
}
