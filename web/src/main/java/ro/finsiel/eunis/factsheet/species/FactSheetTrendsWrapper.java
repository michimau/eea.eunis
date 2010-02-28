package ro.finsiel.eunis.factsheet.species;

/**
 * Wrapper for trend information for a given species.
 * @author finsiel
 */
public class FactSheetTrendsWrapper {
  private String country;
  private String bioregion;
  private String startPeriod;
  private String endPeriod;
  private String status;
  private String trends;
  private String quality;
  private String reference;

  /**
   * Create a new instance of FactSheetTrendsWrapper.
   */
  public FactSheetTrendsWrapper() {}

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
   * Getter for biogeoretion property.
   * @return bioregion.
   */
  public String getBioregion() {
    return bioregion;
  }

  /**
   * Setter for bigeoregion property.
   * @param bioregion biogeoregion.
   */
  public void setBioregion(String bioregion) {
    this.bioregion = bioregion;
  }

  /**
   * Getter for startPeriod property.
   * @return startPeriod.
   */
  public String getStartPeriod() {
    return this.startPeriod;
  }

  /**
   * Setter for startPeriod property.
   * @param startPeriod startPeriod.
   */
  public void setStartPeriod(String startPeriod) {
    this.startPeriod = startPeriod;
  }

  /**
   * Getter for endPeriod property.
   * @return endPeriod.
   */
  public String getEndPeriod() {
    return endPeriod;
  }

  /**
   * Setter for endPeriod property.
   * @param endPeriod endPeriod.
   */
  public void setEndPeriod(String endPeriod) {
    this.endPeriod = endPeriod;
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
   * Getter for trends property.
   * @return trends.
   */
  public String getTrends() {
    return trends;
  }

  /**
   * Setter for trends property.
   * @param trends trends.
   */
  public void setTrends(String trends) {
    this.trends = trends;
  }

  /**
   * Getter for quality property.
   * @return quality.
   */
  public String getQuality() {
    return quality;
  }

  /**
   * Setter for quality property.
   * @param quality quality.
   */
  public void setQuality(String quality) {
    this.quality = quality;
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
