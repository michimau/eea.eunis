package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.DoubleJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:13 $
 **/
public class ReportsDistributionStatusDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new ReportsDistributionStatusPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_NATURE_OBJECT_REPORT_TYPE");
        this.setReadOnly(true);
        this.setTableAlias("A");

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_NATURE_OBJECT",
                        "getIdNatureObject", "setIdNatureObject",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_NATURE_OBJECT_LINK",
                        "getIdNatureObjectLink", "setIdNatureObjectLink",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_TYPE",
                        "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO,
                        NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                        "getIdReportAttributes", "setIdReportAttributes",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));

        JoinTable joinTableGrid = new JoinTable("CHM62EDT_REPORT_TYPE B",
                "ID_REPORT_TYPE", "ID_REPORT_TYPE");

        joinTableGrid.addJoinColumn(
                new StringJoinColumn("LOOKUP_TYPE", "setLookupTypeGrid"));
        joinTableGrid.addJoinColumn(
                new StringJoinColumn("ID_LOOKUP", "setIdLookupGrid"));
        this.addJoinTable(joinTableGrid);

        JoinTable Grid = null;

        Grid = new JoinTable("CHM62EDT_GRID C", "ID_LOOKUP", "NAME");
        Grid.addJoinColumn(new StringJoinColumn("NAME", "setName"));
        Grid.addJoinColumn(new DoubleJoinColumn("LATITUDE", "setLatitude"));
        Grid.addJoinColumn(new DoubleJoinColumn("LONGITUDE", "setLongitude"));
        // Grid.addJoinColumn(new IntegerJoinColumn("ID_DC", "setIdDc"));
        joinTableGrid.addJoinTable(Grid);

        JoinTable joinTableDist = new JoinTable("CHM62EDT_REPORT_TYPE D",
                "ID_REPORT_TYPE", "ID_REPORT_TYPE");

        joinTableDist.addJoinColumn(
                new StringJoinColumn("LOOKUP_TYPE", "setLookupTypeDist"));
        joinTableDist.addJoinColumn(
                new StringJoinColumn("ID_LOOKUP", "setIdLookupDist"));
        this.addJoinTable(joinTableDist);

        JoinTable Dist = null;

        Dist = new JoinTable("CHM62EDT_DISTRIBUTION_STATUS E", "ID_LOOKUP",
                "ID_DISTRIBUTION_STATUS");
        Dist.addJoinColumn(new StringJoinColumn("NAME", "setDistributionStatus"));
        joinTableDist.addJoinTable(Dist);
    }
}
