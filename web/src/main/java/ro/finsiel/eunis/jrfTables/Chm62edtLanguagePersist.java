/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtLanguagePersist extends PersistentObject {
    private Integer idLanguage = null;
    private String code = null;
    private String nameEn = null;
    private String nameFr = null;
    private String nameDe = null;
    private Short selection = null;
    private String family = null;
    private String comment = null;

    public Integer getIdLanguage() {
        return idLanguage;
    }

    public void setIdLanguage(Integer idLanguage) {
        this.idLanguage = idLanguage;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNameEn() {
        return nameEn;
    }

    public void setNameEn(String nameEn) {
        this.nameEn = nameEn;
    }

    public String getNameFr() {
        return nameFr;
    }

    public void setNameFr(String nameFr) {
        this.nameFr = nameFr;
    }

    public String getNameDe() {
        return nameDe;
    }

    public void setNameDe(String nameDe) {
        this.nameDe = nameDe;
    }

    public Short getSelection() {
        return selection;
    }

    public void setSelection(Short selection) {
        this.selection = selection;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
