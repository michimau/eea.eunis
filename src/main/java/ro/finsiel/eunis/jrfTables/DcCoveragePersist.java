/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcCoveragePersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idCoverage = null;
  /**
   * This is a database field.
   **/
  private String i_coverage = null;
  /**
   * This is a database field.
   **/
  private String i_spatial = null;
  /**
   * This is a database field.
   **/
  private String i_temporal = null;

  public DcCoveragePersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getCoverage() {
    return i_coverage;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdCoverage() {
    return i_idCoverage;
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
  public String getSpatial() {
    return i_spatial;
  }

  /**
   * Getter for a database field.
   **/
  public String getTemporal() {
    return i_temporal;
  }

  /**
   * Setter for a database field.
   * @param coverage
   **/
  public void setCoverage(String coverage) {
    i_coverage = coverage;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idCoverage
   **/
  public void setIdCoverage(Integer idCoverage) {
    i_idCoverage = idCoverage;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
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
   * @param spatial
   **/
  public void setSpatial(String spatial) {
    i_spatial = spatial;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param temporal
   **/
  public void setTemporal(String temporal) {
    i_temporal = temporal;
    this.markModifiedPersistentState();
  }

}
