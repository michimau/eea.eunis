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
public class DcRelationDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new DcRelationPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("DC_RELATION");
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
                            "ID_RELATION",
                            "getIdRelation",
                            "setIdRelation",
                            DEFAULT_TO_ZERO
                            , NATURAL_PRIMARY_KEY
                    )));
    this.addColumnSpec(
            new StringColumnSpec(
                    "RELATION",
                    "getRelation",
                    "setRelation",
                    DEFAULT_TO_EMPTY_STRING
                    , REQUIRED
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_VERSION_OF",
                    "getIsVersionOf",
                    "setIsVersionOf",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "HAS_VERSION",
                    "getHasVersion",
                    "setHasVersion",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_REPLACED_BY",
                    "getIsReplacedBy",
                    "setIsReplacedBy",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_REQUIRED_BY",
                    "getIsRequiredBy",
                    "setIsRequiredBy",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "REQUIRES",
                    "getRequires",
                    "setRequires",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_PART_OF",
                    "getIsPartOf",
                    "setIsPartOf",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "HAS_PART",
                    "getHasPart",
                    "setHasPart",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_REFERENCED_BY",
                    "getIsReferencedBy",
                    "setIsReferencedBy",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "_REFERENCES",
                    "getReferences",
                    "setReferences",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "IS_FORMAT_OF",
                    "getIsFormatOf",
                    "setIsFormatOf",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "HAS_FORMAT",
                    "getHasFormat",
                    "setHasFormat",
                    DEFAULT_TO_NULL
            ));
  }

}
