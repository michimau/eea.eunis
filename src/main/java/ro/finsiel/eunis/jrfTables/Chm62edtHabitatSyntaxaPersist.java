/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtHabitatSyntaxaPersist extends PersistentObject {

  private String syntaxaName = null;
  private String syntaxaAuthor = null;
  private String i_idHabitat = null;
  private String i_idSyntaxa = null;
  private String i_relationType = null;
  private Integer IdDc = null;
  private String IdSyntaxaSource = "";
  private String source = null;
  private String sourceAbbrev = null;


  public Integer getIdDc() {
    return IdDc;
  }

  public void setIdDc(Integer idDc) {
    IdDc = idDc;
  }

  public String getSyntaxaName() {
    return syntaxaName;
  }

  public void setSyntaxaName(String syntaxaName) {
    this.syntaxaName = syntaxaName;
  }

  public String getSyntaxaAuthor() {
    return syntaxaAuthor;
  }

  public void setSyntaxaAuthor(String syntaxaAuthor) {
    this.syntaxaAuthor = syntaxaAuthor;
  }

  public Chm62edtHabitatSyntaxaPersist() {
    super();
  }

  public String getSource() {
    if (null == source) return "";
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getSourceAbbrev() {
    if (null == sourceAbbrev) return "";
    return sourceAbbrev;
  }

  public void setSourceAbbrev(String sourceAbbrev) {
    this.sourceAbbrev = sourceAbbrev;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdHabitat() {
    return i_idHabitat;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdSyntaxa() {
    return i_idSyntaxa;
  }

  /**
   * Getter for a database field.
   **/
//  public Short getRelationExist() { return i_relationExist; }

  /**
   * Getter for a database field.
   **/
  public String getRelationType() {
    if (null == i_relationType) return "";
    return i_relationType;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdSyntaxaSource() {
    if (null == IdSyntaxaSource) return "";
    return IdSyntaxaSource;
  }

  /**
   * Setter for a database field.
   * @param idHabitat
   **/
  public void setIdHabitat(String idHabitat) {
    i_idHabitat = idHabitat;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idSyntaxa
   **/
  public void setIdSyntaxa(String idSyntaxa) {
    i_idSyntaxa = idSyntaxa;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param relationExist
   **/
//  public void setRelationExist(Short relationExist) {
//    i_relationExist = relationExist;
//    this.markModifiedPersistentState();
//  }

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
   * @param IdSyntaxaSource
   **/
  public void setIdSyntaxaSource(String IdSyntaxaSource) {
    this.IdSyntaxaSource = IdSyntaxaSource;
    this.markModifiedPersistentState();
  }

}
