package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_HABITAT_CLASS_CODE.
 * @author finsiel
 **/
public class Chm62edtHabitatClassCodeDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatClassCodePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        this.setTableName("CHM62EDT_HABITAT_CLASS_CODE");
        this.setReadOnly(true);

        this.addColumnSpec(
                new StringColumnSpec("ID_HABITAT", "getIdHabitat",
                "setIdHabitat", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_CLASS_CODE", "getIdClassCode",
                "setIdClassCode", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("TITLE", "getTitle", "setTitle",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("RELATION_TYPE", "getRelationType",
                "setRelationType", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CODE", "getCode", "setCode",
                DEFAULT_TO_NULL));
    }

    /**
     * Wrapper method for SELECT COUNT(*) FROM CHM62EDT_HABITAT_CLASS_CODE WHERE (...).
     * @param sqlWhere SQL to be executed for count (...).
     * @return Number of elements found within database.
     */
    public Long countWhere(String sqlWhere) {
        return this.findLong(
                "SELECT COUNT(*) FROM " + this.getTableAlias() + " WHERE "
                + sqlWhere);
    }
}
