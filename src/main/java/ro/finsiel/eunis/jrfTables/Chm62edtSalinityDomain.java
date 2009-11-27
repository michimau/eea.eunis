package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_SALINITY.
 * @author finsiel
 **/
public class Chm62edtSalinityDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtSalinityPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_SALINITY");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_SALINITY", "getIdSalinity", "setIdSalinity", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", null));
    this.addColumnSpec(new StringColumnSpec("OLD_CODE", "getOldCode", "setOldCode", null));
    this.addColumnSpec(new ShortColumnSpec("USED", "getUsed", "setUsed", null));
  }
}
