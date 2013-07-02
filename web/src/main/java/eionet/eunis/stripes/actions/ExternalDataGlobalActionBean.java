package eionet.eunis.stripes.actions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;

import eionet.eunis.dto.ForeignDataQueryDTO;
import eionet.eunis.rdf.LinkedData;
import eionet.sparqlClient.helpers.ResultValue;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * ActionBean for global external data queries
 * 
 * @author Jaak Kapten
 */

@UrlBinding("/externalglobal")
public class ExternalDataGlobalActionBean extends AbstractStripesAction {

    /** LinkedData tab variables. */
    private List<ForeignDataQueryDTO> queries;
    private String query;
    private ArrayList<Map<String, Object>> queryResultCols;
    private ArrayList<HashMap<String, ResultValue>> queryResultRows;
    private String attribution;

    
    @DefaultHandler
    public Resolution index() {
        linkeddata(1367, 4046);
        return new ForwardResolution("/stripes/global-external-data.jsp");
    }
    
    /**
     * Populate the member variables used in the "linkeddata" tab.
     * 
     * @param idSpecies
     *            - The species ID.
     */
    private void linkeddata(int idSpecies, Integer natObjId) {
        try {
            Properties props = new Properties();
            props.loadFromXML(getClass().getClassLoader().getResourceAsStream("externaldata_species.xml"));
            LinkedData fd = new LinkedData(props, natObjId, "_linkedDataQueries");
            queries = fd.getQueryObjects();
            if (!StringUtils.isBlank(query)) {

                fd.executeQuery(query, idSpecies);
                queryResultCols = fd.getCols();
                queryResultRows = fd.getRows();

                attribution = fd.getAttribution();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ForeignDataQueryDTO> getQueries() {
        return queries;
    }

    public void setQueries(List<ForeignDataQueryDTO> queries) {
        this.queries = queries;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public ArrayList<Map<String, Object>> getQueryResultCols() {
        return queryResultCols;
    }

    public void setQueryResultCols(ArrayList<Map<String, Object>> queryResultCols) {
        this.queryResultCols = queryResultCols;
    }

    public ArrayList<HashMap<String, ResultValue>> getQueryResultRows() {
        return queryResultRows;
    }

    public void setQueryResultRows(ArrayList<HashMap<String, ResultValue>> queryResultRows) {
        this.queryResultRows = queryResultRows;
    }

    public String getAttribution() {
        return attribution;
    }

    public void setAttribution(String attribution) {
        this.attribution = attribution;
    }
    
}
