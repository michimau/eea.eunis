package ro.finsiel.eunis.dataimport.parsers;

import eionet.eunis.util.Constants;
import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import ro.finsiel.eunis.dataimport.parsers.CallbackSAXParser.SaxCallback;
import ro.finsiel.eunis.dataimport.parsers.CallbackSAXParser.Values;

/**
 * Implementation of Natura 2000 import using Callback SAX Parser
 */
public class Natura2000ParserCallback {

    private static final Map<String, String> designationsMapping = new HashMap<String, String>();
    static {
        designationsMapping.put("A", "IN08");
        designationsMapping.put("B", "IN09");
        designationsMapping.put("C", "IN12");
        designationsMapping.put("D", "IN08");
        designationsMapping.put("E", "IN09");
        designationsMapping.put("F", "IN08");
        designationsMapping.put("G", "IN09");
        designationsMapping.put("H", "IN08");
        designationsMapping.put("I", "IN09");
        designationsMapping.put("J", "IN08");
        designationsMapping.put("K", "IN09");
    }

    private final SQLUtilities sqlUtilities;
    private Connection con;

    /**
     * Constructor
     * @param sqlUtilities DB access object
     */
    public Natura2000ParserCallback(SQLUtilities sqlUtilities) {
        this.sqlUtilities = sqlUtilities;
        this.con = sqlUtilities.getConnection();
        this.errors = new ArrayList<String>();
    }

    private PreparedStatement preparedStatementNatObject;
    private PreparedStatement preparedStatementSiteInsert;
    private PreparedStatement preparedStatementNatObjectReportType;
    private PreparedStatement preparedStatementNatObjectGeoscope;
    private PreparedStatement preparedStatementReportAttribute;
    private PreparedStatement preparedStatementSiteSites;
    private PreparedStatement preparedStatementSiteAttribute;
    private PreparedStatement preparedStatementSiteRelatedDesignations;
    private PreparedStatement preparedStatementReportType;
    private PreparedStatement preparedStatementUpdateManager;

    private int maxNoIdInt = 0;
    private int maxReportAttributeId = 0;
    private int maxReportTypeId = 0;
    private int siteDescriptionHabClassCodeCnt;

    private String siteNatureObjectId;
    private String siteCode;
    private String geoscopeId;

    private List<String> errors;

    /**
     * Debug, prints the call and value; mapped with "*" will print all the XML document's data
     */
//    @SaxCallback("*")
    public void callDebugPrint(String path, Values values){
        System.out.println("  CALL(" + path +") = " + values.get(path));
    }

    /**
     * Init the site code and DB cleanup
     */
    @SaxCallback("Natura2000-SDF.SiteIdentification.SiteCode")
    public void callSiteCode(String path, Values values) throws Exception {
        siteCode = values.get(path);
        getSiteNatObjectId();
        deleteOldRecords();
        setSitesTab(siteNatureObjectId, Constants.SITES_TAB_GENERAL);
    }

    /**
     * Callback for adminitrative region, writes the NutsCode and NutsCover data
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteLocation.AdministrativeRegion")
    public void callAdminRegion(String path, Values values) throws Exception {
        String nutsCode = values.getFromCurrent("NutsCode");
        String nutsCover = values.getFromCurrent("NutsCover");

        if (nutsCode != null && nutsCode.length() > 0 && nutsCover != null && nutsCover.length() > 0) {
            boolean regionExists = regionExists(nutsCode);

            if (regionExists) {
                maxReportTypeId++;
                maxReportAttributeId++;
                insertNatObjectReportType(siteNatureObjectId, "-1", -1, maxReportTypeId, maxReportAttributeId, -1);

                preparedStatementReportType.setInt(1, maxReportTypeId);
                preparedStatementReportType.setString(2, nutsCode);
                preparedStatementReportType.setString(3, "REGION_CODE");
                preparedStatementReportType.executeUpdate();

                insertReportAttribute("COVER", "NUMBER", nutsCover);

            } else {
                System.out.println(" Warning! AdministrativeRegion with code " + nutsCode + " doesn't exist!");
            }
        }

    }

    /**
     * Callback for BioDescription
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteLocation.BiogeograpichRegion.BioDescription")
    public void callBioDescription(String path, Values values) throws Exception {
        String bioRegion = values.get(path);

        if (bioRegion != null && bioregionExists(bioRegion)) {
            insertSiteAttribute(siteCode, bioRegion.toUpperCase(), "BOOLEAN", "TRUE", "sdfxml");
        } else {
            System.out.println(" Warning! BioRegion '" + bioRegion + "' doesn't exist!");
        }
    }

    /**
     * Callback for document end; commit and close the connection
     * @param exceptions List of exceptions caought by the parser
     * @throws Exception
     */
    @SaxCallback({">end"})
    public void callFinal(List<Exception> exceptions) throws Exception {
        System.out.println("Finished site " + siteCode);
        // exceptions during load
        // add the site id at the top of the exceptions list
        // todo add the local errors to the list?
        if(exceptions.size() > 0){
            try {
                if (siteCode != null) {
                    exceptions.add(0, new Exception("Error! Site ID: " + siteCode));
                }
                con.rollback();
            } catch(SQLException e){
                exceptions.add(e);
            }
        }  else {
            try{
                con.commit();
            } catch(SQLException e){
                exceptions.add(e);
            }
        }

        if (preparedStatementNatObject != null) {
            preparedStatementNatObject.close();
        }
        if (preparedStatementSiteInsert != null) {
            preparedStatementSiteInsert.close();
        }
        if (preparedStatementNatObjectReportType != null) {
            preparedStatementNatObjectReportType.close();
        }
        if (preparedStatementNatObjectGeoscope != null) {
            preparedStatementNatObjectGeoscope.close();
        }
        if (preparedStatementReportAttribute != null) {
            preparedStatementReportAttribute.close();
        }
        if (preparedStatementSiteSites != null) {
            preparedStatementSiteSites.close();
        }
        if (preparedStatementSiteAttribute != null) {
            preparedStatementSiteAttribute.close();
        }
        if (preparedStatementSiteRelatedDesignations != null) {
            preparedStatementSiteRelatedDesignations.close();
        }
        if (preparedStatementReportType != null) {
            preparedStatementReportType.close();
        }
        if (preparedStatementUpdateManager != null) {
            preparedStatementUpdateManager.close();
        }

        if (con != null) {
            con.close();
        }

    }

    /**
     * Writes the Site table
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteLocation")
    public void callSiteLocation(String path, Values values) throws Exception {

        String siteType = values.get("Natura2000-SDF.SiteIdentification.SiteType");
        String siteDesignation = null;
        // Resolve site designation
        if (siteType != null && siteType.length() > 0) {
            siteDesignation = designationsMapping.get(siteType);
        }

        preparedStatementNatObject.setString(1, siteNatureObjectId);
        preparedStatementNatObject.setString(2, siteCode);
        preparedStatementNatObject.executeUpdate();

        preparedStatementSiteInsert.setString(1, siteCode);
        preparedStatementSiteInsert.setString(2, siteNatureObjectId);
        preparedStatementSiteInsert.setString(3, values.get("Natura2000-SDF.SiteIdentification.SiteName"));
        preparedStatementSiteInsert.setString(4, parseDate(values.get("Natura2000-SDF.SiteIdentification.Date_Compilation")));
        preparedStatementSiteInsert.setString(5, parseDate(values.get("Natura2000-SDF.SiteIdentification.Date_Update")));
        preparedStatementSiteInsert.setString(6, parseDate(values.get("Natura2000-SDF.SiteIdentification.Date_Spa")));
        preparedStatementSiteInsert.setString(7, values.get("Natura2000-SDF.SiteIdentification.Respondent"));
        preparedStatementSiteInsert.setString(8, values.get("Natura2000-SDF.SiteIdentification.Description"));
        preparedStatementSiteInsert.setString(9, values.get("Natura2000-SDF.SiteLocation.Latitude"));
        preparedStatementSiteInsert.setString(10, values.get("Natura2000-SDF.SiteLocation.Longitude"));
        preparedStatementSiteInsert.setString(11, values.get("Natura2000-SDF.SiteLocation.AreaHA"));
        preparedStatementSiteInsert.setString(12, values.get("Natura2000-SDF.SiteLocation.Altitude_Min"));
        preparedStatementSiteInsert.setString(13, values.get("Natura2000-SDF.SiteLocation.Altitude_Max"));
        preparedStatementSiteInsert.setString(14, values.get("Natura2000-SDF.SiteLocation.Altitude_Mean"));
        preparedStatementSiteInsert.setString(15, "NATURA2000");
        preparedStatementSiteInsert.setString(16, "80");
        preparedStatementSiteInsert.setString(17, siteDesignation);

        String lengthKm = values.get("Natura2000-SDF.SiteLocation.LengthKM");

        try {
            if(lengthKm!= null){
                double length = Double.parseDouble(lengthKm);
                length = length * 1000;
                lengthKm = Double.toString(length);
            }
        } catch (NumberFormatException e){
            errors.add("Length " + lengthKm + " is unparseable!");
        }

        if (lengthKm != null && lengthKm.length() > 0) {
            preparedStatementSiteInsert.setString(18, lengthKm);
        } else {
            preparedStatementSiteInsert.setNull(18, Types.DECIMAL);
        }
        preparedStatementSiteInsert.executeUpdate();

        geoscopeId = getGeoscopeId();
        preparedStatementNatObjectGeoscope.setString(1, siteNatureObjectId);
        preparedStatementNatObjectGeoscope.setString(2, geoscopeId);
        preparedStatementNatObjectGeoscope.executeUpdate();

        insertSiteAttribute(siteCode, "TYPE", "TEXT", siteType, "sdfxml");
    }

    /**
     * Inserts a habitat
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.EcologicalInformation.EcologicalInformation31.Habitat")
    public void callHabitat(String path, Values values) throws Exception {
        String habitatCode = values.getFromCurrent("HCode");
        String habitatCover = values.getFromCurrent("HCover");
        String habitatRepresentatity = values.getFromCurrent("HRepresentatity");
        String habitatRelsurface = values.getFromCurrent("HRelsurface");
        String habitatConsStatus = values.getFromCurrent("HConsStatus");
        String habitatGlobalAssesment = values.getFromCurrent("HGlobalAssesment");

        if (habitatCode != null) {
            String habitatIdNatObject = getHabitatNatObjectId(habitatCode);

            if (habitatIdNatObject != null && habitatIdNatObject.length() > 0) {

                maxReportAttributeId++;

                insertNatObjectReportType(siteNatureObjectId, habitatIdNatObject, -1, -1, maxReportAttributeId, -1);


                setSitesTab(siteNatureObjectId, Constants.SITES_TAB_HABITAT_TYPES);
                setHabitatTabSites(habitatIdNatObject);

                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_SOURCE_TABLE, "TEXT", "habit2");
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_COVER, "TEXT", habitatCover);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_REPRESENTATIVITY, "TEXT", habitatRepresentatity);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_RELATIVE_SURFACE, "TEXT", habitatRelsurface);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_CONSERVATION, "TEXT", habitatConsStatus);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_HABITAT_GLOBAL, "TEXT", habitatGlobalAssesment);

                preparedStatementReportAttribute.executeBatch();
                preparedStatementReportAttribute.clearParameters();

            } else {
                batchSiteAttribute(siteCode, "HABITAT_CODE_" + habitatCode, "TEXT", habitatCode, "habit2");
                batchSiteAttribute(siteCode, "HABITAT_COVER_" + habitatCode, "NUMBER", habitatCover, "habit2");
                batchSiteAttribute(siteCode, "HABITAT_REPRESENTATIVITY_" + habitatCode, "NUMBER", habitatRepresentatity, "habit2");
                batchSiteAttribute(siteCode, "HABITAT_RELATIVE_SURFACE_" + habitatCode, "NUMBER", habitatRelsurface, "habit2");
                batchSiteAttribute(siteCode, "HABITAT_CONSERVATION_" + habitatCode, "TEXT", habitatConsStatus, "habit2");
                batchSiteAttribute(siteCode, "HABITAT_GLOBAL_" + habitatCode, "TEXT", habitatGlobalAssesment, "habit2");

                preparedStatementSiteAttribute.executeBatch();
                preparedStatementSiteAttribute.clearParameters();
            }
        }
    }

    /**
     * Writes species
     * @throws Exception
     */
    @SaxCallback({"Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32A.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32B.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32C.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32D.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32E.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32F.SpeciesList.Species",
            "Natura2000-SDF.EcologicalInformation.EcologicalInformation32.EcologicalInformation32G.SpeciesList.Species"})
    public void callSpecies(String path, Values values) throws Exception {
        String speciesCode = values.getFromCurrent("SpeciesCode");
        String speciesName = values.getFromCurrent("SpeciesName");
        String speciesWinter = values.getFromCurrent("Winter");
        String speciesPopulation = values.getFromCurrent("Population");
        String speciesIsolation = values.getFromCurrent("IsolationFactor");
        String speciesConservation = values.getFromCurrent("Conservation");
        String speciesGlobal = values.getFromCurrent("GlobalImportance");
        String speciesResident = values.getFromCurrent("Resident");
        String speciesStaging = values.getFromCurrent("Staging");
        String speciesBreeding = values.getFromCurrent("Breeding");

        String ecoInfo = null;
        if (path.contains("EcologicalInformation32A")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_BIRD;
        } else if (path.contains("EcologicalInformation32B")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_MAMMAL;
        } else if (path.contains("EcologicalInformation32C")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_AMPREP;
        } else if (path.contains("EcologicalInformation32D")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_FISHES;
        } else if (path.contains("EcologicalInformation32E")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_INVERT;
        } else if (path.contains("EcologicalInformation32F")) {
            ecoInfo = Constants.N2000_SPECIES_GROUP_PLANT;
        }

        if (speciesCode != null) {
            String speciesIdNatObject = getSpeciesNatObjectId(speciesCode);

            if (speciesIdNatObject != null && speciesIdNatObject.length() > 0) {

                if (ecoInfo == null || ecoInfo.length() == 0) {
                    ecoInfo = Constants.N2000_SPECIES_GROUP_BIRD;
                }

                maxReportAttributeId++;
                insertNatObjectReportType(siteNatureObjectId, speciesIdNatObject, -1, -1, maxReportAttributeId, -1);

                setSitesTab(siteNatureObjectId, Constants.SITES_TAB_FAUNA_FLORA);
                setSpeciesTabSites(speciesIdNatObject);

                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_RESIDENT, "TEXT", speciesResident);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_POPULATION, "TEXT", speciesPopulation);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_CONSERVATION, "TEXT", speciesConservation);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_ISOLATION, "TEXT", speciesIsolation);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_GLOBAL, "TEXT", speciesGlobal);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_STAGING, "TEXT", speciesStaging);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_WINTER, "TEXT", speciesWinter);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_BREEDING, "TEXT", speciesBreeding);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_OTHER_SPECIES, "TEXT", speciesBreeding);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_BREEDING, "TEXT", "False");
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_SOURCE_TABLE, "TEXT", ecoInfo);

                preparedStatementReportAttribute.executeBatch();
                preparedStatementReportAttribute.clearParameters();
            } else {
                batchSiteAttribute(siteCode, "OTHER_SPECIES_" + speciesName, "TEXT", speciesName, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_RESIDENT_" + speciesName, "TEXT", speciesResident, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_POPULATION_" + speciesName, "TEXT", speciesPopulation, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_BREEDING_" + speciesName, "TEXT", speciesBreeding, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_WINTERING_" + speciesName, "TEXT", speciesWinter, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_STAGING_" + speciesName, "TEXT", speciesStaging, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_CONSERVATION_" + speciesName, "TEXT", speciesConservation, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_ISOLATION_" + speciesName, "TEXT", speciesIsolation, "spec");
                batchSiteAttribute(siteCode, "OTHER_SPECIES_GLOBAL_" + speciesName, "TEXT", speciesGlobal, "spec");
                preparedStatementSiteAttribute.executeBatch();
                preparedStatementSiteAttribute.clearParameters();
            }
        }
    }

    /**
     * Writes other species
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.EcologicalInformation.EcologicalInformation33.OtherSpeciesList.OtherSpecies")
    public void callOtherSpecies(String path, Values values) throws Exception {
        String otherSpeciesSciName = values.getFromCurrent("SciName");
        String otherSpeciesPopulation = values.getFromCurrent("Population");
        String otherSpeciesMotivation = values.getFromCurrent("Motivation");
        String otherSpeciesGroup = values.getFromCurrent("Group");

        if (otherSpeciesSciName != null && otherSpeciesSciName.length() > 0) {

            String speciesIdNatObject = getSpeciesNatObjectIdByName(otherSpeciesSciName);

            if (speciesIdNatObject != null && speciesIdNatObject.length() > 0) {

                maxReportAttributeId++;
                insertNatObjectReportType(siteNatureObjectId, speciesIdNatObject, -1, -1, maxReportAttributeId, -1);

                setSitesTab(siteNatureObjectId, Constants.SITES_TAB_FAUNA_FLORA);
                setSpeciesTabSites(speciesIdNatObject);

                batchReportAttribute(Constants.REPORT_ATTRIBUTE_SPECIES_SOURCE_TABLE, "TEXT", "spec");
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_OTHER_SPECIES_MOTIVATION, "TEXT", otherSpeciesMotivation);
                batchReportAttribute(Constants.REPORT_ATTRIBUTE_OTHER_SPECIES_POPULATION, "TEXT", otherSpeciesPopulation);

                preparedStatementReportAttribute.executeBatch();
                preparedStatementReportAttribute.clearParameters();

            } else {
                batchSiteAttribute(siteCode, "OTHER_SPECIES_" + otherSpeciesSciName, "TEXT", "spec", "spec" );
                setSitesTab(siteNatureObjectId, Constants.SITES_TAB_FAUNA_FLORA);

                batchSiteAttribute(siteCode, "OTHER_SPECIES_TAXGROUP_" + otherSpeciesSciName, "TEXT", otherSpeciesGroup, "spec" );
                batchSiteAttribute(siteCode, "OTHER_SPECIES_POPULATION_" + otherSpeciesSciName, "TEXT", otherSpeciesPopulation, "spec" );
                batchSiteAttribute(siteCode, "OTHER_SPECIES_MOTIVATION_" + otherSpeciesSciName, "TEXT", otherSpeciesMotivation, "spec" );

                preparedStatementSiteAttribute.executeBatch();
                preparedStatementSiteAttribute.clearParameters();
            }
        }
    }

    /**
     * Writes habitat classes
     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteDescription.HabitatClasses")
    public void callHabitatClasses(String path, Values values) throws Exception {
        String siteDescriptionHabClassDesc = values.getFromCurrent("Description");
        String siteDescriptionHabClassCover = values.getFromCurrent("Cover");

        if (siteDescriptionHabClassDesc != null && siteDescriptionHabClassCover != null) {
            insertSiteDescriptionHabitatClasses(siteDescriptionHabClassDesc, siteCode, siteDescriptionHabClassCover);
        }
    }

    /**
     * Writes site attributes
     * Change from the previus version: doesn't write if null
     * @throws Exception
     */
    @SaxCallback({"Natura2000-SDF.SiteDescription.OtherCharacteristics",
            "Natura2000-SDF.SiteDescription.QualityImportance",
            "Natura2000-SDF.SiteDescription.Vulnerability",
            "Natura2000-SDF.SiteDescription.SiteDesignation",
            "Natura2000-SDF.SiteDescription.Documentation"})
    public void callSiteAttribute(String path, Values values) throws Exception {
        String content = values.get(path);
        if (path.endsWith("OtherCharacteristics")) {
            insertSiteAttribute(siteCode, "HABITAT_CHARACTERIZATION", "TEXT", content, "habit2");
        } else if (path.endsWith("QualityImportance")) {
            insertSiteAttribute(siteCode, "QUALITY", "TEXT", content, "habit2");
        } else if (path.endsWith("Vulnerability")) {
            insertSiteAttribute(siteCode, "VULNERABILITY", "TEXT", content, "habit2");
        } else if (path.endsWith("SiteDesignation")) {
            insertSiteAttribute(siteCode, "SITE_DESIGNATION", "TEXT", content, "habit2");
        } else if (path.endsWith("Documentation")) {
            insertSiteAttribute(siteCode, "DOCUMENTATION", "TEXT", content, "habit2");
        }
    }

    /**
     * Writes designation types

     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteProtection.DesignationTypes")
    public void callDesignationTypes(String path, Values values) throws Exception {
        String siteProtectionDesigTypeCode = values.getFromCurrent("Code");
        String siteProtectionDesigTypeCover = values.getFromCurrent("Cover");

        if (siteProtectionDesigTypeCode != null && siteProtectionDesigTypeCover != null) {
            preparedStatementSiteRelatedDesignations.setString(1, siteCode);
            preparedStatementSiteRelatedDesignations.setString(2, siteProtectionDesigTypeCode);
            preparedStatementSiteRelatedDesignations.setString(3, geoscopeId);
            preparedStatementSiteRelatedDesignations.setString(4, siteProtectionDesigTypeCover);

            preparedStatementSiteRelatedDesignations.executeUpdate();

            setSitesTab(siteNatureObjectId, Constants.SITES_TAB_DESIGNATION);
        }
    }

    /**
     * Writes the site manager

     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteImpacts.SiteManagement.Responsible")
    public void callResponsible(String path, Values values) throws Exception {
        preparedStatementUpdateManager.setString(1, values.get(path));
        preparedStatementUpdateManager.setString(2, siteCode);
        preparedStatementUpdateManager.executeUpdate();
    }

    /**
     * Within / around site

     * @throws Exception
     */
    @SaxCallback({"Natura2000-SDF.SiteImpacts.WithinSite",
            "Natura2000-SDF.SiteImpacts.AroundSite"})
    public void callWithinAroundSite(String path, Values values) throws Exception {
        String siteImpactsCode = values.getFromCurrent("Code");
        String siteImpactsIntensity = values.getFromCurrent("Intensity");
        String siteImpactsInfluence = values.getFromCurrent("Influence");
        String siteImpactsPercent = values.getFromCurrent("Percent");

        if (siteImpactsCode != null && siteImpactsCode.length() > 0) {

            maxReportTypeId++;
            preparedStatementReportType.setInt(1, maxReportTypeId);
            preparedStatementReportType.setString(2, siteImpactsCode);
            preparedStatementReportType.setString(3, "HUMAN_ACTIVITY");
            preparedStatementReportType.executeUpdate();

            maxReportAttributeId++;

            batchReportAttribute("IN_OUT", "TEXT", (path.endsWith("WithinSite") ? "I" : "O"));
            batchReportAttribute("INTENSITY", "TEXT", siteImpactsIntensity);
            batchReportAttribute("INFLUENCE", "TEXT", siteImpactsInfluence);
            batchReportAttribute("COVER", "NUMBER", siteImpactsPercent);

            preparedStatementReportAttribute.executeBatch();
            preparedStatementReportAttribute.clearParameters();

            insertNatObjectReportType(siteNatureObjectId,"-1", -1, maxReportTypeId, maxReportAttributeId, -1);

            setSitesTab(siteNatureObjectId, Constants.SITES_TAB_OTHER_INFO);
        }
    }

    /**
     * Writes other site code
     * Needs to be called after siteCode is initialized

     * @throws Exception
     */
    @SaxCallback("Natura2000-SDF.SiteIdentification.OtherSiteCode")
    public void callOtherSiteCode(String path, Values values) throws  Exception {
        String code = values.get(path);

        if (code != null && code.length() > 0) {
            preparedStatementSiteSites.setString(1, siteCode);
            preparedStatementSiteSites.setString(2, code);
            preparedStatementSiteSites.setString(3, "=");
            preparedStatementSiteSites.executeUpdate();

            setSitesTab(siteNatureObjectId, Constants.SITES_TAB_SITES);
        }
    }



    private boolean regionExists(String regionCode) {
        boolean ret = false;
        String query = "SELECT ID_REGION_CODE FROM chm62edt_region_codes WHERE ID_REGION_CODE = '" + regionCode + "'";
        String rcId = sqlUtilities.ExecuteSQL(query);

        if (rcId != null && rcId.length() > 0) {
            ret = true;
        }

        return ret;
    }

    private void getSiteNatObjectId() {
        String query = "SELECT ID_NATURE_OBJECT FROM chm62edt_sites WHERE ID_SITE='" + siteCode + "'";

        siteNatureObjectId = sqlUtilities.ExecuteSQL(query);
        if (siteNatureObjectId == null || siteNatureObjectId.length() == 0) {
            maxNoIdInt++;
            siteNatureObjectId = Integer.toString(maxNoIdInt);
        }
    }

    private void deleteOldRecords() throws Exception {

        PreparedStatement ps = null;

        try {

            String query = "DELETE FROM chm62edt_site_attributes WHERE ID_SITE = ?";

            ps = con.prepareStatement(query);
            ps.setString(1, siteCode);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_sites_sites WHERE ID_SITE = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteCode);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_sites_related_designations WHERE ID_SITE = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteCode);
            ps.executeUpdate();

            query = "DELETE ST FROM chm62edt_report_attributes AS ST, chm62edt_nature_object_report_type AS TT " +
                    "WHERE ST.ID_REPORT_ATTRIBUTES = TT.ID_REPORT_ATTRIBUTES AND TT.ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE ST FROM chm62edt_report_attributes AS ST, chm62edt_nature_object_geoscope AS TT " +
                    "WHERE ST.ID_REPORT_ATTRIBUTES = TT.ID_REPORT_ATTRIBUTES AND TT.ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_nature_object_geoscope WHERE ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE ST FROM chm62edt_report_attributes AS ST, chm62edt_reports AS TT " +
                    "WHERE ST.ID_REPORT_ATTRIBUTES = TT.ID_REPORT_ATTRIBUTES AND TT.ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_reports WHERE ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_sites WHERE ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

            query = "DELETE FROM chm62edt_nature_object WHERE ID_NATURE_OBJECT = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, siteNatureObjectId);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
        }
    }

    private void setSitesTab(String idNatureObject, String tabName) throws Exception {
        PreparedStatement ps = null;

        try {
            if (tabName.equals(Constants.SITES_TAB_GENERAL)) {
                String query = "INSERT IGNORE INTO chm62edt_tab_page_sites(ID_NATURE_OBJECT,GENERAL_INFORMATION) VALUES(?,'Y')";

                ps = con.prepareStatement(query);
            } else {
                String query = "UPDATE chm62edt_tab_page_sites SET " + tabName + "='Y' WHERE ID_NATURE_OBJECT=?";

                ps = con.prepareStatement(query);
            }
            ps.setString(1, idNatureObject);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
        }

    }

    @SaxCallback(">start")
    public void init() throws Exception{

        maxNoIdInt = getMaxId("SELECT MAX(ID_NATURE_OBJECT) FROM chm62edt_nature_object");
        maxReportAttributeId = getMaxId("SELECT MAX(ID_REPORT_ATTRIBUTES) FROM chm62edt_report_attributes");
        maxReportTypeId = getMaxId("SELECT MAX(ID_REPORT_TYPE) FROM chm62edt_report_type");

        String queryNatObject =
                "INSERT INTO chm62edt_nature_object (ID_NATURE_OBJECT, ORIGINAL_CODE, ID_DC, TYPE) VALUES (?,?, -1, 'NATURA2000_SITES')";
        this.preparedStatementNatObject = con.prepareStatement(queryNatObject);

        String querySiteInsert =
                "INSERT INTO chm62edt_sites (ID_SITE, ID_NATURE_OBJECT, NAME, COMPILATION_DATE, "
                        + "COMPLEX_NAME, DISTRICT_NAME, "
                        + "UPDATE_DATE, SPA_DATE, RESPONDENT, DESCRIPTION, LATITUDE, "
                        + "LONGITUDE, AREA, ALT_MIN, ALT_MAX, ALT_MEAN, SOURCE_DB, "
                        + "ID_GEOSCOPE, ID_DESIGNATION, LENGTH) VALUES "
                        + "(?,?,?,?,'','',?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        this.preparedStatementSiteInsert = con.prepareStatement(querySiteInsert);

        String queryUpdateManager = "UPDATE chm62edt_sites SET MANAGER = ? WHERE ID_SITE = ?";
        this.preparedStatementUpdateManager = con.prepareStatement(queryUpdateManager);

        String insertNatObjectReportType = "INSERT IGNORE INTO chm62edt_nature_object_report_type "
                + "(ID_NATURE_OBJECT, ID_NATURE_OBJECT_LINK, ID_GEOSCOPE, ID_REPORT_TYPE, ID_REPORT_ATTRIBUTES, ID_DC) "
                + "VALUES (?,?,?,?,?,?)";
        this.preparedStatementNatObjectReportType = con.prepareStatement(insertNatObjectReportType);

        String insertNatObjectGeoscope = "INSERT IGNORE INTO chm62edt_nature_object_geoscope "
                + "(ID_NATURE_OBJECT, ID_NATURE_OBJECT_LINK, ID_DC, ID_GEOSCOPE, ID_REPORT_ATTRIBUTES) "
                + "VALUES (?,-1,-1,?,-1)";
        this.preparedStatementNatObjectGeoscope = con.prepareStatement(insertNatObjectGeoscope);

        String insertReportAttribute = "INSERT IGNORE INTO chm62edt_report_attributes "
                + "(ID_REPORT_ATTRIBUTES, NAME, TYPE, VALUE) VALUES (?,?,?,?)";
        this.preparedStatementReportAttribute = con.prepareStatement(insertReportAttribute);

        String insertSiteSites = "INSERT IGNORE INTO chm62edt_sites_sites "
                + "(ID_SITE, ID_SITE_LINK, SEQUENCE, RELATION_TYPE, WITHIN_PROJECT, SOURCE_TABLE) "
                + "VALUES (?,?,-1,?,1,'sitrel')";
        this.preparedStatementSiteSites = con.prepareStatement(insertSiteSites);

        String insertSiteAttribute = "INSERT IGNORE INTO chm62edt_site_attributes "
                + "(ID_SITE, NAME, TYPE, VALUE, SOURCE_DB, SOURCE_TABLE) VALUES (?,?,?,?,'NATURA2000',?)";
        this.preparedStatementSiteAttribute = con.prepareStatement(insertSiteAttribute);

        String insertSiteRelatedDesignations = "INSERT IGNORE INTO chm62edt_sites_related_designations "
                + "(ID_SITE, ID_DESIGNATION, ID_GEOSCOPE, SEQUENCE, OVERLAP_TYPE, OVERLAP, SOURCE_DB, SOURCE_TABLE) "
                + "VALUES (?,?,?,-1,-1,?,'NATURA2000','desigc')";
        this.preparedStatementSiteRelatedDesignations = con.prepareStatement(insertSiteRelatedDesignations);

        String insertReportType = "INSERT IGNORE INTO chm62edt_report_type (ID_REPORT_TYPE, ID_LOOKUP, LOOKUP_TYPE) VALUES (?,?,?)";
        this.preparedStatementReportType = con.prepareStatement(insertReportType);

        con.setAutoCommit(false);

    }

    private int getMaxId(String query) throws ParseException {
        String maxId = sqlUtilities.ExecuteSQL(query);
        int maxIdInt = 0;

        if (maxId != null && maxId.length() > 0) {
            maxIdInt = new Integer(maxId);
        }

        return maxIdInt;
    }

    private String parseDate(String input) {
        String ret = "";

        if (input != null && input.length() > 0) {
            if (input.contains("T00:00:00")) {
                int end = input.indexOf("T");
                String date = input.substring(0, end);

                ret = date.replace("-", "");
            }
        }
        return ret;
    }

    private boolean bioregionExists(String bioRegionCode) {
        boolean ret = false;
        String query = "SELECT ID_BIOGEOREGION FROM chm62edt_biogeoregion WHERE UPPER(NAME) = '"
                + EunisUtil.replaceTags(bioRegionCode.toUpperCase()) + "'";
        String brId = sqlUtilities.ExecuteSQL(query);

        if (brId != null && brId.length() > 0) {
            ret = true;
        }

        return ret;
    }

    private String getGeoscopeId() {
        String query = "SELECT ID_GEOSCOPE FROM chm62edt_country WHERE ISO_2L = '"
                + siteCode.substring(0, 2) + "' ORDER BY ID_GEOSCOPE";

        return sqlUtilities.ExecuteSQL(query);
    }

    private String getHabitatNatObjectId(String habCode) {
        String query = "SELECT ID_NATURE_OBJECT FROM chm62edt_habitat WHERE CODE_2000='" + habCode + "'";
        return sqlUtilities.ExecuteSQL(query);
    }

    private void setHabitatTabSites(String habitatIdNatureObject) throws Exception {
        PreparedStatement ps = null;

        try {
            String query = "UPDATE chm62edt_tab_page_habitats SET SITES='Y' WHERE ID_NATURE_OBJECT = ?";

            ps = con.prepareStatement(query);
            ps.setString(1, habitatIdNatureObject);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
        }
    }

    private String getSpeciesNatObjectId(String speciesCode) {
        String query = "SELECT ID_NATURE_OBJECT FROM chm62edt_species WHERE CODE_2000='" +speciesCode+"'";
        return sqlUtilities.ExecuteSQL(query);
    }

    private void setSpeciesTabSites(String speciesIdNatureObject) throws Exception {
        PreparedStatement ps = null;

        try {
            String query = "UPDATE chm62edt_tab_page_species SET SITES='Y' WHERE ID_NATURE_OBJECT = ?";

            ps = con.prepareStatement(query);
            ps.setString(1, speciesIdNatureObject);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
        }
    }

    private String getSpeciesNatObjectIdByName(String sciName) {
        String query = "SELECT ID_NATURE_OBJECT FROM chm62edt_species WHERE SCIENTIFIC_NAME='"
                + EunisUtil.replaceTags(sciName) + "'";

        return sqlUtilities.ExecuteSQL(query);
    }

    private void insertSiteDescriptionHabitatClasses(String desc, String siteId, String cover) throws Exception {
        String code_query = "SELECT SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2) AS CODE "
                + "FROM chm62edt_site_attributes WHERE VALUE = '" + desc + "' LIMIT 1";
        String code = sqlUtilities.ExecuteSQL(code_query);

        // If code doesn't exist figure out some test code. XML files doesn't contain habitat code.
        if (code == null || code.length() == 0) {
            code = "XX" + siteDescriptionHabClassCodeCnt;
            siteDescriptionHabClassCodeCnt++;
        }

        if (code != null && code.length() > 0) {
            insertSiteAttribute(siteId, "HABITAT_NAME_EN_" + code, "TEXT", desc, "habit2");
            insertSiteAttribute(siteId, "HABITAT_COVER_" + code, "NUMBER", cover, "habit2");
            insertSiteAttribute(siteId, "HABITAT_CODE_" + code, "TEXT", code, "habit2");
        }
    }

    private void insertSiteAttribute(String siteId, String name, String type, String value, String sourceTable) throws Exception {
        batchSiteAttribute(siteId, name, type, value, sourceTable);
        preparedStatementSiteAttribute.executeBatch();
        preparedStatementSiteAttribute.clearParameters();
    }

    private void batchSiteAttribute(String siteId, String name, String type, String value, String sourceTable) throws Exception {
        if(value!=null) {
            preparedStatementSiteAttribute.setString(1, siteId);
            preparedStatementSiteAttribute.setString(2, name);
            preparedStatementSiteAttribute.setString(3, type);
            preparedStatementSiteAttribute.setString(4, value);
            preparedStatementSiteAttribute.setString(5, sourceTable);
            preparedStatementSiteAttribute.addBatch();
        }
    }

    private void batchReportAttribute(String name, String type, String value) throws Exception {
        if(value != null) {
            preparedStatementReportAttribute.setInt(1, maxReportAttributeId);
            preparedStatementReportAttribute.setString(2, name);
            preparedStatementReportAttribute.setString(3, type);
            preparedStatementReportAttribute.setString(4, value);
            preparedStatementReportAttribute.addBatch();
        }
    }

    private void insertReportAttribute(String name, String type, String value) throws Exception {
        batchReportAttribute(name, type, value);
        preparedStatementReportAttribute.executeBatch();
        preparedStatementReportAttribute.clearParameters();
    }

    private void insertNatObjectReportType(String natureObjectId, String natureObjectLink, int idGeoscope, int reportType, int reportAttributes, int idDc )  throws Exception {
        preparedStatementNatObjectReportType.setString(1, natureObjectId);
        preparedStatementNatObjectReportType.setString(2, natureObjectLink);
        preparedStatementNatObjectReportType.setInt(3, idGeoscope);
        preparedStatementNatObjectReportType.setInt(4, reportType);
        preparedStatementNatObjectReportType.setInt(5, reportAttributes);
        preparedStatementNatObjectReportType.setInt(6, idDc);
        preparedStatementNatObjectReportType.executeUpdate();
    }
}
