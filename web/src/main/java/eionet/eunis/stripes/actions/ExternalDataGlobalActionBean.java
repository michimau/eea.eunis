package eionet.eunis.stripes.actions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import eionet.eunis.dto.ForeignDataQueryDTO;
import eionet.eunis.rdf.LinkedData;
import eionet.sparqlClient.helpers.ResultValue;

/**
 * ActionBean for global external data queries.
 *
 * @author Jaak Kapten
 * @author Jaanus Heinlaid
 */

@UrlBinding("/externalglobal")
public class ExternalDataGlobalActionBean extends AbstractStripesAction {

    /** The static Log4j logger for this class. */
    private static final Logger LOGGER = Logger.getLogger(ExternalDataGlobalActionBean.class);

    /** The name of the query-type attribute used in properties file. */
    private static final String QUERY_TYPE_ATTRIBUTE = "querytype";

    /** The default JSP that this action bean resolutes to. */
    public static final String DEFAULT_JSP = "/stripes/global-external-data.jsp";

    /** The name of the properties files from which the linked data helper will be created. */
    public static final String LINKED_DATA_PROPERTIES_FILE_NAME = "externaldata_global.xml";

    /** The query types supported by this action bean. */
    public enum QueryType {
        SQL, SPARQL
    };

    /** Linked data helper initialized from properties file. */
    private LinkedData linkedDataHelper = createLinkedDataHelper();

    /** The query to be executed. This is query identifier, as it comes from the queries resource file. */
    private String query;

    /** The columns of the executed query's result list, as they are returned by {@link LinkedData#getCols()}. */
    private ArrayList<Map<String, Object>> queryResultCols;

    /** The rows of the executed query's result list, as they are returned by {@link LinkedData#getRows()}. */
    private ArrayList<HashMap<String, ResultValue>> queryResultRows;

    /** The executed query result attribution, as it comes from {@link LinkedData#getAttribution()}. */
    private String attribution;

    /**
     * The default event handler.
     *
     * @return Resolution to go to.
     */
    @DefaultHandler
    public Resolution defaultEvent() {

        if (isQuerySelected()) {

            String queryType = linkedDataHelper.getQueryAttribute(query, QUERY_TYPE_ATTRIBUTE);
            queryType = queryType == null ? StringUtils.EMPTY : queryType.trim();

            boolean isSPARQL = queryType.equalsIgnoreCase(QueryType.SPARQL.name());
            boolean isSQL = queryType.equalsIgnoreCase(QueryType.SQL.name());

            if (isSPARQL || isSQL) {
                try {
                    linkedDataHelper.setActionBeanContext(getContext());
                    if (isSPARQL) {
                        linkedDataHelper.executeQuery(query, -1);
                    } else {
                        linkedDataHelper.executeSQLQuery(query, getContext().getSqlUtilities());
                    }
                    queryResultCols = linkedDataHelper.getCols();
                    queryResultRows = linkedDataHelper.getRows();
                    attribution = linkedDataHelper.getAttribution();
                } catch (Exception e) {
                    String msg = "The execution of query \"" + query + "\" failed with technical error: ";
                    showWarning(msg + e.getMessage());
                    LOGGER.error(msg, e);
                }
            } else {
                showWarning("Selected query type (" + queryType + ") not supported yet!");
            }
        }
        return new ForwardResolution(DEFAULT_JSP);
    }

    /**
     * Getter for {@link #linkedDataHelper}.
     *
     * @return The {@link #linkedDataHelper}.
     */
    public LinkedData getLinkedDataHelper() {
        return linkedDataHelper;
    }

    /**
     * A JSP-convenient accessor for the {@link LinkedData#getQueryObjects()} of {@link #linkedDataHelper}.
     *
     * @return The list of query-objects in the linked data helper.
     */
    public List<ForeignDataQueryDTO> getQueries() {
        return linkedDataHelper == null ? null : linkedDataHelper.getQueryObjects();
    }

    /**
     * @return the query
     */
    public String getQuery() {
        return query;
    }

    /**
     * @param query the query to set
     */
    public void setQuery(String query) {
        this.query = query;
    }

    /**
     *
     * @return
     */
    public boolean isQuerySelected() {
        return StringUtils.isNotBlank(query);
    }

    /**
     * @return the queryResultCols
     */
    public ArrayList<Map<String, Object>> getQueryResultCols() {
        return queryResultCols;
    }

    /**
     * @return the queryResultRows
     */
    public ArrayList<HashMap<String, ResultValue>> getQueryResultRows() {
        return queryResultRows;
    }

    /**
     * @return the attribution
     */
    public String getAttribution() {
        return attribution;
    }

    /**
     * Creates {@link LinkedData} helper from {@link #LINKED_DATA_PROPERTIES_FILE_NAME}.
     *
     * @return The created helper.
     */
    private static LinkedData createLinkedDataHelper() {

        Properties props = new Properties();
        ClassLoader classLoader = ExternalDataGlobalActionBean.class.getClassLoader();
        try {
            props.loadFromXML(classLoader.getResourceAsStream(LINKED_DATA_PROPERTIES_FILE_NAME));
            return new LinkedData(props, null, null);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load " + LINKED_DATA_PROPERTIES_FILE_NAME, e);
        }
    }
}
