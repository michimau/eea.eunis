/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtPopulationUnitPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_description = null;
    private Integer idPopulationUnit = null;
    private String name = null;

    public Chm62edtPopulationUnitPersist() {
        super();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getIdPopulationUnit() {
        return idPopulationUnit;
    }

    public void setIdPopulationUnit(Integer idPopulationUnit) {
        this.idPopulationUnit = idPopulationUnit;
    }

    /**
     * Getter for a database field.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Setter for a database field.
     * @param description
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }
}
