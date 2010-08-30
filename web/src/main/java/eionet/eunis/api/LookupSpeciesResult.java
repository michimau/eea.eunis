package eionet.eunis.api;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.ElementArray;
import org.simpleframework.xml.Root;


/**
 * Class to represent lookup species search result.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleks21@gmail.com">contact</a>
 */
@Root(strict = false, name="l:result")
public class LookupSpeciesResult implements Serializable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	@Attribute(name = "xmlns:l")
	@SuppressWarnings("unused")
	private static final String namespace = "http://eunis.eea.europa.eu/api/ns";
	
	
	@ElementArray(name = "full", empty = false, required = false, entry = "l:species")
	private SpeciesDTO[] fullMatches;
	
	@ElementArray(name = "fuzzy", empty = false, required = false, entry = "l:species")
	private SpeciesDTO[] fuzzyMatches;

	public SpeciesDTO[] getFullMatches() {
		return fullMatches;
	}

	public void setFullMatches(SpeciesDTO[] fullMatches) {
		this.fullMatches = fullMatches;
	}

	public SpeciesDTO[] getFuzzyMatches() {
		return fuzzyMatches;
	}

	public void setFuzzyMatches(SpeciesDTO[] fuzzyMatches) {
		this.fuzzyMatches = fuzzyMatches;
	}
}
