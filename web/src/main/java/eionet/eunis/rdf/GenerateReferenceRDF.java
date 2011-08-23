package eionet.eunis.rdf;

import java.util.List;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;

public class GenerateReferenceRDF {

    /**
     * RDF root element. Domain name is hardwired. It should have come from getContext().getInitParameter("DOMAIN_NAME")
     * or have been provided in constructor.
     */
    public static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        + "<rdf:RDF xml:base=\"http://eunis.eea.europa.eu/\"\n"
        + "  xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "  xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "  xmlns=\"http://purl.org/dc/terms/\">\n";

    private DcIndexDTO object;
    private List<AttributeDto> attributes;
    /** Identifier of the reference (ID_DC). */
    private String id;
    //private StringBuffer rdf;

    public GenerateReferenceRDF(String id) {
        if (id != null && id.length() > 0) {
            this.object = DaoFactory.getDaoFactory().getReferncesDao().getDcIndex(id);
            this.attributes = DaoFactory.getDaoFactory().getReferncesDao().getDcAttributes(id);
        }
        this.id = id;
        //this.rdf = new StringBuffer();
    }

    public GenerateReferenceRDF(DcIndexDTO object) {
        if (object != null && object.getIdDc() != null) {
            this.object = object;
            this.attributes = DaoFactory.getDaoFactory().getReferncesDao().getDcAttributes(object.getIdDc());
            this.id = object.getIdDc();
        }
        //this.rdf = new StringBuffer();
    }

    public StringBuffer getReferenceRdf() {
        StringBuffer rdf = new StringBuffer();
        try {
            if (object != null && attributes != null) {
                rdf.append("<rdf:Description rdf:about=\"references/").append(id).append("\">\n");
                rdf.append(RDFUtil.writeReference("rdf:type", "http://purl.org/dc/dcmitype/Text"));
                rdf.append(RDFUtil.writeLiteral("title", object.getTitle()));
                rdf.append(RDFUtil.writeLiteral("alternative", object.getAlternative()));
                rdf.append(RDFUtil.writeLiteral("creator", object.getSource()));
                rdf.append(RDFUtil.writeReference("rdfs:seeAlso", object.getUrl()));
                rdf.append(RDFUtil.writeLiteral("contributor", object.getEditor()));
                rdf.append(RDFUtil.writeLiteral("created", object.getCreated()));
                rdf.append(RDFUtil.writeLiteral("publisher", object.getPublisher()));
                for(AttributeDto attr : attributes) {
                    rdf.append(RDFUtil.writeProperty(attr.getName(),attr.getValue(), attr.getLang(), attr.getType()));
                }
                rdf.append("</rdf:Description>\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rdf;
    }

}
