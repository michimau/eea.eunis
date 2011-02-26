package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * Date: Sep 26, 2003
 * Time: 9:51:15 AM
 */
public class GenericPersist extends PersistentObject {
    private String column1 = null;

    public GenericPersist() {
        super();
    }

    public String getColumn1() {
        return column1;
    }

    public void setColumn1(String column1) {
        this.column1 = column1;
    }
}
