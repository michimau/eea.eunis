package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * JRF table for CHM62EDT_TAXONOMY outer join CHM62EDT_TAXONOMY.
 * @author finsiel
 **/
public class Chm62edtTaxcodeLeftDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtTaxcodeLeftPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_TAXONOMY");
    this.setReadOnly(true);

    this.addColumnSpec(new StringColumnSpec("ID_TAXONOMY", "getIdTaxcode", "setIdTaxcode", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("LEVEL", "getTaxonomicLevel", "setTaxonomicLevel", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("NAME", "getTaxonomicName", "setTaxonomicName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("GROUP", "getTaxonomicGroup", "setTaxonomicGroup", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("ID_TAXONOMY_LINK", "getIdTaxcodeLink", "setIdTaxcodeLink", DEFAULT_TO_NULL));

    OuterJoinTable oJoinTable = new OuterJoinTable("CHM62EDT_TAXONOMY", "ID_TAXONOMY_LINK", "ID_TAXONOMY");
    oJoinTable.setTableAlias("a");
    oJoinTable.addJoinColumn(new StringJoinColumn("NAME", "parentLevelName", "setParentLevelName"));
    oJoinTable.addJoinColumn(new IntegerJoinColumn("ID_TAXONOMY_LINK", "classCode", "setClassID"));
    this.addJoinTable(oJoinTable);
  }
}