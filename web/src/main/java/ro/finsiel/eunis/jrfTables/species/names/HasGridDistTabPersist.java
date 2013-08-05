package ro.finsiel.eunis.jrfTables.species.names;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class HasGridDistTabPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private Integer i_idSpecies = null;

    /**
     * This is a database field.
     **/
    private Integer i_idSpeciesLink = null;

    /**
     * This is a database field.
     **/
    private String i_scientificName = null;

    public HasGridDistTabPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }
  
    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Getter for a database field.
     **/
    public String getScientificName() {
        return i_scientificName;
    }

    /**
     * Setter for a database field.
     * @param sname
     **/
    public void setScientificName(String sname) {
        i_scientificName = sname;
        this.markModifiedPersistentState();
    }
  
    /**
     * Getter for a database field.
     **/
    public Integer getIdSpecies() {
        return i_idSpecies;
    }

    /**
     * Setter for a database field.
     * @param idSpecies
     **/
    public void setIdSpecies(Integer idSpecies) {
        i_idSpecies = idSpecies;
        this.markModifiedPersistentState();
    }
  
    /**
     * Getter for a database field.
     **/
    public Integer getIdSpeciesLink() {
        return i_idSpeciesLink;
    }

    /**
     * Setter for a database field.
     * @param idSpeciesLink
     **/
    public void setIdSpeciesLink(Integer idSpeciesLink) {
        i_idSpeciesLink = idSpeciesLink;
        this.markModifiedPersistentState();
    }

}
