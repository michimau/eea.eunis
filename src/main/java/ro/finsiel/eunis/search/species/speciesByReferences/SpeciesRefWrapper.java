package ro.finsiel.eunis.search.species.speciesByReferences;

/**
 * Wrapper around species information.
 * @author finsiel
 */
public class SpeciesRefWrapper {
  private Integer idSpecies = null;
  private Integer idSpeciesLink = null;
  private Integer idNatureObject = null;
  private String scientificName = null;
  private String groupName = null;
  private String orderName = null;
  private String familyName = null;

  /**
   * Ctor.
   * @param idSpecies ID_SPECIES
   * @param idSpeciesLink ID_SPECIES_LINK
   * @param idNatureObject ID_NATURE_OBJECT
   * @param scientificName SCIENTIFIC_NAME
   * @param groupName Group
   * @param orderName Order
   * @param familyName Family
   */
  public SpeciesRefWrapper(Integer idSpecies,
                           Integer idSpeciesLink,
                           Integer idNatureObject,
                           String scientificName,
                           String groupName,
                           String orderName,
                           String familyName)
  {
    this.idSpecies = idSpecies;
    this.idSpeciesLink = idSpeciesLink;
    this.idNatureObject = idNatureObject;
    this.scientificName = scientificName;
    this.groupName = groupName;
    this.orderName = orderName;
    this.familyName = familyName;
  }

  /**
   * Getter for idSpecies property.
   * @return idSpecies.
   */
  public Integer getIdSpecies() {
    return idSpecies;
  }

  /**
   * Getter for idSpeciesLink property.
   * @return idSpeciesLink.
   */
  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  /**
   * Getter for idNatureObject property.
   * @return idNatureObject.
   */
  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  /**
   * Getter for orderName property.
   * @return orderName.
   */
  public String getOrderName() {
    return orderName;
  }

  /**
   * Getter for scientificName property.
   * @return scientificName.
   */
  public String getScientificName() {
    return scientificName;
  }

  /**
   * Getter for groupName property.
   * @return groupName.
   */
  public String getGroupName() {
    return groupName;
  }

  /**
   * Getter for familyName property.
   * @return familyName.
   */
  public String getFamilyName() {
    return familyName;
  }
}