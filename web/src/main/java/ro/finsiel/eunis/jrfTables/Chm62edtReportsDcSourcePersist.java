/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

import java.util.Date;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtReportsDcSourcePersist extends PersistentObject {

    private String Source = null;
    private String Editor = null;
    private Date created = null;
    private String Title = null;
    private String Publisher = null;
    private Integer idNatureObject = null;
    private Integer idGeoscope = null;
    private Integer idReportType = null;
    private Integer idGeoscopeLink = null;
    private Integer idReportAttributes = null;

    private Integer i_idDc = null;
    private String i_comment = null;

    public Chm62edtReportsDcSourcePersist() {
        super();
    }

    public Integer getIdReportAttributes() {
        return idReportAttributes;
    }

    public void setIdReportAttributes(Integer idReportAttributes) {
        this.idReportAttributes = idReportAttributes;
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
        // this.markModifiedPersistentState();
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

    public String getEditor() {
        return Editor;
    }

    public String getTitle() {
        return Title;
    }

    public String getPublisher() {
        return Publisher;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date ts) {
        created = ts;
    }

    public Integer getIdNatureObject() {
        return idNatureObject;
    }

    public void setIdNatureObject(Integer idNatureObject) {
        this.idNatureObject = idNatureObject;
    }

    public Integer getIdGeoscope() {
        return idGeoscope;
    }

    public void setIdGeoscope(Integer idGeoscope) {
        this.idGeoscope = idGeoscope;
    }

    public Integer getIdGeoscopeLink() {
        return idGeoscopeLink;
    }

    public void setIdGeoscopeLink(Integer idGeoscopeLink) {
        this.idGeoscopeLink = idGeoscopeLink;
    }

    public Integer getIdReportType() {
        return idReportType;
    }

    public void setIdReportType(Integer idReportType) {
        this.idReportType = idReportType;
    }
}
