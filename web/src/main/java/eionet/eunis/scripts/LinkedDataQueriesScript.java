package eionet.eunis.scripts;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.sparqlClient.helpers.QueryExecutor;
import eionet.sparqlClient.helpers.QueryResult;
import eionet.sparqlClient.helpers.ResultValue;

/**
 *
 * Updates records in chm62edt_nature_object_attributes table where NAME matches the given queries name, e.g. "_linkedDataQueries",
 * "_conservationStatusQueries".
 *
 * @author Rait
 */
public class LinkedDataQueriesScript {

    /**
     * @param queriesName e.g. "_linkedDataQueries", "_conservationStatusQueries"
     * @param queriesXMLFileName e.g. "externaldata_species.xml", "conservationstatus_species.xml"
     */
    private static void queriesScript(String queriesName, String queriesXMLFileName) {

        try {
            System.out.println("Command started!");

            ISpeciesFactsheetDao dao = DaoFactory.getDaoFactory().getSpeciesFactsheetDao();

            // Remove previous records from chm62edt_nature_object_attributes
            dao.deleteNatureObjAttrsForAll(queriesName);

            // Insert _Queries records into chm62edt_nature_object_attributes for each species
            dao.insertNatureObjAttrForAll(queriesName);

            // update _Queries records in chm62edt_nature_object_attributes for each species
            String codes = "";
            Properties props = new Properties();
            URL url = ClassLoader.getSystemResource(queriesXMLFileName);
            props.loadFromXML(url.openStream());
            String[] queries = props.getProperty("queries").split("\\s+");
            for (String queryId : queries) {
                System.out.println("Starting with query: " + queryId);
                String endpoint = props.getProperty(queryId + ".endpoint");
                String query = props.getProperty(queryId + ".codes");
                if (!StringUtils.isBlank(query)) {
                    QueryExecutor executor = new QueryExecutor();
                    executor.executeQuery(endpoint, query);
                    QueryResult result = executor.getResults();
                    if (result != null) {
                        ArrayList<HashMap<String, ResultValue>> rows = result.getRows();
                        if (rows != null) {
                            for (HashMap<String, ResultValue> row : rows) {
                                for (String key : row.keySet()) {
                                    ResultValue val = row.get(key);
                                    if (codes.length() > 0) {
                                        codes += ",";
                                    }
                                    codes += val.getValue();
                                }
                            }
                        }
                    }
                }
                if (!StringUtils.isBlank(codes)) {
                    dao.appendToNatureObjAttr(codes, queriesName, queryId);
                    codes = "";
                    System.out.println("Finished with query: " + queryId);

                }
            }
            // Remove leftovers
            dao.deleteEmptyNatureObjAttrsForAll(queriesName);

            System.out.println("Command successfully finished!");

        } catch (Exception e) {
            System.out.println("Error occured: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * @param args
     */
    public static void main(String[] args) {

        queriesScript("_linkedDataQueries", "externaldata_species.xml");
        queriesScript("_conservationStatusQueries", "conservationstatus_species.xml");
    }

}
