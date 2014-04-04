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
        pageTitle = getContext().getInitParameter("PAGE_TITLE") + " " + natureObject + " "
        + getContentManagement().cmsPhrase("Advanced Search");

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

        attributes.add(getContentManagement().cmsPhrase("Scientific name"));
        attributes.add(getContentManagement().cmsPhrase("Common Name"));
        attributes.add(getContentManagement().cmsPhrase("Group"));
        attributes.add(getContentManagement().cmsPhrase("Threat Status"));
        attributes.add(getContentManagement().cmsPhrase("International Threat Status"));
        attributes.add(getContentManagement().cmsPhrase("Country"));
        attributes.add(getContentManagement().cmsPhrase("Biogeoregion"));
        attributes.add(getContentManagement().cmsPhrase("Reference author"));
        attributes.add(getContentManagement().cmsPhrase("Reference title"));
        attributes.add(getContentManagement().cmsPhrase("Legal instr. title"));
        attributes.add(getContentManagement().cmsPhrase("Taxonomy"));
        attributes.add(getContentManagement().cmsPhrase("Abundance"));
        attributes.add(getContentManagement().cmsPhrase("Trend"));
        attributes.add(getContentManagement().cmsPhrase("Distribution Status"));

        return attributes;
    }

    public List<String> getOperatorsList() {
        ArrayList<String> operators = new ArrayList<String>();

        operators.add(getContentManagement().cmsPhrase("Equal"));
        operators.add(getContentManagement().cmsPhrase("Contains"));
        operators.add(getContentManagement().cmsPhrase("Between"));
        operators.add("Regex");

        return operators;
    }

    public List<String> getListForCtriteria() {
        ArrayList<String> values = new ArrayList<String>();

        values.add(getContentManagement().cmsPhrase("All"));
        values.add(getContentManagement().cmsPhrase("Any"));

        return values;
    }

}
