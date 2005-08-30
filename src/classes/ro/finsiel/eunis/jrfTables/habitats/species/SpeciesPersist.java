package ro.finsiel.eunis.jrfTables.habitats.species;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 17, 2003
 * Time: 1:56:13 PM
 */
public class SpeciesPersist extends PersistentObject {
  private String i_scientificName = null;
  private Integer i_idSpecies = null;
  private Integer i_idSpeciesLink = null;

  public SpeciesPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Setter for a database field.
   * @param scientificName
   **/
  public void setScientificName(String scientificName) {
    i_scientificName = scientificName;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdSpecies() {
    return i_idSpecies;
  }

  /**
   * Setter for a database field.
   * @param idSpecies
   **/
  public void setIdSpecies(Integer idSpecies) {
    i_idSpecies = idSpecies;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdSpeciesLink() {
    return i_idSpeciesLink;
  }

  /**
   * Setter for a database field.
   * @param idSpeciesLink
   **/
  public void setIdSpeciesLink(Integer idSpeciesLink) {
    i_idSpeciesLink = idSpeciesLink;
    this.markModifiedPersistentState();
  }

}