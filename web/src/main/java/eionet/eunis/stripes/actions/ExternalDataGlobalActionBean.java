package eionet.eunis.stripes.actions;

import java.util.List;
import java.util.Properties;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import eionet.eunis.dto.ForeignDataQueryDTO;
import eionet.eunis.rdf.LinkedData;

/**
 * ActionBean for global external data queries.
 *
 * @author Jaak Kapten
 * @author Jaanus Heinlaid
 */

@UrlBinding("/externalglobal")
public class ExternalDataGlobalActionBean extends AbstractStripesAction {

    /** The default JSP that this action bean resolutes to. */
    public static final String DEFAULT_JSP = "/stripes/global-external-data.jsp";

    /** The name of the properties files from which the linked data helper will be created. */
    public static final String LINKED_DATA_PROPERTIES_FILE_NAME = "externaldata_global.xml";

    /** Linked data helper initialized from properties file. */
    public static final LinkedData LINKED_DATA_HELPER = createLinkedDataHelper();

    /** The query to be executed. This is query identifier, as it comes from the queries resource file. */
    private String query;

    /**
     * The default event handler.
     *
     * @return Resolution to go to.
     */
    @DefaultHandler
    public Resolution defaultHandler() {
        return new ForwardResolution(DEFAULT_JSP);
    }

    /**
     * Executes a linked-data query submitted by the user. The query is to be looked from {@link #query}.
     * @return Resolution to go to.
     */
    public Resolution execute() {
        if (isQuerySelected()) {
            showMessage("Selected query: " + query);
        } else {
            showWarning("No query selected!");
        }
        return new ForwardResolution(DEFAULT_JSP);
    }

    /**
     * Just a convenient accessor for JSP to access {@link #LINKED_DATA_HELPER}.
     *
     * @return The {@link #LINKED_DATA_HELPER}.
     */
    public LinkedData getLinkedDataHelper() {
        return LINKED_DATA_HELPER;
    }

    /**
     * A JSP-convenient accessor for the {@link LinkedData#getQueryObjects()} of {@link #LINKED_DATA_HELPER}.
     * @return The list of query-objects in the linked data helper.
     */
    public List<ForeignDataQueryDTO> getQueries() {
        return LINKED_DATA_HELPER == null ? null : LINKED_DATA_HELPER.getQueryObjects();
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
