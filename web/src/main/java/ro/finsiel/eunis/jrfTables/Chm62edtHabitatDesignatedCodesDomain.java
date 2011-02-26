package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

import java.util.List;


/**
 * JRF table for CHM62EDT_HABITAT_DESIGNATED_CODES.
 * @author finsiel
 **/
public class Chm62edtHabitatDesignatedCodesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatDesignatedCodesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_HABITAT_DESIGNATED_CODES");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_DESIGNATED_CODE",
                "getIdDesignatedCode", "setIdDesignatedCode", DEFAULT_TO_ZERO,
                NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("CODE", "getCode", "setCode",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("LEGAL_INSTRUMENT_ABBREV",
                "getLegalInstrumentAbbrev", "setLegalInstrumentAbrev",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("LEGAL_INSTRUMENT", "getLegalInstrument",
                "setLegalInstrument", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("GEOLEVEL", "getGeolevel", "setGeolevel",
                DEFAULT_TO_NULL));
    }
}
