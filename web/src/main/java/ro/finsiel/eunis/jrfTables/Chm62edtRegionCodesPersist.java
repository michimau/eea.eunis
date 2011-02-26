/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:51 $
 **/
public class Chm62edtRegionCodesPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_idRegionCode = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    private String name = null;

    public Chm62edtRegionCodesPersist() {
        super();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter for a database field.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdRegionCode() {
        return i_idRegionCode;
    }

    /**
     * Setter for a database field.
     * @param description
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idRegionCode
     **/
    public void setIdRegionCode(String idRegionCode) {
        i_idRegionCode = idRegionCode;
        this.markModifiedPersistentState();
    }

}
