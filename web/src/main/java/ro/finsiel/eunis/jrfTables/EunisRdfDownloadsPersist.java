package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

import java.sql.Timestamp;
import java.util.Date;


/**
 * Persistent object for the EUNIS_RELATER_REPORTS table.
 * Date: Oct 8, 2003
 * Time: 1:59:41 PM
 */
public class EunisRdfDownloadsPersist extends PersistentObject {

    /** Name of the report (some kind of description). */
    private String title = null;

    /** Name of the file on the server. */
    private String fileName = null;

    /** Comment (long description) of the file. */
    private String comment = null;

    /** Date of upload/creation */
    private Timestamp recordDate = null;

    private Integer sort;

    /**
     * Constructs an new PersistentObject of this kind.
     */
    public EunisRdfDownloadsPersist() {
        super();
    }

    /**
     * Getter for title property.
     * @return value of reportName
     */
    public String getTitle() {
        return title;
    }

    /**
     * Setter for title property.
     * @param title new value for title
     */
    public void setTitle(String title) {
        this.title = title;
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
     * Getter for recordAuthor property.
     * @return value of recordAuthor
     */
    public String getComment() {
        return comment;
    }

    /**
     * Setter for comment property.
     * @param comment new value for recordAuthor
     */
    public void setComment(String comment) {
        this.comment = comment;
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

    public void setRecordDate(long t){
        this.recordDate = new Timestamp(t);
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}
