package eionet.eunis.stripes.actions;


import java.util.ArrayList;
import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * ActionBean to replace old /species-advanced.jsp.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/speciesAdvancedSearch/{natureObject}")
public class SpeciesAdvancedActionBean extends AbstractStripesAction {
    private String natureObject = "";
    private String pageTitle = "";

    @DefaultHandler
    public Resolution index() {
        pageTitle = getContext().getInitParameter("PAGE_TITLE") + " "
                + natureObject + " "
                + getContentManagement().cms("advanced_search");

        return new ForwardResolution("/stripes/species-advanced.layout.jsp");
    }

    public String getNatureObject() {
        return natureObject;
    }

    public void setNatureObject(String natureObject) {
        this.natureObject = natureObject;
    }

    public String getPageTitle() {
        return pageTitle;
    }

    public List<String> getAttributesList() {
        ArrayList<String> attributes = new ArrayList<String>();

        attributes.add(getContentManagement().cms("scientific_name"));
        attributes.add(getContentManagement().cms("vernacular_name"));
        attributes.add(getContentManagement().cms("group"));
        attributes.add(getContentManagement().cms("threat_status"));
        attributes.add(getContentManagement().cms("international_threat_status"));
        attributes.add(getContentManagement().cms("country"));
        attributes.add(getContentManagement().cms("biogeoregion"));
        attributes.add(getContentManagement().cms("reference_author"));
        attributes.add(getContentManagement().cms("reference_title"));
        attributes.add(getContentManagement().cms("species_advanced_19"));
        attributes.add(getContentManagement().cms("taxonomy"));
        attributes.add(getContentManagement().cms("abundance"));
        attributes.add(getContentManagement().cms("trend"));
        attributes.add(getContentManagement().cms("distribution_status"));

        return attributes;
    }

    public List<String> getOperatorsList() {
        ArrayList<String> operators = new ArrayList<String>();

        operators.add(getContentManagement().cms("equal"));
        operators.add(getContentManagement().cms("contains"));
        operators.add(getContentManagement().cms("between"));
        operators.add("Regex");

        return operators;
    }

    public List<String> getListForCtriteria() {
        ArrayList<String> values = new ArrayList<String>();

        values.add(getContentManagement().cms("all"));
        values.add(getContentManagement().cms("any"));

        return values;
    }

}
