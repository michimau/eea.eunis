package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_ACTIVITY_INTENSITY.
 * @author finsiel
 **/
public class Chm62edtActivityIntensityDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtActivityIntensityPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_ACTIVITY_INTENSITY");
    this.addColumnSpec(new StringColumnSpec("ID_ACTIVITY_INTENSITY", "getIdNatura2000SiteType", "setIdNatura2000SiteType", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));

  }
}