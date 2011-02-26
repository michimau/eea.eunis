package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtClassCodePersist extends PersistentObject {
    private Integer i_idClassCode = null;
    private String i_className = null;
    private String i_classRef = null;
    private Short i_currentData = null;
    private Integer sortOrder = null;
    private Integer currentClassification = null;

    /**
     * Creates a new Chm62edtClassCodePersist object.
     */
    public Chm62edtClassCodePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getSortOrder() {
        return sortOrder;
    }

    /**
     * Setter for a database field.
     * @param sortOrder New value.
     **/
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getCurrentClassification() {
        return currentClassification;
    }

    /**
     * Setter for a database field.
     * @param currentClassification New value.
     **/
    public void setCurrentClassification(Integer currentClassification) {
        this.currentClassification = currentClassification;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getClassName() {
        return i_className;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getClassRef() {
        return i_classRef;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Short getCurrentData() {
        return i_currentData;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdClassCode() {
        return i_idClassCode;
    }

    /**
     * Setter for a database field.
     * @param className New value.
     **/
    public void setClassName(String className) {
        i_className = className;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param classRef New value.
     **/
    public void setClassRef(String classRef) {
        i_classRef = classRef;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param currentData New value.
     **/
    public void setCurrentData(Short currentData) {
        i_currentData = currentData;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idClassCode New value.
     **/
    public void setIdClassCode(Integer idClassCode) {
        i_idClassCode = idClassCode;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }
}
