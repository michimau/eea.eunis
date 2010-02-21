package eionet.eunis.dto;

import java.io.Serializable;
import java.util.List;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;


/**
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@Root(strict = false, name = "species")
public class SpeciesFactsheetDto implements Serializable{
	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6343981482733538221L;

	public static final String HEADER = "<rdf:RDF " +
			"xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
			"xmlns:dwc=\"http://rs.tdwg.org/dwc/terms/\" \n" +
			"xmlns =\"http://eunis.eea.europa.eu/rdf/species-schema.rdf#\">\n";
			

	public static final String FOOTER = "\n</rdf:RDF>";

	
	@Element(required = false, name = "binomialName")
	private String scientificName;
	@Element(required = false, name = "dwc:scientificNameAuthorship")
	private String author;
	@Element(required = false, name = "dwc:genus")
	private String genus;
	@Element(required = false, name = "dwc:scientificName")
	private String dwcScientificName;
	@ElementList(required = false, type = VernacularNameDto.class, inline = true)
	private List<VernacularNameDto> vernacularNames;
	@Element(required = false, name = "synonymFor")
	private SpeciesSynonymDto synonymFor;
	@ElementList(required = false, inline = true, entry = "hasSynonym")
	private List<SpeciesSynonymDto> hasSynonyms;
	
	
	public String getScientificName() {
		return scientificName;
	}
	public void setScientificName(String scientificName) {
		this.scientificName = scientificName;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getGenus() {
		return genus;
	}
	public void setGenus(String genus) {
		this.genus = genus;
	}
	public List<VernacularNameDto> getVernacularNames() {
		return vernacularNames;
	}
	public void setVernacularNames(List<VernacularNameDto> vernacularNames) {
		this.vernacularNames = vernacularNames;
	}
	public String getDwcScientificName() {
		return dwcScientificName;
	}
	public void setDwcScientificName(String dwcScientificName) {
		this.dwcScientificName = dwcScientificName;
	}
	public SpeciesSynonymDto getSynonymFor() {
		return synonymFor;
	}
	public void setSynonymFor(SpeciesSynonymDto synonymFor) {
		this.synonymFor = synonymFor;
	}
	public List<SpeciesSynonymDto> getHasSynonyms() {
		return hasSynonyms;
	}
	public void setHasSynonyms(List<SpeciesSynonymDto> hasSynonyms) {
		this.hasSynonyms = hasSynonyms;
	}
	
	
	
}
