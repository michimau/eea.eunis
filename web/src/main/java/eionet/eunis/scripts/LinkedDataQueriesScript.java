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


public class LinkedDataQueriesScript {

    /**
     * @param args
     */
    public static void main(String[] args) {

        try {
            System.out.println("Linked data command started!");

            ISpeciesFactsheetDao dao = DaoFactory.getDaoFactory().getSpeciesFactsheetDao();

            // Remove previous records from chm62edt_nature_object_attributes
            dao.removeAllNatObLinkedData();

            // Insert _linkedDataQueries records into chm62edt_nature_object_attributes for each species
            dao.insertNatObLinkedData();

            // update _linkedDataQueries records in chm62edt_nature_object_attributes for each species
            String codes = "";
            Properties props = new Properties();
            URL url = ClassLoader.getSystemResource("externaldata_species.xml");
            props.loadFromXML(url.openStream());
            String[] queries = props.getProperty("queries").split(" ");
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
                    dao.updateNatObLinkedData(codes, queryId);
                    codes = "";
                    System.out.println("Finished with query: " + queryId);

                }
            }
            // Remove leftovers
            dao.removeEmptyNatObLinkedData();

            System.out.println("Linked data command successfully finished!");

        } catch (Exception e) {
            System.out.println("Error occured: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
