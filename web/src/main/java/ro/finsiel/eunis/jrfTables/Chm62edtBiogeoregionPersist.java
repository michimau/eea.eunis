package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtBiogeoregionPersist extends PersistentObject {
    private Integer i_idBiogeoregion = null;
    private Integer i_idGeoscope = null;
    private String i_biogeoregionCode = null;
    private String i_biogeoregionCodeEea = null;
    private String i_biogeoregionName = null;
    private Short i_selection = null;

    /**
     * Creates an new instance of Chm62edtBiogeoregionPersist object.
     */
    public Chm62edtBiogeoregionPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getBiogeoregionCode() {
        return i_biogeoregionCode;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getBiogeoregionCodeEea() {
        return i_biogeoregionCodeEea;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getBiogeoregionName() {
        return i_biogeoregionName;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdBiogeoregion() {
        return i_idBiogeoregion;
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
    public Short getSelection() {
        return i_selection;
    }

    /**
     * Setter for a database field.
     * @param biogeoregionCode New value.
     **/
    public void setBiogeoregionCode(String biogeoregionCode) {
        i_biogeoregionCode = biogeoregionCode;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param biogeoregionCodeEea New value.
     **/
    public void setBiogeoregionCodeEea(String biogeoregionCodeEea) {
        i_biogeoregionCodeEea = biogeoregionCodeEea;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param biogeoregionName New value.
     **/
    public void setBiogeoregionName(String biogeoregionName) {
        i_biogeoregionName = biogeoregionName;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idBiogeoregion New value.
     **/
    public void setIdBiogeoregion(Integer idBiogeoregion) {
        i_idBiogeoregion = idBiogeoregion;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idGeoscope New value.
     **/
    public void setIdGeoscope(Integer idGeoscope) {
        i_idGeoscope = idGeoscope;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param selection New value.
     **/
    public void setSelection(Short selection) {
        i_selection = selection;
        this.markModifiedPersistentState();
    }
}
