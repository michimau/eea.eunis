package ro.finsiel.eunis.jrfTables.species.taxonomy;

/**
 * Date: Mar 26, 2003
 * Time: 11:28:40 AM
 */


import net.sf.jrf.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.*;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:19 $
 **/
public class Chm62edtTaxcodeDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new Chm62edtTaxcodePersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_TAXONOMY");

    this.addColumnSpec(
            new StringColumnSpec(
                    "ID_TAXONOMY",
                    "getIdTaxcode",
                    "setIdTaxcode",
                    DEFAULT_TO_EMPTY_STRING
                    , NATURAL_PRIMARY_KEY
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "LEVEL",
                    "getTaxonomicLevel",
                    "setTaxonomicLevel",
                    DEFAULT_TO_EMPTY_STRING
                    , REQUIRED
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "NAME",
                    "getTaxonomicName",
                    "setTaxonomicName",
                    DEFAULT_TO_EMPTY_STRING
                    , REQUIRED
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "GROUP",
                    "getTaxonomicGroup",
                    "setTaxonomicGroup",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new IntegerColumnSpec(
                    "ID_DC",
                    "getIdDc",
                    "setIdDc",
                    DEFAULT_TO_ZERO
                    , REQUIRED
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "ID_TAXONOMY_LINK",
                    "getIdTaxcodeLink",
                    "setIdTaxcodeLink",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "ID_TAXONOMY_PARENT",
                    "getIdTaxcodeParent",
                    "setIdTaxcodeParent",
                    DEFAULT_TO_NULL
            ));
    this.addColumnSpec(
            new StringColumnSpec(
                    "TAXONOMY_TREE",
                    "getTaxonomyTree",
                    "setTaxonomyTree",
                    DEFAULT_TO_NULL
            ));
  }
}
