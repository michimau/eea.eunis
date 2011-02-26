package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.BooleanColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_NATURE_OBJECT_PICTURE.
 * @author finsiel
 **/
public class Chm62edtNatureObjectPictureDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtNatureObjectPicturePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_NATURE_OBJECT_PICTURE");
        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_OBJECT", "getIdObject",
                        "setIdObject", DEFAULT_TO_NULL),
                        new StringColumnSpec("NATURE_OBJECT_TYPE",
                        "getNatureObjectType", "setNatureObjectType",
                        DEFAULT_TO_NULL, REQUIRED),
                        new StringColumnSpec("NAME", "getName", "setName",
                        DEFAULT_TO_NULL, REQUIRED),
                        new StringColumnSpec("FILE_NAME", "getFileName",
                        "setFileName", DEFAULT_TO_NULL, REQUIRED)));
        this.addColumnSpec(
                new BooleanColumnSpec("MAIN_PIC", "isMainPicture",
                "setMainPicture", DEFAULT_TO_FALSE));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new IntegerColumnSpec("MAX_WIDTH", "getMaxWidth", "setMaxWidth",
                DEFAULT_TO_ZERO));
        this.addColumnSpec(
                new IntegerColumnSpec("MAX_HEIGHT", "getMaxHeight",
                "setMaxHeight", DEFAULT_TO_ZERO));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE", "getSource", "setSource",
                DEFAULT_TO_EMPTY_STRING));
    }
}
