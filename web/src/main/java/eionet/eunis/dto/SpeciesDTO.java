package eionet.eunis.dto;

import java.io.Serializable;

/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public class SpeciesDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idSpecies;
	private String kingdom;
	private String phylum;
	private String speciesClass;
	private String order;
	private String family;
	private String genus;
	private String scientificName;
	private String author;
	private String validName;
	private String idSpeciesLink;
	private String typeRelatedSpecies;
	private String groupSpecies;
	private String taxonomicReference;
	private String idItis;
	private String idNcbi;
	private String idWorms;
	private String idRedlist;
	private String idFaeu;
	private String idGbif;
	
	public String getIdSpecies() {
		return idSpecies;
	}
	public void setIdSpecies(String idSpecies) {
		this.idSpecies = idSpecies;
	}
	public String getKingdom() {
		return kingdom;
	}
	public void setKingdom(String kingdom) {
		this.kingdom = kingdom;
	}
	public String getPhylum() {
		return phylum;
	}
	public void setPhylum(String phylum) {
		this.phylum = phylum;
	}
	public String getSpeciesClass() {
		return speciesClass;
	}
	public void setSpeciesClass(String speciesClass) {
		this.speciesClass = speciesClass;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public String getFamily() {
		return family;
	}
	public void setFamily(String family) {
		this.family = family;
	}
	public String getGenus() {
		return genus;
	}
	public void setGenus(String genus) {
		this.genus = genus;
	}
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
	public String getValidName() {
		return validName;
	}
	public void setValidName(String validName) {
		this.validName = validName;
	}
	public String getIdSpeciesLink() {
		return idSpeciesLink;
	}
	public void setIdSpeciesLink(String idSpeciesLink) {
		this.idSpeciesLink = idSpeciesLink;
	}
	public String getTypeRelatedSpecies() {
		return typeRelatedSpecies;
	}
	public void setTypeRelatedSpecies(String typeRelatedSpecies) {
		this.typeRelatedSpecies = typeRelatedSpecies;
	}
	public String getGroupSpecies() {
		return groupSpecies;
	}
	public void setGroupSpecies(String groupSpecies) {
		this.groupSpecies = groupSpecies;
	}
	public String getTaxonomicReference() {
		return taxonomicReference;
	}
	public void setTaxonomicReference(String taxonomicReference) {
		this.taxonomicReference = taxonomicReference;
	}
	public String getIdItis() {
		return idItis;
	}
	public void setIdItis(String idItis) {
		this.idItis = idItis;
	}
	public String getIdNcbi() {
		return idNcbi;
	}
	public void setIdNcbi(String idNcbi) {
		this.idNcbi = idNcbi;
	}
	public String getIdWorms() {
		return idWorms;
	}
	public void setIdWorms(String idWorms) {
		this.idWorms = idWorms;
	}
	public String getIdRedlist() {
		return idRedlist;
	}
	public void setIdRedlist(String idRedlist) {
		this.idRedlist = idRedlist;
	}
	public String getIdFaeu() {
		return idFaeu;
	}
	public void setIdFaeu(String idFaeu) {
		this.idFaeu = idFaeu;
	}
	public String getIdGbif() {
		return idGbif;
	}
	public void setIdGbif(String idGbif) {
		this.idGbif = idGbif;
	}
	
}
