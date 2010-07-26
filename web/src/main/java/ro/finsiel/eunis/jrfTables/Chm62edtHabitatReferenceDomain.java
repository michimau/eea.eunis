package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * JRF table for CHM62EDT_HABITAT_REFERENCES.
 **/
public class Chm62edtHabitatReferenceDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtHabitatReferencePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_HABITAT_REFERENCES");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );
    this.addColumnSpec(new StringColumnSpec("HAVE_SOURCE", "getHaveSource", "setHaveSource", DEFAULT_TO_ZERO));
    this.addColumnSpec(new StringColumnSpec("HAVE_OTHER_REFERENCES", "getHaveRef", "setHaveRef", DEFAULT_TO_ZERO));

    JoinTable sourceTable = new JoinTable("DC_SOURCE D", "ID_DC", "ID_DC");
    sourceTable.addJoinColumn(new StringJoinColumn("SOURCE", "getSource","setSource"));
    this.addJoinTable(sourceTable);
    
    JoinTable titleTable = new JoinTable("DC_TITLE T", "ID_DC", "ID_DC");
    titleTable.addJoinColumn(new StringJoinColumn("TITLE", "getTitle","setTitle"));
    this.addJoinTable(titleTable);
  }
}