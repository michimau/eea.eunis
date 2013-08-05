/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtHabitatHabitatPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_idHabitat = null;

    /**
     * This is a database field.
     **/
    private Integer i_idHabitatLink = null;

    /**
     * This is a database field.
     **/
    private String i_relationType = null;

    /**
     * This is a database field.
     **/
    // private Short i_relationExist = null;

    public Chm62edtHabitatHabitatPersist() {
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
    public Integer getIdHabitatLink() {
        return i_idHabitatLink;
    }

    /**
     * Getter for a database field.
     **/
    // public Short getRelationExist() {
    // return i_relationExist;
    // }

    /**
     * Getter for a database field.
     **/
    public String getRelationType() {
        return i_relationType;
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
     * @param idHabitatLink
     **/
    public void setIdHabitatLink(Integer idHabitatLink) {
        i_idHabitatLink = idHabitatLink;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param relationExist
     **/
    // public void setRelationExist(Short relationExist) {
    // i_relationExist = relationExist;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param relationType
     **/
    public void setRelationType(String relationType) {
        i_relationType = relationType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
