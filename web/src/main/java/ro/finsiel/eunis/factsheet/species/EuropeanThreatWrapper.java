package ro.finsiel.eunis.factsheet.species;


/**
 * Wrapper class for European threat status information displayed in species factsheet.
 * Encapsulates three fields: status, reference, area.
 * @author finsiel
 */
public class EuropeanThreatWrapper {
    private String status = null;
    private String reference = null;
    private String area = null;

    /**
     * Creates an new EuropeanThreatWrapper object.
     * @param status Status.
     * @param reference Reference.
     * @param area Area.
     */
    public EuropeanThreatWrapper(String status, String reference, String area) {
        this.status = status;
        this.reference = reference;
        this.area = area;
    }

    /**
     * Creates an new EuropeanThreatWrapper object.
     */
    public EuropeanThreatWrapper() {
        status = null;
        reference = null;
    }

    /**
     * Getter for status property.
     * @return status.
     */
    public String getStatus() {
        if (null == status) {
            return "n/a";
        }
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
        if (null == reference) {
            return "n/a";
        }
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
     * Getter for area property.
     * @return area.
     */
    public String getArea() {
        if (null == area) {
            return "n/a";
        }
        return area;
    }

    /**
     * Setter for area property.
     * @param area area.
     */
    public void setArea(String area) {
        this.area = area;
    }
}
