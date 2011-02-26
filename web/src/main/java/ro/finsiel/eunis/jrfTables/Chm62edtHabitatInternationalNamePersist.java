/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:49 $
 **/
public class Chm62edtHabitatInternationalNamePersist extends PersistentObject {

    private Integer IdHabitat = null;
    private Integer IdLanguage = null;
    private String Name = null;
    private String NameEn = null;

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

}
