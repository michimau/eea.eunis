package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_LANGUAGE.
 * @author finsiel
 **/
public class Chm62edtLanguageDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtLanguagePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_LANGUAGE");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_LANGUAGE", "getIdLanguage",
                "setIdLanguage", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("CODE", "getCode", "setCode",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("NAME_EN", "getNameEn", "setNameEn",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new ShortColumnSpec("SELECTION", "getSelection", "setSelection",
                null, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("NAME_FR", "getNameFr", "setNameFr",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NAME_DE", "getNameDe", "setNameDe",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("FAMILY", "getFamily", "setFamily",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("COMMENT", "getComment", "setComment",
                DEFAULT_TO_NULL));
    }
}
