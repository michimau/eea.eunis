/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtSyntaxaPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idSyntaxa = null;

    /**
     * This is a database field.
     **/
    private String i_sourceAbbrev = null;

    /**
     * This is a database field.
     **/
    private String i_source = null;

    /**

     public Chm62edtSyntaxaPersist() {
     super();
     }

     /**
     * Getter for a database field.
     **/
    public String getSourceAbbrev() {
        return i_sourceAbbrev;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdSyntaxa() {
        return i_idSyntaxa;
    }

    /**
     * Getter for a database field.
     **/
    public String getSource() {
        if (null == i_source) {
            return "";
        }
        return i_source;
    }

    /**
     * Setter for a database field.
     * @param code
     **/
    public void setSourceAbbrev(String sourceAbbrev) {
        i_sourceAbbrev = sourceAbbrev;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSyntaxa
     **/
    public void setIdSyntaxa(Integer idSyntaxa) {
        i_idSyntaxa = idSyntaxa;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param name
     **/
    public void setSource(String source) {
        i_source = source;
        this.markModifiedPersistentState();
    }

}
