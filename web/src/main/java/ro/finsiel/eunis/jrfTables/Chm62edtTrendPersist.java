/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class Chm62edtTrendPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idTrend = null;

    /**
     * This is a database field.
     **/
    private String i_trendStatus = null;

    /**
     * This is a database field.
     **/
    private String i_trendDefinition = null;

    public Chm62edtTrendPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdTrend() {
        return i_idTrend;
    }

    /**
     * Getter for a database field.
     **/
    public String getDescription() {
        return i_trendDefinition;
    }

    /**
     * Getter for a database field.
     **/
    public String getStatus() {
        return i_trendStatus;
    }

    /**
     * Setter for a database field.
     * @param idTrend
     **/
    public void setIdTrend(Integer idTrend) {
        i_idTrend = idTrend;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param trendDefinition
     **/
    public void setDescription(String trendDefinition) {
        i_trendDefinition = trendDefinition;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param trendStatus
     **/
    public void setStatus(String trendStatus) {
        i_trendStatus = trendStatus;
        this.markModifiedPersistentState();
    }

}
