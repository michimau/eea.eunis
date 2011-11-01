package eionet.eunis.stripes.actions;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import eionet.eunis.dto.TaxonomyDto;
import eionet.eunis.rdf.GenerateTaxonomyRDF;
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

        GenerateTaxonomyRDF genRdf = new GenerateTaxonomyRDF(idtaxonomy);
        TaxonomyDto dto = genRdf.getTaxonomyRdf();

        if (dto != null) {
            return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, SimpleFrameworkUtils.convertToString(
                    GenerateTaxonomyRDF.HEADER, dto, Constants.RDF_FOOTER));
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
