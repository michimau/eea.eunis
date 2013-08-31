package eionet.eunis.rdf;

import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.util.Properties;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import org.junit.Test;

import eionet.eunis.util.sql.ConnectionUtil;
import eionet.rdfexport.RDFExportService;
import eionet.rdfexport.RDFExportServiceImpl;



/**
 * Test the RDF Exporter script.
 */
public class RDFExporterTest {

    private static final String UTF8_ENCODING = "UTF-8";

    @Test
    public void concatWithInt() throws Exception {
        Properties props = new Properties();
        props.setProperty("species.query", "SELECT 3456 AS ID, CONCAT(3456, '/general') AS 'foaf:isPrimaryTopicOf->species'");
        props.setProperty("baseurl", "http://eunis.eea.europa.eu/species");
        props.setProperty("vocabulary", "http://eunis.eea.europa.eu/rdf/schema.rdf#");
        props.setProperty("xmlns.foaf", "http://xmlns.com/foaf/0.1/");

        Connection con = ConnectionUtil.getSimpleConnection();
        ByteArrayOutputStream testOutput = new ByteArrayOutputStream();

        RDFExportService rdfExportService = new RDFExportServiceImpl(testOutput, con, props);
        rdfExportService.exportTable("species", null);
        String expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<rdf:RDF xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"\n"
            + " xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
            + " xmlns=\"http://eunis.eea.europa.eu/rdf/schema.rdf#\" xml:base=\"http://eunis.eea.europa.eu/species\">\n"
            + "\n"
            + "<Species rdf:about=\"species/3456\">\n"
            + " <foaf:isPrimaryTopicOf rdf:resource=\"species/3456/general\"/>\n"
            + "</Species>\n"
            + "</rdf:RDF>\n";

        String actual = testOutput.toString(UTF8_ENCODING);
        testOutput.close();

        assertEquals(expected, actual);
    }

}
