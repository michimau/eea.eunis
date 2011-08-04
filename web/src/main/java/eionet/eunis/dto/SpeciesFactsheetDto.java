package eionet.eunis.dto;


import java.io.Serializable;
import java.util.List;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;


/**
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@Root(strict = false, name = "SpeciesSynonym")
public class SpeciesFactsheetDto implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6343981482733538221L;

    public static final String HEADER = "<rdf:RDF " + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
    + "xmlns:dwc=\"http://rs.tdwg.org/dwc/terms/\" \n"
    + "xmlns =\"http://eunis.eea.europa.eu/rdf/species-schema.rdf#\">\n";

    private static final String DOMAIN_LOCATION = "http://eunis.eea.europa.eu/species/";

    @Element(required = false, name = "speciesCode")
    private int speciesId;

    @Element(required = false, name = "binomialName")
    private String scientificName;

    @Element(required = false, name = "validName")
    private DatatypeDto validName;

    @Element(required = false, name = "taxonomicRank")
    private String typeRelatedSpecies;

    @Element(required = false, name = "taxonomy")
    private ResourceDto taxonomy;

    @Element(required = false, name = "rdf:type")
    private ResourceDto dcmitype;

    @Element(required = false, name = "dwc:scientificNameAuthorship")
    private String author;

    @Element(required = false, name = "dwc:genus")
    private String genus;

    @Element(required = false, name = "dwc:scientificName")
    private String dwcScientificName;

    @Element(required = false, name = "dwc:kingdom")
    private String kingdom;

    @Element(required = false, name = "dwc:phylum")
    private String phylum;

    @Element(required = false, name = "dwc:class")
    private String dwcClass;

    @Element(required = false, name = "dwc:order")
    private String order;

    @Element(required = false, name = "dwc:family")
    private String family;

    @Element(required = false, name = "dwc:nameAccordingToID")
    private ResourceDto nameAccordingToID;

    @ElementList(required = false, type = VernacularNameDto.class, inline = true)
    private List<VernacularNameDto> vernacularNames;

    @Element(required = false, name = "synonymFor")
    private SpeciesSynonymDto synonymFor;

    @ElementList(required = false, inline = true, entry = "hasLegalReference")
    private List<LegalReferenceDTO> hasLegalReferences;

    @ElementList(required = false, inline = true, entry = "hasSynonym")
    private List<SpeciesSynonymDto> hasSynonyms;

    @ElementList(required = false, inline = true, entry = "isExpectedIn")
    private List<ResourceDto> expectedInLocations;

    @ElementList(required = false, inline = true)
    private List<AttributeDto> attributes;

    @Attribute(required = false, name = "rdf:about")
    public String getRdfAbout() {
        return DOMAIN_LOCATION + speciesId;
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

    public List<AttributeDto> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<AttributeDto> attributes) {
        this.attributes = attributes;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public List<ResourceDto> getExpectedInLocations() {
        return expectedInLocations;
    }

    public void setExpectedInLocations(List<ResourceDto> expectedInLocations) {
        this.expectedInLocations = expectedInLocations;
    }

    public ResourceDto getDcmitype() {
        return dcmitype;
    }

    public void setDcmitype(ResourceDto dcmitype) {
        this.dcmitype = dcmitype;
    }

    public List<LegalReferenceDTO> getHasLegalReferences() {
        return hasLegalReferences;
    }

    public void setHasLegalReferences(List<LegalReferenceDTO> hasLegalReferences) {
        this.hasLegalReferences = hasLegalReferences;
    }

    public DatatypeDto getValidName() {
        return validName;
    }

    public void setValidName(DatatypeDto validName) {
        this.validName = validName;
    }

    public String getTypeRelatedSpecies() {
        return typeRelatedSpecies;
    }

    public void setTypeRelatedSpecies(String typeRelatedSpecies) {
        this.typeRelatedSpecies = typeRelatedSpecies;
    }

    public ResourceDto getTaxonomy() {
        return taxonomy;
    }

    public void setTaxonomy(ResourceDto taxonomy) {
        this.taxonomy = taxonomy;
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

    public String getDwcClass() {
        return dwcClass;
    }

    public void setDwcClass(String dwcClass) {
        this.dwcClass = dwcClass;
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

    public ResourceDto getNameAccordingToID() {
        return nameAccordingToID;
    }

    public void setNameAccordingToID(ResourceDto nameAccordingToID) {
        this.nameAccordingToID = nameAccordingToID;
    }

}
