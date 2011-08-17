package eionet.eunis.rdf;

import java.util.Hashtable;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;

public class GenerateDocumentRDF {

    public static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        + "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private DcIndexDTO object;
    private Hashtable<String, AttributeDto> attributes;
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
                rdf.append(RDFUtil.writeLiteral("dcterms:coverage", getValue("coverage")));
                rdf.append(RDFUtil.writeLiteral("dcterms:created", object.getCreated()));
                rdf.append(RDFUtil.writeLiteral("dcterms:description", getValue("description")));
                rdf.append(RDFUtil.writeLiteral("dcterms:format", getValue("format")));
                rdf.append(RDFUtil.writeLiteral("dcterms:identifier", getValue("identifier")));
                rdf.append(RDFUtil.writeLiteral("dcterms:language", getValue("language")));
                rdf.append(RDFUtil.writeLiteral("dcterms:publisher", object.getPublisher()));
                rdf.append(RDFUtil.writeLiteral("dcterms:relation", getValue("relation")));
                rdf.append(RDFUtil.writeLiteral("dcterms:rights", getValue("rights")));
                rdf.append(RDFUtil.writeLiteral("dcterms:subject", getValue("subject")));
                rdf.append(RDFUtil.writeLiteral("dcterms:type", getValue("type")));
                rdf.append("</rdf:Description>\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rdf;
    }

    private String getValue(String key) {
        String ret = null;
        if (key != null && attributes != null) {
            AttributeDto attr = attributes.get(key);
            if (attr != null) {
                ret = attr.getValue();
            }
        }
        return ret;
    }
}
