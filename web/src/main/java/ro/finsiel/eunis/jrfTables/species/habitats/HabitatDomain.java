/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables.species.habitats;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class HabitatDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new HabitatPersist();
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
    }

    public Long countWhere(String sqlWhere) {
        return this.findLong(
                "SELECT count(*) FROM " + this.getTableAlias() + " WHERE "
                + sqlWhere);
    }

    public Integer maxlevel(String sqlWhere) {
        String isGoodHabitat = " IF(TRIM(H.CODE_2000) <> '',RIGHT(H.CODE_2000,2),1) <> IF(TRIM(H.CODE_2000) <> '','00',2) AND IF(TRIM(H.CODE_2000) <> '',LENGTH(H.CODE_2000),1) = IF(TRIM(H.CODE_2000) <> '',4,1) ";

        return this.findInteger(
                "SELECT max(hab_level) FROM CHM62EDT_HABITAT WHERE "
                        + isGoodHabitat + " AND " + sqlWhere);
    }
}
