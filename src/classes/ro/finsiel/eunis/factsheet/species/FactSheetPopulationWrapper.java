package ro.finsiel.eunis.factsheet.species;

/**
 * Wrapper object for population. Used in species factsheet.
 * @author finsiel
 */
public class FactSheetPopulationWrapper {
  private String country = "";
  private String bioregion = "";
  private int min = -1;
  private int max = -1;
  private String units = "";
  private String status = "";
  private String quality = "";
  private String date = "";
  private String reference = "";

  /**
   * Creates a new FactSheetPopulationWrapper object.
   */
  public FactSheetPopulationWrapper() {
  }

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
   * Getter for min property.
   * @return min.
   */
  public int getMin() {
    return min;
  }

  /**
   * Setter for min property.
   * @param min min.
   */
  public void setMin(int min) {
    this.min = min;
  }

  /**
   * Getter for max propety.
   * @return max.
   */
  public int getMax() {
    return max;
  }

  /**
   * Setter for max property.
   * @param max max.
   */
  public void setMax(int max) {
    this.max = max;
  }

  /**
   * Getter for units property.
   * @return units.
   */
  public String getUnits() {
    return units;
  }

  /**
   * Setter for units property.
   * @param units units.
   */
  public void setUnits(String units) {
    this.units = units;
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
   * Getter for quelity property.
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
   * Getter for date property.
   * @return date.
   */
  public String getDate() {
    return date;
  }

  /**
   * Setter for date property.
   * @param date date.
   */
  public void setDate(String date) {
    this.date = date;
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
   * Getter for bioregion property.
   * @return bioregion.
   */
  public String getBioregion() {
    return bioregion;
  }

  /**
   * Setter for bioregion property.
   * @param bioregion bioregion.
   */
  public void setBioregion(String bioregion) {
    this.bioregion = bioregion;
  }
}