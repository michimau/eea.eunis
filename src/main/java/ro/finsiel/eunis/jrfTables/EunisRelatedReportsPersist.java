package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

import java.sql.Timestamp;

/**
 * Persistent object for the EUNIS_RELATER_REPORTS table.
 * Date: Oct 8, 2003
 * Time: 1:59:41 PM
 */
public class EunisRelatedReportsPersist extends PersistentObject {
  /** Name of the report (some kind of description). */
  private String reportName = null;
  /** Name of the file on the server. */
  private String fileName = null;
  /** Specifies if document is approved or not. */
  private Integer approved = null;
  /** User which uploaded the file. */
  private String recordAuthor = null;
  /** Date of upload (do not set this, as it's automatically handled by MySQL. */
  private Timestamp recordDate = null;

  /**
   * Constructs an new PersistentObject of this kind.
   */
  public EunisRelatedReportsPersist() {
    super();
  }

  /**
   * Getter for reportName property.
   * @return value of reportName
   */
  public String getReportName() {
    return reportName;
  }

  /**
   * Setter for reportName property.
   * @param reportName new value for reportName
   */
  public void setReportName(String reportName) {
    this.reportName = reportName;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for fileName property.
   * @return value of fileName
   */
  public String getFileName() {
    return fileName;
  }

  /**
   * Setter for fileName property.
   * @param fileName new value for fileName.
   */
  public void setFileName(String fileName) {
    this.fileName = fileName;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for approved property.
   * @return value of approved.
   */
  public Integer getApproved() {
    return approved;
  }

  /**
   * Setter for approved property.
   * @param approved new value for approved
   */
  public void setApproved(Integer approved) {
    this.approved = approved;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for recordAuthor property.
   * @return value of recordAuthor
   */
  public String getRecordAuthor() {
    return recordAuthor;
  }

  /**
   * Setter for recordAuthor property.
   * @param recordAuthor new value for recordAuthor
   */
  public void setRecordAuthor(String recordAuthor) {
    this.recordAuthor = recordAuthor;
    this.markModifiedPersistentState();
  }

  /**
   * Getter for recordDate property.
   * @return value of recordDate
   */
  public Timestamp getRecordDate() {
    return recordDate;
  }

  /**
   * Setter for recordDate property.
   * @param recordDate new value for recordDate
   */
  public void setRecordDate(Timestamp recordDate) {
    this.recordDate = recordDate;
    this.markModifiedPersistentState();
  }
}