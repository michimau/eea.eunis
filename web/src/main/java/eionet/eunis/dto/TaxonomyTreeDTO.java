package eionet.eunis.dto;


import java.io.Serializable;


/**
 * 
 * @author altnyris
 */
public class TaxonomyTreeDTO implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String kingdom;
    private String phylum;
    private String dwcClass;
    private String order;
    private String family;

    public String getKingdom() {
        return kingdom;
    }
    public void setKingdom(String kingdom) {
        this.kingdom = kingdom;
    }
    public String getPhylum() {
        return phylum;
    }
    public void setPhylum(String phylum) {
        this.phylum = phylum;
    }
    public String getDwcClass() {
        return dwcClass;
    }
    public void setDwcClass(String dwcClass) {
        this.dwcClass = dwcClass;
    }
    public String getOrder() {
        return order;
    }
    public void setOrder(String order) {
        this.order = order;
    }
    public String getFamily() {
        return family;
    }
    public void setFamily(String family) {
        this.family = family;
    }
}
