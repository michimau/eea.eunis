package ro.finsiel.eunis.dataimport;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet;
import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
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
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            EunisUtil.writeLogMessage("GENERAL tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            // Delete old records
            ps = con.prepareStatement("DELETE FROM chm62edt_tab_page_species");
            ps.executeUpdate();

            String mainSql =
                "INSERT INTO chm62edt_tab_page_species (ID_NATURE_OBJECT,GENERAL_INFORMATION) "
                + "(SELECT ID_NATURE_OBJECT,'Y' FROM chm62edt_species)";

            ps = con.prepareStatement(mainSql);
            ps.executeUpdate();

            EunisUtil.writeLogMessage("GENERAL tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            // Update GBIF tab
            EunisUtil
            .writeLogMessage("GBIF tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd, sqlc);
            String gbifSql =
                "UPDATE chm62edt_tab_page_species SET GBIF = 'Y' WHERE ID_NATURE_OBJECT IN ( "
                + "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE TYPE_RELATED_SPECIES IN ('Species','Subspecies','Synonym'))";
            ps = con.prepareStatement(gbifSql);
            ps.executeUpdate();
            EunisUtil.writeLogMessage("GBIF tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            // Update Geographical distribution tab
            String s =
                "CHM62EDT_REPORTS AS A, CHM62EDT_REPORT_TYPE AS B, DC_INDEX AS C "
                + "WHERE A.ID_REPORT_TYPE=B.ID_REPORT_TYPE AND A.ID_DC = C.ID_DC AND (B.LOOKUP_TYPE IN ('SPECIES_STATUS')) AND "
                + "EXISTS (SELECT * FROM CHM62EDT_COUNTRY AS CO WHERE CO.AREA_NAME_EN not like 'ospar%' "
                + "and CO.ID_GEOSCOPE=A.ID_GEOSCOPE LIMIT 1) AND "
                + "EXISTS(SELECT * FROM CHM62EDT_BIOGEOREGION AS BIO WHERE BIO.ID_GEOSCOPE=A.ID_GEOSCOPE_LINK LIMIT 1) AND "
                + "EXISTS(SELECT * FROM CHM62EDT_SPECIES_STATUS AS SS WHERE SS.ID_SPECIES_STATUS=B.ID_LOOKUP LIMIT 1)";
            updateSpeciesTab(s, con, sqlc, "GEOGRAPHICAL_DISTRIBUTION");

            /*
             * distribution = new ReportsDistributionStatusDomain().findWhere("ID_NATURE_OBJECT = " + noid +
             *" AND (D.LOOKUP_TYPE ='DISTRIBUTION_STATUS' OR D.LOOKUP_TYPE ='GRID') GROUP BY C.NAME,C.LATITUDE,C.LONGITUDE LIMIT 1"
             * );
             */

            // Update Habitats tab
            s =
                "CHM62EDT_HABITAT AS H "
                + "INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS R ON H.ID_NATURE_OBJECT = R.ID_NATURE_OBJECT_LINK "
                + "INNER JOIN CHM62EDT_SPECIES AS A ON R.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                + "WHERE H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000'";
            updateSpeciesTab(s, con, sqlc, "HABITATS");

            // Update LEGAL_INSTRUMENTS tab
            s =
                "CHM62EDT_REPORTS AS A " + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                + "INNER JOIN DC_INDEX AS C ON A.ID_DC = C.ID_DC " + "WHERE B.LOOKUP_TYPE='LEGAL_STATUS'";
            updateSpeciesTab(s, con, sqlc, "LEGAL_INSTRUMENTS");

            // Update POPULATION tab
            s =
                "CHM62EDT_REPORTS AS A " + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                + "INNER JOIN DC_INDEX AS C ON A.ID_DC = C.ID_DC " + "WHERE B.LOOKUP_TYPE='POPULATION_UNIT'";
            updateSpeciesTab(s, con, sqlc, "POPULATION");

            // Update SITES tab
            s =
                "CHM62EDT_SPECIES AS A "
                + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT";
            updateSpeciesTab(s, con, sqlc, "SITES");

            // Update THREAT_STATUS tab
            s =
                "CHM62EDT_REPORTS AS A " + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                + "WHERE B.LOOKUP_TYPE='CONSERVATION_STATUS'";
            updateSpeciesTab(s, con, sqlc, "THREAT_STATUS");

            // Update TRENDS tab
            s =
                "CHM62EDT_REPORTS AS A, CHM62EDT_REPORT_TYPE AS RT WHERE A.ID_REPORT_TYPE=RT.ID_REPORT_TYPE "
                + "AND RT.LOOKUP_TYPE='TREND'";
            updateSpeciesTab(s, con, sqlc, "TRENDS");

            // Update VERNACULAR_NAMES tab
            s =
                "CHM62EDT_REPORTS AS A "
                + "INNER JOIN CHM62EDT_REPORT_ATTRIBUTES AS B ON A.ID_REPORT_ATTRIBUTES = B.ID_REPORT_ATTRIBUTES "
                + "INNER JOIN CHM62EDT_REPORT_TYPE AS C ON A.ID_REPORT_TYPE = C.ID_REPORT_TYPE "
                + "INNER JOIN CHM62EDT_LANGUAGE AS D ON C.ID_LOOKUP = D.ID_LANGUAGE "
                + "WHERE C.LOOKUP_TYPE='language' AND B.NAME='vernacular_name'";
            updateSpeciesTab(s, con, sqlc, "VERNACULAR_NAMES");

            // Update REFERENCES tab
            EunisUtil.writeLogMessage("REFERENCES tab generation started. Time: " + new Timestamp(System.currentTimeMillis()),
                    cmd, sqlc);
            updateReferences(con);
            EunisUtil.writeLogMessage("REFERENCES tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()),
                    cmd, sqlc);

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating species tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    private void updateSpeciesTab(String sql, Connection con, SQLUtilities sqlc, String tab) throws Exception {

        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            EunisUtil.writeLogMessage(tab + " tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            String query =
                "UPDATE chm62edt_tab_page_species SET `" + tab + "` = 'Y' WHERE ID_NATURE_OBJECT IN ("
                + "SELECT DISTINCT A.ID_NATURE_OBJECT FROM " + sql + ")";
            ps = con.prepareStatement(query);
            ps.executeUpdate();

            // Update senior species where junior species = 'Y' - START
            String sql_parent_species =
                "SELECT DISTINCT senior.ID_NATURE_OBJECT AS NAT_OB_ID " + "FROM chm62edt_species AS junior "
                + "JOIN chm62edt_tab_page_species AS juniors using(ID_NATURE_OBJECT) "
                + "JOIN chm62edt_species AS senior ON junior.ID_SPECIES_LINK = senior.ID_SPECIES "
                + "JOIN chm62edt_tab_page_species AS seniors ON senior.ID_NATURE_OBJECT = seniors.ID_NATURE_OBJECT "
                + "WHERE junior.ID_SPECIES <> junior.ID_SPECIES_LINK " + "AND juniors." + tab + " = 'Y' AND seniors."
                + tab + " = 'N'";

            ps = con.prepareStatement(sql_parent_species);
            rs = ps.executeQuery();
            String ids = "";
            while (rs.next()) {
                String natObId = rs.getString("NAT_OB_ID");
                if (natObId != null && natObId.length() > 0) {
                    ids += natObId + ",";
                }
            }
            // Remove last comma
            if (ids != null && ids.lastIndexOf(",") != -1) {
                ids = ids.substring(0, ids.lastIndexOf(","));
            }

            if (ids != null && ids.length() > 0) {
                query = "UPDATE chm62edt_tab_page_species SET `" + tab + "` = 'Y' WHERE ID_NATURE_OBJECT IN (" + ids + ")";
                ps = con.prepareStatement(query);
                ps.executeUpdate();
            }
            // Update senior species where junior species = 'Y' - END

            EunisUtil.writeLogMessage(tab + " tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

        } finally {
            // connection will be closed in setTabSpecies() method
            closeAll(null, ps, rs);
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
                    String sql =
                        "INSERT IGNORE INTO chm62edt_tab_page_habitats (ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES(" + noid
                        + ",'Y')";

                    ps2 = con.prepareStatement(sql);
                    ps2.executeUpdate();

                    String fields = "";

                    HabitatsFactsheet factsheet = new HabitatsFactsheet(new Integer(habid).toString());

                    fields += "GEOGRAPHICAL_DISTRIBUTION='Y',";

                    List species =
                        new HabitatsNatureObjectReportTypeSpeciesDomain()
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

                    String types =
                        "('altitude','chemistry','climate','cover','humidity','impact','life_form','light_intensity',"
                        + "'substrate','temperature','usage','water','depth','geomorph','species_richness','exposure','spatial',"
                        + "'temporal','salinity')";
                    boolean other =
                        exists("CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS A, CHM62EDT_REPORT_TYPE AS B "
                                + "WHERE A.ID_REPORT_TYPE=B.ID_REPORT_TYPE AND ID_NATURE_OBJECT='"
                                + noid + "' AND B.LOOKUP_TYPE IN " + types, con);

                    if (other) {
                        fields += "OTHER='Y',";
                    } else {
                        fields += "OTHER='N',";
                    }

                    String isGoodHabitat =
                        " IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) "
                        + "AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ";
                    String sql_sites =
                        "CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " + " WHERE   "
                        + isGoodHabitat + " AND A.ID_NATURE_OBJECT =" + noid + " AND C.SOURCE_DB <> 'EMERALD'";
                    boolean sites = exists(sql_sites, con);

                    String sql_subsites =
                        "CHM62EDT_HABITAT AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                        + " WHERE A.ID_NATURE_OBJECT ="
                        + noid
                        + (factsheet.isAnnexI() ? " and right(A.code_2000,2) <> '00' and length(A.code_2000) = 4 "
                                + "AND if(right(A.code_2000,1) = '0',left(A.code_2000,3),A.code_2000) like '"
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
                        ps2 =
                            con.prepareStatement("UPDATE chm62edt_tab_page_habitats SET " + fields
                                    + " WHERE ID_NATURE_OBJECT=" + noid);
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
    public void setTabSitesOld() {

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

                String sql =
                    "INSERT IGNORE INTO chm62edt_tab_page_sites (ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES(" + noid
                    + ",'Y')";

                ps2 = con.prepareStatement(sql);
                ps2.executeUpdate();

                String fields = "";

                SiteFactsheet factsheet = new SiteFactsheet(siteid);
                int type = factsheet.getType();

                // DESIGNATION
                if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD || type == SiteFactsheet.TYPE_CORINE) {
                    List sitesDesigc = new ArrayList();

                    if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD) {
                        sitesDesigc =
                            new DesignationsSitesRelatedDesignationsDomain()
                        .findWhere("ID_SITE='"
                                + siteid
                                + "' AND SOURCE_TABLE = 'desigc' "
                                + "group by id_designation, description_en,NATIONAL_CATEGORY,overlap LIMIT 1");
                    } else {
                        // CORINE
                        sitesDesigc =
                            new DesignationsSitesRelatedDesignationsDomain()
                        .findWhere("ID_SITE='"
                                + siteid
                                + "' group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type LIMIT 1");
                    }
                    List sitesDesigr = new Vector();

                    if (type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD) {
                        sitesDesigr =
                            new DesignationsSitesRelatedDesignationsDomain()
                        .findWhere("ID_SITE='"
                                + siteid
                                + "' AND SOURCE_TABLE = 'desigr' "
                                + "group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type LIMIT 1");
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
                    habit1Eunis = new SiteHabitatsDomain().findWhere("A.ID_NATURE_OBJECT='" + noid
                            + "' and CHM62EDT_REPORT_ATTRIBUTES.NAME='SOURCE_TABLE' and CHM62EDT_REPORT_ATTRIBUTES.VALUE='habit1' LIMIT 1");
                    habit1NotEunis = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + siteid
                            + "' AND SOURCE_TABLE = 'HABIT1' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2) LIMIT 1");
                    habits2Eunis = new SiteHabitatsDomain().findWhere("A.ID_NATURE_OBJECT='" + noid
                            + "' and CHM62EDT_REPORT_ATTRIBUTES.NAME='SOURCE_TABLE' and CHM62EDT_REPORT_ATTRIBUTES.VALUE='habit2' LIMIT 1");
                    habits2NotEunis = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='"+ siteid
                            + "' AND SOURCE_TABLE = 'HABIT2' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2) LIMIT 1");
                } else {
                    String isGoodHabitat =
                        " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> "
                        + "IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND "
                        + "IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = "
                        + "IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";

                    habitats = new SiteHabitatsDomain().findWhere(isGoodHabitat + " AND A.ID_NATURE_OBJECT='" + noid
                            + "' GROUP BY CHM62EDT_HABITAT.ID_NATURE_OBJECT, CHM62EDT_SITES.ID_NATURE_OBJECT LIMIT 1");
                    sitesSpecificHabitats = new Chm62edtSitesAttributesDomain().findWhere(" NAME LIKE 'HABITAT_CODE_%' AND ID_SITE='" + siteid
                            + "' group by name LIMIT 1");
                }

                if ((SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD
                        && (!habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty() || !habits2Eunis.isEmpty() || !habits2NotEunis.isEmpty()))
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
                    List activities = new HumanActivityDomain().findWhere("LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND ID_SITE='" + siteid + "' LIMIT 1");

                    if (activities.size() > 0) {
                        other_exist = true;
                    }
                }
                if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type || SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type) {
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

                    if (!photoType.equalsIgnoreCase("") && !photoNumber.equalsIgnoreCase("")
                            && !photoLocation.equalsIgnoreCase("") && !photoDescription.equalsIgnoreCase("")
                            && !photoDescription.equalsIgnoreCase("") && !photoDate.equalsIgnoreCase("")
                            && !photoAuthor.equalsIgnoreCase("")) {
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

    /**
     * Generate tab information for sites
     */
    public void setTabSites() {

        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            EunisUtil.writeLogMessage("GENERAL tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            // Delete old records
            ps = con.prepareStatement("DELETE FROM chm62edt_tab_page_sites");
            ps.executeUpdate();

            String mainSql = "INSERT INTO chm62edt_tab_page_sites (ID_NATURE_OBJECT,GENERAL_INFORMATION) "
                + "(SELECT ID_NATURE_OBJECT,'Y' FROM chm62edt_sites)";

            ps = con.prepareStatement(mainSql);
            ps.executeUpdate();

            EunisUtil.writeLogMessage("GENERAL tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            // Update DESIGNATION tab
            String s =
                "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_DESIGNATIONS D "
                + "JOIN CHM62EDT_SITES_RELATED_DESIGNATIONS AS R ON D.ID_DESIGNATION = R.ID_DESIGNATION "
                + "JOIN CHM62EDT_SITES AS A ON R.ID_SITE = A.ID_SITE "
                + "WHERE R.SOURCE_DB IN ('NATURA2000','EMERALD','CORINE') AND R.SOURCE_TABLE IN ('desigr','desigc')";
            updateSitesTab(s, con, sqlc, "DESIGNATION");

            // Update HABITATS tab
            s = "SELECT N.ID_NATURE_OBJECT FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS N "
                + "JOIN CHM62EDT_HABITAT AS H ON N.ID_NATURE_OBJECT_LINK = H.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_REPORT_ATTRIBUTES AS R ON N.ID_REPORT_ATTRIBUTES = R.ID_REPORT_ATTRIBUTES "
                + "WHERE R.NAME = 'SOURCE_TABLE' AND R.VALUE IN ('habit1','habit2') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE  "
                + "WHERE S.SOURCE_TABLE IN ('HABIT1','HABIT2') AND S.NAME LIKE 'HABITAT_CODE_%' AND A.SOURCE_DB IN ('NATURA2000','EMERALD') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS N "
                + "JOIN CHM62EDT_SITES AS A ON N.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_HABITAT AS H ON N.ID_NATURE_OBJECT_LINK = H.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_REPORT_ATTRIBUTES AS R ON N.ID_REPORT_ATTRIBUTES = R.ID_REPORT_ATTRIBUTES "
                + "WHERE A.SOURCE_DB NOT IN ('NATURA2000','EMERALD')";
            updateSitesTab(s, con, sqlc, "HABITATS");

            // Update SITES tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_SITES_SITES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE_LINK = A.ID_SITE "
                + "JOIN CHM62EDT_NATURA2000_SITE_TYPE AS C ON S.RELATION_TYPE=C.ID_SITE_TYPE "
                + "WHERE (A.SOURCE_DB = 'NATURA2000' AND S.SOURCE_TABLE IN ('sitrel','corine')) OR (A.SOURCE_DB != 'NATURA2000')";
            updateSitesTab(s, con, sqlc, "SITES");

            // Update OTHER tab
            s = "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITES AS A "
                + "JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS N ON A.ID_NATURE_OBJECT = N.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_REPORT_TYPE AS R ON N.ID_REPORT_TYPE = R.ID_REPORT_TYPE "
                + "JOIN CHM62EDT_NATURA2000_ACTIVITY_CODE AS C ON R.ID_LOOKUP = C.ID_ACTIVITY_CODE "
                + "WHERE R.LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND A.SOURCE_DB IN ('NATURA2000','CORINE','DIPLOMA','BIOGENETIC','EMERALD') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE "
                + "WHERE A.SOURCE_DB IN ('NATURA2000','EMERALD','DIPLOMA','BIOGENETIC') AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'MAP_ID' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'MAP_SCALE' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'MAP_PROJECTION' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'MAP_DETAILS' AND LENGTH(S2.VALUE) > 0 LIMIT 1) "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE  "
                + "WHERE A.SOURCE_DB IN ('NATURA2000','EMERALD','DIPLOMA','BIOGENETIC') AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_TYPE' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_NUMBER' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_LOCATION' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_DESCRIPTION' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_DATE' AND LENGTH(S2.VALUE) > 0 LIMIT 1) AND "
                + "EXISTS(SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES AS S2 WHERE S2.ID_SITE=S.ID_SITE AND S2.NAME = 'PHOTO_AUTHOR' AND LENGTH(S2.VALUE) > 0 LIMIT 1) "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE "
                + "WHERE LENGTH(A.IUCNAT) > 0 OR (S.NAME IN ('TYPOLOGY','REFERENCE_DOCUMENT_NUMBER','REFERENCE_DOCUMENT_SOURCE') AND LENGTH(S.VALUE) > 0)";
            updateSitesTab(s, con, sqlc, "OTHER");

            // Update FAUNA_FLORA tab
            s = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE SOURCE_DB IN ('NATURA2000','EMERALD','CORINE','BIOGENETIC','DIPLOMA') AND "
                + "((LENGTH(RESPONDENT) > 0 AND RESPONDENT <> 'NULL') OR (LENGTH(MANAGER) > 0 AND MANAGER <> 'NULL')) "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE AND A.SOURCE_DB IN ('NATURA2000','EMERALD','CORINE','BIOGENETIC','DIPLOMA') "
                + "WHERE S.NAME IN ('AUTHOR','CONTACT_INTERNATIONAL','CONTACT_NATIONAL','CONTACT_REGIONAL','CONTACT_LOCAL') AND LENGTH(S.VALUE) > 0 "
                + "UNION "
                + "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE SOURCE_DB IN ('NATURA2000','EMERALD','CORINE','BIOGENETIC','DIPLOMA') AND "
                + "((LENGTH(`CHARACTER`) > 0 AND `CHARACTER` <> 'NULL') OR (LENGTH(OWNERSHIP) > 0 AND OWNERSHIP <> 'NULL') "
                + "OR (LENGTH(MANAGEMENT_PLAN) > 0 AND MANAGEMENT_PLAN <> 'NULL')) "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE AND A.SOURCE_DB IN ('NATURA2000','EMERALD','CORINE','BIOGENETIC','DIPLOMA') "
                + "WHERE S.NAME IN ('QUALITY','VULNERABILITY','DOCUMENTATION','HABITAT_CHARACTERIZATION', "
                + "'FLORA_CHARACTERIZATION','FAUNA_CHARACTERIZATION','POTENTIAL_VEGETATION','GEOMORPHOLOGY', "
                + "'EDUCATIONAL_INTEREST','CULTURAL_HERITAGE','JUSTIFICATION','METHODOLOGY','BUDGET', "
                + "'OFFICIAL_URL','INTERESTING_URL') AND LENGTH(S.VALUE) > 0 "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_DESIGNATIONS AS D "
                + "INNER JOIN CHM62EDT_SITES AS A ON (D.ID_DESIGNATION = A.ID_DESIGNATION AND "
                + "D.ID_GEOSCOPE = A.ID_GEOSCOPE AND A.SOURCE_DB NOT IN ('CDDA_NATIONAL','CDDA_INTERNATIONAL')) "
                + "WHERE (LENGTH(D.DESCRIPTION) > 0 AND A.DESCRIPTION <> 'NULL') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS R "
                + "JOIN CHM62EDT_SITES AS A ON R.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_SPECIES AS S ON R.ID_NATURE_OBJECT_LINK = S.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_GROUP_SPECIES AS G ON S.ID_GROUP_SPECIES = G.ID_GROUP_SPECIES "
                + "WHERE A.SOURCE_DB IN ('EMERALD','CORINE','BIOGENETIC','DIPLOMA') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE "
                + "WHERE A.SOURCE_DB IN ('EMERALD','CORINE','BIOGENETIC','DIPLOMA') AND S.NAME LIKE ('SPECIES%') AND LENGTH(S.VALUE) > 0 "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS R "
                + "JOIN CHM62EDT_SITES AS A ON R.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_SPECIES AS S ON R.ID_NATURE_OBJECT_LINK = S.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_GROUP_SPECIES AS G ON S.ID_GROUP_SPECIES = G.ID_GROUP_SPECIES "
                + "JOIN CHM62EDT_REPORT_ATTRIBUTES AS T ON R.ID_REPORT_ATTRIBUTES = T.ID_REPORT_ATTRIBUTES "
                + "WHERE A.SOURCE_DB IN ('NATURA2000') AND T.NAME='SOURCE_TABLE' "
                + "AND T.VALUE IN ('AMPREP','BIRD','FISHES','INVERT','MAMMAL','PLANT','spec') "
                + "UNION "
                + "SELECT A.ID_NATURE_OBJECT FROM CHM62EDT_SITE_ATTRIBUTES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE = A.ID_SITE "
                + "WHERE A.SOURCE_DB IN ('NATURA2000') AND "
                + "S.SOURCE_TABLE IN ('AMPREP','BIRD','FISHES','INVERT','MAMMAL','PLANT','SPEC') AND S.NAME LIKE 'OTHER_SPECIES_%'";
            updateSitesTab(s, con, sqlc, "FAUNA_FLORA");

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating sites tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    private void updateSitesTab(String sql, Connection con, SQLUtilities sqlc, String tab) throws Exception {

        PreparedStatement ps = null;
        try {
            EunisUtil.writeLogMessage(tab + " tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);

            String query = "UPDATE chm62edt_tab_page_sites SET `" + tab + "` = 'Y' WHERE ID_NATURE_OBJECT IN (" + sql + ")";
            ps = con.prepareStatement(query);
            ps.executeUpdate();

            EunisUtil.writeLogMessage(tab + " tab generation finished. Time: " + new Timestamp(System.currentTimeMillis()), cmd,
                    sqlc);
        } finally {
            // connection will be closed in setTabSites() method
            closeAll(null, ps, null);
        }
    }

    private boolean exists(String sql, Connection con) {
        boolean ret = false;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = "select * from " + sql + " LIMIT 1";

        try {

            ps = con.prepareStatement(query);
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

    private void updateReferences(Connection con) {

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement("UPDATE CHM62EDT_TAB_PAGE_SPECIES SET `REFERENCES`='N'");
            ps.executeUpdate();

            String strSQL =
                "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT`"
                + " ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `CHM62EDT_REPORTS`"
                + " ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `CHM62EDT_REPORT_TYPE`"
                + " ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)"
                + " WHERE"
                + " (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS',"
                + " 'SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))"
                + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL =
                "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT`"
                + " ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)"
                + " WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` <> `CHM62EDT_SPECIES`.`ID_SPECIES_LINK`" + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL =
                "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT`"
                + " ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)"
                + " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)"
                + " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)"
                + " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)" + ")";

            ps = con.prepareStatement(strSQL);
            ps.executeUpdate();

            strSQL =
                "UPDATE `CHM62EDT_TAB_PAGE_SPECIES` SET `REFERENCES`='Y' WHERE `CHM62EDT_TAB_PAGE_SPECIES`.`ID_NATURE_OBJECT` IN ("
                + " SELECT `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`"
                + " FROM"
                + " `CHM62EDT_SPECIES`"
                + " INNER JOIN `CHM62EDT_NATURE_OBJECT`"
                + " ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)"
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
            // Connection will be closed in parent method
            closeAll(null, ps, rs);
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
