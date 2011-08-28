package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Root;


/**
 * DTO object for species factsheet Grid distribution tab
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class SpeciesDistributionDTO implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String name;
    private String latitude;
    private String longitude;
    private String status;
    private String reference;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

}
