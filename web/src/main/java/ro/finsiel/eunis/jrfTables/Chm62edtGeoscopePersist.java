package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtGeoscopePersist extends PersistentObject {
    private Integer i_idGeoscope = null;
    private Integer i_idGeoscopeParent = null;
    private Integer i_idDc = null;
    private String i_areaType = null;

    /**
     * Creates an new instance of Chm62edtGeoscopePersist object.
     */
    public Chm62edtGeoscopePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getAreaType() {
        return i_areaType;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdGeoscope() {
        return i_idGeoscope;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdGeoscopeParent() {
        return i_idGeoscopeParent;
    }

    /**
     * Setter for a database field.
     * @param areaType New value.
     **/
    public void setAreaType(String areaType) {
        i_areaType = areaType;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDc New value.
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idGeoscope New value.
     **/
    public void setIdGeoscope(Integer idGeoscope) {
        i_idGeoscope = idGeoscope;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idGeoscopeParent New value.
     **/
    public void setIdGeoscopeParent(Integer idGeoscopeParent) {
        i_idGeoscopeParent = idGeoscopeParent;
        this.markModifiedPersistentState();
    }

}
