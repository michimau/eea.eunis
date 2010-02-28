/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtSiteGlossaryPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String i_term = null;
  /**
   * This is a database field.
   **/
  private Byte[] i_definition = null;
  /**
   * This is a database field.
   **/
  private String i_reference = null;

  public Chm62edtSiteGlossaryPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public Byte[] getDefinition() {
    return i_definition;
  }

  /**
   * Getter for a database field.
   **/
  public String getReference() {
    return i_reference;
  }

  /**
   * Getter for a database field.
   **/
  public String getTerm() {
    return i_term;
  }

  /**
   * Setter for a database field.
   * @param definition
   **/
  public void setDefinition(Byte[] definition) {
    i_definition = definition;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param reference
   **/
  public void setReference(String reference) {
    i_reference = reference;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param term
   **/
  public void setTerm(String term) {
    i_term = term;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

}
