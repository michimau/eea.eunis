package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtRelativeSurfacePersist extends PersistentObject {
    private String idRelativeSurface = null;
    private String name = null;
    private String description = null;

    /**
     * Constructs an new Chm62edtRelativeSurfacePersist object.
     */
    public Chm62edtRelativeSurfacePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIdRelativeSurface() {
        return idRelativeSurface;
    }

    /**
     * Setter for a database field.
     * @param idRelativeSurface New value.
     **/
    public void setIdRelativeSurface(String idRelativeSurface) {
        this.idRelativeSurface = idRelativeSurface;
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
