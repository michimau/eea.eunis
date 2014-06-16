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
 chm62edt_habitat.ID_HABITAT,
 chm62edt_habitat.SCIENTIFIC_NAME,
 chm62edt_country.AREA_NAME,
 chm62edt_biogeoregion.NAME,
 chm62edt_reports.ID_GEOSCOPE, ID_GEOSCOPE_LINK

 FROM chm62edt_habitat

 INNER JOIN chm62edt_reports ON  chm62edt_habitat.ID_NATURE_OBJECT = chm62edt_reports.ID_NATURE_OBJECT
 INNER JOIN chm62edt_country ON chm62edt_reports.ID_GEOSCOPE = chm62edt_country.ID_GEOSCOPE
 INNER JOIN chm62edt_biogeoregion ON chm62edt_reports.ID_GEOSCOPE_LINK = chm62edt_biogeoregion.ID_GEOSCOPE
 WHERE chm62edt_reports.ID_GEOSCOPE = 10
 AND chm62edt_reports.ID_GEOSCOPE_LINK = 257
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

    this.setTableName("chm62edt_habitat");
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

    JoinTable reports = new JoinTable("chm62edt_reports B", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    reports.addJoinColumn(new IntegerJoinColumn("ID_REPORT_ATTRIBUTES", "setIdReportAttributes"));
    this.addJoinTable(reports);

    JoinTable country = new JoinTable("chm62edt_country C", "ID_GEOSCOPE", "ID_GEOSCOPE");
    country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
    country.addJoinColumn(new StringJoinColumn("ISO_2L", "setIso2L"));
    reports.addJoinTable(country);

    JoinTable biogeoregion = new JoinTable("chm62edt_biogeoregion D", "ID_GEOSCOPE_LINK", "ID_GEOSCOPE");
    biogeoregion.addJoinColumn(new StringJoinColumn("NAME", "setBiogeoregionName"));
    reports.addJoinTable(biogeoregion);
  }
}