/*
* $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

import java.util.Date;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcIndexDcSourcePersist extends PersistentObject {

  private String Source = null;
  private String Editor = null;
  private java.sql.Timestamp created = null;
  private String Title = null;
  private String Publisher = null;
  private String url = null;


  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private String i_comment = null;


  public DcIndexDcSourcePersist() {
    super();
  }


  /**
   * Getter for a database field.
   **/
  public String getComment() {
    return i_comment;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdDc() {
    return i_idDc;
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
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  public void setSource(String comment) {
    Source = comment;
    //this.markModifiedPersistentState();
  }

  public void setEditor(String comment) {
    Editor = comment;
    // this.markModifiedPersistentState();
  }

  public void setTitle(String comment) {
    Title = comment;
    // this.markModifiedPersistentState();
  }

  public void setPublisher(String comment) {
    Publisher = comment;
    // this.markModifiedPersistentState();
  }

  public String getSource() {
    return Source;
  }


  public void setUrl(String comment) {
    this.url = comment;

  }

  public String getUrl() {
    return url;
  }

  public String getEditor() {
    return Editor;
  }


  public String getTitle() {
    return Title;
  }

  public String getPublisher() {
    return Publisher;
  }

  public java.sql.Timestamp getCreated() {
    return created;
  }

  public void setCreated(java.sql.Timestamp ts) {
    created = ts;
  }
}
