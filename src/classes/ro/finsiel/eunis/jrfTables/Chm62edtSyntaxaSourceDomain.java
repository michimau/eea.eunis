package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtSyntaxaSourceDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new Chm62edtSyntaxaSourcePersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_SYNTAXA_SOURCE");
    this.addColumnSpec(new StringColumnSpec("ID_SYNTAXA_SOURCE", "getIdSyntaxaSource", "setIdSyntaxaSource", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("SOURCE", "getSource", "setSource", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SOURCE_ABBREV", "getSourceAbbrev", "setSourceAbbrev", DEFAULT_TO_NULL));

  }
}
