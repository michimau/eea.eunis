/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtHabitatGlossaryPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_term = null;

    /**
     * This is a database field.
     **/
    private String i_source = null;

    /**
     * This is a database field.
     **/
    private String i_definition = null;

    /**
     * This is a database field.
     **/
    private String i_reference = null;

    /**
     * This is a database field.
     **/
    private String i_modifiedDate = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    public Chm62edtHabitatGlossaryPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getDefinition() {
        return i_definition;
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
    public String getModifiedDate() {
        return i_modifiedDate;
    }

    /**
     * Getter for a database field.
     **/
    public String getReference() {
        return i_reference;
    }

    /**
     * Getter for a database field.
     **/
    public String getSource() {
        return i_source;
    }

    /**
     * Getter for a database field.
     **/
    public String getTerm() {
        return i_term;
    }

    /**
     * Setter for a database field.
     * @param definition
     **/
    public void setDefinition(String definition) {
        i_definition = definition;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param modifiedDate
     **/
    public void setModifiedDate(String modifiedDate) {
        i_modifiedDate = modifiedDate;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param reference
     **/
    public void setReference(String reference) {
        i_reference = reference;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param source
     **/
    public void setSource(String source) {
        i_source = source;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param term
     **/
    public void setTerm(String term) {
        i_term = term;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
