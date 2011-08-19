package eionet.eunis.rdf;

import java.util.List;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;

public class GenerateDocumentRDF {

    public static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        + "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private DcIndexDTO object;
    private List<AttributeDto> attributes;
    private String id;
    private StringBuffer rdf;

    public GenerateDocumentRDF(String id) {
        if (id != null && id.length() > 0) {
            this.object = DaoFactory.getDaoFactory().getDocumentsDao().getDcIndex(id);
            this.attributes = DaoFactory.getDaoFactory().getDocumentsDao().getDcAttributes(id);
        }
        this.id = id;
        this.rdf = new StringBuffer();
    }

    public GenerateDocumentRDF(DcIndexDTO object) {
        if (object != null && object.getIdDc() != null) {
            this.object = object;
            this.attributes = DaoFactory.getDaoFactory().getDocumentsDao().getDcAttributes(object.getIdDc());
            this.id = object.getIdDc();
        }
        this.rdf = new StringBuffer();
    }

    public StringBuffer getDocumentRdf() {
        try {
            if (object != null && attributes != null) {
                rdf.append("<rdf:Description rdf:about=\"http://eunis.eea.europa.eu/documents/").append(id).append("\">\n");
                rdf.append(RDFUtil.writeReference("rdf:type", "http://purl.org/dc/dcmitype/Text"));
                rdf.append(RDFUtil.writeLiteral("dcterms:title", object.getTitle()));
                rdf.append(RDFUtil.writeLiteral("dcterms:alternative", object.getAlternative()));
                rdf.append(RDFUtil.writeLiteral("dcterms:creator", object.getSource()));
                rdf.append(RDFUtil.writeReference("dcterms:source", object.getUrl()));
                rdf.append(RDFUtil.writeLiteral("dcterms:contributor", object.getEditor()));
                rdf.append(RDFUtil.writeLiteral("dcterms:created", object.getCreated()));
                rdf.append(RDFUtil.writeLiteral("dcterms:publisher", object.getPublisher()));
                for(AttributeDto attr : attributes) {
                    if (attr.getType() != null && attr.getType().equals("reference")) {
                        rdf.append(RDFUtil.writeReference("dcterms:" + attr.getName(), attr.getValue()));
                    } else {
                        rdf.append(
                                RDFUtil.writeLiteral("dcterms:" + attr.getName(), attr.getValue(), attr.getLang(), attr.getType())
                        );
                    }
                }
                rdf.append("</rdf:Description>\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rdf;
    }

}