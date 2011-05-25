package eionet.eunis.stripes.actions;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.SpeciesDTO;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

/**
 * ActionBean for species XML dump
 * 
 * @author Risto Alt
 */
@UrlBinding("/dataimport/speciesdump")
public class SpeciesXMLDumpActionBean extends AbstractStripesAction {

    private static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<dataroot xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
            + "xsi:noNamespaceSchemaLocation=\"species.xsd\">\n";

    @DefaultHandler
    public Resolution init() {
        return new ForwardResolution("/stripes/speciesdump.jsp");
    }

    public Resolution generate() {

        return new StreamingResolution("text/xml") {
            public void stream(HttpServletResponse response) throws Exception {
                List<SpeciesDTO> species = DaoFactory.getDaoFactory().getSpeciesDao().getAllSpecies();

                response.getOutputStream().print(HEADER);
                for (SpeciesDTO sp : species) {
                    StringBuffer buf = new StringBuffer();

                    buf.append("<species>\n");
                    buf.append("    <ID_SPECIES>").append(sp.getIdSpecies()).append("</ID_SPECIES>\n");
                    if (sp.getKingdom() != null && sp.getKingdom().length() > 0) {
                        buf.append("    <Kingdom>").append(EunisUtil.replaceTags(sp.getKingdom(), true, true))
                                .append("</Kingdom>\n");
                    }
                    if (sp.getPhylum() != null && sp.getPhylum().length() > 0) {
                        buf.append("    <Phylum>").append(EunisUtil.replaceTags(sp.getPhylum(), true, true)).append("</Phylum>\n");
                    }
                    if (sp.getSpeciesClass() != null && sp.getSpeciesClass().length() > 0) {
                        buf.append("    <Class>").append(EunisUtil.replaceTags(sp.getSpeciesClass(), true, true))
                                .append("</Class>\n");
                    }
                    if (sp.getOrder() != null && sp.getOrder().length() > 0) {
                        buf.append("    <Order>").append(EunisUtil.replaceTags(sp.getOrder(), true, true)).append("</Order>\n");
                    }
                    if (sp.getFamily() != null && sp.getFamily().length() > 0) {
                        buf.append("    <Family>").append(EunisUtil.replaceTags(sp.getFamily(), true, true)).append("</Family>\n");
                    }
                    if (sp.getGenus() != null && sp.getGenus().length() > 0) {
                        buf.append("    <Genus>").append(EunisUtil.replaceTags(sp.getGenus(), true, true)).append("</Genus>\n");
                    }
                    if (sp.getScientificName() != null && sp.getScientificName().length() > 0) {
                        buf.append("    <Scientific_name>").append(EunisUtil.replaceTags(sp.getScientificName(), true, true))
                                .append("</Scientific_name>\n");
                    }
                    if (sp.getAuthor() != null && sp.getAuthor().length() > 0) {
                        buf.append("    <Author>").append(EunisUtil.replaceTags(sp.getAuthor(), true, true)).append("</Author>\n");
                    }
                    if (sp.getValidName() != null && sp.getValidName().length() > 0) {
                        buf.append("    <VALID_NAME>").append(sp.getValidNameInteger()).append("</VALID_NAME>\n");
                    }
                    if (sp.getIdSpeciesLink() != null && sp.getIdSpeciesLink().length() > 0) {
                        buf.append("    <ID_SPECIES_LINK>").append(sp.getIdSpeciesLink()).append("</ID_SPECIES_LINK>\n");
                    }
                    if (sp.getTypeRelatedSpecies() != null && sp.getTypeRelatedSpecies().length() > 0) {
                        buf.append("    <TYPE_RELATED_SPECIES>").append(
                                EunisUtil.replaceTags(sp.getTypeRelatedSpecies(), true, true)).append("</TYPE_RELATED_SPECIES>\n");
                    }
                    if (sp.getGroupSpecies() != null && sp.getGroupSpecies().length() > 0) {
                        buf.append("    <SPECIES_GROUP>").append(EunisUtil.replaceTags(sp.getGroupSpecies(), true, true))
                                .append("</SPECIES_GROUP>\n");
                    }
                    if (sp.getTaxonomicReference() != null && sp.getTaxonomicReference().length() > 0) {
                        buf.append("    <Taxonomic_reference>")
                                .append(EunisUtil.replaceTags(sp.getTaxonomicReference(), true, true))
                                .append("</Taxonomic_reference>\n");
                    }
                    if (sp.getIdItis() != null && sp.getIdItis().length() > 0) {
                        buf.append("    <ID_ITIS>").append(sp.getIdItis()).append("</ID_ITIS>\n");
                    }
                    if (sp.getIdNcbi() != null && sp.getIdNcbi().length() > 0) {
                        buf.append("    <ID_NCBI>").append(sp.getIdNcbi()).append("</ID_NCBI>\n");
                    }
                    if (sp.getIdWorms() != null && sp.getIdWorms().length() > 0) {
                        buf.append("    <ID_WORMS>").append(sp.getIdWorms()).append("</ID_WORMS>\n");
                    }
                    if (sp.getIdRedlist() != null && sp.getIdRedlist().length() > 0) {
                        buf.append("    <ID_REDLIST>").append(sp.getIdRedlist()).append("</ID_REDLIST>\n");
                    }
                    if (sp.getIdFaeu() != null && sp.getIdFaeu().length() > 0) {
                        buf.append("    <ID_FAEU>").append(sp.getIdFaeu()).append("</ID_FAEU>\n");
                    }
                    if (sp.getIdGbif() != null && sp.getIdGbif().length() > 0) {
                        buf.append("    <ID_GBIF>").append(sp.getIdGbif()).append("</ID_GBIF>\n");
                    }

                    buf.append("</species>\n");
                    response.getOutputStream().print(buf.toString());
                }
                response.getOutputStream().print("</dataroot>\n");
            }
        }.setFilename("speciesdump.xml");
    }
}
