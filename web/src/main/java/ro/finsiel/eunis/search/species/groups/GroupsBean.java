package ro.finsiel.eunis.search.species.groups;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for species->groups.
 * @author finsiel.
 */
public class GroupsBean extends AbstractFormBean {

    /** ID_GROUP of the specified group. */
    private String groupID = null;

    /** SCIENTIFIC NAME of the specified group. */
    private String groupName = null;

    /** Expand or collapse vernacular names. Only will work if also showVernacularNames is set. */
    private String expand = null;

    /** Show / Hide Group column. */
    private String showGroup = null;

    /** Show / Hide Order column. */
    private String showOrder = null;

    /** Show / Hide Family column. */
    private String showFamily = null;

    /** Show / Hide Scientific name column. */
    private String showScientificName = null;

    /** Show / Hide Vernacular names column. */
    private String showVernacularNames = null;

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null != groupID) {
            criterias.addElement(new GroupSearchCriteria(Utilities.checkedStringToInt(groupID, new Integer(0))));
        }
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer critType = Utilities.checkedStringToInt(criteriaType[i], GroupSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer op = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new GroupSearchCriteria(criteriaSearch[i], critType, op));
            }
        }
    
        GroupSearchCriteria[] ret = new GroupSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (GroupSearchCriteria) criterias.get(i);
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
            GroupSortCriteria criteria = new GroupSortCriteria(
                    Utilities.checkedStringToInt(sort[i], GroupSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], GroupSortCriteria.ASCENDENCY_NONE));

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
        url.append(Utilities.writeURLParameter("groupName", groupName));
        if (classFields.contains("expand")) {
            if (null != expand) {
                url.append(Utilities.writeURLParameter("expand", expand));
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

        form.append(toFORMParamSuper(classFields));
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            form.append(aSearch.toFORMParam());
        }
        form.append(Utilities.writeFormParameter("groupName", groupName));
        if (null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        // Write columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGroup", GroupsBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showOrder", GroupsBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showFamily", GroupsBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", GroupsBean.SHOW.toString()));
        }
        if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularNames", GroupsBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for groupID property - ID Geoscope of the selected group.
     * @return value of groupID
     */
    public String getGroupID() {
        return groupID;
    }

    /**
     * Setter for groupID property - ID Geoscope of the selected group.
     * @param groupID new value for groupID
     */
    public void setGroupID(String groupID) {
        this.groupID = groupID;
    }

    /**
     * Getter for groupName property - Scientific name of the selected group.
     * @return The value of group in human language...
     */
    public String getGroupName() {
        return groupName;
    }

    /**
     * Setter for groupName property - Scientific name of the selected group.
     * @param groupName new value for group name.
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    /**
     * Setter for expand property - Expand / Collapse vernacular names column.
     * @return value of expand property
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Setter for expand property - Expand / Collapse vernacular names column.
     * @param expand new value for expand property
     */
    public void setExpand(String expand) {
        this.expand = expand;
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
     * @return scientificName
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
     * Getter for showVernacularNames property - Show / Hide Vernacular names column.
     * @return value of showVernacularNames
     */
    public String getShowVernacularNames() {
        return showVernacularNames;
    }

    /**
     * Setter for showVernacularNames - Show / Hide Vernacular names column.
     * @param showVernacularNames new value for showVernacularNames
     */
    public void setShowVernacularNames(String showVernacularNames) {
        this.showVernacularNames = showVernacularNames;
    }

    /**
     * Getter.
     * @return showGroup
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter.
     * @param showGroup New value
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
    }

    /**
     * Test method.
     * @param args Command line arguments.
     */
    public static void main(String[] args) {
        GroupsBean bean = new GroupsBean();

        bean.setGroupID("2");
        Vector classFields = new Vector();

        classFields.addElement("groupID");
        classFields.addElement("currentPage");
        classFields.addElement("pageSize");
        classFields.addElement("sort");
        classFields.addElement("ascendency");
        // System.out.println(bean.toFORMParam(classFields));
        // System.out.println(bean.toSearchCriteria());
        // System.out.println(bean.toSortCriteria());
        // System.out.println(bean.toURLParam(classFields));
    }
}
