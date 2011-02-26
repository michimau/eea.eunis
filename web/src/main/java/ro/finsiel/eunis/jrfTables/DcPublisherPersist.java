/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcPublisherPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idPublisher = null;

    /**
     * This is a database field.
     **/
    private String i_publisher = null;

    public DcPublisherPersist() {
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
    public Integer getIdPublisher() {
        return i_idPublisher;
    }

    /**
     * Getter for a database field.
     **/
    public String getPublisher() {
        return i_publisher;
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
     * @param idPublisher
     **/
    public void setIdPublisher(Integer idPublisher) {
        i_idPublisher = idPublisher;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param publisher
     **/
    public void setPublisher(String publisher) {
        i_publisher = publisher;
        this.markModifiedPersistentState();
    }

}
