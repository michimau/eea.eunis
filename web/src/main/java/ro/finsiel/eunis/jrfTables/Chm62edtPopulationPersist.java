package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtPopulationPersist extends PersistentObject {
    private String idPopulation = null;
    private String name = null;
    private String description = null;

    /**
     * Constructs an new Chm62edtPopulationPersist object.
     */
    public Chm62edtPopulationPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIdPopulation() {
        return idPopulation;
    }

    /**
     * Setter for a database field.
     * @param idPopulation New value.
     **/
    public void setIdPopulation(String idPopulation) {
        this.idPopulation = idPopulation;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getName() {
        return name;
    }

    /**
     * Setter for a database field.
     * @param name New value.
     **/
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getDescription() {
        return description;
    }

    /**
     * Setter for a database field.
     * @param description New value.
     **/
    public void setDescription(String description) {
        this.description = description;
    }
}
