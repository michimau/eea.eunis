package ro.finsiel.eunis.jrfTables.species.country;

import net.sf.jrf.domain.PersistentObject;

import java.util.StringTokenizer;

/**
 * @author finsiel
 * @since 20.01.2003
 * @version 1.0
 **/
public class CountryPersist extends PersistentObject {

  /** This is a database field. */
  private Integer i_idBiogeoregion = null;
  /** This is a database field. */
  private Integer i_idGeoscope = null;
  /** This is a database field. */
  private String i_biogeoregionCode = null;
  /** This is a database field. */
  private String i_biogeoregionCodeEea = null;
  /** This is a database field. */
  private String i_biogeoregionName = null;
  /** This is a database field. */
  private Short i_selection = null;
  /** This is a database field. */
  private Integer idSpecies = null;
  /** This is a database field. */
  private Integer idSpeciesLink = null;
  /** This is a database field.*/
  private Integer IdNatureObjectRep = null;
  /** This is a database field.*/
  private Integer IdGeoscopeLink = null;
  /** This is a database field.*/
  private String ScientificName = null;
  /** This is a database field.*/
  private String CommonName = null;
  /** This is a database field.*/
  private String TaxonomicNameOrder = null;
  /** This is a database field.*/
  private String TaxonomicNameFamily = null;
  /** This is a database field.*/
  private Integer i_idCountry = null;
  /** This is a database field.*/
  private String i_eunisAreaCode = null;
  /** This is a database field.*/
  private String i_areaNameEnglish = null;
  private String taxonomyLevel = null;
  private String taxonomyTree = null;
  private String taxonomyName = null;

  /** Default constructor */
  public CountryPersist() {
    super();
  }


  /** Getter for a database field. */
  public String getBiogeoregionCode() {
    return i_biogeoregionCode;
  }

  /** Getter for a database field. */
  public String getBiogeoregionCodeEea() {
    return i_biogeoregionCodeEea;
  }

  /** Getter for a database field. */
  public String getBiogeoregionName() {
    return i_biogeoregionName;
  }

  /** Getter for a database field. */
  public Integer getIdBiogeoregion() {
    return i_idBiogeoregion;
  }

  /** Getter for a database field. */
  public Integer getIdGeoscope() {
    return i_idGeoscope;
  }

  /** Getter for a database field. */
  public Short getSelection() {
    return i_selection;
  }

  /** Getter for a database field. **/
  public String getAreaNameEnglish() {
    return i_areaNameEnglish;
  }

  /** Getter for a database field. **/
  public String getEunisAreaCode() {
    return i_eunisAreaCode;
  }

  /** Getter for a database field. **/
  public Integer getIdCountry() {
    return i_idCountry;
  }

  /** Getter for a database field. **/
  public Integer getIdNatureObjectRep() {
    return IdNatureObjectRep;
  }

  /** Getter for a database field. **/
  public Integer getIdGeoscopeLink() {
    return IdGeoscopeLink;
  }

  /** Getter for a database field. **/
  public String getScientificName() {
    return ScientificName;
  }

  /** Getter for a database field. **/
  public String getCommonName() {
    return CommonName;
  }

  /** Getter for a database field */
  public String getTaxonomicNameOrder() {
    String level = this.getTaxonomyLevel();

    if(level != null && level.equalsIgnoreCase("order_column"))
       return this.getTaxonomyName();
    else
    {
      String result = "";
      String str = this.getTaxonomyTree();

      StringTokenizer st = new StringTokenizer(str,",");
        while(st.hasMoreTokens())
        {
          StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
          String classification_id = sts.nextToken();
          String classification_level = sts.nextToken();
          String classification_name = sts.nextToken();
          if(classification_level != null && classification_level.equalsIgnoreCase("order_column")) {result = classification_name;break;}
        }

      return result;
    }
  }

  /** Getter for a database field */
  public String getTaxonomicNameFamily() {
    String level = this.getTaxonomyLevel();

    if(level != null && level.equalsIgnoreCase("family"))
       return this.getTaxonomyName();
    else
    {
      String result = "";
      String str = this.getTaxonomyTree();

      StringTokenizer st = new StringTokenizer(str,",");
        while(st.hasMoreTokens())
        {
          StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
          String classification_id = sts.nextToken();
          String classification_level = sts.nextToken();
          String classification_name = sts.nextToken();
          if(classification_level != null && classification_level.equalsIgnoreCase("family")) {result = classification_name;break;}
        }

      return result;
    }
  }

  /** Getter for a database field. **/

  public Integer getIdSpecies() {
    return idSpecies;
  }

  /** Getter for a database field. **/
  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  /**
   * Setter for a database field.
   * @param biogeoregionCode
   **/
  public void setBiogeoregionCode(String biogeoregionCode) {
    i_biogeoregionCode = biogeoregionCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param biogeoregionCodeEea
   **/
  public void setBiogeoregionCodeEea(String biogeoregionCodeEea) {
    i_biogeoregionCodeEea = biogeoregionCodeEea;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param biogeoregionName
   **/
  public void setBiogeoregionName(String biogeoregionName) {
    i_biogeoregionName = biogeoregionName;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idBiogeoregion
   **/
  public void setIdBiogeoregion(Integer idBiogeoregion) {
    i_idBiogeoregion = idBiogeoregion;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idGeoscope
   **/
  public void setIdGeoscope(Integer idGeoscope) {
    i_idGeoscope = idGeoscope;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param selection
   **/
  public void setSelection(Short selection) {
    i_selection = selection;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param areaNameEnglish
   **/
  public void setAreaNameEnglish(String areaNameEnglish) {
    i_areaNameEnglish = areaNameEnglish;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param eunisAreaCode
   **/
  public void setEunisAreaCode(String eunisAreaCode) {
    i_eunisAreaCode = eunisAreaCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idCountry
   **/
  public void setIdCountry(Integer idCountry) {
    i_idCountry = idCountry;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setIdNatureObjectRep(Integer comment) {
    IdNatureObjectRep = comment;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setIdGeoscopeLink(Integer comment) {
    IdGeoscopeLink = comment;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setScientificName(String comment) {
    ScientificName = comment;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setCommonName(String comment) {
    CommonName = comment;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setTaxonomicNameOrder(String comment) {
    TaxonomicNameOrder = comment;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setTaxonomicNameFamily(String comment) {
    TaxonomicNameFamily = comment;
  }

  /**
   * Setter for a database field.
   * @param idSpecies
   **/
  public void setIdSpecies(Integer idSpecies) {
    this.idSpecies = idSpecies;
  }

  /**
   * Setter for a database field.
   * @param idSpeciesLink
   **/
  public void setIdSpeciesLink(Integer idSpeciesLink) {
    this.idSpeciesLink = idSpeciesLink;
  }

  public String getTaxonomyLevel() {
    return taxonomyLevel;
  }

  public void setTaxonomyLevel(String taxonomyLevel) {
    this.taxonomyLevel = taxonomyLevel;
  }

  public String getTaxonomyTree() {
    return taxonomyTree;
  }

  public void setTaxonomyTree(String taxonomyTree) {
    this.taxonomyTree = taxonomyTree;
  }

  public String getTaxonomyName() {
    return taxonomyName;
  }

  public void setTaxonomyName(String taxonomyName) {
    this.taxonomyName = taxonomyName;
  }
}