package ro.finsiel.eunis.utilities;


import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;


public abstract class ResultSetBaseReader<T> {

    /** */
    protected ResultSetMetaData rsMd = null;

    /**
     * 
     * @param rsMd
     */
    public void setResultSetMetaData(ResultSetMetaData rsMd) {
        this.rsMd = rsMd;
    }

    /**
     * 
     * @param rs
     * @throws SQLException 
     */
    public abstract void readRow(ResultSet rs) throws SQLException;

    /**
     * @return processed results.
     */
    public abstract List<T> getResultList();
}
