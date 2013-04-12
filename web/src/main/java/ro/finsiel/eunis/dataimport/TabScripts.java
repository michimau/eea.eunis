package ro.finsiel.eunis.dataimport;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

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

            EunisUtil.writeLogMessage("GENERAL tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Delete old records
            ps = con.prepareStatement("DELETE FROM chm62edt_tab_page_species");
            ps.executeUpdate();

            String mainSql =
                "INSERT INTO chm62edt_tab_page_species (ID_NATURE_OBJECT,GENERAL_INFORMATION) "
                + "(SELECT ID_NATURE_OBJECT,'Y' FROM chm62edt_species)";

            ps = con.prepareStatement(mainSql);
            ps.executeUpdate();

            EunisUtil.writeLogMessage("GENERAL tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Update GBIF tab
            EunisUtil
            .writeLogMessage("GBIF tab generation started. Time: " + new Timestamp(System.currentTimeMillis()), cmd, sqlc);
            String gbifSql =
                "UPDATE chm62edt_tab_page_species SET GBIF = 'Y' WHERE ID_NATURE_OBJECT IN ( "
                        + "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES "
                        + "WHERE TYPE_RELATED_SPECIES IN ('Species','Subspecies','Synonym'))";
            ps = con.prepareStatement(gbifSql);
            ps.executeUpdate();
            EunisUtil.writeLogMessage("GBIF tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

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
            EunisUtil.writeLogMessage("REFERENCES tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);
            updateReferences(con);
            EunisUtil.writeLogMessage("REFERENCES tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            //TODO: Update linked data method

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating species tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    /**
     * Generate species linked data tab information for species. This method assumes that
     * all rows have been set to 'N' already.
     *
     */
    public void setSpeciesLinkedDataTab() {
        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            // Update Linked data tab
            EunisUtil .writeLogMessage("LINKED DATA tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            String linkeddataSql = "UPDATE chm62edt_tab_page_species SET LINKEDDATA = 'N'";
            ps = con.prepareStatement(linkeddataSql);
            ps.executeUpdate();

            linkeddataSql = "UPDATE chm62edt_tab_page_species t "
                    + "JOIN chm62edt_nature_object_attributes a "
                    + "ON t.ID_NATURE_OBJECT=a.ID_NATURE_OBJECT AND a.NAME='_linkedDataQueries' "
                    + "SET LINKEDDATA = 'Y' WHERE LENGTH(OBJECT) > 0";
            ps = con.prepareStatement(linkeddataSql);
            ps.executeUpdate();
            EunisUtil.writeLogMessage("LINKED DATA tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating species linked data tab information: "
                    + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    /**
     * Generate species conservation status tab information for species. This method assumes that
     * all rows have been set to 'N' already.
     *
     */
    public void setSpeciesConservationStatusTab() {
        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            // Update Conservation status tab
            EunisUtil .writeLogMessage("CONSERVATION STATUS tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            String linkeddataSql = "UPDATE chm62edt_tab_page_species SET CONSERVATION_STATUS = 'N'";
            ps = con.prepareStatement(linkeddataSql);
            ps.executeUpdate();

            linkeddataSql = "UPDATE chm62edt_tab_page_species t "
                    + "JOIN chm62edt_nature_object_attributes a "
                    + "ON t.ID_NATURE_OBJECT=a.ID_NATURE_OBJECT AND a.NAME='_conservationStatusQueries' "
                    + "SET CONSERVATION_STATUS = 'Y' WHERE LENGTH(OBJECT) > 0";
            ps = con.prepareStatement(linkeddataSql);
            ps.executeUpdate();
            EunisUtil.writeLogMessage("CONSERVATION STATUS tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating species conservation status tab information: "
                    + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    private void updateSpeciesTab(String sql, Connection con, SQLUtilities sqlc, String tab) throws Exception {

        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            EunisUtil.writeLogMessage(tab + " tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);
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

            EunisUtil.writeLogMessage(tab + " tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

        } finally {
            // connection will be closed in setTabSpecies() method
            closeAll(null, ps, rs);
        }
    }

    /**
     * Generate tab information for habitats.
     */
    public void setTabHabitats() {

        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            EunisUtil.writeLogMessage("GENERAL tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Delete old records
            ps = con.prepareStatement("DELETE FROM chm62edt_tab_page_habitats");
            ps.executeUpdate();

            String mainSql = "INSERT INTO chm62edt_tab_page_habitats (ID_NATURE_OBJECT,GENERAL_INFORMATION) "
                + "(SELECT ID_NATURE_OBJECT,'Y' FROM chm62edt_habitat)";

            ps = con.prepareStatement(mainSql);
            ps.executeUpdate();

            EunisUtil.writeLogMessage("GENERAL tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Update GEOGRAPHICAL_DISTRIBUTION tab
            String s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_HABITAT AS A "
                + "JOIN CHM62EDT_REPORTS AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT "
                + "JOIN CHM62EDT_COUNTRY AS C ON B.ID_GEOSCOPE = C.ID_GEOSCOPE "
                + "JOIN CHM62EDT_BIOGEOREGION AS D ON B.ID_GEOSCOPE_LINK = D.ID_GEOSCOPE";
            updateTab(s, con, sqlc, "GEOGRAPHICAL_DISTRIBUTION", "chm62edt_tab_page_habitats");

            // Update SPECIES tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_HABITAT AS A "
                + "JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                + "JOIN CHM62EDT_SPECIES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                + "WHERE A.ID_HABITAT <> '-1' AND A.ID_HABITAT <> '10000'";
            updateTab(s, con, sqlc, "SPECIES", "chm62edt_tab_page_habitats");

            // Update HABITATS tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_HABITAT_SYNTAXA AS S "
                + "JOIN CHM62EDT_HABITAT AS A ON S.ID_HABITAT = A.ID_HABITAT "
                + "JOIN CHM62EDT_SYNTAXA AS B ON S.ID_SYNTAXA = B.ID_SYNTAXA "
                + "JOIN CHM62EDT_SYNTAXA_SOURCE AS C ON S.ID_SYNTAXA_SOURCE = C.ID_SYNTAXA_SOURCE";
            updateTab(s, con, sqlc, "HABITATS", "chm62edt_tab_page_habitats");

            // Update LEGAL_INSTRUMENTS tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_HABITAT AS A "
                + "JOIN CHM62EDT_HABITAT_CLASS_CODE AS B ON A.ID_HABITAT = B.ID_HABITAT "
                + "JOIN CHM62EDT_CLASS_CODE AS C ON B.ID_CLASS_CODE = C.ID_CLASS_CODE "
                + "WHERE C.LEGAL = 1";
            updateTab(s, con, sqlc, "LEGAL_INSTRUMENTS", "chm62edt_tab_page_habitats");

            // Update OTHER tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS A "
                + "JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                + "WHERE B.LOOKUP_TYPE IN ('altitude','chemistry','climate','cover','humidity','impact','life_form',"
                + "'light_intensity', 'substrate','temperature','usage','water','depth','geomorph','species_richness',"
                + "'exposure','spatial', 'temporal','salinity')";
            updateTab(s, con, sqlc, "OTHER", "chm62edt_tab_page_habitats");

            // Update SITES tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_HABITAT AS A "
                + "JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                + "JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                + "WHERE IF(TRIM(A.CODE_2000) <> '', RIGHT(A.CODE_2000,2), 1) <> IF(TRIM(A.CODE_2000) <> '','00',2) "
                + "AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) "
                + "AND C.SOURCE_DB <> 'EMERALD'";
            updateTab(s, con, sqlc, "SITES", "chm62edt_tab_page_habitats");

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating sites tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    /**
     * Generate tab information for sites.
     */
    public void setTabSites() {

        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            EunisUtil.writeLogMessage("GENERAL tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Delete old records
            ps = con.prepareStatement("DELETE FROM chm62edt_tab_page_sites");
            ps.executeUpdate();

            String mainSql = "INSERT INTO chm62edt_tab_page_sites (ID_NATURE_OBJECT,GENERAL_INFORMATION) "
                + "(SELECT ID_NATURE_OBJECT,'Y' FROM chm62edt_sites)";

            ps = con.prepareStatement(mainSql);
            ps.executeUpdate();

            EunisUtil.writeLogMessage("GENERAL tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            // Update DESIGNATION tab
            String s =
                "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_DESIGNATIONS D "
                + "JOIN CHM62EDT_SITES_RELATED_DESIGNATIONS AS R ON D.ID_DESIGNATION = R.ID_DESIGNATION "
                + "JOIN CHM62EDT_SITES AS A ON R.ID_SITE = A.ID_SITE "
                + "WHERE R.SOURCE_DB IN ('NATURA2000','EMERALD','CORINE') AND R.SOURCE_TABLE IN ('desigr','desigc')";
            updateTab(s, con, sqlc, "DESIGNATION", "chm62edt_tab_page_sites");

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
            updateTab(s, con, sqlc, "HABITATS", "chm62edt_tab_page_sites");

            // Update SITES tab
            s = "SELECT DISTINCT A.ID_NATURE_OBJECT FROM CHM62EDT_SITES_SITES AS S "
                + "JOIN CHM62EDT_SITES AS A ON S.ID_SITE_LINK = A.ID_SITE "
                + "JOIN CHM62EDT_NATURA2000_SITE_TYPE AS C ON S.RELATION_TYPE=C.ID_SITE_TYPE "
                + "WHERE (A.SOURCE_DB = 'NATURA2000' AND S.SOURCE_TABLE IN ('sitrel','corine')) OR (A.SOURCE_DB != 'NATURA2000')";
            updateTab(s, con, sqlc, "SITES", "chm62edt_tab_page_sites");

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
            updateTab(s, con, sqlc, "OTHER", "chm62edt_tab_page_sites");

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
            updateTab(s, con, sqlc, "FAUNA_FLORA", "chm62edt_tab_page_sites");

        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating sites tab information: " + e.getMessage(), cmd, sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    private void updateTab(String sql, Connection con, SQLUtilities sqlc, String tab, String table) throws Exception {

        PreparedStatement ps = null;
        try {
            EunisUtil.writeLogMessage(tab + " tab generation started. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);

            String query = "UPDATE "+table+" SET `" + tab + "` = 'Y' WHERE ID_NATURE_OBJECT IN (" + sql + ")";
            ps = con.prepareStatement(query);
            ps.executeUpdate();

            EunisUtil.writeLogMessage(tab + " tab generation finished. Time: "
                    + new Timestamp(System.currentTimeMillis()), cmd, sqlc);
        } finally {
            // connection will be closed in parent method
            closeAll(null, ps, null);
        }
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
                + " INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)"
                + " INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)"
                + ")";

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
