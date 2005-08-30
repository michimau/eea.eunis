package ro.finsiel.eunis.jrfTables.species.internationalthreatstatus;

import net.sf.jrf.domain.PersistentObject;

import java.util.StringTokenizer;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:15 $
 **/
public class InternationalThreatStatusPersist extends PersistentObject {

  private String scName = null;
  private String defAbrev = null;
  private Integer idCons = null;
  private Integer idNatObj = null;
  private Integer idSpecies = null;
  private Integer idSpeciesLink = null;
  private Integer idDc = null;
  private String taxonomicNameOrder = null;
  private String taxonomicNameFamily = null;
  private String taxonomyLevel = null;
  private String taxonomyTree = null;
  private String taxonomyName = null;



  public String getScName() {
    return scName;
  }

  public void setScName(String scName) {
    this.scName = scName;
  }

  public String getDefAbrev() {
    return defAbrev;
  }

  public void setDefAbrev(String defAbrev) {
    this.defAbrev = defAbrev;
  }

  public Integer getIdCons() {
    return idCons;
  }

  public void setIdCons(Integer idCons) {
    this.idCons = idCons;
  }

  public Integer getIdNatureObject() {
    return idNatObj;
  }

  public void setIdNatureObject(Integer idNatObj) {
    this.idNatObj = idNatObj;
  }

  public Integer getIdSpecies() {
    return idSpecies;
  }

  public void setIdSpecies(Integer idSpecies) {
    this.idSpecies = idSpecies;
  }

  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  public void setIdSpeciesLink(Integer idSpeciesLink) {
    this.idSpeciesLink = idSpeciesLink;
  }

  public Integer getIdDCore() {
    return idDc;
  }

  public void setIdDCore(Integer idDc) {
    this.idDc = idDc;
  }


  /**
   * This is a database field.
   **/
  private Integer i_idGroupspecies = null;
  /**
   * This is a database field.
   **/
  private String i_commonName = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = null;
  /**
   * This is a database field.
   **/
  private Short i_selection = null;
  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  private String taxonomicLevel = null;
  private String areaNameEn = null;
  private Integer idCountry = null;

  public InternationalThreatStatusPersist() {
    super();
  }


  public String getTaxonomicLevel() {
    return taxonomicLevel;
  }

  public void setTaxonomicLevel(String taxonomicLevel) {
    this.taxonomicLevel = taxonomicLevel;
  }

  /**
   * Getter for a database field.
   **/
  public String getCommonName() {
    return i_commonName;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdDc() {
    return i_idDc;
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
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Getter for a database field.
   **/
  public Short getSelection() {
    return i_selection;
  }

  /**
   * Setter for a database field.
   * @param commonName
   **/
  public void setCommonName(String commonName) {
    i_commonName = commonName;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idGroupspecies
   **/
  public void setIdGroupspecies(Integer idGroupspecies) {
    i_idGroupspecies = idGroupspecies;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
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
   * @param selection
   **/
  public void setSelection(Short selection) {
    i_selection = selection;
    this.markModifiedPersistentState();
  }

    public String getAreaNameEn() {
        return areaNameEn;
    }

    public void setAreaNameEn(String areaNameEn) {
        this.areaNameEn = areaNameEn;
    }

    public Integer getIdCountry() {
        return idCountry;
    }

    public void setIdCountry(Integer idCountry) {
        this.idCountry = idCountry;
    }


  public void setTaxonomicNameOrder(String taxonomicNameOrder) {
    this.taxonomicNameOrder = taxonomicNameOrder;
  }


  public void setTaxonomicNameFamily(String taxonomicNameFamily) {
    this.taxonomicNameFamily = taxonomicNameFamily;
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
}
