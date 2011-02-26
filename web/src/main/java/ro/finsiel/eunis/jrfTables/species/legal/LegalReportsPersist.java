package ro.finsiel.eunis.jrfTables.species.legal;


import net.sf.jrf.domain.PersistentObject;


 /**
 * @author finsiel
 * @version 1.0
 * @since 15.01.2003
 */
public class LegalReportsPersist extends PersistentObject {

    /** This is a database field. */
    private Integer i_idNatureObject = null;

    /** This is a database field. */
    private Integer i_idDc = null;

    /** This is a database field. */
    private Integer i_idGeoscope = null;

    /** This is a database field. */
    private Integer i_idGeoscopeLink = null;

    /** This is a database field. */
    private Integer i_idReportType = null;

    /** This is a database field. */
    private Integer i_idReportAttributes = null;

    private String annex = null;
    private String alternative = null;

    public LegalReportsPersist() {
        super();
    }

    public Integer getIdReportAttributes() {
        return i_idReportAttributes;
    }

    public void setIdReportAttributes(Integer idReportAttributes) {
        this.i_idReportAttributes = idReportAttributes;
    }

    public String getAlternative() {
        return alternative;
    }

    public void setAlternative(String alternative) {
        this.alternative = alternative;
    }

    public String getAnnex() {
        return annex;
    }

    public void setAnnex(String annex) {
        this.annex = annex;
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
    public Integer getIdGeoscope() {
        return i_idGeoscope;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdGeoscopeLink() {
        return i_idGeoscopeLink;
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
    public Integer getIdReportType() {
        return i_idReportType;
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
     * @param idGeoscope
     **/
    public void setIdGeoscope(Integer idGeoscope) {
        i_idGeoscope = idGeoscope;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idGeoscopeLink
     **/
    public void setIdGeoscopeLink(Integer idGeoscopeLink) {
        i_idGeoscopeLink = idGeoscopeLink;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
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
     * @param idReportType
     **/
    public void setIdReportType(Integer idReportType) {
        i_idReportType = idReportType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
