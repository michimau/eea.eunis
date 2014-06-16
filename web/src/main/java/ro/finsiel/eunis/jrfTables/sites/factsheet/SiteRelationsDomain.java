/**
 * User: root
 * Date: May 22, 2003
 * Time: 4:29:12 PM
 */
package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.BigDecimalColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * Site relations with other sites
 */
public class SiteRelationsDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new SiteRelationsPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("chm62edt_sites_sites");
    this.setTableAlias("A");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_ZERO, REQUIRED),
                    new StringColumnSpec("ID_SITE_LINK", "getIdSiteLink", "setIdSiteLink", DEFAULT_TO_EMPTY_STRING, REQUIRED),
                    new IntegerColumnSpec("SEQUENCE", "getSequence", "setSequence", DEFAULT_TO_ZERO, REQUIRED)
            )
    );
    this.addColumnSpec(new BigDecimalColumnSpec("OVERLAP", "getOverlap", "setOverlap", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("RELATION_TYPE", "getRelationType", "setRelationType", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("WITHIN_PROJECT", "getWithinProject", "setWithinProject", DEFAULT_TO_ZERO));
//    this.addColumnSpec(new StringColumnSpec("SOURCE_TABLE", "getSourceTable", "setSourceTable", DEFAULT_TO_NULL));

    JoinTable sites = new JoinTable("chm62edt_sites B", "ID_SITE_LINK", "ID_SITE");
    sites.addJoinColumn(new StringJoinColumn("NAME", "setSiteName"));
    this.addJoinTable(sites);

    OuterJoinTable siteTypes = new OuterJoinTable("chm62edt_natura2000_site_type C", "RELATION_TYPE", "ID_SITE_TYPE");
    siteTypes.addJoinColumn(new StringJoinColumn("NAME", "setRelationName"));
    this.addJoinTable(siteTypes);
  }
}
