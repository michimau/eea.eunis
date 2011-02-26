/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcContributorPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idContributor = null;

    /**
     * This is a database field.
     **/
    private String i_contributor = null;

    public DcContributorPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getContributor() {
        return i_contributor;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdContributor() {
        return i_idContributor;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Setter for a database field.
     * @param contributor
     **/
    public void setContributor(String contributor) {
        i_contributor = contributor;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idContributor
     **/
    public void setIdContributor(Integer idContributor) {
        i_idContributor = idContributor;
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

}
