package ro.finsiel.eunis.jrfTables.habitats.species;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;

/**
 * Date: Sep 17, 2003
 * Time: 11:01:16 AM
 */
public class HabitatsDomain extends AbstractDomain {
  /****/
  public PersistentObject newPersistentObject() {
    return new HabitatsPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("chm62edt_habitat");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
  }

  public Long findLong(String sql) {
    return super.findLong(sql);
  }
}
