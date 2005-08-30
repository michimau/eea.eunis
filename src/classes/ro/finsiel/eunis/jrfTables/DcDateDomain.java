package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for DC_DATE.
 * @author finsiel
 **/
public class DcDateDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new DcDatePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("DC_DATE");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_DATE", "getIdDate", "setIdDate", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );
    this.addColumnSpec(new TimestampColumnSpec("MDATE", "getMdate", "setMdate", DEFAULT_TO_NULL));
    this.addColumnSpec(new TimestampColumnSpec("CREATED", "getCreated", "setCreated", DEFAULT_TO_NULL));
    this.addColumnSpec(new TimestampColumnSpec("VALID", "getValid", "setValid", DEFAULT_TO_NULL));
    this.addColumnSpec(new TimestampColumnSpec("AVAILABLE", "getAvailable", "setAvailable", DEFAULT_TO_NULL));
    this.addColumnSpec(new TimestampColumnSpec("ISSUED", "getIssued", "setIssued", DEFAULT_TO_NULL));
    this.addColumnSpec(new TimestampColumnSpec("MODIFIED", "getModified", "setModified", DEFAULT_TO_NULL));
  }
}