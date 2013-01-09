package ro.finsiel.eunis.factsheet.species;

import java.util.List;


/**
 * Wrapper for legal information about species, used in species factsheet.
 * @author finsiel
 */
public class LegalStatusWrapper {
    private String legalText = "n/a";
    private String url = "n/a";
    private String detailedReference = "n/a";
    private String area = "n/a";
    private String reference = "";
    private String refcd = "";
    private String comments = "";
    private Integer idDc;

    /**
     * Create a new LegalStatusWrapper object.
     */
    public LegalStatusWrapper() {}

    /**
     * Getter for comments property.
     * @return comments.
     */
    public String getComments() {
        return comments;
    }

    /**
     * Setter for comments property.
     * @param comments New value
     */
    public void setComments(String comments) {
        this.comments = comments;
    }

    /**
     * Getter for legalText property.
     * @return legalText.
     */
    public String getLegalText() {
        return legalText;
    }

    /**
     * Setter for legalText property.
     * @param legalText New value
     */
    public void setLegalText(String legalText) {
        this.legalText = legalText;
    }

    /**
     * Getter for url property.
     * @return url.
     */
    public String getUrl() {
        return url;
    }

    /**
     * Setter for url property.
     * @param url url.
     */
    public void setUrl(String url) {
        this.url = url;
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
     * Getter for refcd property (reference code).
     * @return refcd.
     */
    public String getRefcd() {
        return refcd;
    }

    /**
     * Setter for reference code property.
     * @param refcd refcd.
     */
    public void setRefcd(String refcd) {
        this.refcd = refcd;
    }

    /**
     * Getter for detailedReference property.
     * @return detailedReference.
     */
    public String getDetailedReference() {
        return detailedReference;
    }

    /**
     * Setter for detailedReference property.
     * @param detailedReference detailedReference.
     */
    public void setDetailedReference(String detailedReference) {
        this.detailedReference = detailedReference;
    }

    /**
     * Getter for area property.
     * @return area.
     */
    public String getArea() {
        return area;
    }

    /**
     * Setter for area property.
     * @param area area.
     */
    public void setArea(String area) {
        this.area = area;
    }

    public Integer getIdDc() {
        return idDc;
    }

    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    /*
     * (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        LegalStatusWrapper obj2 = (LegalStatusWrapper) this;
        List<LegalStatusWrapper> objects = (List<LegalStatusWrapper>) obj;
        boolean status = false;
        for (LegalStatusWrapper object : objects) {
            if ((object.idDc.compareTo(obj2.idDc) == 0 && isStringsEquals(object.area, obj2.area)
                    && isStringsEquals(object.comments, obj2.comments)
                    && isStringsEquals(object.detailedReference, obj2.detailedReference)
                    && isStringsEquals(object.legalText, obj2.legalText) && isStringsEquals(object.refcd, obj2.refcd)
                    && isStringsEquals(object.reference, obj2.reference) && isStringsEquals(object.url, obj2.url))
                    && !(isAllNull(obj2))) {

                status = true;
            }
        }
        return status;

    }

    private static boolean isStringsEquals(String str1, String str2) {
        if (str1 == null && str2 == null) {
            return true;
        } else if ((str1 == null && str2 != null) || (str1 != null && str2 == null)) {
            return false;
        } else {
            return str1.equals(str2);
        }

    }

    private static boolean isAllNull(LegalStatusWrapper obj1) {
        if (obj1.idDc == null && obj1.area == null && obj1.comments == null && obj1.detailedReference == null
                && obj1.legalText == null && obj1.refcd == null && obj1.reference == null && obj1.url == null) {
            return true;
        } else {
            return false;
        }
    }
}
