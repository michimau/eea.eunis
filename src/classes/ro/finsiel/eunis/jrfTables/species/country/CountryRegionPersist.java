package ro.finsiel.eunis.jrfTables.species.country;

import net.sf.jrf.domain.PersistentObject;

import java.util.StringTokenizer;

/**
 * @author finsiel
 * @since 20.01.2003
 * @version 1.0
 **/
public class CountryRegionPersist extends PersistentObject {

  /** This is a database field. */
  private Integer i_idNatureObject = null;
  /** This is a database field. */
  private Integer i_idDc = null;
  /** This is a database field. */
  private Integer i_idGeoscope = null;
  /** This is a database field. */
  private Integer i_idGeoscopeLink = null;
  /** This is a database field. */
  private Integer i_idReportType = null;
  /** This is a database field. */
  private String i_referencePeriod = null;
  /** This is a database field. */
  private Integer i_popMin = null;
  /** This is a database field.*/
  private Integer i_popMax = null;
  /** This is a database field. */
  private String i_startOfPeriod = null;
  /** This is a database field.*/
  private String i_endOfPeriod = null;
  /** This is a database field. */
  private String i_vernacularName = null;
  /** This is a database field. */
  private Short i_selection = null;
  /** This is a database field. */
  private String i_description = null;
  /** This is a database field.*/
  private String i_comment = null;
  /** This is a database field.*/
  private String i_relationType = null;
  /** This is a database field. */
  private Short i_relationExistence = null;
  /** This is a join field. */
  private String scientificName = null;
  /** This is a join field. */
  private String commonName = null;
  /** This is a join field. */
  private String taxonomicNameFamily = null;
  /** This is a join field. */
  private String taxonomicNameOrder = null;
  /** This is a database field.*/
  private Integer idSpecies = null;
  /** This is a database field.*/
  private Integer idSpeciesLink = null;
  private Integer idReportAttributes = null;
  private String taxonomyLevel = null;
  private String taxonomyTree = null;
  private String taxonomyName = null;


  /** Default constructor */
  public CountryRegionPersist() {
    super();
  }


  public Integer getIdReportAttributes() {
    return idReportAttributes;
  }

  public void setIdReportAttributes(Integer idReportAttributes) {
    this.idReportAttributes = idReportAttributes;
  }


  /** Getter for a database field. */
  public String getComment() {
    return i_comment;
  }

  /** Getter for a database field. */
  public String getDescription() {
    return i_description;
  }

  /** Getter for a database field. */
  public String getEndOfPeriod() {
    return i_endOfPeriod;
  }

  /** Getter for a database field. */
  public Integer getIdDc() {
    return i_idDc;
  }

  /** Getter for a database field. */
  public Integer getIdGeoscope() {
    return i_idGeoscope;
  }

  /** Getter for a database field. */
  public Integer getIdGeoscopeLink() {
    return i_idGeoscopeLink;
  }

  /** Getter for a database field. */
  public Integer getIdNatureObject() {
    return i_idNatureObject;
  }

  /** Getter for a database field. */
  public Integer getIdReportType() {
    return i_idReportType;
  }

  /** Getter for a database field. */
  public Integer getPopMax() {
    return i_popMax;
  }

  /** Getter for a database field. */
  public Integer getPopMin() {
    return i_popMin;
  }

  /** Getter for a database field. */
  public String getReferencePeriod() {
    return i_referencePeriod;
  }

  /** Getter for a database field. */
  public Short getRelationExistence() {
    return i_relationExistence;
  }

  /** Getter for a database field. */
  public String getRelationType() {
    return i_relationType;
  }

  /** Getter for a database field. */
  public Short getSelection() {
    return i_selection;
  }

  /** Getter for a database field. */
  public String getStartOfPeriod() {
    return i_startOfPeriod;
  }

  /** Getter for a database field. */
  public String getVernacularName() {
    return i_vernacularName;
  }

  /** Getter for a database field. */
  public Integer getIdSpecies() {
    return idSpecies;
  }

  /** Getter for a database field. */
  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setComment(String comment) {
    i_comment = comment;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param description
   **/
  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param endOfPeriod
   **/
  public void setEndOfPeriod(String endOfPeriod) {
    i_endOfPeriod = endOfPeriod;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idGeoscope
   **/
  public void setIdGeoscope(Integer idGeoscope) {
    i_idGeoscope = idGeoscope;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idGeoscopeLink
   **/
  public void setIdGeoscopeLink(Integer idGeoscopeLink) {
    i_idGeoscopeLink = idGeoscopeLink;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idNatureObject
   **/
  public void setIdNatureObject(Integer idNatureObject) {
    i_idNatureObject = idNatureObject;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idReportType
   **/
  public void setIdReportType(Integer idReportType) {
    i_idReportType = idReportType;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param popMax
   **/
  public void setPopMax(Integer popMax) {
    i_popMax = popMax;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param popMin
   **/
  public void setPopMin(Integer popMin) {
    i_popMin = popMin;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param referencePeriod
   **/
  public void setReferencePeriod(String referencePeriod) {
    i_referencePeriod = referencePeriod;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param relationExistence
   **/
  public void setRelationExistence(Short relationExistence) {
    i_relationExistence = relationExistence;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param relationType
   **/
  public void setRelationType(String relationType) {
    i_relationType = relationType;
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
   * @param startOfPeriod
   **/
  public void setStartOfPeriod(String startOfPeriod) {
    i_startOfPeriod = startOfPeriod;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param vernacularName
   **/
  public void setVernacularName(String vernacularName) {
    i_vernacularName = vernacularName;
    this.markModifiedPersistentState();
  }

   /** Getter for a database field */
  public String getTaxonomicNameOrder() {
    String level = this.getTaxonomyLevel();

    if(level != null && level.equalsIgnoreCase("order"))
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
          if(classification_level != null && classification_level.equalsIgnoreCase("order")) {result = classification_name;break;}
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
   * Setter for a joined field
   * @param taxonomicNameFamily
   */
  public void setTaxonomicNameFamily(String taxonomicNameFamily) {
    this.taxonomicNameFamily = taxonomicNameFamily;
  }

   /**
   * Setter for a joined field
   * @param taxonomicNameOrder
   */
  public void setTaxonomicNameOrder(String taxonomicNameOrder) {
    this.taxonomicNameOrder = taxonomicNameOrder;
  }

  /**
   * Getter for a joined field
   * @return commonName
   */
  public String getCommonName() {
    return commonName;
  }

  /**
   * Setter for a joined field
   * @param commonName
   */
  public void setCommonName(String commonName) {
    this.commonName = commonName;
  }

  /**
   * Getter for a joined field
   * @return scientificName
   */
  public String getScientificName() {
    return scientificName;
  }

  /**
   * Setter for a joined field
   * @param scientificName
   */
  public void setScientificName(String scientificName) {
    this.scientificName = scientificName;
  }

  /**
   * Setter for a joined field
   * @param idSpecies
   */
  public void setIdSpecies(Integer idSpecies) {
    this.idSpecies = idSpecies;
  }

  /**
   * Setter for a joined field
   * @param idSpeciesLink
   */
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
