package ro.finsiel.eunis.jrfTables.species.habitats;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:14 $
 **/
public class HabitatNatureObjectGeoscopeDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new HabitatNatureObjectGeoscopePersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_HABITAT");
        this.setReadOnly(true);
        this.setTableAlias("H");

        this.addColumnSpec(
                new StringColumnSpec("ID_HABITAT", "getIdHabitat",
                "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName",
                "setScientificName", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CODE_ANNEX1", "getCodeAnnex1",
                "setCodeAnnex1", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new ShortColumnSpec("PRIORITY", "getPriority", "setPriority",
                null, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode",
                "setEunisHabitatCode", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CLASS_REF", "getClassRef", "setClassRef",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CODE_PART_2", "getCodePart2",
                "setCodePart2", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("LEVEL", "getHabLevel", "setHabLevel",
                DEFAULT_TO_NULL));

        JoinTable joinTable = new JoinTable("CHM62EDT_NATURE_OBJECT_GEOSCOPE A",
                "ID_NATURE_OBJECT", "ID_NATURE_OBJECT_LINK");

        joinTable.addJoinColumn(
                new IntegerJoinColumn("ID_NATURE_OBJECT", "idNO", "setidNO"));
        joinTable.addJoinColumn(
                new IntegerJoinColumn("ID_DC", "idDC", "setidDC"));
        this.addJoinTable(joinTable);

        OuterJoinTable Rep = new OuterJoinTable(
                "CHM62EDT_NATURE_OBJECT_REPORT_TYPE B", "ID_NATURE_OBJECT_LINK",
                "ID_NATURE_OBJECT_LINK");

        Rep.addJoinColumn(
                new IntegerJoinColumn("ID_NATURE_OBJECT_LINK", "idNOLink",
                "setidNOLink"));
        joinTable.addJoinTable(Rep);

        JoinTable joinSpecies = new JoinTable("CHM62EDT_SPECIES AAA",
                "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");

        joinTable.addJoinTable(joinSpecies);

    }
}

