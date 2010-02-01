package eionet.eunis.stripes.actions;

import java.util.LinkedList;
import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.util.Pair;

/**
 * ActionBean to replace old /species-factsheet.jsp.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species/{idSpecies}/{tab}")
public class SpeciesFactsheetActionBean extends AbstractStripesAction {
	
	private static final String[][] allTypes = new String[][]{
		{"GENERAL_INFORMATION","general"},
		{"VERNACULAR_NAMES","vern"},
		{"GEOGRAPHICAL_DISTRIBUTION","geo"},
		{"POPULATION","population"},
		{"TRENDS","trends"},
		{"REFERENCES","refs"},
		{"GRID_DISTRIBUTION","grid"},
		{"THREAT_STATUS","threat"},
		{"LEGAL_INSTRUMENTS","legal"},
		{"HABITATS","habitats"},
		{"SITES","sites"},
		{"GBIF","gbif"}}; 
	
	private String idSpecies;
	private int idSpeciesLink;
	
	private SpeciesFactsheet factsheet;
	private String scientificName = "";
	private String author = "";
	
	
	//selected tab
	private String tab;
	//tabs to display
	private List<Pair<String,String>> tabsWithData = new LinkedList<Pair<String,String>>();
	//refered from name
	private String referedFromName;

	
	@DefaultHandler
	public Resolution index(){
		
		if(tab == null || tab.length() == 0){
			tab = "general";
		}
		
		//sanity checks
		if(StringUtils.isBlank(idSpecies) && idSpeciesLink == 0) {
			factsheet = new SpeciesFactsheet(0, 0);
		}
		int tempIdSpecies = 0;
		//get idSpecies based on the request param.
		if (StringUtils.isNumeric(idSpecies)) {
			tempIdSpecies = new Integer(idSpecies);
		} else if (!StringUtils.isBlank(idSpecies)) {
			tempIdSpecies = getContext().getSpeciesFactsheetDao().getIdSpeciesForScientificName(this.idSpecies);
		}
		int mainIdSpecies = getContext().getSpeciesFactsheetDao().getCanonicalIdSpecies(tempIdSpecies);
		//it is not a synonym, check the referer
		if (mainIdSpecies == tempIdSpecies) {
			Integer referedFrom = (Integer) getContext().getFromSession("referer");
			if (referedFrom != null && referedFrom > 0) {
				getContext().removeFromSession("referer");
				referedFromName = getContext().getSpeciesFactsheetDao().getScientificName(referedFrom);
			}
			factsheet = new SpeciesFactsheet(mainIdSpecies, mainIdSpecies);
		}
		//it's a synonym for another specie, redirect.
		else {
			getContext().addToSession("referer", tempIdSpecies);
			RedirectResolution redirect = new RedirectResolution(getUrlBinding()).addParameter("idSpecies", mainIdSpecies);
			return redirect;
		}
		
		if (factsheet.exists()) {
			//set up some vars used in the presentation layer
			setMetaDescription(factsheet.getSpeciesDescription());
			scientificName = StringEscapeUtils.escapeHtml(
					factsheet.getSpeciesNatureObject().getScientificName());
			author  = StringEscapeUtils.escapeHtml(
					factsheet.getSpeciesNatureObject().getAuthor());
			
			SQLUtilities sqlUtil = getContext().getSqlUtilities();
			for (int i = 0; i< allTypes.length; i++) {
				if (!sqlUtil.TabPageIsEmpy(factsheet.getSpeciesNatureObject().getIdNatureObject().toString(), "SPECIES", allTypes[i][0])) {
					tabsWithData.add(new Pair<String, String>(allTypes[i][1], getContentManagement().cms(allTypes[i][0].toLowerCase())));
				}
			}
		}
		String eeaHome = getContext().getInitParameter("EEA_HOME");
		String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,factsheet";
		setBtrail(btrail);
		return new ForwardResolution("/stripes/species-factsheet.layout.jsp");
	}


	/**
	 * @return the factsheet
	 */
	public SpeciesFactsheet getFactsheet() {
		return factsheet;
	}

	/**
	 * @param factsheet the factsheet to set
	 */
	public void setFactsheet(SpeciesFactsheet factsheet) {
		this.factsheet = factsheet;
	}

	/**
	 * @return the currentTab
	 */
	public String getTab() {
		return tab;
	}

	/**
	 * @param currentTab the currentTab to set
	 */
	public void setTab(String tab) {
		this.tab = tab;
	}

	/**
	 * @return the tabsWithData
	 */
	public List<Pair<String, String>> getTabsWithData() {
		return tabsWithData;
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
	 * @return the referedFromName
	 */
	public String getReferedFromName() {
		return referedFromName;
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


	/**
	 * @return the scientificName
	 */
	public String getScientificName() {
		return scientificName;
	}


	/**
	 * @return the author
	 */
	public String getAuthor() {
		return author;
	}

}
