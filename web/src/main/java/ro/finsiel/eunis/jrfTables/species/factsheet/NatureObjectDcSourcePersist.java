package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.domain.PersistentObject;

import java.util.Date;


/**
 *
 * @version $Revision$ $Date$
 **/
public class NatureObjectDcSourcePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private String i_type = null;
    private String Source = null;
    private String Editor = null;
    private Date created = null;
    private String Title = null;
    private String Publisher = null;
    private String url = null;

    public NatureObjectDcSourcePersist() {
        super();
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setSource(String comment) {
        this.Source = comment;
    }

    public void setEditor(String comment) {
        this.Editor = comment;
    }

    public void setTitle(String comment) {
        this.Title = comment;
    }

    public void setPublisher(String comment) {
        this.Publisher = comment;
    }

    public String getSource() {
        return Source;
    }

    public String getEditor() {
        return Editor;
    }

    public String getTitle() {
        if (null == Title) {
            return "";
        }
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

    /*
     public Timestamp getCreated() { return created; }
     public void setCreated(Timestamp ts) { this.created = ts; }
     */

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    /**
     * Getter for a database field.
     **/
    public String getType() {
        return i_type;
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param type
     **/
    public void setType(String type) {
        i_type = type;
        this.markModifiedPersistentState();
    }

}
