package ro.finsiel.eunis.factsheet.species;

/**
 * Wrapper object for species - habitats link.
 * @author finsiel
 */
public class SpeciesHabitatWrapper {
  /**
   * Define an EUNIS habitat.
   */
  public static final int HABITAT_EUNIS = 0;
  /**
   * Defina an ANNEX I habitat.
   */
  public static final int HABITAT_ANNEX_I = 1;

  /** Name of the habitat. */
  private String habitatName = null;
  /** This is the habitat code which is either EUNIS or ANNEX I. In order to make distinction use the habitatType below. **/
  private String habitatCode = null;
  /** Type of habitat. possible values: HABITAT_EUNIS or HABITAT_ANNEX_I. */
  private int habitatType = -1;

  private String idHabitat = null;
  private String geoscope = null;
  private String abundance = null;
  private String frequencies = null;
  private String faithfulness = null;
  private String speciesStatus = null;
  private String comment = null;

  /**
   * Creates an new SpeciesHabitatWrapper object.
   * @param habitatName Name of the habitat.
   * @param habitatCode Code of the habitat.
   * @param idHabitat ID of the habitat.
   * @param habitatType Type of habitat (one of the two public static fields of this class).
   * @param geoscope Country.
   * @param abundance Abundance.
   * @param frequencies Frequency.
   * @param faithfulness Faithfulness.
   * @param speciesStatus Species status.
   * @param comment Comment.
   */
  public SpeciesHabitatWrapper(String habitatName,
                               String habitatCode,
                               String idHabitat,
                               int habitatType,
                               String geoscope,
                               String abundance,
                               String frequencies,
                               String faithfulness,
                               String speciesStatus,
                               String comment) {
    this.habitatName = habitatName;
    this.habitatCode = habitatCode;
    this.habitatType = habitatType;
    this.idHabitat = idHabitat;
    this.geoscope = geoscope;
    this.abundance = abundance;
    this.frequencies = frequencies;
    this.faithfulness = faithfulness;
    this.speciesStatus = speciesStatus;
    this.comment = comment;
  }

  /**
   * Getter for habitatName property.
   * @return habitatName.
   */
  public String getHabitatName() {
    return habitatName;
  }

  /**
   * Getter for habitatCode property.
   * @return habitatCode.
   */
  public String getHabitatCode() {
    return habitatCode;
  }

  /**
   * Getter for habitatType property.
   * @return habitatType.
   */
  public int getHabitatType() {
    return habitatType;
  }

  /**
   * Getter for idHabitat property.
   * @return idHabitat.
   */
  public String getIdHabitat() {
    return idHabitat;
  }

  /**
   * Retrieve habitat code (for EUNIS habitats).
   * @return Habitat code.
   */
  public String getEunisHabitatcode() {
    if (HABITAT_EUNIS == habitatType) return habitatCode;
    return "";
  }

  /**
   * Retrieve habitat code (for ANNEX I habitats).
   * @return Habitat code.
   */
  public String getAnnexICode() {
    if (HABITAT_ANNEX_I == habitatType) return habitatCode;
    return "";
  }

  /**
   * Getter for geoscope property.
   * @return geoscope.
   */
  public String getGeoscope() {
    return geoscope;
  }

  /**
   * Getter for abundance property.
   * @return abundance.
   */
  public String getAbundance() {
    return abundance;
  }

  /**
   * Getter for frequencies property.
   * @return frequencies.
   */
  public String getFrequencies() {
    return frequencies;
  }

  /**
   * Getter for faithfulness property.
   * @return faithfulness.
   */
  public String getFaithfulness() {
    return faithfulness;
  }

  /**
   * Getter for specieStatus property.
   * @return speciesStatus.
   */
  public String getSpeciesStatus() {
    return speciesStatus;
  }

  /**
   * Getter for comment property.
   * @return comment.
   */
  public String getComment() {
    return comment;
  }
}