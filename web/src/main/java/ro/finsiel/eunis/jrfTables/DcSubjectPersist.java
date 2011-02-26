/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:54 $
 **/
public class DcSubjectPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idSubject = null;

    /**
     * This is a database field.
     **/
    private String i_subject = null;

    public DcSubjectPersist() {
        super();
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
    public Integer getIdSubject() {
        return i_idSubject;
    }

    /**
     * Getter for a database field.
     **/
    public String getSubject() {
        return i_subject;
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
     * @param idSubject
     **/
    public void setIdSubject(Integer idSubject) {
        i_idSubject = idSubject;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param subject
     **/
    public void setSubject(String subject) {
        i_subject = subject;
        this.markModifiedPersistentState();
    }

}
