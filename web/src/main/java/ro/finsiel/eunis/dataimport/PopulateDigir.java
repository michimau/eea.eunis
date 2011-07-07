package ro.finsiel.eunis.dataimport;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author altnyris
 */
public class PopulateDigir {

    private String SQL_DRV = "";
    private String SQL_URL = "";
    private String SQL_USR = "";
    private String SQL_PWD = "";

    private PreparedStatement digirRecordPreparedStatement;
    private int counter = 0;

    private String digir_CatalogNumber;

    private String digir_BasisOfRecord = "Assesment";
    private String digir_InstitutionCode = "EEA";
    private String digir_CollectionCode = "EUNIS2";
    private String digir_GeodeticDatum = "not recorded";
    private String digir_RelatedInformation = "";
    private String digir_CoordinateUncertaintyInMeters = "70000";
    private String digir_Continent = "Europe";

    private String digir_GlobalUniqueIdentifier = "";

    private String digir_ScientificName;
    private String digir_Kingdom;
    private String digir_Phylum;
    private String digir_Class;
    private String digir_Order;
    private String digir_Family;
    private String digir_Genus;
    private String digir_ScientificNameAuthor;
    private String digir_Country;
    private String digir_DecimalLatitude;
    private String digir_DecimalLongitude;
    private String digir_YearCollected;
    private String digir_MonthCollected;
    private String digir_DayCollected;

    private Connection con = null;

    private boolean cmd = false;

    /**
     * Creates a new PopulateDigir object.
     */
    public PopulateDigir() {
    }

    /**
     * Initialization method for this object.
     * 
     * @param SQL_DRIVER_NAME JDBC driver.
     * @param SQL_DRIVER_URL JDBC url.
     * @param SQL_DRIVER_USERNAME JDBC username.
     * @param SQL_DRIVER_PASSWORD JDBC password.
     * @param cmd
     */
    public void Init(String SQL_DRIVER_NAME, String SQL_DRIVER_URL,
            String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD, boolean cmd) {
        SQL_DRV = SQL_DRIVER_NAME;
        SQL_URL = SQL_DRIVER_URL;
        SQL_USR = SQL_DRIVER_USERNAME;
        SQL_PWD = SQL_DRIVER_PASSWORD;
        this.cmd = cmd;
    }

    public void populate() throws SQLException {

        Statement st = null;
        SQLUtilities sql = new SQLUtilities();

        try {

            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            DatabaseMetaData dbm = con.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "eunis_digir", null);

            if (tables.next()) {
                loadDigir();
            } else {
                st = con.createStatement();

                String table = "CREATE TABLE eunis_digir ("
                    + "`GlobalUniqueIdentifier` varchar(64) default NULL, "
                    + "`DateLastModified` datetime default NULL, "
                    + "`BasisOfRecord` varchar(50) default NULL, "
                    + "`InstitutionCode` varchar(16) default NULL, "
                    + "`CollectionCode` varchar(16) default NULL, "
                    + "`CatalogNumber` varchar(64) default NULL, "
                    + "`ScientificName` varchar(64) default NULL, "
                    + "`Kingdom` varchar(32) default NULL, "
                    + "`Phylum` varchar(32) default NULL, "
                    + "`Class` varchar(32) default NULL, "
                    + "`Order` varchar(32) default NULL, "
                    + "`Family` varchar(32) default NULL, "
                    + "`Genus` varchar(32) default NULL, "
                    + "`ScientificNameAuthor` varchar(50) default NULL, "
                    + "`Continent` varchar(16) default NULL, "
                    + "`Country` varchar(32) default NULL, "
                    + "`GeodeticDatum` varchar(64) default 'not recorded', "
                    + "`DecimalLatitude` varchar(32) default NULL, "
                    + "`DecimalLongitude` varchar(32) default NULL, "
                    + "`CoordinateUncertaintyInMeters` int(6) default NULL, "
                    + "`YearCollected` tinyint(4) default NULL, "
                    + "`MonthCollected` tinyint(4) default NULL, "
                    + "`DayCollected` tinyint(4) default NULL, "
                    + "`Collector` tinyint(4) default NULL, "
                    + "`RelatedInformation` varchar(255) default NULL, "
                    + "KEY `GlobalUniqueIdentifier` (`GlobalUniqueIdentifier`), "
                    + "FULLTEXT KEY `ScientificName` (`ScientificName`)) ENGINE=MyISAM DEFAULT CHARSET=utf8";

                st.executeUpdate(table);
                loadDigir();
            }

        } catch (Exception e) {
            e.printStackTrace();
            EunisUtil.writeLogMessage("ERROR occured while populating DIGIR data: " + e.getMessage(), cmd, sql);
            throw new RuntimeException(e.toString(), e);
        } finally {
            if (st != null) {
                st.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }

    private void loadDigirRecord() throws SQLException {

        String strCatalogNumberHash = "";

        if (digir_CatalogNumber != null && digir_CatalogNumber.length() > 0) {
            strCatalogNumberHash = EunisUtil.digestHexDec(digir_CatalogNumber,
            "MD5");
        }

        try {
            digirRecordPreparedStatement.setString(1, strCatalogNumberHash);
            digirRecordPreparedStatement.setString(2, digir_BasisOfRecord);
            digirRecordPreparedStatement.setString(3, digir_InstitutionCode);
            digirRecordPreparedStatement.setString(4, digir_CollectionCode);
            digirRecordPreparedStatement.setString(5,
                    digir_GlobalUniqueIdentifier);
            digirRecordPreparedStatement.setString(6, digir_ScientificName);
            digirRecordPreparedStatement.setString(7, digir_Kingdom);
            digirRecordPreparedStatement.setString(8, digir_Phylum);
            digirRecordPreparedStatement.setString(9, digir_Class);
            digirRecordPreparedStatement.setString(10, digir_Order);
            digirRecordPreparedStatement.setString(11, digir_Family);
            digirRecordPreparedStatement.setString(12, digir_Genus);
            digirRecordPreparedStatement.setString(13,
                    digir_ScientificNameAuthor);
            digirRecordPreparedStatement.setString(14, digir_Continent);

            if (digir_Country != null && !digir_Country.equalsIgnoreCase("NULL")) {
                digirRecordPreparedStatement.setString(15, digir_Country);
            } else {
                digirRecordPreparedStatement.setNull(15, java.sql.Types.VARCHAR);
            }

            digirRecordPreparedStatement.setString(16, digir_GeodeticDatum);

            if (digir_DecimalLatitude != null
                    && !digir_DecimalLatitude.equalsIgnoreCase("NULL")) {
                digirRecordPreparedStatement.setString(17, digir_DecimalLatitude);
            } else {
                digirRecordPreparedStatement.setNull(17, java.sql.Types.VARCHAR);
            }

            if (digir_DecimalLongitude != null
                    && !digir_DecimalLongitude.equalsIgnoreCase("NULL")) {
                digirRecordPreparedStatement.setString(18,
                        digir_DecimalLongitude);
            } else {
                digirRecordPreparedStatement.setNull(18, java.sql.Types.VARCHAR);
            }

            digirRecordPreparedStatement.setString(19,
                    digir_CoordinateUncertaintyInMeters);
            digirRecordPreparedStatement.setString(20, digir_YearCollected);
            digirRecordPreparedStatement.setString(21, digir_MonthCollected);
            digirRecordPreparedStatement.setString(22, digir_DayCollected);
            digirRecordPreparedStatement.setString(23, digir_RelatedInformation);

            counter++;
            digirRecordPreparedStatement.addBatch();
            if (counter % 10000 == 0) {
                digirRecordPreparedStatement.executeBatch();
                digirRecordPreparedStatement.clearParameters();
                System.gc();
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(digirRecordPreparedStatement.toString());
            throw new RuntimeException(
                    e.toString() + " " + digirRecordPreparedStatement.toString(),
                    e);
        }
    }

    private void loadDigir() throws SQLException {

        StringBuffer digirRecordQuery = new StringBuffer();

        digirRecordQuery
        .append("INSERT IGNORE INTO `eunis_digir` (`GlobalUniqueIdentifier`,`BasisOfRecord`,`InstitutionCode`,")
        .append("`CollectionCode`,`CatalogNumber`,`ScientificName`,`Kingdom`,`Phylum`,`Class`,`Order`,`Family`,")
        .append("`Genus`,`ScientificNameAuthor`,`Continent`,`Country`,`GeodeticDatum`,`DecimalLatitude`,`DecimalLongitude`,")
        .append("`CoordinateUncertaintyInMeters`,`YearCollected`,`MonthCollected`,`DayCollected`,`RelatedInformation`) VALUES(")
        .append(
        "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

        this.digirRecordPreparedStatement = con.prepareStatement(
                digirRecordQuery.toString());

        PreparedStatement ps = null;
        ResultSet rs = null;
        SQLUtilities sql = new SQLUtilities();

        try {
            sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            String query = "SELECT DISTINCT CHM62EDT_SPECIES.ID_SPECIES AS IdSpecies, CHM62EDT_SPECIES.GENUS AS Genus, "
                + "CHM62EDT_SPECIES.SCIENTIFIC_NAME AS ScientificName, CHM62EDT_SPECIES.AUTHOR AS ScientificNameAuthor, "
                + "CHM62EDT_SPECIES.ID_SPECIES AS RelatedInformation, CHM62EDT_COUNTRY.AREA_NAME AS Country, "
                + "CHM62EDT_TAXONOMY.TAXONOMY_TREE AS Taxonomy "
                + "FROM(CHM62EDT_SPECIES) "
                + "INNER JOIN CHM62EDT_REPORTS ON CHM62EDT_SPECIES.ID_NATURE_OBJECT=CHM62EDT_REPORTS.ID_NATURE_OBJECT "
                + "INNER JOIN CHM62EDT_COUNTRY ON CHM62EDT_REPORTS.ID_GEOSCOPE=CHM62EDT_COUNTRY.ID_GEOSCOPE "
                + "INNER JOIN CHM62EDT_TAXONOMY ON CHM62EDT_SPECIES.ID_TAXONOMY=CHM62EDT_TAXONOMY.ID_TAXONOMY";

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {

                if (rs.getRow() % 5000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Load DIGIR data phase 1/5 at row: " + rs.getRow(), cmd, sql);
                }

                digir_GlobalUniqueIdentifier = "urn:catalog:EUNIS2:SPECDIST:"
                    + rs.getString("IdSpecies");

                digir_ScientificName = rs.getString("ScientificName");
                digir_Kingdom = getTaxonomy(rs.getString("Taxonomy"), "Kingdom");
                digir_Phylum = getTaxonomy(rs.getString("Taxonomy"), "Phylum");
                digir_Class = getTaxonomy(rs.getString("Taxonomy"), "Class");
                digir_Order = getTaxonomy(rs.getString("Taxonomy"), "Order");
                digir_Family = getTaxonomy(rs.getString("Taxonomy"), "Family");
                digir_Genus = rs.getString("Genus");
                digir_ScientificNameAuthor = rs.getString("ScientificNameAuthor");
                digir_Country = rs.getString("Country");
                digir_DecimalLatitude = "NULL";
                digir_DecimalLongitude = "NULL";
                digir_YearCollected = "NULL";
                digir_MonthCollected = "NULL";
                digir_DayCollected = "NULL";
                digir_RelatedInformation = "http://eunis.eea.europa.eu/species/"
                    + rs.getString("IdSpecies");
                digir_CatalogNumber = digir_ScientificName + "SPECDIST"
                + digir_Country;

                loadDigirRecord();
            }

            query = "SELECT DISTINCT CHM62EDT_SPECIES.ID_SPECIES AS IdSpecies, CHM62EDT_SPECIES.ID_SPECIES AS RelatedInformation, "
                + "CHM62EDT_SPECIES.SCIENTIFIC_NAME AS ScientificName, CHM62EDT_SPECIES.AUTHOR AS ScientificNameAuthor, "
                + "CHM62EDT_SPECIES.GENUS AS Genus, CHM62EDT_TAXONOMY.TAXONOMY_TREE AS Taxonomy, CHM62EDT_COUNTRY.AREA_NAME AS Country, "
                + "CHM62EDT_SITES.LONG_DEG As Longitude, CHM62EDT_SITES.LAT_DEG As Latitude "
                + "FROM CHM62EDT_SITES "
                + "INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE ON (CHM62EDT_SITES.ID_NATURE_OBJECT = CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_SPECIES ON (CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_NATURE_OBJECT_LINK = CHM62EDT_SPECIES.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_TAXONOMY ON (CHM62EDT_SPECIES.ID_TAXONOMY = CHM62EDT_TAXONOMY.ID_TAXONOMY) "
                + "INNER JOIN CHM62EDT_COUNTRY ON (CHM62EDT_SITES.ID_GEOSCOPE = CHM62EDT_COUNTRY.ID_GEOSCOPE)";

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {

                if (rs.getRow() % 5000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Load DIGIR data phase 2/5 at row: " + rs.getRow(), cmd, sql);
                }

                digir_GlobalUniqueIdentifier = "urn:catalog:EUNIS2:SPECSITES:"
                    + rs.getString("IdSpecies");

                digir_ScientificName = rs.getString("ScientificName");
                digir_Kingdom = getTaxonomy(rs.getString("Taxonomy"), "Kingdom");
                digir_Phylum = getTaxonomy(rs.getString("Taxonomy"), "Phylum");
                digir_Class = getTaxonomy(rs.getString("Taxonomy"), "Class");
                digir_Order = getTaxonomy(rs.getString("Taxonomy"), "Order");
                digir_Family = getTaxonomy(rs.getString("Taxonomy"), "Family");
                digir_Genus = rs.getString("Genus");
                digir_ScientificNameAuthor = rs.getString("ScientificNameAuthor");
                digir_Country = rs.getString("Country");
                digir_DecimalLatitude = rs.getString("Latitude") != null
                ? rs.getString("Latitude")
                        : "0";
                digir_DecimalLongitude = rs.getString("Longitude") != null
                ? rs.getString("Longitude")
                        : "0";
                digir_YearCollected = "NULL";
                digir_MonthCollected = "NULL";
                digir_DayCollected = "NULL";
                digir_RelatedInformation = "http://eunis.eea.europa.eu/species/"
                    + rs.getString("IdSpecies");
                digir_CatalogNumber = digir_ScientificName + "SPECSITES"
                + digir_Country + digir_DecimalLatitude
                + digir_DecimalLongitude;

                loadDigirRecord();
            }

            query = "SELECT DISTINCT CHM62EDT_SPECIES.ID_SPECIES AS IdSpecies, CHM62EDT_SPECIES.SCIENTIFIC_NAME AS ScientificName, "
                + "CHM62EDT_SPECIES.GENUS AS Genus, CHM62EDT_SPECIES.AUTHOR AS ScientificNameAuthor, "
                + "CHM62EDT_TAXONOMY.TAXONOMY_TREE AS Taxonomy "
                + "FROM CHM62EDT_SPECIES "
                + "INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE ON (CHM62EDT_SPECIES.ID_NATURE_OBJECT = CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_HABITAT ON (CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_NATURE_OBJECT_LINK = CHM62EDT_HABITAT.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_TAXONOMY ON (CHM62EDT_SPECIES.ID_TAXONOMY = CHM62EDT_TAXONOMY.ID_TAXONOMY)";

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {

                if (rs.getRow() % 5000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Load DIGIR data phase 3/5 at row: " + rs.getRow(), cmd, sql);
                }

                digir_GlobalUniqueIdentifier = "urn:catalog:EUNIS2:SPECHAB:"
                    + rs.getString("IdSpecies");

                digir_ScientificName = rs.getString("ScientificName");
                digir_Kingdom = getTaxonomy(rs.getString("Taxonomy"), "Kingdom");
                digir_Phylum = getTaxonomy(rs.getString("Taxonomy"), "Phylum");
                digir_Class = getTaxonomy(rs.getString("Taxonomy"), "Class");
                digir_Order = getTaxonomy(rs.getString("Taxonomy"), "Order");
                digir_Family = getTaxonomy(rs.getString("Taxonomy"), "Family");
                digir_Genus = rs.getString("Genus");
                digir_ScientificNameAuthor = rs.getString("ScientificNameAuthor");
                digir_Country = "NULL";
                digir_DecimalLatitude = "NULL";
                digir_DecimalLongitude = "NULL";
                digir_YearCollected = "NULL";
                digir_MonthCollected = "NULL";
                digir_DayCollected = "NULL";
                digir_RelatedInformation = "http://eunis.eea.europa.eu/species/"
                    + rs.getString("IdSpecies");
                digir_CatalogNumber = digir_ScientificName + "SPECHAB";

                loadDigirRecord();
            }

            query = "SELECT DISTINCT CHM62EDT_SPECIES.ID_SPECIES AS IdSpecies, CHM62EDT_SPECIES.SCIENTIFIC_NAME AS ScientificName, "
                + "CHM62EDT_SPECIES.GENUS AS Genus, CHM62EDT_SPECIES.AUTHOR AS ScientificNameAuthor, "
                + "CHM62EDT_TAXONOMY.TAXONOMY_TREE AS Taxonomy, CHM62EDT_GRID.LATITUDE AS Latitude, CHM62EDT_GRID.LONGITUDE AS Longitude "
                + "FROM CHM62EDT_SPECIES "
                + "INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE ON (CHM62EDT_SPECIES.ID_NATURE_OBJECT = CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_REPORT_TYPE ON (CHM62EDT_NATURE_OBJECT_REPORT_TYPE.ID_REPORT_TYPE = CHM62EDT_REPORT_TYPE.ID_REPORT_TYPE) "
                + "INNER JOIN CHM62EDT_GRID ON (CHM62EDT_REPORT_TYPE.ID_LOOKUP = CHM62EDT_GRID.NAME) "
                + "INNER JOIN CHM62EDT_TAXONOMY ON (CHM62EDT_SPECIES.ID_TAXONOMY = CHM62EDT_TAXONOMY.ID_TAXONOMY) "
                + "WHERE (CHM62EDT_REPORT_TYPE.LOOKUP_TYPE = 'GRID')";

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {

                if (rs.getRow() % 5000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Load DIGIR data phase 4/5 at row: " + rs.getRow(), cmd, sql);
                }

                digir_GlobalUniqueIdentifier = "urn:catalog:EUNIS2:SPECGRID:"
                    + rs.getString("IdSpecies");

                digir_ScientificName = rs.getString("ScientificName");
                digir_Kingdom = getTaxonomy(rs.getString("Taxonomy"), "Kingdom");
                digir_Phylum = getTaxonomy(rs.getString("Taxonomy"), "Phylum");
                digir_Class = getTaxonomy(rs.getString("Taxonomy"), "Class");
                digir_Order = getTaxonomy(rs.getString("Taxonomy"), "Order");
                digir_Family = getTaxonomy(rs.getString("Taxonomy"), "Family");
                digir_Genus = rs.getString("Genus");
                digir_ScientificNameAuthor = rs.getString("ScientificNameAuthor");
                digir_Country = "NULL";
                digir_DecimalLatitude = rs.getString("Latitude") != null
                ? rs.getString("Latitude")
                        : "0";
                digir_DecimalLongitude = rs.getString("Longitude") != null
                ? rs.getString("Longitude")
                        : "0";
                digir_YearCollected = "NULL";
                digir_MonthCollected = "NULL";
                digir_DayCollected = "NULL";
                digir_RelatedInformation = "http://eunis.eea.europa.eu/species/"
                    + rs.getString("IdSpecies");
                digir_CatalogNumber = digir_ScientificName + "SPECGRID"
                + digir_DecimalLatitude + digir_DecimalLongitude;

                loadDigirRecord();
            }

            query = "SELECT DISTINCT CHM62EDT_SPECIES.ID_SPECIES AS IdSpecies, CHM62EDT_SPECIES.SCIENTIFIC_NAME AS ScientificName, "
                + "CHM62EDT_SPECIES.GENUS AS Genus, CHM62EDT_SPECIES.AUTHOR AS ScientificNameAuthor, "
                + "CHM62EDT_TAXONOMY.TAXONOMY_TREE AS Taxonomy, CHM62EDT_COUNTRY.AREA_NAME AS Country "
                + "FROM CHM62EDT_SPECIES "
                + "INNER JOIN CHM62EDT_REPORTS ON (CHM62EDT_SPECIES.ID_NATURE_OBJECT = CHM62EDT_REPORTS.ID_NATURE_OBJECT) "
                + "INNER JOIN CHM62EDT_COUNTRY ON (CHM62EDT_REPORTS.ID_GEOSCOPE = CHM62EDT_COUNTRY.ID_GEOSCOPE) "
                + "INNER JOIN CHM62EDT_REPORT_TYPE ON (CHM62EDT_REPORTS.ID_REPORT_TYPE = CHM62EDT_REPORT_TYPE.ID_REPORT_TYPE) "
                + "INNER JOIN CHM62EDT_TAXONOMY ON (CHM62EDT_SPECIES.ID_TAXONOMY = CHM62EDT_TAXONOMY.ID_TAXONOMY) "
                + "WHERE (CHM62EDT_REPORT_TYPE.LOOKUP_TYPE = 'CONSERVATION_STATUS')";

            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {

                if (rs.getRow() % 5000 == 0) {
                    System.gc();
                    EunisUtil.writeLogMessage("Load DIGIR data phase 5/5 at row: " + rs.getRow(), cmd, sql);
                }

                digir_GlobalUniqueIdentifier = "urn:catalog:EUNIS2:SPECSTAT:"
                    + rs.getString("IdSpecies");

                digir_ScientificName = rs.getString("ScientificName");
                digir_Kingdom = getTaxonomy(rs.getString("Taxonomy"), "Kingdom");
                digir_Phylum = getTaxonomy(rs.getString("Taxonomy"), "Phylum");
                digir_Class = getTaxonomy(rs.getString("Taxonomy"), "Class");
                digir_Order = getTaxonomy(rs.getString("Taxonomy"), "Order");
                digir_Family = getTaxonomy(rs.getString("Taxonomy"), "Family");
                digir_Genus = rs.getString("Genus");
                digir_ScientificNameAuthor = rs.getString("ScientificNameAuthor");
                digir_Country = rs.getString("Country");
                digir_DecimalLatitude = "NULL";
                digir_DecimalLongitude = "NULL";
                digir_YearCollected = "NULL";
                digir_MonthCollected = "NULL";
                digir_DayCollected = "NULL";
                digir_RelatedInformation = "http://eunis.eea.europa.eu/species/"
                    + rs.getString("IdSpecies");
                digir_CatalogNumber = digir_ScientificName + "SPECSTAT"
                + digir_Country;

                loadDigirRecord();
            }

            if (!(counter % 10000 == 0)) {
                digirRecordPreparedStatement.executeBatch();
                digirRecordPreparedStatement.clearParameters();
                System.gc();
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.toString(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (rs != null) {
                rs.close();
            }
        }

    }

    private String getTaxonomy(String inputData, String inputRequired) {
        int pos_start, pos_end = 0;
        int pos = 0;
        String ret = "";

        pos_start = inputData.indexOf(inputRequired + "*");
        if (pos_start > 0) {
            pos = inputData.indexOf("*", pos_start + inputRequired.length() + 2);
            if (pos > 0) {
                pos_end = inputData.indexOf(",",
                        pos_start + inputRequired.length() + 2);
                ret = inputData.substring(pos_start + inputRequired.length() + 1,
                        pos_end);
            } else {
                ret = inputData.substring(pos_start + inputRequired.length() + 1);
            }
        }
        return ret;
    }
}
