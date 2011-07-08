package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * Interactive map
 * @author altnyris
 */
@UrlBinding("/gis-tool")
public class GisToolActionBean extends AbstractStripesAction {

    private String btrail;
    private String pageTitle = "";
    private String metaDescription = "";

    @DefaultHandler
    public Resolution init() {
        String eeaHome = getContext().getInitParameter("EEA_HOME");
        btrail = "eea#" + eeaHome + ",home#index.jsp,gis_tool";
        pageTitle = "EUNIS Viewer";
        return new ForwardResolution("/stripes/gis-tool.jsp");
    }

    public String getBtrail() {
        return btrail;
    }

    public String getPageTitle() {
        return pageTitle;
    }

    public String getMetaDescription() {
        return metaDescription;
    }

}
