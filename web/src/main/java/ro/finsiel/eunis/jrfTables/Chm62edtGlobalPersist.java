package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtGlobalPersist extends PersistentObject {
    private String idGlobal = null;
    private String name = null;
    private String description = null;

    /**
     * Constructs an new Chm62edtGlobalPersist object.
     */
    public Chm62edtGlobalPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIdGlobal() {
        return idGlobal;
    }

    /**
     * Setter for a database field.
     * @param idGlobal New value.
     **/
    public void setIdGlobal(String idGlobal) {
        this.idGlobal = idGlobal;
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
