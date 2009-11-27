/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcIndexPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private String i_comment = null;

  private int i_reference = -1;

  public DcIndexPersist() {
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

  public int getReference() {
    return i_reference;
  }

  /**
   * Setter for a database field.
   * @param comment
   **/
  public void setComment(String comment) {
    i_comment = comment;
    this.markModifiedPersistentState();
  }

  public void setReference(Integer reference) {
    if (reference == null) {
      i_reference = -1;
    } else {
      i_reference = reference.intValue();
    }
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

}
