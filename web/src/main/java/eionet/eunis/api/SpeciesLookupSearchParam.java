package eionet.eunis.api;

/**
 * Object to incapsulate lookup species search parameters from API.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleks21@gmail.com">contact</a>
 */
public class SpeciesLookupSearchParam {

	private String speciesName;
	
	private String author;
	
	private boolean returnExactMatches;
	
	private int maxLevenshteinDistance;

	public SpeciesLookupSearchParam() {

	}

	public SpeciesLookupSearchParam(String speciesName, String author) {
		super();
		this.speciesName = speciesName;
		this.author = author;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public boolean isReturnExactMatches() {
		return returnExactMatches;
	}

	public void setReturnExactMatches(boolean returnExactMatches) {
		this.returnExactMatches = returnExactMatches;
	}

	public int getMaxLevenshteinDistance() {
		return maxLevenshteinDistance;
	}

	public void setMaxLevenshteinDistance(int maxLevenshteinDistance) {
		this.maxLevenshteinDistance = maxLevenshteinDistance;
	}
}
