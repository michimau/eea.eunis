/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtHabitatReportTypePersist extends PersistentObject {

    private String lookupType = null;
    private String IDLookup = null;

    /**
     * This is a database field.
     **/
    private String i_idHabitat = null;

    /**
     * This is a database field.
     **/
    private Integer i_idReportType = null;

    /**
     * This is a database field.
     **/
    private String i_reportValue = null;

    public Chm62edtHabitatReportTypePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getIdHabitat() {
        return i_idHabitat;
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
    public String getReportValue() {
        return i_reportValue;
    }

    /**
     * Setter for a database field.
     * @param idHabitat
     **/
    public void setIdHabitat(String idHabitat) {
        i_idHabitat = idHabitat;
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
     * @param reportValue
     **/
    public void setReportValue(String reportValue) {
        i_reportValue = reportValue;
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a joined field.
     **/
    public String getIDLookup() {
        return IDLookup;
    }

    /**
     * Getter for a joined  field.
     **/
    public String getLookupType() {
        return lookupType;
    }

    /**
     * Setter for a joined field.
     * @@param comment
     **/
    public void setLookupType(String comment) {
        lookupType = comment;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a joined  field.
     * @@param comment
     **/
    public void setIDLookup(String comment) {
        IDLookup = comment;
        this.markModifiedPersistentState();
    }

}
