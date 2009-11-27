package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;

/**
 * JRF table for CHM62EDT_HABITAT_SYNTAXA inner join CHM62EDT_SYNTAXA inner join CHM62EDT_SYNTAXA_SOURCE.
 * @author finsiel
 **/
public class Chm62edtHabitatSyntaxaDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtHabitatSyntaxaPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_HABITAT_SYNTAXA");
    this.setTableAlias("A");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ID_SYNTAXA", "getIdSyntaxa", "setIdSyntaxa", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)
            )
    );
    this.addColumnSpec(new StringColumnSpec("RELATION_TYPE", "getRelationType", "setRelationType", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_SYNTAXA_SOURCE", "getIdSyntaxaSource", "setIdSyntaxaSource", DEFAULT_TO_EMPTY_STRING, REQUIRED));

    JoinTable syntaxa = new JoinTable("CHM62EDT_SYNTAXA B", "ID_SYNTAXA", "ID_SYNTAXA");
    syntaxa.addJoinColumn(new StringJoinColumn("NAME", "setSyntaxaName"));
    syntaxa.addJoinColumn(new StringJoinColumn("AUTHOR", "setSyntaxaAuthor"));
    this.addJoinTable(syntaxa);

    JoinTable syntaxasource = new JoinTable("CHM62EDT_SYNTAXA_SOURCE C", "ID_SYNTAXA_SOURCE", "ID_SYNTAXA_SOURCE");
    syntaxasource.addJoinColumn(new StringJoinColumn("SOURCE", "setSource"));
    syntaxasource.addJoinColumn(new StringJoinColumn("SOURCE_ABBREV", "setSourceAbbrev"));
    syntaxasource.addJoinColumn(new IntegerJoinColumn("ID_DC", "setIdDc"));
    this.addJoinTable(syntaxasource);
  }
}