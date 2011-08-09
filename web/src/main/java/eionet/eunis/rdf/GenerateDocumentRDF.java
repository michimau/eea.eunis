package eionet.eunis.rdf;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DcObjectDTO;

public class GenerateDocumentRDF {

    public static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        + "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private DcObjectDTO object;
    private String id;
    private StringBuffer rdf;

    public GenerateDocumentRDF(String id) {
        if (id != null && id.length() > 0) {
            this.object = DaoFactory.getDaoFactory().getDocumentsDao().getDcObject(id);
        }
        this.id = id;
        this.rdf = new StringBuffer();
    }

    public StringBuffer getDocumentRdf() {
        try {
            if (object != null) {
                rdf.append("<rdf:Description rdf:about=\"http://eunis.eea.europa.eu/documents/").append(id).append("\">\n");
                rdf.append(RDFUtil.writeReference("rdf:type", "http://purl.org/dc/dcmitype/Text"));
                rdf.append(RDFUtil.writeLiteral("dcterms:title", object.getTitle()));
                rdf.append(RDFUtil.writeLiteral("dcterms:alternative", object.getAlternative()));
                rdf.append(RDFUtil.writeLiteral("dcterms:creator", object.getSource()));
                rdf.append(RDFUtil.writeReference("dcterms:source", object.getSourceUrl()));
                rdf.append(RDFUtil.writeLiteral("dcterms:contributor", object.getEditor()));
                rdf.append(RDFUtil.writeLiteral("dcterms:coverage", object.getCoverage()));
                rdf.append(RDFUtil.writeLiteral("dcterms:created", object.getDate()));
                rdf.append(RDFUtil.writeLiteral("dcterms:description", object.getDescription()));
                rdf.append(RDFUtil.writeLiteral("dcterms:format", object.getFormat()));
                rdf.append(RDFUtil.writeLiteral("dcterms:identifier", object.getIdentifier()));
                rdf.append(RDFUtil.writeLiteral("dcterms:language", object.getLanguage()));
                rdf.append(RDFUtil.writeLiteral("dcterms:publisher", object.getPublisher()));
                rdf.append(RDFUtil.writeLiteral("dcterms:relation", object.getRelation()));
                rdf.append(RDFUtil.writeLiteral("dcterms:rights", object.getRights()));
                rdf.append(RDFUtil.writeLiteral("dcterms:subject", object.getSubject()));
                rdf.append(RDFUtil.writeLiteral("dcterms:type", object.getType()));
                rdf.append("</rdf:Description>\n");            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rdf;
    }
}
