package ro.finsiel.eunis.jrfTables.habitats.factsheet;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

public class HabitatLegalDomain extends AbstractDomain {

  /**
   **/
  public PersistentObject newPersistentObject() {
    return new HabitatLegalPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_HABITAT");
    this.setTableAlias("A");
    this.setReadOnly(true);

    this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_ANNEX1", "getCodeAnnex1", "setCodeAnnex1", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("PRIORITY", "getPriority", "setPriority", null, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CLASS_REF", "getClassRef", "setClassRef", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_PART_2", "getCodePart2", "setCodePart2", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("LEVEL", "getHabLevel", "setHabLevel", DEFAULT_TO_NULL));

    JoinTable natObjRepType = null;
    natObjRepType = new JoinTable("CHM62EDT_HABITAT_CLASS_CODE B", "ID_HABITAT", "ID_HABITAT");
    natObjRepType.addJoinColumn(new StringJoinColumn("TITLE", "setTitle"));
    natObjRepType.addJoinColumn(new StringJoinColumn("RELATION_TYPE", "setRelationType"));
    natObjRepType.addJoinColumn(new StringJoinColumn("CODE", "setCode"));
    this.addJoinTable(natObjRepType);

    JoinTable repType = null;
    repType = new JoinTable("CHM62EDT_CLASS_CODE C", "ID_CLASS_CODE", "ID_CLASS_CODE");
    repType.addJoinColumn(new StringJoinColumn("NAME", "setLegalName"));
    repType.addJoinColumn(new IntegerJoinColumn("ID_DC", "setIdDc"));
    natObjRepType.addJoinTable(repType);
  }
}
