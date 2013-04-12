/**
 *
 */
package eionet.eunis.rdf;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dto.ForeignDataQueryDTO;
import eionet.sparqlClient.helpers.QueryExecutor;
import eionet.sparqlClient.helpers.QueryResult;
import eionet.sparqlClient.helpers.ResultValue;

/**
 * A helper class for executing linked data queries.
 *
 * @author Risto Alt
 */
public class LinkedData {

    private static final Logger logger = Logger.getLogger(LinkedData.class);

    /** All the queries in the properties file. */
    private String[] queries;
    /** Hashtable of loaded properties. */
    private Properties props;
    /** Arraylist of all query objects in properties file. */
    private ArrayList<ForeignDataQueryDTO> queryObjects;
    /** Label link pairs. */
    private HashMap<String, String> links;
    /** Column labels. */
    private HashMap<String, String> columnLabels;

    /** Query result rows. */
    private ArrayList<HashMap<String, ResultValue>> rows;
    /** Query result cols. */
    private ArrayList<Map<String, Object>> cols;
    /** Source of the data. */
    private String attribution;

    /**
     * Create helper on the basis of given properties, and for the given queries of the given nature object.
     *
     * @param props
     * @param natureObjId
     * @param queriesName
     * @throws Exception
     */
    public LinkedData(Properties props, Integer natureObjId, String queriesName) throws Exception {
        this.props = props;
        queries = props.getProperty("queries").split("\\s+");

        if (queries != null) {
            queryObjects = new ArrayList<ForeignDataQueryDTO>();
            for (String queryId : queries) {
                ISpeciesFactsheetDao dao = DaoFactory.getDaoFactory().getSpeciesFactsheetDao();
                boolean resultExists = dao.queryResultExists(natureObjId, queryId, queriesName);
                if (natureObjId == null || (natureObjId != null && resultExists)) {
                    ForeignDataQueryDTO dto = new ForeignDataQueryDTO();
                    dto.setId(queryId);
                    dto.setTitle(props.getProperty(queryId + ".title"));
                    dto.setSummary(props.getProperty(queryId + ".summary"));
                    dto.setQuery(props.getProperty(queryId + ".query"));
                    queryObjects.add(dto);
                }
            }
        }
    }

    /**
     *
     * @param queryId
     * @param id
     * @throws Exception
     */
    public void executeQuery(String queryId, int id) throws Exception {

        if (props != null && queryId != null) {
            String query = props.getProperty(queryId + ".query");
            String endpoint = props.getProperty(queryId + ".endpoint");
            attribution = props.getProperty(queryId + ".attribution");

            if (!StringUtils.isBlank(query) && !StringUtils.isBlank(endpoint)) {
                // Replace [IDENTIFIER] in query
                if (query.contains("[IDENTIFIER]")) {
                    query = query.replace("[IDENTIFIER]", new Integer(id).toString());
                }
                QueryExecutor executor = new QueryExecutor();
                executor.executeQuery(endpoint, query);
                QueryResult result = executor.getResults();

                generateRows(queryId, result);
                generateCols(queryId, result);
            } else {
                logger.error("query or endpoint is not defined in linkeddata properties file for: " + queryId);
            }
        }
    }

    /**
     * Copy existing row values to new rows HashMap. Generate links if defined in properties file.
     *
     * @param queryId - query identifier.
     * @param result - query result object.
     */
    private void generateRows(String queryId, QueryResult result) throws Exception {

        rows = new ArrayList<HashMap<String, ResultValue>>();

        // Search for label->link relations from properties file
        links = new HashMap<String, String>();
        for (String key : props.stringPropertyNames()) {
            if (key.startsWith(queryId + ".link.")) {
                String linkCol = props.getProperty(key);
                links.put(key.substring(key.lastIndexOf(".") + 1), linkCol);
            }
        }

        if (result != null && result.getRows() != null) {
            for (HashMap<String, ResultValue> row : result.getRows()) {
                List<String> usedCols = new ArrayList<String>();
                HashMap<String, ResultValue> newrow = new HashMap<String, ResultValue>();
                for (String key : row.keySet()) {
                    ResultValue value = row.get(key);
                    if (!usedCols.contains(key)) {
                        if (links != null && links.containsKey(key)) {
                            String val = EunisUtil.replaceTags(value.getValue(), true, true);
                            String linkCol = links.get(key);
                            String link = row.get(linkCol).getValue();
                            if (!StringUtils.isBlank(link)) {
                                link = EunisUtil.replaceTags(link, true, true);
                                val = "<a href=\"" + link + "\">" + val + "</a>";
                                value = new ResultValue(val, true);
                            } else {
                                value = new ResultValue(val, value.isLiteral());
                            }
                            usedCols.add(linkCol);
                            newrow.remove(linkCol);
                        }
                        newrow.put(key, value);
                        usedCols.add(key);
                    }
                }
                rows.add(newrow);
            }
        }
    }

    /**
     * Copy existing column values to new cols ArrayList.
     * If labels are deifned in properties file then replace title with defined label.
     *
     * @param queryId - query identifier.
     * @param result - query result object.
     */
    private void generateCols(String queryId, QueryResult result) throws Exception {

        cols = new ArrayList<Map<String, Object>>();

        // Search for column labels from properties file
        columnLabels = new HashMap<String, String>();
        for (String key : props.stringPropertyNames()) {
            if (key.startsWith(queryId + ".column.")) {
                String label = props.getProperty(key);
                columnLabels.put(key.substring(key.lastIndexOf(".") + 1), label);
            }
        }

        if (result != null && result.getCols() != null) {
            for (Map<String, Object> col : result.getCols()) {
                Map<String, Object> newcol = new HashMap<String, Object>();
                String prop = (String) col.get("property");
                newcol.put("property", prop);
                if (columnLabels != null && columnLabels.containsKey(prop)) {
                    newcol.put("title", columnLabels.get(prop));
                } else {
                    String title = prop.replaceAll("_", " ");
                    if (title != null && title.length() > 1) {
                        title = Character.toUpperCase(title.charAt(0)) + title.substring(1);
                    }
                    newcol.put("title", title);
                }
                newcol.put("sortable", col.get("sortable"));

                if (rows != null && rows.size() > 0 && rows.get(0).containsKey(prop)) {
                    cols.add(newcol);
                }
            }
        }
    }

    public ArrayList<ForeignDataQueryDTO> getQueryObjects() {
        return queryObjects;
    }

    public ArrayList<Map<String, Object>> getCols() {
        return cols;
    }

    public ArrayList<HashMap<String, ResultValue>> getRows() {
        return rows;
    }

    public String getAttribution() {
        return attribution;
    }

    /**
     *
     * @param filterThese
     * @return
     */
    public ArrayList<ForeignDataQueryDTO> getQueryObjects(String... filterThese) {

        if (queryObjects == null || queryObjects.isEmpty() || filterThese == null || filterThese.length == 0) {
            return queryObjects;
        }

        ArrayList<ForeignDataQueryDTO> resultList = new ArrayList<ForeignDataQueryDTO>();
        List<String> theseOnly = Arrays.asList(filterThese);
        for (ForeignDataQueryDTO queryObject : queryObjects) {
            if (theseOnly.contains(queryObject.getId())) {
                resultList.add(queryObject);
            }
        }

        return resultList;
    }
}
