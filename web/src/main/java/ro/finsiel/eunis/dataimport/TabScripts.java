package ro.finsiel.eunis.dataimport;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet;
import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.jrfTables.Chm62edtHabitatSyntaxaDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesDomain;
import ro.finsiel.eunis.jrfTables.DesignationsSitesRelatedDesignationsDomain;
import ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteHabitatsDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteRelationsDomain;
import ro.finsiel.eunis.jrfTables.species.habitats.HabitatsNatureObjectReportTypeSpeciesDomain;
import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;

public class TabScripts {

    private String SQL_DRV = "";
    private String SQL_URL = "";
    private String SQL_USR = "";
    private String SQL_PWD = "";

    // Is executed from command line
    private boolean cmd = false;

    public TabScripts() {
    }

    public void Init(String SQL_DRIVER_NAME, String SQL_DRIVER_URL, String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD,
            boolean cmd) {
        SQL_DRV = SQL_DRIVER_NAME;
        SQL_URL = SQL_DRIVER_URL;
        SQL_USR = SQL_DRIVER_USERNAME;
        SQL_PWD = SQL_DRIVER_PASSWORD;
        this.cmd = cmd;
    }

    /**
     * Generate tab information for species
     */
    public void setTabSpecies() {

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            int noid, speciesid = 0;
            String sql, fields, s, synonymsIDs = "";

            String mainSql = "SELECT ID_NATURE_OBJECT, ID_SPECIES, ID_SPECIES_LINK FROM CHM62EDT_SPECIES WHERE TYPE_RELATED_SPECIES IN ('Species','Subspecies') LIMIT 5000";

            ps = con.prepareStatement(mainSql);
            rs = ps.executeQuery();
            while (rs.next()) {
                // This routine generates so many objects that the garbage
                // collector can't keep up
                // We therefore run it manually for every 10.000 rows. There is
                // no need for speed here.
                if (rs.getRow() % 10000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Species tab generation at row: " + rs.getRow(), cmd, sqlc);
                }
                noid = rs.getInt("ID_NATURE_OBJECT");
                speciesid = rs.getInt("ID_SPECIES");

                fields = "";

                sql = "INSERT IGNORE INTO chm62edt_tab_page_species (ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES(" +noid+ ",'Y')";

                ps2 = con.prepareStatement(sql);
                ps2.executeUpdate();

                synonymsIDs = SpeciesFactsheet.getSpeciesSynonymsCommaSeparated(new Integer(noid), new Integer(speciesid));

                s = "CHM62EDT_REPORTS AS A, CHM62EDT_REPORT_TYPE AS B, DC_INDEX AS C "
                    + "WHERE A.ID_REPORT_TYPE=B.ID_REPORT_TYPE AND A.ID_DC = C.ID_DC AND (B.LOOKUP_TYPE IN ('SPECIES_STATUS')) "
                    + "AND  (A.ID_NATURE_OBJECT IN (" + synonymsIDs + ")) AND "
                    + "EXISTS (SELECT * FROM CHM62EDT_COUNTRY AS CO WHERE CO.AREA_NAME_EN not like 'ospar%' and CO.ID_GEOSCOPE=A.ID_GEOSCOPE LIMIT 1) AND "
                    + "EXISTS(SELECT * FROM CHM62EDT_BIOGEOREGION AS BIO WHERE BIO.ID_GEOSCOPE=A.ID_GEOSCOPE_LINK LIMIT 1) AND "
                    + "EXISTS(SELECT * FROM CHM62EDT_SPECIES_STATUS AS SS WHERE SS.ID_SPECIES_STATUS=B.ID_LOOKUP LIMIT 1)";
                boolean geo = exists(s, con);

                if (geo) {
                    fields += "GEOGRAPHICAL_DISTRIBUTION='Y',";
                } else {
                    fields += "GEOGRAPHICAL_DISTRIBUTION='N',";
                }

                /*distribution = new ReportsDistributionStatusDomain().findWhere("ID_NATURE_OBJECT = " + noid
                        + " AND (D.LOOKUP_TYPE ='DISTRIBUTION_STATUS' OR D.LOOKUP_TYPE ='GRID') GROUP BY C.NAME,C.LATITUDE,C.LONGITUDE LIMIT 1");

                if (distribution != null && distribution.size() > 0) {
                    fields += "GRID_DISTRIBUTION='Y',";
                } else {
                    fields += "GRID_DISTRIBUTION='N',";
                }*/

                s = "CHM62EDT_HABITAT AS H "
                    + "INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS A ON H.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT_LINK "
                    + "INNER JOIN CHM62EDT_SPECIES AS C ON A.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                    + "WHERE H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000' AND C.ID_NATURE_OBJECT IN ("+synonymsIDs+") "
                    + "GROUP BY H.ID_NATURE_OBJECT";
                boolean habitats = exists(s, con);

                if (habitats) {
                    fields += "HABITATS='Y',";
                } else {
                    fields += "HABITATS='N',";
                }

                s = "CHM62EDT_REPORTS AS A "
                    + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                    + "INNER JOIN DC_INDEX AS C ON A.ID_DC = C.ID_DC "
                    + "WHERE B.LOOKUP_TYPE='LEGAL_STATUS' AND A.ID_NATURE_OBJECT IN ("+synonymsIDs+")";
                boolean legal = exists(s, con);

                if (legal) {
                    fields += "LEGAL_INSTRUMENTS='Y',";
                } else {
                    fields += "LEGAL_INSTRUMENTS='N',";
                }

                s = "CHM62EDT_REPORTS AS A "
                    + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                    + "INNER JOIN DC_INDEX AS C ON A.ID_DC = C.ID_DC "
                    + "WHERE B.LOOKUP_TYPE='POPULATION_UNIT' AND A.ID_NATURE_OBJECT IN ("+synonymsIDs+")";
                boolean pop = exists(s, con);

                if (pop) {
                    fields += "POPULATION='Y',";
                } else {
                    fields += "POPULATION='N',";
                }

                s = "CHM62EDT_SPECIES AS A "
                    + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                    + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                    + " WHERE A.ID_NATURE_OBJECT IN ( " + synonymsIDs + " )";
                boolean sites = exists(s, con);

                if (sites) {
                    fields += "SITES='Y',";
                } else {
                    fields += "SITES='N',";
                }

                s = "CHM62EDT_REPORTS AS A "
                    + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                    + "WHERE B.LOOKUP_TYPE='CONSERVATION_STATUS' AND A.ID_NATURE_OBJECT IN (" + synonymsIDs + ")";
                boolean threatStatus = exists(s, con);

                if (threatStatus) {
                    fields += "THREAT_STATUS='Y',";
                } else {
                    fields += "THREAT_STATUS='N',";
                }

                s = "CHM62EDT_REPORTS AS R, CHM62EDT_REPORT_TYPE AS RT WHERE R.ID_REPORT_TYPE=RT.ID_REPORT_TYPE "
                    + "AND RT.LOOKUP_TYPE='TREND' AND R.ID_NATURE_OBJECT IN (" + synonymsIDs + ")";
                boolean trends = exists(s, con);

                if (trends) {
                    fields += "TRENDS='Y',";
                } else {
                    fields += "TRENDS='N',";
                }

                s = "CHM62EDT_REPORTS AS A "
                    + "INNER JOIN CHM62EDT_REPORT_ATTRIBUTES AS B ON A.ID_REPORT_ATTRIBUTES = B.ID_REPORT_ATTRIBUTES "
                    + "INNER JOIN CHM62EDT_REPORT_TYPE AS C ON A.ID_REPORT_TYPE = C.ID_REPORT_TYPE "
                    + "INNER JOIN CHM62EDT_LANGUAGE AS D ON C.ID_LOOKUP = D.ID_LANGUAGE "
                    + "WHERE C.LOOKUP_TYPE='language' AND A.ID_NATURE_OBJECT IN (" + synonymsIDs + ") "
                    + "AND B.NAME='vernacular_name' GROUP BY B.VALUE, D.NAME_EN";
                boolean verNameList = exists(s, con);

                if (verNameList) {
                    fields += "VERNACULAR_NAMES='Y',";
                } else {
                    fields += "VERNACULAR_NAMES='N',";
                }

                if (fields.endsWith(",")) {
                    fields = fields.substring(0, fields.length() - 1);
                }
                if (fields != null && fields.length() > 0) {
                    ps2 = con.prepareStatement("UPDATE chm62edt_tab_page_species SET "+ fields +" WHERE ID_NATURE_OBJECT=" + noid);
                    ps2.executeUpdate();
                }

            }
            //updateReferences();

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating species tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
    }

    /**
     * Generate tab information for habitats
     */
    public void setTabHabitats() {

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            String mainSql = "SELECT ID_NATURE_OBJECT, ID_HABITAT FROM CHM62EDT_HABITAT";

            ps = con.prepareStatement(mainSql);
            rs = ps.executeQuery();
            while (rs.next()) {

                if (rs.getRow() % 10000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Habitats tab generation at row: " + rs.getRow(), cmd, sqlc);
                }

                int noid = rs.getInt("ID_NATURE_OBJECT");
                int habid = rs.getInt("ID_HABITAT");

                if (habid != -1) {
                    String sql = "INSERT IGNORE INTO chm62edt_tab_page_habitats (ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES("
                        + noid + ",'Y')";

                    ps2 = con.prepareStatement(sql);
                    ps2.executeUpdate();

                    String fields = "";

                    HabitatsFactsheet factsheet = new HabitatsFactsheet(new Integer(habid).toString());

                    fields += "GEOGRAPHICAL_DISTRIBUTION='Y',";

                    List species = new HabitatsNatureObjectReportTypeSpeciesDomain()
                    .findWhere("H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000' AND H.ID_NATURE_OBJECT = " + noid
                            + " GROUP BY C.ID_NATURE_OBJECT ORDER BY C.SCIENTIFIC_NAME LIMIT 1");

                    if (species.size() > 0) {
                        fields += "SPECIES='Y',";
                    } else {
                        fields += "SPECIES='N',";
                    }

                    List hablist = new Chm62edtHabitatSyntaxaDomain().findWhere("A.ID_HABITAT='" + habid + "' LIMIT 1");

                    if (hablist.size() > 0) {
                        fields += "HABITATS='Y',";
                    } else {
                        fields += "HABITATS='N',";
                    }

                    List legallist = new HabitatLegalDomain().findWhere("C.LEGAL=1 AND A.ID_HABITAT='" + habid + "' LIMIT 1");

                    if (legallist.size() > 0) {
                        fields += "LEGAL_INSTRUMENTS='Y',";
                    } else {
                        fields += "LEGAL_INSTRUMENTS='N',";
                    }

                    String types = "('altitude','chemistry','climate','cover','humidity','impact','life_form','light_intensity',"
                        + "'substrate','temperature','usage','water','depth','geomorph','species_richness','exposure','spatial',"
                        + "'temporal','salinity')";
                    boolean other = exists(
                            "CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS A, CHM62EDT_REPORT_TYPE AS B WHERE A.ID_REPORT_TYPE=B.ID_REPORT_TYPE AND ID_NATURE_OBJECT='"
                            + noid + "' AND B.LOOKUP_TYPE IN " + types, con);

                    if (other) {
                        fields += "OTHER='Y',";
                    } else {
                        fields += "OTHER='N',";
                    }

                    String isGoodHabitat = " IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ";
                    String sql_sites = "CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " + " WHERE   "
                        + isGoodHabitat + " AND A.ID_NATURE_OBJECT =" + noid + " AND C.SOURCE_DB <> 'EMERALD'";
                    boolean sites = exists(sql_sites, con);

                    String sql_subsites = "CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                        + " WHERE A.ID_NATURE_OBJECT ="
                        + noid
                        + (factsheet.isAnnexI() ? " and right(A.code_2000,2) <> '00' and length(A.code_2000) = 4 AND if(right(A.code_2000,1) = '0',left(A.code_2000,3),A.code_2000) like '"
                                + factsheet.getCode2000() + "%' and A.code_2000 <> '" + factsheet.getCode2000() + "'"
                                : " AND A.EUNIS_HABITAT_CODE like '" + factsheet.getEunisHabitatCode()
                                + "%' and A.EUNIS_HABITAT_CODE<> '" + factsheet.getEunisHabitatCode() + "'")
                                + " AND C.SOURCE_DB <> 'EMERALD'";
                    boolean subsites = exists(sql_subsites, con);

                    if (sites || subsites) {
                        fields += "SITES='Y',";
                    } else {
                        fields += "SITES='N',";
                    }

                    if (fields.endsWith(",")) {
                        fields = fields.substring(0, fields.length() - 1);
                    }
                    if (fields != null && fields.length() > 0) {
                        ps2 = con.prepareStatement("UPDATE chm62edt_tab_page_habitats SET " + fields + " WHERE ID_NATURE_OBJECT="
                                + noid);
                        ps2.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating habitats tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
    }

    /**
     * Generate tab information for sites
     */
    public void setTabSites() {

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            String mainSql = "SELECT ID_NATURE_OBJECT, ID_SITE FROM CHM62EDT_SITES";

            ps = con.prepareStatement(mainSql);
            rs = ps.executeQuery();
            while (rs.next()) {

                if (rs.getRow() % 10000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Sites tab generation at row: " + rs.getRow(), cmd, sqlc);
                }

                int noid = rs.getInt("ID_NATURE_OBJECT");
                String siteid = rs.getString("ID_SITE");

                String sql = "INSERT IGNORE INTO chm62edt_tab_page_sites (ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES(" + noid
                + ",'Y')";

                ps2 = con.prepareStatement(sql);
                ps2.executeUpdate();

                String fields = "";

                SiteFactsheet factsheet = new SiteFactsheet(siteid);
                int type = factsheet.getType();

                // DESIGNATION
                if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD
                        || type == SiteFactsheet.TYPE_CORINE) {
                    List sitesDesigc = new ArrayList();

                    if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD) {
                        sitesDesigc = new DesignationsSitesRelatedDesignationsDomain()
                        .findWhere("ID_SITE='"
                                + siteid
                                + "' AND SOURCE_TABLE = 'desigc' group by id_designation, description_en,NATIONAL_CATEGORY,overlap LIMIT 1");
                    } else {
                        // CORINE
                        sitesDesigc = new DesignationsSitesRelatedDesignationsDomain().findWhere("ID_SITE='" + siteid
                                + "' group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type LIMIT 1");
                    }
                    List sitesDesigr = new Vector();

                    if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD) {
                        sitesDesigr = new DesignationsSitesRelatedDesignationsDomain()
                        .findWhere("ID_SITE='"
                                + siteid
                                + "' AND SOURCE_TABLE = 'desigr' group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type LIMIT 1");
                    }
                    if ((sitesDesigc != null && sitesDesigc.size() > 0) || (sitesDesigr != null && sitesDesigr.size() > 0)) {
                        fields += "DESIGNATION='Y',";
                    } else {
                        fields += "DESIGNATION='N',";
                    }
                }

                // FLORA & FAUNA
                fields += "FAUNA_FLORA='Y',";

                // HABITATS
                List habit1Eunis = new ArrayList();
                List habit1NotEunis = new ArrayList();
                List habits2Eunis = new ArrayList();
                List habits2NotEunis = new ArrayList();

                List habitats = new ArrayList();
                List sitesSpecificHabitats = new ArrayList();

                if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD) {
                    habit1Eunis = new SiteHabitatsDomain()
                    .findWhere("A.ID_NATURE_OBJECT='"
                            + noid
                            + "' and CHM62EDT_REPORT_ATTRIBUTES.NAME='SOURCE_TABLE' and CHM62EDT_REPORT_ATTRIBUTES.VALUE='habit1' LIMIT 1");
                    habit1NotEunis = new Chm62edtSitesAttributesDomain()
                    .findWhere("ID_SITE='"
                            + siteid
                            + "' AND SOURCE_TABLE = 'HABIT1' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2) LIMIT 1");
                    habits2Eunis = new SiteHabitatsDomain()
                    .findWhere("A.ID_NATURE_OBJECT='"
                            + noid
                            + "' and CHM62EDT_REPORT_ATTRIBUTES.NAME='SOURCE_TABLE' and CHM62EDT_REPORT_ATTRIBUTES.VALUE='habit2' LIMIT 1");
                    habits2NotEunis = new Chm62edtSitesAttributesDomain()
                    .findWhere("ID_SITE='"
                            + siteid
                            + "' AND SOURCE_TABLE = 'HABIT2' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2) LIMIT 1");
                } else {
                    String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";

                    habitats = new SiteHabitatsDomain().findWhere(isGoodHabitat + " AND A.ID_NATURE_OBJECT='" + noid
                            + "' GROUP BY CHM62EDT_HABITAT.ID_NATURE_OBJECT, CHM62EDT_SITES.ID_NATURE_OBJECT LIMIT 1");
                    sitesSpecificHabitats = new Chm62edtSitesAttributesDomain()
                    .findWhere(" NAME LIKE 'HABITAT_CODE_%' AND ID_SITE='" + siteid + "' group by name LIMIT 1");
                }

                if ((SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD
                        && (!habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty() || !habits2Eunis.isEmpty() || !habits2NotEunis
                                .isEmpty()))
                                || (!habitats.isEmpty() || !sitesSpecificHabitats.isEmpty())) {
                    fields += "HABITATS='Y',";
                } else {
                    fields += "HABITATS='N',";
                }

                // SITES
                List sites = new ArrayList();
                List sitesNatura200 = new ArrayList();
                List sitesCorine = new ArrayList();

                if (type != SiteFactsheet.TYPE_NATURA2000) {
                    sites = new SiteRelationsDomain().findWhere("A.ID_SITE='" + siteid + "' LIMIT 1");
                } else {
                    sitesNatura200 = new SiteRelationsDomain().findWhere("A.ID_SITE='" + siteid
                            + "' AND B.SOURCE_DB = 'NATURA2000' AND A.SOURCE_TABLE = 'sitrel' LIMIT 1");
                    sitesCorine = new SiteRelationsDomain().findWhere("A.ID_SITE='" + siteid
                            + "' AND B.SOURCE_DB = 'NATURA2000' AND A.SOURCE_TABLE = 'corine' LIMIT 1");
                }
                if (!sites.isEmpty() || !sitesNatura200.isEmpty() || !sitesCorine.isEmpty()) {
                    fields += "SITES='Y',";
                } else {
                    fields += "SITES='N',";
                }

                // OTHER
                boolean other_exist = false;

                if (SiteFactsheet.TYPE_CORINE == type || SiteFactsheet.TYPE_DIPLOMA == type
                        || SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_NATURA2000 == type
                        || type == SiteFactsheet.TYPE_EMERALD) {
                    List activities = new HumanActivityDomain().findWhere("LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND ID_SITE='" + siteid
                            + "' LIMIT 1");

                    if (activities.size() > 0) {
                        other_exist = true;
                    }
                }
                if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type
                        || SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type) {
                    String mapID = factsheet.getMapID();
                    String mapScale = factsheet.getMapScale();
                    String mapProjection = factsheet.getMapProjection();
                    String mapDetails = factsheet.getMapDetails();

                    if (!mapID.equalsIgnoreCase("") && !mapScale.equalsIgnoreCase("") && !mapProjection.equalsIgnoreCase("")
                            && !mapDetails.equalsIgnoreCase("")) {
                        other_exist = true;
                    }

                    String photoType = factsheet.getPhotoType().toString();
                    String photoNumber = factsheet.getPhotoNumber();
                    String photoLocation = factsheet.getPhotoLocation();
                    String photoDescription = factsheet.getPhotoDescription();
                    String photoDate = factsheet.getPhotoDate();
                    String photoAuthor = factsheet.getPhotoAuthor();

                    if (!photoType.equalsIgnoreCase("") && !photoNumber.equalsIgnoreCase("") && !photoLocation.equalsIgnoreCase("")
                            && !photoDescription.equalsIgnoreCase("") && !photoDescription.equalsIgnoreCase("")
                            && !photoDate.equalsIgnoreCase("") && !photoAuthor.equalsIgnoreCase("")) {
                        other_exist = true;
                    }
                }
                String category = factsheet.getSiteObject().getIucnat();
                String typology = factsheet.getTypology();
                String referenceDocNumber = factsheet.getReferenceDocumentNumber();
                String referenceDocSource = factsheet.getReferenceDocumentSource();

                if (!category.equalsIgnoreCase("") || !typology.equalsIgnoreCase("") || !referenceDocNumber.equalsIgnoreCase("")
                        || !referenceDocSource.equalsIgnoreCase("")) {
                    other_exist = true;
                }
                if (other_exist) {
                    fields += "OTHER='Y',";
                } else {
                    fields += "OTHER='N',";
                }

                if (fields.endsWith(",")) {
                    fields = fields.substring(0, fields.length() - 1);
                }
                if (fields != null && fields.length() > 0) {
                    ps2 = con.prepareStatement("UPDATE chm62edt_tab_page_sites SET " + fields + " WHERE ID_NATURE_OBJECT=" + noid);
                    ps2.executeUpdate();
                }
            }

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating sites tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
    }

    private boolean exists(String sql, Connection con) {
        boolean ret = false;
        PreparedStatement ps = null;
        ResultSet rs = null;

        sql = "select * from " + sql + " LIMIT 1";

        try {

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                ret = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeAll(null, ps, rs);
        }
        return ret;
    }

    private void updateReferences() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement("UPDATE CHM62EDT_TAB_PAGE_SPECIES SET `REFERENCES`='N'");
            ps.executeUpdate();

            String strSQL = "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)"
                + " WHERE"
                + " (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))"
                + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL = "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)"
                + " WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` <> `CHM62EDT_SPECIES`.`ID_SPECIES_LINK`" + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL = "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)" + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL = "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)" + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
    }

    private void closeAll(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

}
