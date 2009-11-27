package ro.finsiel.eunis.jrfTables.habitats.factsheet;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;

/**
 SELECT
 CHM62EDT_HABITAT.ID_HABITAT,
 CHM62EDT_HABITAT.SCIENTIFIC_NAME,
 CHM62EDT_COUNTRY.AREA_NAME,
 CHM62EDT_BIOGEOREGION.NAME,
 CHM62EDT_REPORTS.ID_GEOSCOPE, ID_GEOSCOPE_LINK

 FROM CHM62EDT_HABITAT

 INNER JOIN CHM62EDT_REPORTS ON  CHM62EDT_HABITAT.ID_NATURE_OBJECT = CHM62EDT_REPORTS.ID_NATURE_OBJECT
 INNER JOIN CHM62EDT_COUNTRY ON CHM62EDT_REPORTS.ID_GEOSCOPE = CHM62EDT_COUNTRY.ID_GEOSCOPE
 INNER JOIN CHM62EDT_BIOGEOREGION ON CHM62EDT_REPORTS.ID_GEOSCOPE_LINK = CHM62EDT_BIOGEOREGION.ID_GEOSCOPE
 WHERE CHM62EDT_REPORTS.ID_GEOSCOPE = 10
 AND CHM62EDT_REPORTS.ID_GEOSCOPE_LINK = 257
 */
public class HabitatCountryDomain extends AbstractDomain {
  public PersistentObject newPersistentObject() {
    return new HabitatCountryPersist();
  }

  /****/
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
    this.addColumnSpec(new IntegerColumnSpec("LEVEL", "getLevel", "setLevel", DEFAULT_TO_NULL));

    JoinTable reports = new JoinTable("CHM62EDT_REPORTS B", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    reports.addJoinColumn(new IntegerJoinColumn("ID_REPORT_ATTRIBUTES", "setIdReportAttributes"));
    this.addJoinTable(reports);

    JoinTable country = new JoinTable("CHM62EDT_COUNTRY C", "ID_GEOSCOPE", "ID_GEOSCOPE");
    country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
    country.addJoinColumn(new StringJoinColumn("ISO_2L", "setIso2L"));
    reports.addJoinTable(country);

    JoinTable biogeoregion = new JoinTable("CHM62EDT_BIOGEOREGION D", "ID_GEOSCOPE_LINK", "ID_GEOSCOPE");
    biogeoregion.addJoinColumn(new StringJoinColumn("NAME", "setBiogeoregionName"));
    reports.addJoinTable(biogeoregion);
  }
}