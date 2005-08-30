package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.column.columnoptions.NullableColumnOption;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for EUNIS_RELATED_REPORTS.
 * @author finsiel
 **/
public class EunisRelatedReportsDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new EunisRelatedReportsPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("EUNIS_RELATED_REPORTS");
    this.addColumnSpec(new StringColumnSpec("FILE_NAME", "getFileName", "setFileName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("REPORT_NAME", "getReportName", "setReportName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new IntegerColumnSpec("APPROVED", "getApproved", "setApproved", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec( new TimestampColumnSpec("RECORD_DATE", "getRecordDate", "setRecordDate", DEFAULT_TO_NOW ) );
    this.addColumnSpec( new StringColumnSpec( "RECORD_AUTHOR", new NullableColumnOption(), "getRecordAuthor", "setRecordAuthor", null) );
  }
}