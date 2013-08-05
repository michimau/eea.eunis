package ro.finsiel.eunis.jrfTables.species.glossary;


import net.sf.jrf.domain.PersistentObject;


 /**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtGlossaryPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_term = null;

    /**
     * This is a database field.
     **/
    private String i_source = null;

    /**
     * This is a database field.
     **/
    private String i_definition = null;

    /**
     * This is a database field.
     **/
    private String i_linkDescription = null;

    /**
     * This is a database field.
     **/
    private String i_linkUrl = null;

    /**
     * This is a database field.
     **/
    private String i_reference = null;

    /**
     * This is a database field.
     **/
    private String i_termDomain = null;

    /**
     * This is a database field.
     **/
    private String i_searchDomain = null;

    /**
     * This is a database field.
     **/
    private Integer i_idLanguage = null;

    /**
     * This is a database field.
     **/
    private String i_dateChanged = null;

    /**
     * This is a database field.
     **/
    private Short i_current = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    public Chm62edtGlossaryPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getTerm() {
        return i_term;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdLanguage() {
        return i_idLanguage;
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
    public String getDateChanged() {
        return i_dateChanged;
    }

    /**
     * Getter for a database field.
     **/
    public Short getCurrent() {
        return i_current;
    }

    /**
     * Getter for a database field.
     **/
    public String getSource() {
        return i_source;
    }

    /**
     * Getter for a database field.
     **/
    public String getDefinition() {
        return i_definition;
    }

    /**
     * Getter for a database field.
     **/
    public String getLinkDescription() {
        return i_linkDescription;
    }

    /**
     * Getter for a database field.
     **/
    public String getLinkUrl() {
        return i_linkUrl;
    }

    /**
     * Getter for a database field.
     **/
    public String getReference() {
        return i_reference;
    }

    /**
     * Getter for a database field.
     **/
    public String getTermDomain() {
        return i_termDomain;
    }

    /**
     * Getter for a database field.
     **/
    public String getSearchDomain() {
        return i_searchDomain;
    }

    /**
     * Setter for a database field.
     * @param term
     **/
    public void setTerm(String term) {
        i_term = term;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param source
     **/
    public void setSource(String source) {
        i_source = source;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param definition
     **/
    public void setDefinition(String definition) {
        i_definition = definition;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param linkDescription
     **/
    public void setLinkDescription(String linkDescription) {
        i_linkDescription = linkDescription;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param linkUrl
     **/
    public void setLinkUrl(String linkUrl) {
        i_linkUrl = linkUrl;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param reference
     **/
    public void setReference(String reference) {
        i_reference = reference;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param termDomain
     **/
    public void setTermDomain(String termDomain) {
        i_termDomain = termDomain;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param searchDomain
     **/
    public void setSearchDomain(String searchDomain) {
        i_searchDomain = searchDomain;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idLanguage
     **/
    public void setIdLanguage(Integer idLanguage) {
        i_idLanguage = idLanguage;
        this.markModifiedPersistentState();
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
     * @param dateChanged
     **/
    public void setDateChanged(String dateChanged) {
        i_dateChanged = dateChanged;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param current
     **/
    public void setCurrent(Short current) {
        i_current = current;
        this.markModifiedPersistentState();
    }
}
