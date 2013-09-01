package eionet.eunis.util.sql;

import java.net.MalformedURLException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.sparqlClient.helpers.QueryResult;
import eionet.sparqlClient.helpers.ResultValue;

/**
 * An extension of {@link ResultSetBaseReader} that places the rows and columns into structures used by {@link QueryResult}.
 *
 * @author jaanus
 */
public class SPARQLQueryResultSQLReader extends ResultSetBaseReader<HashMap<String, ResultValue>> {

    /** Identifies the key in the column-maps that denotes the columns' identifier/label. */
    private static final String COLUMN_IDENTIFIER_PROPERTY = "property";

    /** The rows of the query result. Initialized at first need only. */
    private ArrayList<HashMap<String, ResultValue>> rows;

    /** The columns of the query result. Initialized at first need only. */
    private ArrayList<Map<String, Object>> cols;

    /*
     * (non-Javadoc)
     *
     * @see ro.finsiel.eunis.utilities.ResultSetBaseReader#readRow(java.sql.ResultSet)
     */
    @Override
    public void readRow(ResultSet rs) throws SQLException {

        if (cols == null) {
            initializeColumns(rs);
        }

        int colIndex = 1;
        HashMap<String, ResultValue> rowMap = new HashMap<String, ResultValue>();
        for (Map<String, Object> colMap : cols) {

            String colIdentifier = colMap.get(COLUMN_IDENTIFIER_PROPERTY).toString();
            String colValue = rs.getString(colIndex++);
            String colStringValue = (colValue == null) ? StringUtils.EMPTY : colValue;
            boolean isLiteral = !isURL(colStringValue);

            ResultValue resultValue = new ResultValue(colStringValue, isLiteral);
            rowMap.put(colIdentifier, resultValue);
        }

        if (rows == null) {
            rows = new ArrayList<HashMap<String, ResultValue>>();
        }
        rows.add(rowMap);
    }

    /**
     * Initializes {@link #cols} from the given {@link ResultSet}.
     *
     * @param rs The given {@link ResultSet}.
     * @throws SQLException Thrown when reading from the given SQL result-set.
     */
    private void initializeColumns(ResultSet rs) throws SQLException {

        ResultSetMetaData rsMd = rs.getMetaData();
        int colCount = rsMd.getColumnCount();
        for (int i = 1; i <= colCount; i++) {

            String colLabel = rsMd.getColumnLabel(i);
            Map<String, Object> colMap = new HashMap<String, Object>();
            colMap.put(COLUMN_IDENTIFIER_PROPERTY, colLabel);
            colMap.put("title", colLabel);
            colMap.put("sortable", Boolean.TRUE);

            if (cols == null) {
                cols = new ArrayList<Map<String, Object>>();
            }
            cols.add(colMap);
        }
    }

    /**
     * Utility method: returns true if the given string can be converted into a legal {@link URL} and it defintiely has a protocol.
     *
     * @param str The given string.
     * @return As above.
     */
    public static boolean isURL(String str) {

        try {
            URL url = new URL(str);
            return StringUtils.isNotBlank(url.getProtocol());
        } catch (MalformedURLException e) {
            return false;
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see ro.finsiel.eunis.utilities.ResultSetBaseReader#getResultList()
     */
    @Override
    public List<HashMap<String, ResultValue>> getResultList() {
        return rows;
    }

    /**
     * @return the rows
     */
    public ArrayList<HashMap<String, ResultValue>> getRows() {
        return rows;
    }

    /**
     * @return the cols
     */
    public ArrayList<Map<String, Object>> getCols() {
        return cols;
    }
}
