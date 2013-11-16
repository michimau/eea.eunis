package ro.finsiel.eunis.jrfTables;


/**
 * Date: May 5, 2003
 * Time: 11:31:33 AM
 */

import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtSitesAttributesPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_idSite = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_type = null;

    /**
     * This is a database field.
     **/
    private String i_value = null;

    /**
     * This is a database field.
     **/
    private String i_sourceDb = null;

    /**
     * This is a database field.
     **/
    private String i_sourceTable = null;

    public Chm62edtSitesAttributesPersist() {
        super();
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
    public String getName() {
        return i_name;
    }

    /**
     * Getter for a database field.
     **/
    public String getType() {
        return i_type;
    }

    /**
     * Getter for a database field.
     **/
    public String getValue() {
        if (null == i_value) {
            return "";
        }
        return i_value;
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
     * @param name
     **/
    public void setName(String name) {
        i_name = name;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param type
     **/
    public void setType(String type) {
        i_type = type;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param value
     **/
    public void setValue(String value) {
        i_value = value;
        this.markModifiedPersistentState();
    }
}
