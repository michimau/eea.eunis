package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;


/**
 * JRF table for chm62edt_species inner join chm62edt_nature_object inner join dc_index.
 * @author finsiel
 **/
public class SpeciesNatureObjectDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new SpeciesNatureObjectPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_species");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES", "getIdSpecies",
                "setIdSpecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName",
                "setScientificName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new ShortColumnSpec("VALID_NAME", "getValidName", "setValidName",
                null, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink",
                "setIdSpeciesLink", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("TYPE_RELATED_SPECIES",
                "getTypeRelatedSpecies", "setTypeRelatedSpecies",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new ShortColumnSpec("TEMPORARY_SELECT", "getTemporarySelect",
                "setTemporarySelect", null));
        this.addColumnSpec(
                new StringColumnSpec("SPECIES_MAP", "getSpeciesMap",
                "setSpeciesMap", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies",
                "setIdGroupspecies", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("ID_TAXONOMY", "getIdTaxcode",
                "setIdTaxcode", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("AUTHOR", "getAuthor", "setAuthor",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("GENUS", "getGenus", "setGenus",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CODE_2000", "getNatura2000Code", "setNatura2000Code",
                DEFAULT_TO_NULL));

        JoinTable natureObject = new JoinTable("chm62edt_nature_object",
                "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");

        natureObject.addJoinColumn(
                new IntegerJoinColumn("ID_DC", "idDublinCore", "setIdDublinCore"));
        this.addJoinTable(natureObject);

        // JoinTable dcIndex = new JoinTable("dc_index", "ID_DC", "ID_DC");
        // dcIndex.addJoinColumn(new IntegerJoinColumn("REFERENCE", "getReference", "setReference"));
        // natureObject.addJoinTable(dcIndex);
        OuterJoinTable dcIndex = new OuterJoinTable("dc_index", "ID_DC", "ID_DC");

        dcIndex.addJoinColumn(
                new IntegerJoinColumn("REFERENCE", "getReference",
                "setReference"));
        natureObject.addJoinTable(dcIndex);
    }
}
