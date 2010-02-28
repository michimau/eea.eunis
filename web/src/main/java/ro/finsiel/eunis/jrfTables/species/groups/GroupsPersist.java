package ro.finsiel.eunis.jrfTables.species.groups;

import net.sf.jrf.domain.PersistentObject;

import java.util.StringTokenizer;

/**
 * @author finsiel
 * @version 1.0
 * @since 07.01.2003
 */
public final class GroupsPersist extends PersistentObject {

  /** This is a database field. */
  private Integer i_idSpecies = null;
  /** This is a database field. */
  private Integer i_idNatureObject = null;
  /** This is a database field. */
  private String i_scientificName = null;
  /** This is a database field. */
  private Integer i_idGroupspecies = null;
  /** This is a database field. */
  private String i_idTaxcode = null;
  /** This is a database field. */
  private String taxonomicNameFamily = null;
  /** This is a database field. */
  private String taxonomicNameOrder = null;
  /** This is a database field. */
  private Integer idSpeciesLink = null;
  private String taxonomyLevel = null;
  private String taxonomyTree = null;
  private String taxonomyName = null;


  private String commonName = null;


  /** Default constructor */
  public GroupsPersist() {
    super();
  }


  /** Getter for a database field. */
  public Integer getIdGroupspecies() {
    return i_idGroupspecies;
  }

  /** Getter for a database field. */
  public Integer getIdNatureObject() {
    return i_idNatureObject;
  }

  /** Getter for a database field. */
  public Integer getIdSpecies() {
    return i_idSpecies;
  }

  /** Getter for a database field. */
  public String getIdTaxcode() {
    return i_idTaxcode;
  }

  /** Getter for a database field. */
  public String getScientificName() {
    return i_scientificName;
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
   * @param idTaxcode
   **/
  public void setIdTaxcode(String idTaxcode) {
    i_idTaxcode = idTaxcode;
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



  /**
   * Setter for a database field
   * @param taxonomicNameFamily
   */
  public void setTaxonomicNameFamily(String taxonomicNameFamily) {
    this.taxonomicNameFamily = taxonomicNameFamily;
  }

  /**
   * Setter for a database field
   * @param taxonomicNameOrder
   */
  public void setTaxonomicNameOrder(String taxonomicNameOrder) {
    this.taxonomicNameOrder = taxonomicNameOrder;
  }




  /**
   * Getterf for a database field
   */
  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  /**
   * Setter for a database field
   * @param idSpeciesLink
   */
  public void setIdSpeciesLink(Integer idSpeciesLink) {
    this.idSpeciesLink = idSpeciesLink;
  }

  public String getCommonName() {
    return commonName;
  }

  public void setCommonName( String commonName ) {
    this.commonName = commonName;
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
