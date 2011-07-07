package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * JRF table for CHM62EDT_HABITAT_INTERNATIONAL_NAME inner join CHM62EDT_LANGUAGE.
 * @author finsiel
 **/
public class Chm62edtHabitatInternationalNameDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatInternationalNamePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_HABITAT_INTERNATIONAL_NAME");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_HABITAT", "getIdHabitat",
                                "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                                new IntegerColumnSpec("ID_LANGUAGE", "getIdLanguage",
                                        "setIdLanguage", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(new StringColumnSpec("INTERNATIONAL_NAME", "getName", "setName",DEFAULT_TO_NULL));

        JoinTable Language = new JoinTable("CHM62EDT_LANGUAGE A", "ID_LANGUAGE","ID_LANGUAGE");

        Language.addJoinColumn(new StringJoinColumn("NAME_EN", "getNameEn", "setNameEn"));
        Language.addJoinColumn(new StringJoinColumn("CODE", "getCode", "setCode"));
        this.addJoinTable(Language);
    }
}
