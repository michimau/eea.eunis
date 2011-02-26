package ro.finsiel.eunis.factsheet.species;


import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;


/**
 * Wrapper for geographical status information, used in species factsheet.
 * @author finsiel
 */
public class GeographicalStatusWrapper {
    private Chm62edtCountryPersist country = null;
    private String region = "";
    private String status = "";
    private String reference = "";

    /**
     * Getter for country property.
     * @return country (with all information about it ex. ISO code, NAME etc.).
     */
    public Chm62edtCountryPersist getCountry() {
        return country;
    }

    /**
     * Setter for country property.
     * @param country country.
     */
    public void setCountry(Chm62edtCountryPersist country) {
        this.country = country;
    }

    /**
     * Getter for biogeoregion property.
     * @return region.
     */
    public String getRegion() {
        return region;
    }

    /**
     * Setter for biogeoregion property.
     * @param region region.
     */
    public void setRegion(String region) {
        this.region = region;
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
     * @param status status.
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
}
