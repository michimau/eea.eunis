package ro.finsiel.eunis.factsheet.species;


/**
 * Wrapper object for national threat status, used in species factsheet.
 * @author finsiel
 */
public class NationalThreatWrapper {
    private String country = "n/a";
    private String iso2L = "";
    private String status = "n/a";
    private String reference = "n/a";
    private Short selection = new Short("0");
    private String threatCode = "";
    private int referenceYear = 0;
    private Integer idDc;
    private Integer idConsStatus = 0;

    // Additional field for species factsheet
    private String statusDesc = "";

    /**
     * Creates a new NationalThreatWrapper object.
     * @param country Country.
     * @param status Status.
     * @param reference Reference.
     */
    public NationalThreatWrapper(String country, String status, String reference) {
        this.country = country;
        this.status = status;
        this.reference = reference;
    }

    /**
     * Alternative constructor.
     * @param country Country
     * @param status Status
     * @param referenceYear Referenced year
     */
    public NationalThreatWrapper(String country, String status, int referenceYear) {
        this.country = country;
        this.status = status;
        this.referenceYear = referenceYear;
    }

    /**
     * Creates a new NationalThreatWrapper object.
     */
    public NationalThreatWrapper() {}

    /**
     * Getter for country property.
     * @return country.
     */
    public String getCountry() {
        return country;
    }

    /**
     * Setter for country property.
     * @param country country.
     */
    public void setCountry(String country) {
        this.country = country;
    }

    /**
     * Getter for status property.
     * @return status.
     */
    public String getStatus() {
        return status;
    }

    /**
     * Setter for status property.
     * @param status New value
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * Getter for reference property.
     * @return reference.
     */
    public String getReference() {
        return reference;
    }

    /**
     * Setter for reference property.
     * @param reference reference.
     */
    public void setReference(String reference) {
        this.reference = reference;
    }

    /**
     * Getter for iso2L property.
     * @return iso2L.
     */
    public String getIso2L() {
        return iso2L;
    }

    /**
     * Setter for iso2L property.
     * @param iso2L New value
     */
    public void setIso2L(String iso2L) {
        this.iso2L = iso2L;
    }

    /**
     * Getter for selection property.
     * @return selection.
     */
    public Short getSelection() {
        return selection;
    }

    /**
     * Setter for selection property.
     * @param selection selection.
     */
    public void setSelection(Short selection) {
        this.selection = selection;
    }

    /**
     * Getter for threatCode property.
     * @return threatCode.
     */
    public String getThreatCode() {
        return threatCode;
    }

    /**
     * Setter for threatCode property.
     * @param threatCode threatCode.
     */
    public void setThreatCode(String threatCode) {
        this.threatCode = threatCode;
    }

    /**
     * Getter for referenceYear property.
     * @return referenceYear.
     */
    public int getReferenceYear() {
        return referenceYear;
    }

    /**
     * Setter for referenceYear property.
     * @param referenceYear referenceYear.
     */
    public void setReferenceYear(int referenceYear) {
        this.referenceYear = referenceYear;
    }

    public Integer getIdDc() {
        return idDc;
    }

    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    public String getStatusDesc() {
        return statusDesc;
    }

    public void setStatusDesc(String statusDesc) {
        this.statusDesc = statusDesc;
    }

    public Integer getIdConsStatus() {
        return idConsStatus;
    }

    public void setIdConsStatus(Integer idConsStatus) {
        this.idConsStatus = idConsStatus;
    }

}
