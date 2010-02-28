package ro.finsiel.eunis.factsheet.species;

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
}