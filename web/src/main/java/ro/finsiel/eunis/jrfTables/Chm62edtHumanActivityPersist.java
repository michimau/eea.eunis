/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtHumanActivityPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idHumanActivity = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    /**
     * This is a database field.
     **/
    private String name = null;

    public Chm62edtHumanActivityPersist() {
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
    public Integer getIdHumanActivity() {
        return i_idHumanActivity;
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
     * @param idHumanActivity
     **/
    public void setIdHumanActivity(Integer idHumanActivity) {
        i_idHumanActivity = idHumanActivity;
        this.markModifiedPersistentState();
    }

}
