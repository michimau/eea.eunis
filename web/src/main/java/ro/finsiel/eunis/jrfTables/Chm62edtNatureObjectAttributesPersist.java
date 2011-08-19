package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 **/
public class Chm62edtNatureObjectAttributesPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_object = null;

    /**
     * This is a database field.
     **/
    private String i_objectlang = null;

    /**
     * This is a database field.
     **/
    private String type;

    public Chm62edtNatureObjectAttributesPersist() {
        super();
    }

    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    public void setIdNatureObject(Integer natureObject) {
        i_idNatureObject = natureObject;
        this.markModifiedPersistentState();
    }

    public String getName() {
        return i_name;
    }

    public void setName(String i_name) {
        this.i_name = i_name;
        this.markModifiedPersistentState();
    }

    public String getObject() {
        return i_object;
    }

    public void setObject(String i_object) {
        this.i_object = i_object;
        this.markModifiedPersistentState();
    }

    public String getObjectLang() {
        return i_objectlang;
    }

    public void setObjectLang(String i_objectlang) {
        this.i_objectlang = i_objectlang;
        this.markModifiedPersistentState();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
        this.markModifiedPersistentState();
    }

}
