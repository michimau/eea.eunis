package ro.finsiel.eunis.jrfTables.species.synonyms;


import net.sf.jrf.domain.PersistentObject;


public class ScientificNamePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idSpecies = null;

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private String i_scientificName = null;

    private Integer i_idSpeciesLink = null;

    /**
     * This is a database field.
     **/
    private Integer i_idGroupspecies = null;

    // /** This is a database field. */
    // private String taxonomicNameFamily = null;
    // /** This is a database field. */
    // private String taxonomicNameOrder = null;
    // private String taxonomicLevel = null;


    private String ScName = null;
    private String GrName = null;
    private Integer IdSpec = null;
    private Integer IdSpecLink = null;
    private Integer IdNatObj = null;

    private String typeRelatedSpecies = null;

    public ScientificNamePersist() {
        super();
    }

    // public String getTaxonomicNameFamily() {
    // return taxonomicNameFamily;
    // }
    //
    // public void setTaxonomicNameFamily(String taxonomicNameFamily) {
    // this.taxonomicNameFamily = taxonomicNameFamily;
    // }
    //
    // public String getTaxonomicNameOrder() {
    // return taxonomicNameOrder;
    // }
    //
    // public void setTaxonomicNameOrder(String taxonomicNameOrder) {
    // this.taxonomicNameOrder = taxonomicNameOrder;
    // }
    //
    // public String getTaxonomicLevel() {
    // return taxonomicLevel;
    // }
    //
    // public void setTaxonomicLevel(String taxonomicLevel) {
    // this.taxonomicLevel = taxonomicLevel;
    // }

    public String getTypeRelatedSpecies() {
        return typeRelatedSpecies;
    }

    public void setTypeRelatedSpecies(String typeRelatedSpecies) {
        this.typeRelatedSpecies = typeRelatedSpecies;
    }

    public String getScName() {
        return ScName;
    }

    public void setScName(String ScName) {
        this.ScName = ScName;
    }

    public String getGrName() {
        return GrName;
    }

    public void setGrName(String GrName) {
        this.GrName = GrName;
    }

    public Integer getIdSpec() {
        return IdSpec;
    }

    public void setIdSpec(Integer IdSpec) {
        this.IdSpec = IdSpec;
    }

    public Integer getIdSpecLink() {
        return IdSpecLink;
    }

    public void setIdSpecLink(Integer IdSpecLink) {
        this.IdSpecLink = IdSpecLink;
    }

    public Integer getIdNatObj() {
        return IdNatObj;
    }

    public void setIdNatObj(Integer IdNatObj) {
        this.IdNatObj = IdNatObj;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdSpecies() {
        return i_idSpecies;
    }

    /**
     * Getter for a database field.
     **/
    public String getScientificName() {
        return i_scientificName;
    }

    public Integer getIdSpeciesLink() {
        return i_idSpeciesLink;
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSpecies
     **/
    public void setIdSpecies(Integer idSpecies) {
        i_idSpecies = idSpecies;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param scientificName
     **/
    public void setScientificName(String scientificName) {
        i_scientificName = scientificName;
        this.markModifiedPersistentState();
    }

    public void setIdSpeciesLink(Integer idSpeciesLink) {
        i_idSpeciesLink = idSpeciesLink;
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdGroupspecies() {
        return i_idGroupspecies;
    }

    /**
     * Setter for a database field.
     * @param idGroupspecies
     **/
    public void setIdGroupspecies(Integer idGroupspecies) {
        i_idGroupspecies = idGroupspecies;
        this.markModifiedPersistentState();
    }

}
