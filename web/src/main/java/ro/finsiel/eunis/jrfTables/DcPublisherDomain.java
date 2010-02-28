package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for DC_PUBLISHER.
 * @author finsiel
 **/
public class DcPublisherDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new DcPublisherPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("DC_PUBLISHER");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_PUBLISHER", "getIdPublisher", "setIdPublisher", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );
    this.addColumnSpec(new StringColumnSpec("PUBLISHER", "getPublisher", "setPublisher", DEFAULT_TO_NULL));
  }
}