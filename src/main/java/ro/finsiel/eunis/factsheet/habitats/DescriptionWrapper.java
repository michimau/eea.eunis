package ro.finsiel.eunis.factsheet.habitats;

/**
 * This class encapsulates descriptions and references about an habitat.
 * @author finsiel
 */
public class DescriptionWrapper {
  private String description = null;
  private String language = null;
  private String ownerText = null;
  private Integer idDc = null;

  /**
   * Constructs an new DescriptionWrapper object.
   * @param description Description language.
   * @param language Language of description.
   * @param ownerText Author of the description.
   * @param idDc Reference code from DC (doublin core) tables.
   */
  public DescriptionWrapper(final String description, final String language, final String ownerText, Integer idDc) {
    this.description = description;
    this.language = language;
    this.ownerText = ownerText;
    this.idDc = idDc;
  }

  /**
   * Getter for description.
   * @return Description.
   */
  public String getDescription() {
    return description;
  }

  /**
   * Getter for language property.
   * @return Language
   */
  public String getLanguage() {
    return language;
  }

  /**
   * Getter for ownerTextProperty.
   * @return Owner text.
   */
  public String getOwnerText() {
    return ownerText;
  }

  /**
   * Getter for idDc property.
   * @return ID_DC.
   */
  public Integer getIdDc() {
    return idDc;
  }
}