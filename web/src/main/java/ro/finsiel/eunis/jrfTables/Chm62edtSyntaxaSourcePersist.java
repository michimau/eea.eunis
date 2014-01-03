package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtSyntaxaSourcePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String idSyntaxaSource = null;

    /**
     * This is a database field.
     **/
    private String source = "";

    /**
     * This is a database field.
     **/
    private String sourceAbbrev = "";

    public Chm62edtSyntaxaSourcePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getSource() {
        return source;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdSyntaxaSource() {
        return idSyntaxaSource;
    }

    /**
     * Setter for a database field.
     * @param source
     **/
    public void setSource(String source) {
        this.source = source;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSyntaxaSource
     **/
    public void setIdSyntaxaSource(String idSyntaxaSource) {
        this.idSyntaxaSource = idSyntaxaSource;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    public String getSourceAbbrev() {
        return sourceAbbrev;
    }

    public void setSourceAbbrev(String sourceAbbrev) {
        this.sourceAbbrev = sourceAbbrev;
        this.markModifiedPersistentState();
    }
}
