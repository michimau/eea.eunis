/**
 * User: root
 * Date: May 22, 2003
 * Time: 4:07:32 PM
 */
package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

public class SiteHabitatsDomain extends AbstractDomain {


  /****/
  public PersistentObject newPersistentObject() {
    return new SiteHabitatsPersist();
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
    this.addColumnSpec(new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_NULL));

    JoinTable sites = new JoinTable("CHM62EDT_SITES", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(sites);

    JoinTable habitat = new JoinTable("CHM62EDT_HABITAT", "ID_NATURE_OBJECT_LINK", "ID_NATURE_OBJECT");
    habitat.addJoinColumn(new StringJoinColumn("DESCRIPTION", "setHabitatDescription"));
    habitat.addJoinColumn(new StringJoinColumn("ID_HABITAT", "setIdHabitat"));
    habitat.addJoinColumn(new StringJoinColumn("CODE_2000", "setCode2000"));
    this.addJoinTable(habitat);

    JoinTable att = new JoinTable("CHM62EDT_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
    this.addJoinTable(att);

  }
}
