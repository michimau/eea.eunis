package ro.finsiel.eunis.jrfTables.species.habitats;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:14 $
 **/
public class HabitatNatureObjectReportTypePersist extends PersistentObject {
    // Sort this type of objects after their EUNIS CODE



    // Currently criteria used for sorting


    private Integer idNatObj = null;
    private Integer idNatObjLink = null;

    /**
     * This is a database field.
     **/
    private String i_idHabitat = null;

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private String i_scientificName = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    /**
     * This is a database field.
     **/
    private String i_code2000 = null;

    /**
     * This is a database field.
     **/
    private String i_codeAnnex1 = null;

    /**
     * This is a database field.
     **/
    private Short i_priority = null;

    /**
     * This is a database field.
     **/
    private String i_eunisHabitatCode = null;

    /**
     * This is a database field.
     **/
    private String i_classRef = null;

    /**
     * This is a database field.
     **/
    private String i_codePart2 = null;

    /**
     * This is a database field.
     **/
    private Integer i_habLevel = null;

    public HabitatNatureObjectReportTypePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/

    public Integer getidNatObj() {
        return idNatObj;
    }

    public Integer getidNatObjLink() {
        return idNatObjLink;
    }

    public String getClassRef() {
        return i_classRef;
    }

    /**
     * Getter for a database field.
     **/
    public String getCode2000() {
        return i_code2000;
    }

    /**
     * Getter for a database field.
     **/
    public String getCodeAnnex1() {
        return i_codeAnnex1;
    }

    /**
     * Getter for a database field.
     **/
    public String getCodePart2() {
        return i_codePart2;
    }

    /**
     * Getter for a database field.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Getter for a database field.
     **/
    public String getEunisHabitatCode() {
        return i_eunisHabitatCode;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getHabLevel() {
        if (null == i_habLevel) {
            return new Integer(0);
        }
        return i_habLevel;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdHabitat() {
        return i_idHabitat;
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
    public Short getPriority() {
        return i_priority;
    }

    /**
     * Getter for a database field.
     **/
    public String getScientificName() {
        return i_scientificName;
    }

    /**
     * Setter for a database field.
     * @param classRef
     **/
    public void setClassRef(String classRef) {
        i_classRef = classRef;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param code2000
     **/
    public void setCode2000(String code2000) {
        i_code2000 = code2000;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param codeAnnex1
     **/
    public void setCodeAnnex1(String codeAnnex1) {
        i_codeAnnex1 = codeAnnex1;
        this.markModifiedPersistentState();
    }

    /**
     }   * Setter for a database field.
     * @param codePart2
     **/
    public void setCodePart2(String codePart2) {
        i_codePart2 = codePart2;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param description
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param eunisHabitatCode
     **/
    public void setEunisHabitatCode(String eunisHabitatCode) {
        i_eunisHabitatCode = eunisHabitatCode;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param habLevel
     **/
    public void setHabLevel(Integer habLevel) {
        i_habLevel = habLevel;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idHabitat
     **/
    public void setIdHabitat(String idHabitat) {
        i_idHabitat = idHabitat;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param priority
     **/
    public void setPriority(Short priority) {
        i_priority = priority;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param scientificName
     **/
    public void setScientificName(String scientificName) {
        i_scientificName = scientificName;
        this.markModifiedPersistentState();
    }

    public void setidNatObj(Integer id) {
        this.idNatObj = id;
    }

    public void setidNatObjLink(Integer id) {
        this.idNatObjLink = id;
    }

}
