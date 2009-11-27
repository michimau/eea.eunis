/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:49 $
 **/
public class Chm62edtHabitatDesignatedCodesPersist extends PersistentObject {
  /**
   * This is a database field.
   **/
  private String i_legalInstrumentAbrev = null;
  /**
   * This is a database field.
   **/
  private String i_legalInstrument = null;
  /**
   * This is a database field.
   **/
  private String i_geolevel = null;

  private Integer idDesignatedCode = null;
  private String code = null;


  public Chm62edtHabitatDesignatedCodesPersist() {
    super();
  }


  public Integer getIdDesignatedCode() {
    return idDesignatedCode;
  }

  public void setIdDesignatedCode(Integer idDesignatedCode) {
    this.idDesignatedCode = idDesignatedCode;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  /**
   * Getter for a database field.
   **/
  public String getGeolevel() {
    return i_geolevel;
  }

  /**
   * Getter for a database field.
   **/
  public String getLegalInstrument() {
    return i_legalInstrument;
  }

  /**
   * Getter for a database field.
   **/
  public String getLegalInstrumentAbbrev() {
    return i_legalInstrumentAbrev;
  }

  /**
   * Setter for a database field.
   * @param geolevel
   **/
  public void setGeolevel(String geolevel) {
    i_geolevel = geolevel;
    this.markModifiedPersistentState();
  }


  /**
   * Setter for a database field.
   * @param legalInstrument
   **/
  public void setLegalInstrument(String legalInstrument) {
    i_legalInstrument = legalInstrument;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param legalInstrumentAbrev
   **/
  public void setLegalInstrumentAbrev(String legalInstrumentAbrev) {
    i_legalInstrumentAbrev = legalInstrumentAbrev;
    this.markModifiedPersistentState();
  }

}
