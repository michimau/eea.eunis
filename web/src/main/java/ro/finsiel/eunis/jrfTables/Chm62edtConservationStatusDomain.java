package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.DateColumnSpec;
import net.sf.jrf.column.columnoptions.NullableColumnOption;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

import java.util.List;


/**
 * JRF table for CHM62EDT_CONSERVATION_STATUS.
 * @author finsiel
 **/
public class Chm62edtConservationStatusDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtConservationStatusPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_CONSERVATION_STATUS");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_CONSERVATION_STATUS",
                "getIdConsStatus", "setIdConsStatus", DEFAULT_TO_ZERO,
                NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("CODE", "getCode", "setCode",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new DateColumnSpec("RED_BOOK_DATE", new NullableColumnOption(),
                "getRedBookDate", "setRedBookDate", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_CONSERVATION_STATUS_LINK",
                "getIdConsStatusLink", "setIdConsStatusLink", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));

    JoinTable dcIndex = new JoinTable("DC_INDEX", "ID_DC", "ID_DC");

    dcIndex.addJoinColumn(new StringJoinColumn("SOURCE", "source", "setSource"));
    this.addJoinTable(dcIndex);

    }

    /**
     * Execute custom SQL query.
     * @param sqlString SQL query.
     * @return List of Chm62edtConservationStatusPersist objects.
     */
    public List findGeneral(String sqlString) {
        String sql = sqlString;

        return this.findCustom(sql);
    }
}
