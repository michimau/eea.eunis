package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * ActionBean to replace old /species-factsheet.jsp.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/species-factsheet.jsp")
public class SpeciesFactsheetRedirectActionBean extends AbstractStripesAction {
	
    private static final String[] allTypes = new String[] {
        "general", "vernacular", "countries", "population", "trends", "references", "grid", "legal", "habitats", "sites", "gbif"}; 
	
    private String idSpecies;
    private int idSpeciesLink;
	
    // selected tab
    private int tab;
	
    @DefaultHandler
    public Resolution index() {
		
        String tabName = allTypes[tab];
        String url = "/species/" + idSpecies;

        if (tabName != null && tabName.length() > 0) {
            url += "/" + tabName;
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
        if (tab > 11 || tab < 0) {
            tab = 0;
        }
        this.tab = tab;
    }

    /**
     * @return the idSpecies
     */
    public String getIdSpecies() {
        return idSpecies;
    }

    /**
     * @param idSpecies the idSpecies to set
     */
    public void setIdSpecies(String idSpecies) {
        this.idSpecies = idSpecies;
    }

    /**
     * @return the idSpeciesLink
     */
    public int getIdSpeciesLink() {
        return idSpeciesLink;
    }

    /**
     * @param idSpeciesLink the idSpeciesLink to set
     */
    public void setIdSpeciesLink(int idSpeciesLink) {
        this.idSpeciesLink = idSpeciesLink;
    }

}
