package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_REPORT_TYPE.
 * @author finsiel
 **/
public class Chm62edtReportTypeDomain extends AbstractDomain {


  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtReportTypePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_REPORT_TYPE");
    this.setReadOnly(true);
    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_REPORT_TYPE", "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ID_LOOKUP", "getIdLookup", "setIdLookup", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("LOOKUP_TYPE", "getLookupType", "setLookupType", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)
            )
    );
  }
}