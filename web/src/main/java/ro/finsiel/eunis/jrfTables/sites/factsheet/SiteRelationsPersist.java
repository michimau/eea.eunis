/**
 * User: root
 * Date: May 22, 2003
 * Time: 4:29:37 PM
 */
package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.PersistentObject;

public class SiteRelationsPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String i_idSite = null;
  /**
   * This is a database field.
   **/
  private String i_idSiteLink = null;
  /**
   * This is a database field.
   **/
  private String i_relationType = null;
  /**
   * This is a database field.
   **/
  private Integer i_withinProject = null;
  /**
   * This is a database field.
   **/
  private java.math.BigDecimal i_overlap = null;
  /**
   * This is a database field.
   **/
  private Integer sequence = null;
  /**
   * This is a database field.
   **/
  private String siteName = null;
  /**
   * This is a database field.
   **/
//  private String i_sourceTable = null;
  /**
   * This is a database field.
   **/
  private String i_relationName = null;


  public SiteRelationsPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
//  public String getSourceTable() {
//    return i_sourceTable;
//  }

  /**
   * Setter for a database field.
   **/
//  public void setSourceTable(String sourceTable) {
//    this.i_sourceTable = sourceTable;
//  }

  /**
   * Setter for a database field.
   **/
  public void setRelationName(String relationName) {
    this.i_relationName = relationName;
  }

  /**
   * Getter for a database field.
   **/
  public String getRelationName() {
    return i_relationName;
  }

  public String getSiteName() {
    return siteName;
  }

  public void setSiteName(String siteName) {
    this.siteName = siteName;
  }

  public Integer getSequence() {
    return sequence;
  }

  public void setSequence(Integer sequence) {
    this.sequence = sequence;
  }

  public Integer getWithinProject() {
    if (null == i_withinProject) return new Integer(-1);
    return i_withinProject;
  }

  public void setWithinProject(Integer withinProject) {
    this.i_withinProject = withinProject;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdSite() {
    return i_idSite;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdSiteLink() {
    return i_idSiteLink;
  }

  /**
   * Getter for a database field.
   **/
  public java.math.BigDecimal getOverlap() {
    if (null == i_overlap) return new java.math.BigDecimal(0);
    return i_overlap;
  }

  /**
   * Getter for a database field.
   **/
  public String getRelationType() {
    if (null == i_relationType) return "";
    return i_relationType;
  }

  /**
   * Setter for a database field.
   * @param idSite
   **/
  public void setIdSite(String idSite) {
    i_idSite = idSite;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idSiteLink
   **/
  public void setIdSiteLink(String idSiteLink) {
    i_idSiteLink = idSiteLink;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param overlap
   **/
  public void setOverlap(java.math.BigDecimal overlap) {
    i_overlap = overlap;
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

}
