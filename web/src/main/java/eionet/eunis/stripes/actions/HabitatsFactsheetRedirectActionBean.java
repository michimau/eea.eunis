package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * ActionBean to replace old /habitats-factsheet.jsp.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/habitats-factsheet.jsp")
public class HabitatsFactsheetRedirectActionBean extends AbstractStripesAction {
	
    private static final String[] allTypes = new String[] {
        "general", "distribution", "instruments", "habitats", "sites", "species", "other"}; 
	
    private String idHabitat;
	
    // selected tab
    private int tab;
    private int mini = -1;
	
    @DefaultHandler
    public Resolution index() {
		
        String tabName = allTypes[tab];
        String url = "/habitats/" + idHabitat;

        if (tabName != null && tabName.length() > 0) {
            url += "/" + tabName;
        }
        if (mini > -1) {
            url += "?mini=" + mini;
        }
        RedirectResolution redirect = new RedirectResolution(url);

        return redirect;
    }

    /**
     * @return the currentTab
     */
    public int getTab() {
        return tab;
    }

    /**
     * @param currentTab the currentTab to set
     */
    public void setTab(int tab) {
        if (tab > 6 || tab < 0) {
            tab = 0;
        }
        this.tab = tab;
    }

    public int getMini() {
        return mini;
    }

    public void setMini(int mini) {
        this.mini = mini;
    }

    public String getIdHabitat() {
        return idHabitat;
    }

    public void setIdHabitat(String idHabitat) {
        this.idHabitat = idHabitat;
    }

}
