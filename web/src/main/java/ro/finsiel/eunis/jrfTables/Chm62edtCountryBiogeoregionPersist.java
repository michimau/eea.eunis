package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtCountryBiogeoregionPersist extends PersistentObject {
    private String i_codeBiogeoregion = null;
    private String i_codeCountry = null;
    private Integer percentage = null;

    /**
     * Creates an new Chm62edtCountryBiogeoregionPersist object.
     */
    public Chm62edtCountryBiogeoregionPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getCodeBiogeoregion() {
        return i_codeBiogeoregion;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getCodeCountry() {
        return i_codeCountry;
    }

    /**
     * Setter for a database field.
     * @param codeBiogeoregion New value.
     **/
    public void setCodeBiogeoregion(String codeBiogeoregion) {
        i_codeBiogeoregion = codeBiogeoregion;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param codeCountry New value.
     **/
    public void setCodeCountry(String codeCountry) {
        i_codeCountry = codeCountry;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getPercentage() {
        return percentage;
    }

    /**
     * Setter for a database field.
     * @param percentage New value.
     **/
    public void setPercentage(Integer percentage) {
        this.percentage = percentage;
    }
}
