package ro.finsiel.eunis.jrfTables.species.taxonomy;


/**
 * Date: Apr 15, 2003
 * Time: 10:05:22 AM
 */

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:19 $
 **/
public class Chm62edtTaxcodeAllJoinsDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new Chm62edtTaxcodeAllJoinsPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_TAXONOMY");
        this.setReadOnly(true);
        this.setTableAlias("A");

        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY", "getIdTaxcode",
                "setIdTaxcode", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("LEVEL", "getTaxonomicLevel",
                "setTaxonomicLevel", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getTaxonomicName",
                "setTaxonomicName", DEFAULT_TO_EMPTY_STRING, REQUIRED));

        this.addColumnSpec(
                new StringColumnSpec("GROUP", "getTaxonomicGroup",
                "setTaxonomicGroup", DEFAULT_TO_NULL));

        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY_LINK", "getIdTaxcodeLink",
                "setIdTaxcodeLink", DEFAULT_TO_NULL));
        // this.addColumnSpec(
        // new StringColumnSpec(
        // "NOTES",
        // "getNotes",
        // "setNotes",
        // DEFAULT_TO_NULL
        // ));

        // Joined tables
        OuterJoinTable taxcode1 = null;
        OuterJoinTable taxcode2 = null;
        OuterJoinTable taxcode3 = null;
        OuterJoinTable taxcode4 = null;
        OuterJoinTable taxcode5 = null;

        taxcode1 = new OuterJoinTable("CHM62EDT_TAXONOMY B", "ID_TAXONOMY_LINK",
                "ID_TAXONOMY");
        taxcode1.addJoinColumn(
                new StringJoinColumn("ID_TAXONOMY", "id1", "setId1"));
        taxcode1.addJoinColumn(
                new StringJoinColumn("ID_DC", "idDc1", "setIdDc1"));
        taxcode1.addJoinColumn(new StringJoinColumn("NAME", "name1", "setName1"));
        taxcode1.addJoinColumn(
                new StringJoinColumn("LEVEL", "level1", "setLevel1"));
        this.addJoinTable(taxcode1);

        taxcode2 = new OuterJoinTable("CHM62EDT_TAXONOMY C", "ID_TAXONOMY_LINK",
                "ID_TAXONOMY");
        taxcode2.addJoinColumn(
                new StringJoinColumn("ID_TAXONOMY", "id2", "setId2"));
        taxcode2.addJoinColumn(
                new StringJoinColumn("ID_DC", "idDc2", "setIdDc2"));
        taxcode2.addJoinColumn(new StringJoinColumn("NAME", "name2", "setName2"));
        taxcode2.addJoinColumn(
                new StringJoinColumn("LEVEL", "level2", "setLevel2"));
        taxcode1.addJoinTable(taxcode2);

        taxcode3 = new OuterJoinTable("CHM62EDT_TAXONOMY D", "ID_TAXONOMY_LINK",
                "ID_TAXONOMY");
        taxcode3.addJoinColumn(
                new StringJoinColumn("ID_TAXONOMY", "id3", "setId3"));
        taxcode3.addJoinColumn(
                new StringJoinColumn("ID_DC", "idDc3", "setIdDc3"));
        taxcode3.addJoinColumn(new StringJoinColumn("NAME", "name3", "setName3"));
        taxcode3.addJoinColumn(
                new StringJoinColumn("LEVEL", "level3", "setLevel3"));
        taxcode2.addJoinTable(taxcode3);

        taxcode4 = new OuterJoinTable("CHM62EDT_TAXONOMY E", "ID_TAXONOMY_LINK",
                "ID_TAXONOMY");
        taxcode4.addJoinColumn(
                new StringJoinColumn("ID_TAXONOMY", "id4", "setId4"));
        taxcode4.addJoinColumn(
                new StringJoinColumn("ID_DC", "idDc4", "setIdDc4"));
        taxcode4.addJoinColumn(new StringJoinColumn("NAME", "name4", "setName4"));
        taxcode4.addJoinColumn(
                new StringJoinColumn("LEVEL", "level4", "setLevel4"));
        taxcode3.addJoinTable(taxcode4);

        taxcode5 = new OuterJoinTable("CHM62EDT_TAXONOMY G", "ID_TAXONOMY_LINK",
                "ID_TAXONOMY");
        taxcode5.addJoinColumn(
                new StringJoinColumn("ID_TAXONOMY", "id5", "setId5"));
        taxcode5.addJoinColumn(
                new StringJoinColumn("ID_DC", "idDc5", "setIdDc5"));
        taxcode5.addJoinColumn(new StringJoinColumn("NAME", "name5", "setName5"));
        taxcode5.addJoinColumn(
                new StringJoinColumn("LEVEL", "level5", "setLevel5"));
        taxcode4.addJoinTable(taxcode5);

    }
}
