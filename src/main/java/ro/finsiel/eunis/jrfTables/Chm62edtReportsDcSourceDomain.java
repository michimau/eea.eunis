package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.DateJoinColumn;

/**
 * JRF table for CHM62EDT_REPORTS inner join DC_INDEX outer join DC_SOURCE outer join DC_DATE outer join DC_TITLE
 * outer join DC_PUBLISHER.
 * @author finsiel
 **/
public class Chm62edtReportsDcSourceDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtReportsDcSourcePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    JoinTable Index = null;
    OuterJoinTable IndexSource = null;
    OuterJoinTable IndexDate = null;
    OuterJoinTable IndexTitle = null;
    OuterJoinTable IndexPublisher = null;

    this.setTableName("CHM62EDT_REPORTS");
    this.setReadOnly(true);


    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_GEOSCOPE_LINK", "getIdGeoscopeLink", "setIdGeoscopeLink", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_REPORT_TYPE", "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_REPORT_ATTRIBUTES", "getIdReportAttributes", "setIdReportAttributes", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );

    Index = new JoinTable("DC_INDEX", "ID_DC", "ID_DC");
    this.addJoinTable(Index);

    IndexSource = new OuterJoinTable("DC_SOURCE", "ID_DC", "ID_DC");
    IndexSource.addJoinColumn(new StringJoinColumn("SOURCE", "source", "setSource"));
    IndexSource.addJoinColumn(new StringJoinColumn("EDITOR", "editor", "setEditor"));
    Index.addJoinTable(IndexSource);

    IndexDate = new OuterJoinTable("DC_DATE", "ID_DC", "ID_DC");
    IndexDate.addJoinColumn(new DateJoinColumn("CREATED", "created", "setCreated"));
    Index.addJoinTable(IndexDate);

    IndexTitle = new OuterJoinTable("DC_TITLE", "ID_DC", "ID_DC");
    IndexTitle.addJoinColumn(new StringJoinColumn("TITLE", "title", "setTitle"));
    Index.addJoinTable(IndexTitle);

    IndexPublisher = new OuterJoinTable("DC_PUBLISHER", "ID_DC", "ID_DC");
    IndexPublisher.addJoinColumn(new StringJoinColumn("PUBLISHER", "publisher", "setPublisher"));
    Index.addJoinTable(IndexPublisher);
  }

  /**
   * Wrapper for SELECT COUNT(*) FROM DC_INDEX AS a LEFT JOIN DC_SOURCE AS b ON a.ID_DC=b.ID_DC WHERE...
   * @param sqlWhere WHERE condition.
   * @return Long.
   */
  public Long countWhere(String sqlWhere) {
    return this.findLong("SELECT count(*) FROM DC_INDEX AS a LEFT JOIN DC_SOURCE AS b ON a.ID_DC=b.ID_DC " + sqlWhere);
  }
}