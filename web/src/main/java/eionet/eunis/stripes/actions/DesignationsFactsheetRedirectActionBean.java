package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * ActionBean to replace old /designations-factsheet.jsp.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/designations-factsheet.jsp")
public class DesignationsFactsheetRedirectActionBean extends AbstractStripesAction {
	
    private String idDesign;
    private String geoscope;
    private boolean showSites = false;
    private String fromWhere = "";
	
    @DefaultHandler
    public Resolution index() {
		
        String url = "/designations/" + geoscope + ":" + idDesign;

        if (showSites) {
            url += "?showSites=true";
        }
        if (fromWhere != null && fromWhere.length() > 0) {
            if (url.indexOf("?") > -1) {
                url += "&";
            } else {
                url += "?";
            }
            url += "fromWhere=" + fromWhere;
        }
        RedirectResolution redirect = new RedirectResolution(url);

        return redirect;
    }

    public String getIdDesign() {
        return idDesign;
    }

    public void setIdDesign(String idDesign) {
        this.idDesign = idDesign;
    }

    public String getGeoscope() {
        return geoscope;
    }

    public void setGeoscope(String geoscope) {
        this.geoscope = geoscope;
    }

    public boolean isShowSites() {
        return showSites;
    }

    public void setShowSites(boolean showSites) {
        this.showSites = showSites;
    }

    public String getFromWhere() {
        return fromWhere;
    }

    public void setFromWhere(String fromWhere) {
        this.fromWhere = fromWhere;
    }

    /**
     * @return the currentTab
     */
	


}
