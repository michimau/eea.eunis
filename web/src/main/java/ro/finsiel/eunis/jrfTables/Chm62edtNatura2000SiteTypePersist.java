package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtNatura2000SiteTypePersist extends PersistentObject {
    private String idNatura2000SiteType = null;
    private String name = null;
    private String description = null;

    /**
     * Constructs an new Chm62edtNatura2000SiteTypePersist object.
     */
    public Chm62edtNatura2000SiteTypePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIdNatura2000SiteType() {
        return idNatura2000SiteType;
    }

    /**
     * Setter for a database field.
     * @param idNatura2000SiteType New value.
     **/
    public void setIdNatura2000SiteType(String idNatura2000SiteType) {
        this.idNatura2000SiteType = idNatura2000SiteType;
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
