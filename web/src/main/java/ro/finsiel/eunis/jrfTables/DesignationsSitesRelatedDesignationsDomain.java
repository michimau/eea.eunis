package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


public class DesignationsSitesRelatedDesignationsDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new DesignationsSitesRelatedDesignationsPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_DESIGNATIONS");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_DESIGNATION",
                        "getIdDesignation", "setIdDesignation", DEFAULT_TO_NULL,
                        NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                        "setIdGeoscope", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION_EN", "getDescriptionEn",
                "setDescriptionEn", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION_FR", "getDescriptionFr",
                "setDescriptionFr", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("CDDA_SITES", "getCddaSites",
                "setCddaSites", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new BigDecimalColumnSpec("REFERENCE_AREA", "getReferenceArea",
                "setReferenceArea", null));
        this.addColumnSpec(
                new BigDecimalColumnSpec("TOTAL_AREA", "getTotalArea",
                "setTotalArea", null));
        this.addColumnSpec(
                new StringColumnSpec("ID_DESIGNATION", "getAbbreviation",
                "setAbbreviation", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NATIONAL_LAW", "getNationalLaw",
                "setNationalLaw", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NATIONAL_CATEGORY", "getNationalCategory",
                "setNationalCategory", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NATIONAL_LAW_REFERENCE",
                "getNationalLawReference", "setNationalLawReference",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("NATIONAL_LAW_AGENCY",
                "getNationalLawAgency", "setNationalLawAgency", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("DATA_SOURCE", "getDataSource",
                "setDataSource", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new BigDecimalColumnSpec("REFERENCE_NUMBER",
                "getReferenceNumber", "setReferenceNumber", null));
        this.addColumnSpec(
                new StringColumnSpec("REFERENCE_DATE", "getReferenceDate",
                "setReferenceDate", null));
        this.addColumnSpec(
                new StringColumnSpec("REMARK", "getRemark", "setRemark", null));
        this.addColumnSpec(
                new StringColumnSpec("REMARK_SOURCE", "getRemarkSource",
                "setRemarkSource", null));

        JoinTable J = new JoinTable("CHM62EDT_SITES_RELATED_DESIGNATIONS I",
                "ID_DESIGNATION", "ID_DESIGNATION");

        J.addJoinColumn(new StringJoinColumn("OVERLAP", "setOverlap"));
        J.addJoinColumn(new StringJoinColumn("OVERLAP_TYPE", "setOverlapType"));
        J.addJoinColumn(
                new StringJoinColumn("DESIGNATED_SITE", "setDesignatedSite"));
        J.addJoinColumn(new StringJoinColumn("SOURCE_DB", "setSourceDB"));
        this.addJoinTable(J);
    }
}
