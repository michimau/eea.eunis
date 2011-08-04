package eionet.eunis.dto;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

/**
 * @author altnyris
 */
@Root(strict = false, name = "Taxonomy")
public class TaxonomyDto implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6343981482733538221L;

    public static final String HEADER = "<rdf:RDF xmlns=\"http://eunis.eea.europa.eu/rdf/taxonomies-schema.rdf#\"\n"
        + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private static final String DOMAIN_LOCATION = "http://eunis.eea.europa.eu/taxonomy/";

    private String taxonomyId;

    @Element(required = false, name = "level")
    private String level;

    @Element(required = false, name = "name")
    private String name;

    @Element(required = false, name = "link")
    private ResourceDto link;

    @Element(required = false, name = "parent")
    private ResourceDto parent;

    @Element(required = false, name = "dcterms:source")
    private ResourceDto source;

    @Element(required = false, name = "notes")
    private String notes;

    @Attribute(required = false, name = "rdf:about")
    public String getRdfAbout() {
        return DOMAIN_LOCATION + taxonomyId;
    }

    public String getTaxonomyId() {
        return taxonomyId;
    }

    public void setTaxonomyId(String taxonomyId) {
        this.taxonomyId = taxonomyId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ResourceDto getLink() {
        return link;
    }

    public void setLink(ResourceDto link) {
        this.link = link;
    }

    public ResourceDto getParent() {
        return parent;
    }

    public void setParent(ResourceDto parent) {
        this.parent = parent;
    }

    public ResourceDto getSource() {
        return source;
    }

    public void setSource(ResourceDto source) {
        this.source = source;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
