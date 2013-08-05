/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtTaxonomyPersist extends PersistentObject {

    String parentLevelName = null;
    Integer classId = null;

    /**
     * This is a database field.
     **/
    private String i_idTaxonomy = null;

    /**
     * This is a database field.
     **/
    private String i_level = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_group = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private String i_idTaxonomyParent = null;

    /**
     * This is a database field.
     **/
    private String i_taxonomyTree = null;

    /**
     * This is a database field.
     **/
    private String i_idTaxonomyLink = null;

    public Chm62edtTaxonomyPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a joined field.
     **/
    public String getParentLevelName() {
        return parentLevelName;
    }

    /**
     * Getter for a joined field.
     **/
    public Integer getClassID() {
        return classId;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdTaxonomy() {
        return i_idTaxonomy;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdTaxonomyLink() {
        return i_idTaxonomyLink;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdTaxonomyParent() {
        return i_idTaxonomyParent;
    }

    /**
     * Getter for a database field.
     **/
    public String getTaxonomyTree() {
        return i_taxonomyTree;
    }

    /**
     * Getter for a database field.
     **/
    // public String getNotes() {
    // return i_notes;
    // }

    /**
     * Getter for a database field.
     **/
    public String getGroup() {
        return i_group;
    }

    /**
     * Getter for a database field.
     **/
    public String getLevel() {
        return i_level;
    }

    /**
     * Getter for a database field.
     **/
    public String getName() {
        return i_name;
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
     * @param idTaxonomy
     **/
    public void setIdTaxonomy(String idTaxonomy) {
        i_idTaxonomy = idTaxonomy;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idTaxonomyLink
     **/
    public void setIdTaxonomyLink(String idTaxonomyLink) {
        i_idTaxonomyLink = idTaxonomyLink;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idTaxonomyParent
     **/
    public void setIdTaxonomyParent(String idTaxonomyParent) {
        i_idTaxonomyParent = idTaxonomyParent;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param taxonomyTree
     **/
    public void setTaxonomyTree(String taxonomyTree) {
        i_taxonomyTree = taxonomyTree;
        this.markModifiedPersistentState();
    }

    public void setParentLevelName(String value) {
        parentLevelName = value;
        this.markModifiedPersistentState();
    }

    public void setClassID(Integer value) {
        classId = value;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param group
     **/
    public void setGroup(String group) {
        i_group = group;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param level
     **/
    public void setLevel(String level) {
        i_level = level;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param name
     **/
    public void setName(String name) {
        i_name = name;
        this.markModifiedPersistentState();
    }

}
