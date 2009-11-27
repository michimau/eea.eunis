/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcDescriptionDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new DcDescriptionPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("DC_DESCRIPTION");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec(
                            "ID_DC",
                            "getIdDc",
                            "setIdDc",
                            DEFAULT_TO_ZERO
                            , NATURAL_PRIMARY_KEY
                    ),
                    new IntegerColumnSpec(
                            "ID_DESCRIPTION",
                            "getIdDescription",
                            "setIdDescription",
                            DEFAULT_TO_ZERO
                            , NATURAL_PRIMARY_KEY
                    )));
    this.addColumnSpec(
            new StringColumnSpec(
                    "DESCRIPTION",
                    "getDescription",
                    "setDescription",
                    DEFAULT_TO_EMPTY_STRING
                    , REQUIRED
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "TOC",
                    "getToc",
                    "setToc",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "ABSTRACT",
                    "getAbstract",
                    "setAbstract",
                    DEFAULT_TO_NULL
            ));
  }

}
