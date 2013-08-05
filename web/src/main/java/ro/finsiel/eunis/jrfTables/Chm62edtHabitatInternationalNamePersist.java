/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtHabitatInternationalNamePersist extends PersistentObject {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    private Integer IdHabitat = null;
    private Integer IdLanguage = null;
    private String Name = null;
    private String NameEn = null;
    private String Code = null;

    public Integer getIdLanguage() {
        return IdLanguage;
    }

    public void setIdLanguage(Integer idLanguage) {
        IdLanguage = idLanguage;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public String getNameEn() {
        return NameEn;
    }

    public void setNameEn(String nameEn) {
        NameEn = nameEn;
    }

    public Integer getIdHabitat() {
        return IdHabitat;
    }

    public void setIdHabitat(Integer idHabitat) {
        IdHabitat = idHabitat;
    }

    public String getCode() {
        return Code;
    }

    public void setCode(String code) {
        Code = code;
    }

}
