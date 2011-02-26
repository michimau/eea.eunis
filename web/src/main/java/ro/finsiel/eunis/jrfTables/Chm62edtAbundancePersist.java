package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtAbundancePersist extends PersistentObject {
    private Integer i_idAbundance = null;
    private String code = null;
    private String i_description = null;

    /**
     * Constructs an new Chm62edtAbundancePersist object.
     */
    public Chm62edtAbundancePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdAbundance() {
        return i_idAbundance;
    }

    /**
     * Setter for a database field.
     * @param description New value.
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idAbundance New value.
     **/
    public void setIdAbundance(Integer idAbundance) {
        i_idAbundance = idAbundance;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getCode() {
        return code;
    }

    /**
     * Setter for a database field.
     * @param code New value.
     **/
    public void setCode(String code) {
        this.code = code;
    }
}
