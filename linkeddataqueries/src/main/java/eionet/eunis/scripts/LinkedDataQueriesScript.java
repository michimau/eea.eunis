package eionet.eunis.scripts;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.INatureObjectAttrDao;
import eionet.eunis.dao.INatureObjectAttrDao.ObjectType;
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
     * @param objectType
     * @param targetNatObjAttribute
     *            e.g. "_linkedDataQueries", "_conservationStatusQueries"
     * @param queriesXMLFileName
     *            e.g. "externaldata_species.xml", "conservationstatus_species.xml"
     */
    private static void queriesScript(ObjectType objectType, String targetNatObjAttribute, String queriesXMLFileName) {

        try {
            String className = LinkedDataQueriesScript.class.getSimpleName();
            String objectTypeStr = objectType.toString().toLowerCase();

            System.out.println("\n");
            System.out.println(className + " STARTED for " + objectTypeStr + ", queriesFile=\""
                    + queriesXMLFileName + "\", targetAttr=\"" + targetNatObjAttribute + "\"");

            INatureObjectAttrDao dao = DaoFactory.getDaoFactory().getNatureObjectAttrDao();

            System.out.println("Preparing nature object attribute records for " + objectTypeStr + " attribute \""
                    + targetNatObjAttribute + "\"");

            // Remove previous records from chm62edt_nature_object_attributes
            dao.deleteNatureObjAttrsForAll(objectType, targetNatObjAttribute);

            // Insert _Queries records into chm62edt_nature_object_attributes for each species
            dao.insertNatureObjAttrForAll(objectType, targetNatObjAttribute);

            // update _Queries records in chm62edt_nature_object_attributes for each species
            String codes = "";
            Properties props = new Properties();
            URL url = ClassLoader.getSystemResource(queriesXMLFileName);
            props.loadFromXML(url.openStream());
            String[] queries = props.getProperty("queries").split("\\s+");
            for (String queryId : queries) {

                String endpoint = props.getProperty(queryId + ".endpoint");
                String query = props.getProperty(queryId + ".codes");
                if (StringUtils.isNotBlank(query)) {

                    if (StringUtils.isNotBlank(endpoint)) {

                        QueryExecutor executor = new QueryExecutor();
                        System.out.println("Executing codes query \"" + queryId + "\" against " + endpoint);
                        executor.executeQuery(endpoint, query);

                        QueryResult result = executor.getResults();
                        if (result != null) {
                            ArrayList<HashMap<String, ResultValue>> rows = result.getRows();
                            if (rows != null && !rows.isEmpty()) {

                                System.out.println("Codes query \"" + queryId + "\" returned " + rows.size() + " results, going to process them ...!");

                                for (HashMap<String, ResultValue> row : rows) {

                                    for (String key : row.keySet()) {
                                        ResultValue val = row.get(key);
                                        if (codes.length() > 0) {
                                            codes += ",";
                                        }
                                        codes += val.getValue();
                                    }
                                }
                            } else {
                                System.out.println("Codes query \"" + queryId + "\" returned no results!");
                            }
                        } else {
                            System.out.println("Codes query \"" + queryId + "\" returned a NULL result object!");
                        }
                    } else {
                        System.out.println("Found no endpoint URL for codes query \"" + queryId + "\", skipping it!");
                    }
                } else {
                    System.out.println("Codes query \"" + queryId + "\" is blank, skipping it!");
                }

                if (!StringUtils.isBlank(codes)) {

                    dao.appendToNatureObjAttr(objectType, codes, targetNatObjAttribute, queryId);
                    codes = "";
                    System.out.println("Finished with codes query \"" + queryId + "\"");

                }
            }
            // Remove leftovers
            System.out.println("Removing leftovers ...");
            dao.deleteEmptyNatureObjAttrsForAll(objectType, targetNatObjAttribute);

            System.out.println(className + " FINISHED for " + objectTypeStr + ", queriesFile=\""
                    + queriesXMLFileName + "\", targetAttr=\"" + targetNatObjAttribute + "\"");

        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * @param args
     */
    public static void main(String[] args) {

        // Run script for species
        queriesScript(ObjectType.SPECIES, "_linkedDataQueries", "externaldata_species.xml");
        queriesScript(ObjectType.SPECIES, "_conservationStatusQueries", "conservationstatus_species.xml");

        // Run script for habitats
        queriesScript(ObjectType.HABITATS, "_linkedDataQueries", "externaldata_habitats.xml");
        queriesScript(ObjectType.HABITATS, "_conservationStatusQueries", "conservationstatus_habitats.xml");
    }

}
