package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * Date: 03.06.2003
 * Time: 15:00:49
 */
public class RegionsCodesDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new RegionsCodesPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_SITES");
    this.setReadOnly(true);

    this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("RESPONDENT", "getRespondent", "setRespondent", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("MANAGER", "getManager", "setManager", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("COMPLEX_NAME", "getComplexName", "setComplexName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DISTRICT_NAME", "getDistrictName", "setDistrictName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("OWNERSHIP", "getOwnership", "setOwnership", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("HISTORY", "getHistory", "setHistory", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CHARACTER", "getCharacter", "setCharacter", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("MANAGEMENT_PLAN", "getManagementPlan", "setManagementPlan", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("IUCNAT", "getIucnat", "setIucnat", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESIGNATION_DATE", "getDesignationDate", "setDesignationDate", null));
    this.addColumnSpec(new StringColumnSpec("COMPILATION_DATE", "getCompilationDate", "setCompilationDate", null));
    this.addColumnSpec(new StringColumnSpec("PROPOSED_DATE", "getProposedDate", "setProposedDate", null));
    this.addColumnSpec(new StringColumnSpec("CONFIRMED_DATE", "getConfirmedDate", "setConfirmedDate", null));
    this.addColumnSpec(new StringColumnSpec("UPDATE_DATE", "getUpdateDate", "setUpdateDate", null));
    this.addColumnSpec(new StringColumnSpec("SPA_DATE", "getSpaDate", "setSpaDate", null));
    this.addColumnSpec(new StringColumnSpec("SAC_DATE", "getSacDate", "setSacDate", null));
    this.addColumnSpec(new StringColumnSpec("NATIONAL_CODE", "getNationalCode", "setNationalCode", null));
    this.addColumnSpec(new StringColumnSpec("NATURA_2000", "getNatura2000", "setNatura2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NUTS", "getNuts", "setNuts", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AREA", "getArea", "setArea", null));
    this.addColumnSpec(new StringColumnSpec("LENGTH", "getLength", "setLength", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("ALT_MEAN", "getAltMean", "setAltMean", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MAX", "getAltMax", "setAltMax", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MIN", "getAltMin", "setAltMin", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_NULL));

    JoinTable natureObjectReportType = new JoinTable("CHM62EDT_NATURE_OBJECT_REPORT_TYPE B", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(natureObjectReportType);

    JoinTable reportType = new JoinTable("CHM62EDT_REPORT_TYPE C", "ID_REPORT_TYPE", "ID_REPORT_TYPE");
    natureObjectReportType.addJoinTable(reportType);

    JoinTable regionCodes = new JoinTable("CHM62EDT_REGION_CODES D", "ID_LOOKUP", "ID_REGION_CODE");
    regionCodes.addJoinColumn(new StringJoinColumn("ID_REGION_CODE", "setRegionCode"));
    regionCodes.addJoinColumn(new StringJoinColumn("NAME", "setRegionName"));
    regionCodes.addJoinColumn(new StringJoinColumn("DESCRIPTION", "setRegionDescription"));
    reportType.addJoinTable(regionCodes);

    JoinTable reportAttributes = new JoinTable("CHM62EDT_REPORT_ATTRIBUTES E", "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
    reportAttributes.addJoinColumn(new StringJoinColumn("VALUE", "setRegionCover"));
    natureObjectReportType.addJoinTable(reportAttributes);
  }
}
