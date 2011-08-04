package eionet.eunis.stripes.actions;

import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringEscapeUtils;

import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.TaxonomyDto;
import eionet.eunis.util.Constants;
import eionet.eunis.util.SimpleFrameworkUtils;

/**
 * Action bean to generate single taxonomy rdf.
 * 
 * @author Risto Alt
 */
@UrlBinding("/taxonomy/{idtaxonomy}")
public class TaxonomyActionBean extends AbstractStripesAction {

    private String idtaxonomy = "";

    /**
     * @see eionet.eunis.stripes.actions.RdfAware#generateRdf()
     */
    @DefaultHandler
    public Resolution generateRdf() {

        List<Chm62edtTaxcodePersist> list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + idtaxonomy + "'");
        if (list != null && list.size() > 0) {
            Chm62edtTaxcodePersist taxonomy = list.get(0);

            TaxonomyDto dto = new TaxonomyDto();
            dto.setTaxonomyId(taxonomy.getIdTaxcode());
            dto.setLevel(taxonomy.getTaxonomicLevel());
            dto.setName(StringEscapeUtils.escapeXml(taxonomy.getTaxonomicName()));
            dto.setLink(new ResourceDto(taxonomy.getIdTaxcodeLink(), "http://eunis.eea.europa.eu/taxonomy/"));
            dto.setParent(new ResourceDto(taxonomy.getIdTaxcodeParent(), "http://eunis.eea.europa.eu/taxonomy/"));
            dto.setSource(new ResourceDto(taxonomy.getIdDc().toString(), "http://eunis.eea.europa.eu/documents/"));
            dto.setNotes(StringEscapeUtils.escapeXml(taxonomy.getNotes()));

            return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, SimpleFrameworkUtils.convertToString(TaxonomyDto.HEADER, dto,
                    Constants.RDF_FOOTER));
        } else {
            return new ErrorResolution(404);
        }
    }

    public String getIdtaxonomy() {
        return idtaxonomy;
    }

    public void setIdtaxonomy(String idtaxonomy) {
        this.idtaxonomy = idtaxonomy;
    }
}
