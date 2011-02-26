package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtAreaLegalTextPersist extends PersistentObject {
    private Integer idGeoscope = null;
    private Integer idDc = null;
    private Integer idLegalAreaEvent = null;
    private String description = null;
    private String inputDate = null;
    private String legalDate = null;
    private String areaNameEn = null;
    private String name = null;
    private String iso2Wcmc = null;
    private String iso2l = null;

    /**
     * Constructs an new Chm62edtAreaLegalTextPersist object.
     */
    public Chm62edtAreaLegalTextPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIso2Wcmc() {
        return iso2Wcmc;
    }

    /**
     * Setter for a database field.
     * @param iso2Wcmc New value.
     **/
    public void setIso2Wcmc(String iso2Wcmc) {
        this.iso2Wcmc = iso2Wcmc;
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getIso2l() {
        return iso2l;
    }

    /**
     * Setter for a database field.
     * @param iso2l New value.
     **/
    public void setIso2l(String iso2l) {
        this.iso2l = iso2l;
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdGeoscope() {
        return idGeoscope;
    }

    /**
     * Setter for a database field.
     * @param idGeoscope New value.
     **/
    public void setIdGeoscope(Integer idGeoscope) {
        this.idGeoscope = idGeoscope;
        this.forceNewPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdDc() {
        return idDc;
    }

    /**
     * Setter for a database field.
     * @param idDc New value.
     **/
    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
        this.forceNewPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdLegalAreaEvent() {
        return idLegalAreaEvent;
    }

    /**
     * Setter for a database field.
     * @param idLegalAreaEvent New value.
     **/
    public void setIdLegalAreaEvent(Integer idLegalAreaEvent) {
        this.idLegalAreaEvent = idLegalAreaEvent;
        this.markModifiedPersistentState();
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
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getInputDate() {
        return inputDate;
    }

    /**
     * Setter for a database field.
     * @param inputDate New value.
     **/
    public void setInputDate(String inputDate) {
        this.inputDate = inputDate;
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getLegalDate() {
        return legalDate;
    }

    /**
     * Setter for a database field.
     * @param legalDate New value.
     **/
    public void setLegalDate(String legalDate) {
        this.legalDate = legalDate;
        this.markModifiedPersistentState();
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
        this.markModifiedPersistentState();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getAreaNameEn() {
        return areaNameEn;
    }

    /**
     * Setter for a database field.
     * @param areaNameEn New value.
     **/
    public void setAreaNameEn(String areaNameEn) {
        this.areaNameEn = areaNameEn;
        this.markModifiedPersistentState();
    }
}
