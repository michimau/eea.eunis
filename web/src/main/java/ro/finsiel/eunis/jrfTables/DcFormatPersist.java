/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcFormatPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idFormat = null;

    /**
     * This is a database field.
     **/
    private String i_format = null;

    /**
     * This is a database field.
     **/
    private String i_extent = null;

    /**
     * This is a database field.
     **/
    private String i_medium = null;

    public DcFormatPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getExtent() {
        return i_extent;
    }

    /**
     * Getter for a database field.
     **/
    public String getFormat() {
        return i_format;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdFormat() {
        return i_idFormat;
    }

    /**
     * Getter for a database field.
     **/
    public String getMedium() {
        return i_medium;
    }

    /**
     * Setter for a database field.
     * @param extent
     **/
    public void setExtent(String extent) {
        i_extent = extent;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param format
     **/
    public void setFormat(String format) {
        i_format = format;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idFormat
     **/
    public void setIdFormat(Integer idFormat) {
        i_idFormat = idFormat;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param medium
     **/
    public void setMedium(String medium) {
        i_medium = medium;
        this.markModifiedPersistentState();
    }

}
