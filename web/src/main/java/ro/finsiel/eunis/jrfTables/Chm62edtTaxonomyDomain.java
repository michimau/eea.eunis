package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * JRF table for CHM62EDT_TAXONOMY inner join CHM62EDT_TAXONOMY.
 * @author finsiel
 **/
public class Chm62edtTaxonomyDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtTaxonomyPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_TAXONOMY");
        this.setReadOnly(true);

        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY", "getIdTaxonomy",
                "setIdTaxonomy", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("LEVEL", "getLevel", "setLevel",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("GROUP", "getGroup", "setGroup",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY_LINK", "getIdTaxonomyLink",
                "setIdTaxonomyLink", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY_PARENT", "getIdTaxonomyParent",
                "setIdTaxonomyParent", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("TAXONOMY_TREE", "getTaxonomyTree",
                "setTaxonomyTree", DEFAULT_TO_NULL));

        JoinTable joinTable = new JoinTable("CHM62EDT_TAXONOMY",
                "ID_TAXONOMY_LINK", "ID_TAXONOMY");

        joinTable.setTableAlias("a");
        joinTable.addJoinColumn(
                new StringJoinColumn("NAME", "parentLevelName",
                "setParentLevelName"));
        joinTable.addJoinColumn(
                new IntegerJoinColumn("ID_TAXONOMY_LINK", "classCode",
                "setClassID"));
        this.addJoinTable(joinTable);
    }
}
