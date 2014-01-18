package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_SITES.
 * @author finsiel
 **/
public class Chm62edtSitesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSitesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    @SuppressWarnings("deprecation")
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SITES");
        this.setReadOnly(true);
        this.addColumnSpec(
                new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite",
                DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("ID_DESIGNATION", "getIdDesignation",
                "setIdDesignation", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                "setIdGeoscope", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                "setIdNatureObject", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("RESPONDENT", "getRespondent",
                "setRespondent", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("MANAGER", "getManager", "setManager",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("COMPLEX_NAME", "getComplexName",
                "setComplexName", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DISTRICT_NAME", "getDistrictName",
                "setDistrictName", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("OWNERSHIP", "getOwnership", "setOwnership",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("HISTORY", "getHistory", "setHistory",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CHARACTER", "getCharacter", "setCharacter",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("MANAGEMENT_PLAN", "getManagementPlan",
                "setManagementPlan", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("IUCNAT", "getIucnat", "setIucnat",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESIGNATION_DATE", "getDesignationDate",
                "setDesignationDate", null));
        this.addColumnSpec(
                new StringColumnSpec("COMPILATION_DATE", "getCompilationDate",
                "setCompilationDate", null));
        this.addColumnSpec(
                new StringColumnSpec("PROPOSED_DATE", "getProposedDate",
                "setProposedDate", null));
        this.addColumnSpec(
                new StringColumnSpec("CONFIRMED_DATE", "getConfirmedDate",
                "setConfirmedDate", null));
        this.addColumnSpec(
                new StringColumnSpec("UPDATE_DATE", "getUpdateDate",
                "setUpdateDate", null));
        this.addColumnSpec(
                new StringColumnSpec("SPA_DATE", "getSpaDate", "setSpaDate",
                null));
        this.addColumnSpec(
                new StringColumnSpec("SAC_DATE", "getSacDate", "setSacDate",
                null));
        this.addColumnSpec(
                new StringColumnSpec("NATIONAL_CODE", "getNationalCode",
                "setNationalCode", null));
        this.addColumnSpec(
                new StringColumnSpec("NATURA_2000", "getNatura2000",
                "setNatura2000", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NUTS", "getNuts", "setNuts",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("AREA", "getArea", "setArea", null));
        this.addColumnSpec(
                new StringColumnSpec("LENGTH", "getLength", "setLength",
                DEFAULT_TO_NULL));

        this.addColumnSpec(
                new StringColumnSpec("ALT_MEAN", "getAltMean", "setAltMean",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("ALT_MAX", "getAltMax", "setAltMax",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("ALT_MIN", "getAltMin", "setAltMin",
                DEFAULT_TO_NULL));

        this.addColumnSpec(
                new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB",
                DEFAULT_TO_NULL));
    }
}
