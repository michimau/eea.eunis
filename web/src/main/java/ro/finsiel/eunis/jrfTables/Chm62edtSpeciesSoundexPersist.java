package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtSpeciesSoundexPersist extends PersistentObject {
    private String i_Name = null;
    private String i_Phonetic = null;

    /**
     * Constructs an new Chm62edtAbundancePersist object.
     */
    public Chm62edtSpeciesSoundexPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getPhonetic() {
        return i_Phonetic;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getName() {
        return i_Name;
    }

    /**
     * Setter for a database field.
     * @param phonetic New value.
     **/
    public void setPhonetic(String phonetic) {
        i_Phonetic = phonetic;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param name New value.
     **/
    public void setName(String name) {
        i_Name = name;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
