package ro.finsiel.eunis.jrfTables;


/**
 * Date: May 5, 2003
 * Time: 10:52:14 AM
 */

import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtSitesRelatedDesignationsPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_idSite = null;

    /**
     * This is a database field.
     **/
    private String i_idDesignation = null;

    /**
     * This is a database field.
     **/
    private Integer i_sequence = null;

    /**
     * This is a database field.
     **/
    private String i_overlapType = null;

    /**
     * This is a database field.
     **/
    private String i_overlap = null;

    /**
     * This is a database field.
     **/
    private String i_DesignatedSite = null;

    /**
     * This is a database field.
     **/
    private String i_sourceDb = null;

    /**
     * This is a database field.
     **/
    private String i_sourceTable = null;

    public Chm62edtSitesRelatedDesignationsPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getDesignatedSite() {
        return i_DesignatedSite;
    }

    /**
     * Setter for a database field.
     **/
    public void setDesignatedSite(String DesignatedSite) {
        this.i_DesignatedSite = DesignatedSite;
    }

    /**
     * Getter for a database field.
     **/
    public String getSourceDb() {
        return i_sourceDb;
    }

    /**
     * Setter for a database field.
     **/
    public void setSourceDb(String sourceDb) {
        this.i_sourceDb = sourceDb;
    }

    /**
     * Getter for a database field.
     **/
    public String getSourceTable() {
        return i_sourceTable;
    }

    /**
     * Setter for a database field.
     **/
    public void setSourceTable(String sourceTable) {
        this.i_sourceTable = sourceTable;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdSite() {
        return i_idSite;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdDesignation() {
        return i_idDesignation;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getSequence() {
        return i_sequence;
    }

    /**
     * Getter for a database field.
     **/
    public String getOverlapType() {
        return i_overlapType;
    }

    /**
     * Getter for a database field.
     **/
    public String getOverlap() {
        return i_overlap;
    }

    /**
     * Setter for a database field.
     * @param idSite
     **/
    public void setIdSite(String idSite) {
        i_idSite = idSite;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDesignation
     **/
    public void setIdDesignation(String idDesignation) {
        i_idDesignation = idDesignation;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param sequence
     **/
    public void setSequence(Integer sequence) {
        i_sequence = sequence;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param overlapType
     **/
    public void setOverlapType(String overlapType) {
        i_overlapType = overlapType;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param overlap
     **/
    public void setOverlap(String overlap) {
        i_overlap = overlap;
        this.markModifiedPersistentState();
    }

}
