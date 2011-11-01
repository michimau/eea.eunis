package eionet.eunis.rdf;

import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;

import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.TaxonomyDto;

public class GenerateTaxonomyRDF {

    /** RDF header with namespaces. */
    public static final String HEADER = "<rdf:RDF xmlns=\"http://eunis.eea.europa.eu/rdf/taxonomies-schema.rdf#\"\n"
        + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private Chm62edtTaxcodePersist taxonomy;
    private TaxonomyDto dto;

    public GenerateTaxonomyRDF(String idtaxonomy) {
        List<Chm62edtTaxcodePersist> list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + idtaxonomy + "' LIMIT 1");
        if (list != null && list.size() > 0) {
            this.taxonomy = list.get(0);
        }
    }

    public TaxonomyDto getTaxonomyRdf() {
        try {
            if (taxonomy != null) {
                dto = new TaxonomyDto();
                dto.setTaxonomyId(taxonomy.getIdTaxcode());
                dto.setLevel(taxonomy.getTaxonomicLevel());
                dto.setName(StringEscapeUtils.escapeXml(taxonomy.getTaxonomicName()));
                dto.setLink(new ResourceDto(taxonomy.getIdTaxcodeLink(), "http://eunis.eea.europa.eu/taxonomy/"));
                dto.setParent(new ResourceDto(taxonomy.getIdTaxcodeParent(), "http://eunis.eea.europa.eu/taxonomy/"));
                dto.setSource(new ResourceDto(taxonomy.getIdDc().toString(), "http://eunis.eea.europa.eu/references/"));
                dto.setNotes(StringEscapeUtils.escapeXml(taxonomy.getNotes()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }
}
