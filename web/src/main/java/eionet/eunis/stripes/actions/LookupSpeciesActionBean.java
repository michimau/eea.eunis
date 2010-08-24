package eionet.eunis.stripes.actions;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

/**
 * API interface to allow species to be fuzzily looked up. 
 *
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@UrlBinding("/api/lookup-species")
public class LookupSpeciesActionBean extends AbstractStripesAction {
	
	private String species;
	
	private String author;

	@DefaultHandler
	public Resolution lookupSpecies() {
		if (species == null) {
			return new RedirectResolution("/index.jsp");
		}
		return new RedirectResolution("/index.jsp");
	}
	
	public String getSpecies() {
		return species;
	}

	public void setSpecies(String species) {
		this.species = species;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

}
