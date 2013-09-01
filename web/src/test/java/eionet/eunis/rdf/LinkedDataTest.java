package eionet.eunis.rdf;

import java.util.Properties;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import java.util.ArrayList;
import java.util.HashMap;
import org.junit.Test;
import org.junit.BeforeClass;

import eionet.eunis.test.DbHelper;
import eionet.sparqlClient.helpers.ResultValue;
import ro.finsiel.eunis.utilities.SQLUtilities;


/**
 * Test the linked data queries.
 */
public class LinkedDataTest {

    private static SQLUtilities sqlUtils;

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        sqlUtils = DbHelper.getSqlUtilities();
        DbHelper.handleSetUpOperation("seed-redlist-species.xml");
    }


    /**
     * Concatenation of an integer with a string returns a <em>binary</em> string type.
     * This test checks if the serialisation works.
     *
     * @throws Exception when something fails.
     */
    @Test
    public void concatWithInt() throws Exception {
        Properties props = new Properties();
        props.setProperty("queries", "species");
        props.setProperty("species.querytype", "SQL");
        props.setProperty("species.title", "Simple query");
        props.setProperty("species.summary", "");
        props.setProperty("species.column.SCIENTIFIC_NAME", "Name");
        props.setProperty("species.link.SCIENTIFIC_NAME", "URL");

        props.setProperty("species.query", "SELECT ID_SPECIES, SCIENTIFIC_NAME, CONCAT(ID_SPECIES, '/general') AS URL"
                + " FROM chm62edt_species WHERE ID_SPECIES = 9970");

        Integer natureObjId = null;
        LinkedData qObj = new LinkedData(props, natureObjId, "species");
        qObj.executeSQLQuery("species", sqlUtils);
        ArrayList<HashMap<String, ResultValue>> rows = qObj.getRows();

        assertEquals(1, rows.size());
        String expected = "{ID_SPECIES=9970, SCIENTIFIC_NAME=<a href=\"9970/general\">Salmo trutta</a>}";
        for (HashMap<String, ResultValue> row : rows) {
            assertEquals(expected, row.toString());
        }
    }

    /**
     * Concatenation of an integer with a string returns a <em>binary</em> string type.
     * This test checks if the serialisation works.
     *
     * @throws Exception when something fails.
     */
    @Test
    public void concatWithIntNoSeed() throws Exception {
        Properties props = new Properties();
        props.setProperty("queries", "species");
        props.setProperty("species.title", "Simple query");
        props.setProperty("species.summary", "");
        props.setProperty("species.querytype", "SQL");
        props.setProperty("species.query", "SELECT 3456 AS ID, CONCAT(3456, '/general') AS URL");

        Integer natureObjId = null;
        LinkedData qObj = new LinkedData(props, natureObjId, "species");
        qObj.executeSQLQuery("species", sqlUtils);
        ArrayList<HashMap<String, ResultValue>> rows = qObj.getRows();

        assertEquals(1, rows.size());
        String expected = "{ID=3456, URL=3456/general}";
        for (HashMap<String, ResultValue> row : rows) {
            assertEquals(expected, row.toString());
        }
    }

    @Test
    public void valueWithNull() throws Exception {
        Properties props = new Properties();
        props.setProperty("queries", "species");
        props.setProperty("species.title", "Simple query");
        props.setProperty("species.summary", "");
        props.setProperty("species.querytype", "SQL");
        props.setProperty("species.query", "SELECT 3456 AS ID, CONCAT(CONVERT(3456 USING utf8), '/general') AS URL, NULL AS name");

        Integer natureObjId = null;
        LinkedData qObj = new LinkedData(props, natureObjId, "species");
        qObj.executeSQLQuery("species", sqlUtils);
        ArrayList<HashMap<String, ResultValue>> rows = qObj.getRows();

        assertEquals(1, rows.size());
        String expected = "{name=, ID=3456, URL=3456/general}";
        for (HashMap<String, ResultValue> row : rows) {
            assertEquals(expected, row.toString());
        }
    }

    /**
     * Test how datetime is shown. There is no expectation of a particular representation,
     * just that it is readable.
     */
    @Test
    public void handleDateTime() throws Exception {
        Properties props = new Properties();
        props.setProperty("queries", "species");
        props.setProperty("species.title", "Simple query");
        props.setProperty("species.summary", "");
        props.setProperty("species.querytype", "SQL");
        props.setProperty("species.query", "SELECT CAST('2013-08-31 10:20:30' AS DATETIME) AS issued");

        Integer natureObjId = null;
        LinkedData qObj = new LinkedData(props, natureObjId, "species");
        qObj.executeSQLQuery("species", sqlUtils);
        ArrayList<HashMap<String, ResultValue>> rows = qObj.getRows();

        assertEquals(1, rows.size());
        String expected = "{issued=2013-08-31 10:20:30.0}";
        for (HashMap<String, ResultValue> row : rows) {
            assertEquals(expected, row.toString());
        }
    }
}
