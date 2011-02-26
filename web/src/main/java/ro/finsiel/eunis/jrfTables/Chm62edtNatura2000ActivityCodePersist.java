package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtNatura2000ActivityCodePersist extends PersistentObject {
    private String idNatura2000ActivityCode = null;
    private String name = null;
    private String description = null;

    /**
     * Constructs an new Chm62edtNatura2000MotivationCodePersist object.
     */
    public Chm62edtNatura2000ActivityCodePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIdNatura2000ActivityCode() {
        return idNatura2000ActivityCode;
    }

    /**
     * Setter for a database field.
     * @param idNatura2000ActivityCode New value.
     **/
    public void setIdNatura2000ActivityCode(String idNatura2000ActivityCode) {
        this.idNatura2000ActivityCode = idNatura2000ActivityCode;
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
