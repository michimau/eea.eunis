package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;

/**
 * Created by IntelliJ IDEA.
 * User: ancai
 * Date: 10.03.2005
 * Time: 12:34:38
 * To change this template use File | Settings | File Templates.
 */
public class SitesSpeciesReportAttributesDomain extends AbstractDomain {


  /****/
  public PersistentObject newPersistentObject() {
    return new SitesSpeciesReportAttributesPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_NATURE_OBJECT_REPORT_TYPE");
    this.setTableAlias("A");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_NATURE_OBJECT_LINK", "getIdNatureObjectLink", "setIdNatureObjectLink", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_REPORT_TYPE", "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_REPORT_ATTRIBUTES", "getIdReportAttributes", "setIdReportAttributes", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );
    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_NULL);

    JoinTable sites = new JoinTable("CHM62EDT_SITES B", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(sites);

//    JoinTable reportAttributes = new JoinTable("CHM62EDT_REPORT_ATTRIBUTES C", "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
//    reportAttributes.addJoinColumn(new StringJoinColumn("VALUE", "setReportValue"));
//    this.addJoinTable(reportAttributes);

    JoinTable species = new JoinTable("CHM62EDT_SPECIES", "ID_NATURE_OBJECT_LINK", "ID_NATURE_OBJECT");
    species.addJoinColumn(new StringJoinColumn("SCIENTIFIC_NAME", "setSpeciesScientificName"));
    species.addJoinColumn(new IntegerJoinColumn("ID_SPECIES", "setIdSpecies"));
    species.addJoinColumn(new IntegerJoinColumn("ID_SPECIES_LINK", "setIdSpeciesLink"));
    this.addJoinTable(species);

    JoinTable group = new JoinTable("CHM62EDT_GROUP_SPECIES", "ID_GROUP_SPECIES", "ID_GROUP_SPECIES");
    group.addJoinColumn(new StringJoinColumn("COMMON_NAME", "setSpeciesCommonName"));
    species.addJoinTable(group);

    JoinTable reportAtt = new JoinTable("CHM62EDT_REPORT_ATTRIBUTES E", "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
    this.addJoinTable(reportAtt);
  }

//  public List findCustom(String sql) {
//    return this.findCustom(sql);
//  }
}

