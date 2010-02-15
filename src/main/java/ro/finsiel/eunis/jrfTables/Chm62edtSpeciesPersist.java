/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtSpeciesPersist extends PersistentObject {
  /**
   * This is a database field.
   **/
  private Integer i_idSpecies = null;
  /**
   * This is a database field.
   **/
  private Integer i_idNatureObject = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = null;
  /**
   * This is a database field.
   **/
  private String i_genus = null;
  /**
   * This is a database field.
   **/
  private Short i_validName = null;
  /**
   * This is a database field.
   **/
  private Integer i_idSpeciesLink = null;
  /**
   * This is a database field.
   **/
  private String i_typeRelatedSpecies = null;
  /**
   * This is a database field.
   **/
  private Short i_temporarySelect = null;
  /**
   * This is a database field.
   **/
  private String i_taxonomicSpeciesCode = null;
  /**
   * This is a database field.
   **/
  private String i_speciesMap = null;
  /**
   * This is a database field.
   **/
  private Integer i_idGroupspecies = null;
  /**
   * This is a database field.
   **/
  private String i_idTaxcode = null;
  /**
   * This is a database field.
   **/
  private String i_imagePath = null;
  
  /**
   * This is a database field.
   **/
  private String author;

  public Chm62edtSpeciesPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdGroupspecies() {
    return i_idGroupspecies;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdNatureObject() {
    return i_idNatureObject;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdSpecies() {
    return i_idSpecies;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdSpeciesLink() {
    return i_idSpeciesLink;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdTaxcode() {
    return i_idTaxcode;
  }

  /**
   * Getter for a database field.
   **/
  public String getImagePath() {
    return i_imagePath;
  }

  /**
   * Getter for a database field.
   **/
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Getter for a database field.
   **/
  public String getGenus() {
    return i_genus;
  }

  /**
   * Getter for a database field.
   **/
  public String getSpeciesMap() {
    return i_speciesMap;
  }

  /**
   * Getter for a database field.
   **/
  public String getTaxonomicSpeciesCode() {
    return i_taxonomicSpeciesCode;
  }

  /**
   * Getter for a database field.
   **/
  public Short getTemporarySelect() {
    return i_temporarySelect;
  }

  /**
   * Getter for a database field.
   **/
  public String getTypeRelatedSpecies() {
    return i_typeRelatedSpecies;
  }

  /**
   * Getter for a database field.
   **/
  public Short getValidName() {
    return i_validName;
  }

  /**
   * Setter for a database field.
   * @param idGroupspecies
   **/
  public void setIdGroupspecies(Integer idGroupspecies) {
    i_idGroupspecies = idGroupspecies;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idNatureObject
   **/
  public void setIdNatureObject(Integer idNatureObject) {
    i_idNatureObject = idNatureObject;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idSpecies
   **/
  public void setIdSpecies(Integer idSpecies) {
    i_idSpecies = idSpecies;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idSpeciesLink
   **/
  public void setIdSpeciesLink(Integer idSpeciesLink) {
    i_idSpeciesLink = idSpeciesLink;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idTaxcode
   **/
  public void setIdTaxcode(String idTaxcode) {
    i_idTaxcode = idTaxcode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param imagePath
   **/
  public void setImagePath(String imagePath) {
    i_imagePath = imagePath;
    this.markModifiedPersistentState();
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
   * Setter for a database field.
   * @param genus
   **/
  public void setGenus(String genus) {
    i_genus = genus;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param speciesMap
   **/
  public void setSpeciesMap(String speciesMap) {
    i_speciesMap = speciesMap;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param taxonomicSpeciesCode
   **/
  public void setTaxonomicSpeciesCode(String taxonomicSpeciesCode) {
    i_taxonomicSpeciesCode = taxonomicSpeciesCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param temporarySelect
   **/
  public void setTemporarySelect(Short temporarySelect) {
    i_temporarySelect = temporarySelect;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param typeRelatedSpecies
   **/
  public void setTypeRelatedSpecies(String typeRelatedSpecies) {
    i_typeRelatedSpecies = typeRelatedSpecies;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param validName
   **/
  public void setValidName(Short validName) {
    i_validName = validName;
    this.markModifiedPersistentState();
  }

  public String getAuthor() {
	return author;
  }
  
  public void setAuthor(String author) {
	  this.author = author;
	  this.markModifiedPersistentState();
  }
}
