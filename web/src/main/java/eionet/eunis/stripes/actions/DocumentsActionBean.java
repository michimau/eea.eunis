package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import eionet.eunis.stripes.extensions.Redirect303Resolution;


/**
 * Action bean for redirecting documents/ url to references/.
 *
 * @author Risto Alt
 */
@UrlBinding("/documents/{iddoc}/{tab}")
public class DocumentsActionBean extends AbstractStripesAction {

    private String iddoc;
    private String tab;
    private String domainName;

    @DefaultHandler
    public Resolution defaultAction() {

        domainName = getContext().getInitParameter("DOMAIN_NAME");
        if (iddoc == null || iddoc.length() == 0) {
            if (tab != null && tab.length() > 0) {
                iddoc = "/";
            } else {
                iddoc = "";
            }
        } else {
            iddoc = iddoc + "/";
        }
        if (tab == null) {
            tab = "";
        }
        return new Redirect303Resolution(domainName + "/references/" + iddoc + tab);
    }

    public String getIddoc() {
        return iddoc;
    }

    public void setIddoc(String iddoc) {
        this.iddoc = iddoc;
    }

    public String getTab() {
        return tab;
    }

    public void setTab(String tab) {
        this.tab = tab;
    }
}
