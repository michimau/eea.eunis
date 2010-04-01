package eionet.eunis.stripes.actions;

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
	public Resolution index(){
		pageTitle = getContext().getInitParameter("PAGE_TITLE") + " " + natureObject + " "+ getContentManagement().cms("advanced_search");
		
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

}
