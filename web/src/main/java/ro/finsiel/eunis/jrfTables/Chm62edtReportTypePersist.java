/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtReportTypePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idReportType = null;

    /**
     * This is a database field.
     **/
    private String i_idLookup = null;

    /**
     * This is a database field.
     **/
    private String i_lookupType = null;

    public Chm62edtReportTypePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getIdLookup() {
        return i_idLookup;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdReportType() {
        return i_idReportType;
    }

    /**
     * Getter for a database field.
     **/
    public String getLookupType() {
        return i_lookupType;
    }

    /**
     * Setter for a database field.
     * @param idLookup
     **/
    public void setIdLookup(String idLookup) {
        i_idLookup = idLookup;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idReportType
     **/
    public void setIdReportType(Integer idReportType) {
        i_idReportType = idReportType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param lookupType
     **/
    public void setLookupType(String lookupType) {
        i_lookupType = lookupType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
