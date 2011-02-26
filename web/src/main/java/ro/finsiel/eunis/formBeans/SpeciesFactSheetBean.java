package ro.finsiel.eunis.formBeans;


/**
 * Java bean used for species factsheet.
 * @author finsiel
 */
public class SpeciesFactSheetBean extends Object implements java.io.Serializable {
    private String idSpecies;
    private String idNatureObject;
    private String name; // Nume specie
    private String expand; // Expand the contents of popups directly into file (if true)

    /**
     * Creates a new SpeciesFactSheetBean object.
     */
    public SpeciesFactSheetBean() {}

    /**
     * Getter for idSpecies property.
     * @return idSpecies.
     */
    public String getIdSpecies() {
        return idSpecies;
    }

    /**
     * Setter for idSpecies property.
     * @param value idSpecies.
     */
    public void setIdSpecies(String value) {
        idSpecies = value;
    }

    /**
     * Getter for idNatureObject property.
     * @return idNatureObject.
     */
    public String getIdNatureObject() {
        return idNatureObject;
    }

    /**
     * Getter for idNatureObject property.
     * @param idNatureObject idNatureObject.
     */
    public void setIdNatureObject(String idNatureObject) {
        this.idNatureObject = idNatureObject;
    }

    /**
     * Getter for name property.
     * @return name.
     */
    public String getName() {
        return name;
    }

    /**
     * Getter for name property.
     * @param name name.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter for expand property.
     * @return expand.
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Getter for expand property.
     * @param expand expand.
     */
    public void setExpand(String expand) {
        this.expand = expand;
    }
}
