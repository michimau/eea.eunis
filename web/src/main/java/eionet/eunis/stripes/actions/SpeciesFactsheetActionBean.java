package eionet.eunis.stripes.actions;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dto.*;
import eionet.eunis.rdf.LinkedData;
import eionet.eunis.stripes.viewdto.SitesByNatureObjectViewDTO;
import eionet.eunis.util.Constants;
import eionet.sparqlClient.helpers.ResultValue;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sourceforge.stripes.action.*;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import ro.finsiel.eunis.factsheet.species.*;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectAttributesDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectAttributesPersist;
import ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.UniqueVector;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.factsheet.PublicationWrapper;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

/**
 * ActionBean for species factsheet. Data is loaded from {@link ro.finsiel.eunis.factsheet.species.SpeciesFactsheet} and
 * {@link ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist}.
 *
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species/{idSpecies}/{tab}")
public class SpeciesFactsheetActionBean extends AbstractStripesAction {

    /** The argument given. Can be a species number or scientific name */
    private String idSpecies;
    private int idSpeciesLink;

    private SpeciesFactsheet factsheet;
    private String scientificName = "";
    private String author = "";

    /**
     * senior synonym name.
     */
    private String seniorSpecies;

    /**
     * senior synonym ID.
     */
    private int seniorIdSpecies;

    /** Variables for the "general" tab. */
    private List<PictureDTO> pics;
    private SpeciesNatureObjectPersist specie;
    private List<ClassificationDTO> classifications;
    private List<String> breadcrumbClassificationExpands;
    private String authorDate;
    private String gbifLink;
    private String gbifLink2;
    private String kingdomname;
    /** IUCN Redlist number */
    private String redlistLink;
    private String scientificNameURL;
    private String speciesName;
    /** World Register of Marine Species - also has seals etc. */
    private String wormsid;
    /** Natura 2000 identifier in chm62edt_nature_object_attributes. */
    private String n2000id;
    /** Fauna Europea number */
    private String faeu;
    private PublicationWrapper speciesBook;
    /** ITIS TSN number. */
    private String itisTSN;
    /** NCBI number */
    private String ncbi;
    private ArrayList<LinkDTO> links;
    /** List of conservation statuses. */
    private List<NationalThreatWrapper> consStatus;
    /** Conservation status on World level. */
    private NationalThreatWrapper consStatusWO;
    /** Conservation status on European level. */
    private NationalThreatWrapper consStatusEU;
    /** Conservation status on EU25 level. */
    private NationalThreatWrapper consStatusE25;

    private List<SpeciesNatureObjectPersist> subSpecies;
    private List<SpeciesNatureObjectPersist> parentSpecies;
    private String domainName;
    private Hashtable<String, AttributeDto> natObjectAttributes;

    /** Vernacular names tab variables. */
    private List<VernacularNameWrapper> vernNames;

    /** geo tab variables. */
    private Vector<GeographicalStatusWrapper> bioRegions;
    boolean showGeoDistribution = false;
    private String faoCode;
    private String gbifCode;
    private String filename;
    private UniqueVector colorURL;
    private String mapserverURL;
    private String parameters;
    private Hashtable<String, String> statusColorPair;

    /** Grid distribution tab variables. */
    private boolean gridDistSuccess;

    /** Sites distribution tab variables. */
    private List<SitesByNatureObjectPersist> speciesSites;
    private String mapIds;
    private List<SitesByNatureObjectPersist> subSpeciesSites;
    private String subMapIds;

    /** LinkedData tab variables. */
    private List<ForeignDataQueryDTO> queries;
    private String query;
    private ArrayList<Map<String, Object>> queryResultCols;
    private ArrayList<HashMap<String, ResultValue>> queryResultRows;
    private String attribution;
    /** Conservation status tab variables. */
    private List<ForeignDataQueryDTO> conservationStatusQueries;
    private String conservationStatusQuery;
    private String conservationStatusAttribution;

    private LinkedHashMap<String, ArrayList<Map<String, Object>>> conservationStatusQueryResultCols =
            new LinkedHashMap<String, ArrayList<Map<String, Object>>>();
    private LinkedHashMap<String, ArrayList<HashMap<String, ResultValue>>> conservationStatusQueryResultRows =
            new LinkedHashMap<String, ArrayList<HashMap<String, ResultValue>>>();

    private boolean rangeLayer;
    private boolean distributionLayer;
    private boolean attributes;

    private Map<String, List<Chm62edtNatureObjectAttributesPersist>> natureObjectAttributesMap;

    // QuickFactSheet params
    private int synonymsCount;
    private List synonyms;
    private int vernNamesCount;
    private int speciesSitesCount;

    private int habitatsCount;
    private String authorYear;
    private String pageUrl;
    private String englishName = null;
    private String speciesTitle;

    // Legals params
    private List<LegalStatusWrapper> legalStatuses;
    private String unepWcmcPageLink;

    // Sites
    private List<SitesByNatureObjectViewDTO> speciesSitesTable;
    private List<SitesByNatureObjectViewDTO> subSpeciesSitesTable;
    private String scientificNameUrlEncoded;

    /**
     * Map for default picture (if there is no other picture in the DB)
     */
    static final Map<String, String> defaultPictures = new HashMap<String, String>();

    static {
        defaultPictures.put("Algae","005");
        defaultPictures.put("Amphibians","003");
        defaultPictures.put("Birds","018");
        defaultPictures.put("Conifers","020");
        defaultPictures.put("Ferns","007");
        defaultPictures.put("Fishes","006");
        defaultPictures.put("Flowering plants","009");
        defaultPictures.put("Fungi","013");
        defaultPictures.put("Invertebrates","001");
        defaultPictures.put("Mammals","015");
        defaultPictures.put("Mosses & Liverworts","010");
        defaultPictures.put("Protists","019");
        defaultPictures.put("Reptiles","008");
    }


    /**
     * Default Stripes handler
     * @return Stripes resolution
     */
    @DefaultHandler
    public Resolution index() {
        String idSpeciesText = null;

        ISpeciesFactsheetDao dao = DaoFactory.getDaoFactory().getSpeciesFactsheetDao();

        // sanity checks
        if (StringUtils.isBlank(idSpecies) && idSpeciesLink == 0) {
            factsheet = new SpeciesFactsheet(0, 0);
        }
        int mainIdSpecies = 0;

        // get idSpecies based on the request param. Functionality also available in #getSpeciesId()
        if (StringUtils.isNumeric(idSpecies)) {
            mainIdSpecies = new Integer(idSpecies);
        } else if (!StringUtils.isBlank(idSpecies)) {
            idSpeciesText = idSpecies;
            mainIdSpecies = dao.getIdSpeciesForScientificName(this.idSpecies);
        }

        seniorIdSpecies = dao.getCanonicalIdSpecies(mainIdSpecies);

        // it is a synonym, check the senior synonym name
        if (mainIdSpecies != seniorIdSpecies) {
            seniorSpecies = dao.getScientificName(seniorIdSpecies);
        }

        factsheet = new SpeciesFactsheet(mainIdSpecies, mainIdSpecies);

        if (StringUtils.isNotBlank(idSpeciesText) && !factsheet.exists()) {
            // redirecting to more general search in case user tried text based search
            String redirectUrl =
                    "/species-names-result.jsp?pageSize=10" + "&relationOp=2&typeForm=0&showGroup=true&showOrder=true"
                            + "&showFamily=true&showScientificName=true&showVernacularNames=true"
                            + "&showValidName=true&searchSynonyms=true&sort=2&ascendency=0" + "&scientificName=" + idSpeciesText;

            return new RedirectResolution(redirectUrl);
        }

        if (factsheet.exists()) {
            // set up some vars used in the presentation layer
            setMetaDescription(factsheet.getSpeciesDescription());
            scientificName = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getScientificName());
            author = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getAuthor());

            specie = factsheet.getSpeciesNatureObject();

            generalTabActions(mainIdSpecies);

            // Sets all actionBean values for quickfactsheet
            setQuickFactSheetValues();
            // Sets all actionBean values for legals listing.
            setLegalInstruments();
            // Sets all actionBean values for sites
            setSites();
            // Sets all reported area values
            setGeoValues();

            setPictures();

            // Sets data about international threat status
            setConservationStatusData();

            // populates the external data
            linkeddataTabActions(mainIdSpecies, specie.getIdNatureObject());

            // Sets country level and biogeo conservation status
            // TODO The methods executes SPARQL query. Consider caching the results or at least load the content with jQuery
            setConservationStatusDetails(mainIdSpecies, specie.getIdNatureObject());
        }

        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,factsheet";

        setBtrail(btrail);

        return new ForwardResolution("/stripes/species-factsheet/species-factsheet.layout.jsp");
    }
    

    /**
     * Prepares all specific information for quickFacktSheet
     */
    private void setQuickFactSheetValues() {
        pageUrl = getContext().getInitParameter("DOMAIN_NAME") + "/species/" + idSpecies;
        if (factsheet.exists()) {
            authorYear = SpeciesFactsheet.getBookDate(factsheet.getTaxcodeObject().IdDcTaxcode());
            scientificName = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getScientificName());
            author = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getAuthor());
            synonyms = factsheet.getSynonymsIterator();
            synonymsCount = synonyms.size();
            vernNames = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
            vernNamesCount = vernNames.size();
            speciesSites = factsheet.getSitesForSpecies();
            speciesSitesCount = speciesSites.size();
            habitatsCount = factsheet.getHabitatsForSpecies().size();
            
            for (VernacularNameWrapper vernName : vernNames){
                if (vernName.getLanguageCode().toLowerCase().equals("en")){
                    englishName = vernName.getName();
                    break;
                }
            }
            
            speciesTitle = ""; 
            if (englishName != null && englishName.trim().length() > 0){
                speciesTitle += englishName +" - "; 
            }
            speciesTitle += scientificName;
            
            if (author != null && author.trim().length() > 0){
                speciesTitle += " - "+author; 
            }

        }

        // For later refactoring. The following parameteres are used in QuickFactSheet, but initialized outside this method.
        //
        // links = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectLinks(specie.getIdNatureObject());
        // specie.scientificName
        // speciesName

    }

    /**
     * Set list of picture objects for gallery.
     */
    private void setPictures() {
        String picturePath = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");
        pics = factsheet.getPictures(picturePath);

        // http://taskman.eionet.europa.eu/issues/17992
        // display abstract images if no picture available

        if(pics.size() == 0) {
            // different picture by group
            String group = factsheet.getSpeciesGroup();

            PictureDTO pic = new PictureDTO();
            pic.setFilename("default/abstract" + defaultPictures.get(group) + ".jpg");
            pic.setDescription("No photo available for this species");
            pic.setSource("Paco Sánchez Aguado");
            pic.setPath(picturePath);

            pics.add(pic);
        }
    }

    /**
     * Load and parse species conservation status data.
     */
    private void setConservationStatusData() {

        if (factsheet != null) {

            consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());

            // List of species national threat status.
            if (consStatus != null && consStatus.size() > 0) {
                List<NationalThreatWrapper> newConsStatusList = new ArrayList<NationalThreatWrapper>();
                for (NationalThreatWrapper threat : consStatus) {
                    if (threat.getReference() != null && threat.getReference().contains("IUCN")) {
                        scientificNameURL = scientificName.replace(' ', '+');
                    }
                    newConsStatusList.add(threat);

                    if ("WO".equals(threat.getEunisAreaCode())) {
                        if (consStatusWO == null || consStatusWO.getReferenceYear() < threat.getReferenceYear()) {
                            consStatusWO = threat;
                        }
                    } else if ("EU".equals(threat.getEunisAreaCode())) {
                        if (consStatusEU == null || consStatusEU.getReferenceYear() < threat.getReferenceYear()) {
                            consStatusEU = threat;
                        }
                    } else if ("E25".equals(threat.getEunisAreaCode())) {
                        if (consStatusE25 == null || consStatusE25.getReferenceYear() < threat.getReferenceYear()) {
                            consStatusE25 = threat;
                        }
                    }
                }
                consStatus = newConsStatusList;
            }
        }
    }


    /**
     * Prepares all specific information for legal instruments section
     */
    private void setLegalInstruments() {
        Vector legals = factsheet.getLegalStatus();

        legalStatuses = new ArrayList<LegalStatusWrapper>();
        for (Object legal : legals) {
            LegalStatusWrapper legalStatus = (LegalStatusWrapper) legal;
            legalStatus.setDetailedReference(Utilities.formatString(Utilities.treatURLSpecialCharacters(legalStatus
                    .getDetailedReference())));
            legalStatus.setLegalText(Utilities.formatString(Utilities.treatURLSpecialCharacters(legalStatus.getLegalText())));
            legalStatus.setComments(Utilities.treatURLSpecialCharacters(legalStatus.getComments()));

            if (null != legalStatus.getUrl().replaceAll("#", "")) {
                String sFormattedURL = Utilities.formatString(legalStatus.getUrl()).replaceAll("#", "");
                if (sFormattedURL.length() > 50) {
                    sFormattedURL = sFormattedURL.substring(0, 50) + "...";
                }
                legalStatus.setUrl(Utilities.formatString(Utilities.treatURLSpecialCharacters(legalStatus.getUrl())).replaceAll(
                        "#", ""));
                legalStatus.setFormattedUrl(sFormattedURL);
            }

            legalStatuses.add(legalStatus);
        }

        links = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectLinks(specie.getIdNatureObject());

        for (LinkDTO link : links){
            if (link.getName().toLowerCase().equals("unep-wcmc page")){
                unepWcmcPageLink = link.getUrl();
            }
            if(link.getName().toUpperCase().contains("NOBANIS:")){
                nobanisLink = link;
            }
        }

    }

    LinkDTO nobanisLink = null;

    public LinkDTO getNobanisLink(){
        return nobanisLink;
    }

    /**
     * Populate the member variables used in the "sites" tab.
     */
    private void setSites() {

        speciesSitesTable = new ArrayList<SitesByNatureObjectViewDTO>();
        subSpeciesSitesTable = new ArrayList<SitesByNatureObjectViewDTO>();

        // List of sites related to species.
        speciesSites = factsheet.getSitesForSpecies();
        
        try {
            scientificNameUrlEncoded = URLEncoder.encode(scientificName, "UTF-8");
            scientificNameUrlEncoded = scientificNameUrlEncoded.replace("+", "%20");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        for (SitesByNatureObjectPersist site : speciesSites){
            SitesByNatureObjectViewDTO speciesSite = new SitesByNatureObjectViewDTO();

            speciesSite.setIDSite(site.getIDSite());
            speciesSite.setLatitude(site.getLatitude());
            speciesSite.setLongitude(site.getLongitude());
            speciesSite.setName(site.getName());
            speciesSite.setSourceDB(site.getSourceDB());
            speciesSite.setAreaNameEn(Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn())));

            Chm62edtCountryPersist country = CountryUtil.findCountry(site.getAreaNameEn());
            speciesSite.setAreaUrl("countries/"+Utilities.treatURLSpecialCharacters(country.getEunisAreaCode()));
            speciesSite.setSiteNameUrl("sites/" + Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getIDSite())));

            if (site.getSourceDB().equals("NATURA2000")){
                speciesSite.setNatura2000(true);
                speciesSitesTable.add(speciesSite);
            }
        }


        // List of sites related to subspecies.
        subSpeciesSites = factsheet.getSitesForSubpecies();
        
        for (SitesByNatureObjectPersist site : subSpeciesSites){
            SitesByNatureObjectViewDTO speciesSite = new SitesByNatureObjectViewDTO();

            speciesSite.setIDSite(site.getIDSite());
            speciesSite.setLatitude(site.getLatitude());
            speciesSite.setLongitude(site.getLongitude());
            speciesSite.setName(site.getName());
            speciesSite.setSourceDB(site.getSourceDB());
            speciesSite.setAreaNameEn(Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn())));

            Chm62edtCountryPersist country = CountryUtil.findCountry(site.getAreaNameEn());
            speciesSite.setAreaUrl("countries/"+Utilities.treatURLSpecialCharacters(country.getEunisAreaCode()));
            speciesSite.setSiteNameUrl("sites/" + Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getIDSite())));

            if (site.getSourceDB().equals("NATURA2000")){
                speciesSite.setNatura2000(true);
                subSpeciesSitesTable.add(speciesSite);
            }
        }
        
        mapIds = getIds(speciesSites);
        subMapIds = getIds(subSpeciesSites);
    }

    private int getSpeciesId() {
        int tempIdSpecies = 0;

        // get idSpecies based on the request param.
        if (StringUtils.isNumeric(idSpecies)) {
            tempIdSpecies = new Integer(idSpecies);
        } else if (!StringUtils.isBlank(idSpecies)) {
            tempIdSpecies = DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getIdSpeciesForScientificName(this.idSpecies);
        }
        return tempIdSpecies;
    }

    /**
     * Populate the member variables used in the "general" tab.
     *
     * @param mainIdSpecies - The species ID. Same as specie.getIdSpecies()
     */
    private void generalTabActions(int mainIdSpecies) {

        speciesBook = factsheet.getSpeciesBook();

        // Get all pictures for species

        try {
            authorDate = SpeciesFactsheet.getBookAuthorDate(factsheet.getTaxcodeObject().IdDcTaxcode());
            breadcrumbClassificationExpands = new ArrayList<String>();
            classifications = factsheet.getClassifications();
            // Extract kingdom name
            if (classifications != null) {
                String classificationExpand = "";
                for (ClassificationDTO classif : classifications) {
                    if (classificationExpand.length() > 0){
                        classificationExpand+=",";    
                    }
                    classificationExpand += classif.getId();
                    breadcrumbClassificationExpands.add(classificationExpand);
                    if (classif.getLevel().equalsIgnoreCase("kingdom")) {
                        kingdomname = classif.getName();
                    }
                }
            }

            gbifLink = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_GBIF); // specie.getScientificName();
            gbifLink2 = specie.getScientificName();
            gbifLink2 = gbifLink2.replaceAll("\\.", "");
            gbifLink2 = URLEncoder.encode(gbifLink2, "UTF-8");

            String sn = scientificName;

            sn = sn.replaceAll("sp.", "").replaceAll("ssp.", "");

            if (kingdomname.equalsIgnoreCase("Animalia")) {
                kingdomname = "Animals";
            } else if (kingdomname.equalsIgnoreCase("Plantae")) {
                kingdomname = "Plants";
            } else if (kingdomname.equalsIgnoreCase("Fungi")) {
                kingdomname = "Mushrooms";
            }

            speciesName =
                    (scientificName.trim().contains(" ") ? scientificName.trim().substring(scientificName.indexOf(" ") + 1)
                            : scientificName);

            redlistLink = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SPECIES_REDLIST);

            // World Register of Marine Species - also has seals etc.
            wormsid = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_WORMS);

            n2000id = specie.getNatura2000Code();

            if (kingdomname.equalsIgnoreCase("Animals")) {
                faeu = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_FAEU);
            }

            itisTSN = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_ITIS);
            ncbi = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_NCBI);

            subSpecies = factsheet.getSubspecies();
            if (!subSpecies.isEmpty()) {
                List<SpeciesNatureObjectPersist> newList = new ArrayList<SpeciesNatureObjectPersist>();

                for (SpeciesNatureObjectPersist species : subSpecies) {
                    String bad = SpeciesFactsheet.getBookAuthorDate(species.getIdDublinCore());

                    if (bad != null) {
                        species.setBookAuthorDate(bad);
                    }
                    newList.add(species);
                }
                subSpecies = newList;
            }
            
            parentSpecies = factsheet.getParentSpecies();
            if (!parentSpecies.isEmpty()) {
                List<SpeciesNatureObjectPersist> newList = new ArrayList<SpeciesNatureObjectPersist>();

                for (SpeciesNatureObjectPersist species : parentSpecies) {
                    String bad = SpeciesFactsheet.getBookAuthorDate(species.getIdDublinCore());

                    if (bad != null) {
                        species.setBookAuthorDate(bad);
                    }
                    newList.add(species);
                }
                parentSpecies = newList;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Get value for given ID_NATURE_OBJECT and attribute name from chm62edt_nature_object_attributes table.
     *
     * @param id - The nature object ID.
     * @param name - attribute name.
     */
    private String getNatObjectAttribute(Integer id, String name) {
        String ret = null;
        if (id != null && name != null) {
            if (natObjectAttributes == null) {
                natObjectAttributes = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectAttributes(id);
            }
            AttributeDto attr = natObjectAttributes.get(name);
            if (attr != null) {
                ret = attr.getValue();
            }
        }
        return ret;
    }

    /**
     * Populate the member variables used in the "geo" tab.
     */
    private void setGeoValues() {

        // Get FAO code if one exists
        faoCode =
                DaoFactory.getDaoFactory().getNatureObjectAttrDao()
                        .getNatObjAttribute(specie.getIdNatureObject(), Constants.SAME_SPECIES_FIFAO);

        // Get GBIF code if one exists
        gbifCode =
                DaoFactory.getDaoFactory().getNatureObjectAttrDao()
                        .getNatObjAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_GBIF);

        bioRegions = SpeciesFactsheet.getBioRegionIterator(specie.getIdNatureObject(), factsheet.getIdSpecies());
        if (bioRegions.size() > 0) {
            // Display map
            colorURL = new UniqueVector();
            UniqueVector statuses = new UniqueVector();

            // Get all distinct statuses
            for (GeographicalStatusWrapper aRow : bioRegions) {
                statuses.addElement(aRow.getStatus());
            }
            // Compute distinct color for each status
            statusColorPair = ThreatColor.getColorsForMap(statuses);
            Vector<String> addedCountries = new Vector<String>();

            // fix to display in map legend only visible colours
            statuses.clear();
            for (GeographicalStatusWrapper aRow : bioRegions) {
                Chm62edtCountryPersist cntry = aRow.getCountry();

                if (cntry != null && !addedCountries.contains(cntry.getAreaNameEnglish())) {
                    String color = ":H" + statusColorPair.get(aRow.getStatus().toLowerCase());
                    String countryColPair = (cntry.getIso2Wcmc() == null) ? cntry.getIso2l() : cntry.getIso2Wcmc() + color;

                    colorURL.addElement(countryColPair);
                    addedCountries.add(cntry.getAreaNameEnglish());
                    // fix to display in map legend only visible colours
                    statuses.addElement(aRow.getStatus());
                }
            }
            // fix to display in map legend only visible colours
            statusColorPair = ThreatColor.getColorsForMap(statuses);

            int COUNTRIES_PER_MAP = Utilities.checkedStringToInt(getContext().getInitParameter("COUNTRIES_PER_MAP"), 120);

            if (addedCountries.size() < COUNTRIES_PER_MAP) {
                showGeoDistribution = true;
                mapserverURL = getContext().getInitParameter("EEA_MAP_SERVER");
                parameters = "mapType=Standard_B&amp;Q=" + colorURL.getElementsSeparatedByComma() + "&amp;outline=1";
                filename = mapserverURL + "/getmap.asp?" + parameters;
            }
        }

        setRangeLayer(isSpeciesLayer(scientificName, 1));
        setDistributionLayer(isSpeciesLayer(scientificName, 4));
    }

    /**
     * Checks that this species layer exist in discomap server.
     *
     * @param scientificName - species scientific name
     * @param layerNumber - discomap layer number
     * @return boolean
     */
    private boolean isSpeciesLayer(String scientificName, int layerNumber) {
        boolean results = false;
        if (scientificName != null && !scientificName.isEmpty() && layerNumber > 0) {

            String layerNumberS = Integer.toString(layerNumber);
            String rawMapServerFindOperationUrl = getContext().getApplicationProperty("DISCOMAP_SERVER_BIO");
            if (rawMapServerFindOperationUrl != null && rawMapServerFindOperationUrl.trim().length() > 0) {
                String mapServerFindOperationUrl =
                        rawMapServerFindOperationUrl.replace("#{scientific_name}", scientificName.replace(" ", "+").trim())
                                .replace("#{layer_number}", layerNumberS);
                try {

                    String jsonTxt = IOUtils.toString(new URL(mapServerFindOperationUrl));
                    JSONObject json = (JSONObject) JSONSerializer.toJSON(jsonTxt);
                    JSONArray jArray = json.getJSONArray("results");
                    if (jArray.isEmpty()) {

                        results = false;
                    } else {

                        JSONObject jArray0 = jArray.getJSONObject(0); // jArray[0]
                        JSONObject attributes = jArray0.getJSONObject("attributes");
                        if (attributes.getString("Type").trim().equalsIgnoreCase("species")) {
                            results = true;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return results;
    }

    /**
     * Run the queries to be executed on "Conservation status" tab.
     *
     * @param idSpecies The species id
     * @param natObjId -ID_NATURE_OBJECT
     */
    private void setConservationStatusDetails(int idSpecies, Integer natObjId) {
        try {

            Properties props = new Properties();
            props.loadFromXML(getClass().getClassLoader().getResourceAsStream("conservationstatus_species.xml"));
            LinkedData ld = new LinkedData(props, natObjId, "_conservationStatusQueries");
            conservationStatusQueries = ld.getQueryObjects();
            for (ForeignDataQueryDTO conservationStatusQuery1 : conservationStatusQueries) {
                conservationStatusQuery = conservationStatusQuery1.getId();
                if (!StringUtils.isBlank(conservationStatusQuery)) {
                    ld.executeQuery(conservationStatusQuery, idSpecies);
                    conservationStatusQueryResultCols.put(conservationStatusQuery, ld.getCols());
                    conservationStatusQueryResultRows.put(conservationStatusQuery, ld.getRows());

                    conservationStatusAttribution = ld.getAttribution();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns the site ID list
     * @param sites The sites list
     * @return Comma separated Site IDs
     */
    private String getIds(List<SitesByNatureObjectPersist> sites) {

        int maxSitesPerMap = Utilities.checkedStringToInt(getContext().getInitParameter("MAX_SITES_PER_MAP"), 2000);
        String ids = null;

        if (sites.size() > 0) {
            ids = "";
            if (sites.size() < maxSitesPerMap) {
                for (int i = 0; i < sites.size(); i++) {
                    SitesByNatureObjectPersist site = sites.get(i);

                    ids += "'" + site.getIDSite() + "'";
                    if (i < sites.size() - 1) {
                        ids += ",";
                    }
                }
            }
        }

        return ids;
    }

    /**
     * Populate the member variables used in the "linkeddata" tab.
     *
     * @param idSpecies
     *            - The species ID.
     */
    private void linkeddataTabActions(int idSpecies, Integer natObjId) {
        try {
            Properties props = new Properties();
            props.loadFromXML(getClass().getClassLoader().getResourceAsStream("externaldata_species.xml"));
            LinkedData fd = new LinkedData(props, natObjId, "_linkedDataQueries");
            queries = fd.getQueryObjects();

            // runs all the queries
            // todo: this is only to demo the way to display data

            allQueries = new ArrayList<Query>();

            for(ForeignDataQueryDTO queryDTO : queries){
                fd.executeQuery(queryDTO.getId(), idSpecies);
                Query q = new Query(queryDTO, fd.getCols(), fd.getRows(), fd.getAttribution());
                allQueries.add(q);
            }

//            if (!StringUtils.isBlank(query)) {
//
//                fd.executeQuery(query, idSpecies);
//                queryResultCols = fd.getCols();
//                queryResultRows = fd.getRows();
//
//                attribution = fd.getAttribution();
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<Query> allQueries;

    public List<Query> getAllQueries() {
        return allQueries;
    }

    public class Query {
        private ForeignDataQueryDTO query;
        private List<Map<String, Object>> resultCols;
        private List<HashMap<String, ResultValue>> resultRows;
        private String attribution;
        private String title;
        private String summary;

        private Query(ForeignDataQueryDTO query, List<Map<String, Object>> resultCols, List<HashMap<String, ResultValue>> resultRows, String attribution) {
            this.query = query;
            this.resultCols = resultCols;
            this.resultRows = resultRows;
            this.attribution = attribution;
            this.title = query.getTitle();
            this.summary = query.getSummary();
        }

        public ForeignDataQueryDTO getQuery() {
            return query;
        }

        public List<Map<String, Object>> getResultCols() {
            return resultCols;
        }

        public List<HashMap<String, ResultValue>> getResultRows() {
            return resultRows;
        }

        public String getAttribution() {
            return attribution;
        }

        public String getTitle() {
            return title;
        }

        public String getSummary() {
            return summary;
        }
    }

    public LinkedHashMap<String, ArrayList<Map<String, Object>>> getConservationStatusQueryResultCols() {
        return conservationStatusQueryResultCols;
    }

    public LinkedHashMap<String, ArrayList<HashMap<String, ResultValue>>> getConservationStatusQueryResultRows() {
        return conservationStatusQueryResultRows;
    }

    public List<ForeignDataQueryDTO> getConservationStatusQueries() {
        return conservationStatusQueries;
    }

    public String getConservationStatusQuery() {
        return conservationStatusQuery;
    }

    public String getConservationStatusAttribution() {
        return conservationStatusAttribution;
    }

    public boolean isRangeLayer() {
        return rangeLayer;
    }

    public void setRangeLayer(boolean rangeLayer) {
        this.rangeLayer = rangeLayer;
    }

    public boolean isDistributionLayer() {
        return distributionLayer;
    }

    public void setDistributionLayer(boolean distributionLayer) {
        this.distributionLayer = distributionLayer;
    }

    /**
     * @return the factsheet
     */
    public SpeciesFactsheet getFactsheet() {
        return factsheet;
    }

    /**
     * @param factsheet the factsheet to set
     */
    public void setFactsheet(SpeciesFactsheet factsheet) {
        this.factsheet = factsheet;
    }

    /**
     * @return the idSpecies
     */
    public String getIdSpecies() {
        return idSpecies;
    }

    /**
     * @param idSpecies the idSpecies to set
     */
    public void setIdSpecies(String idSpecies) {
        this.idSpecies = idSpecies;
    }

    /**
     * @return seniorSpecies
     */
    public String getSeniorSpecies() {
        return seniorSpecies;
    }

    /**
     * @return the idSpeciesLink
     */
    public int getIdSpeciesLink() {
        return idSpeciesLink;
    }

    /**
     * @param idSpeciesLink the idSpeciesLink to set
     */
    public void setIdSpeciesLink(int idSpeciesLink) {
        this.idSpeciesLink = idSpeciesLink;
    }

    /**
     * @return the scientificName
     */
    public String getScientificName() {
        return scientificName;
    }

    /**
     * @return the author
     */
    public String getAuthor() {
        return author;
    }

    public boolean isGridDistSuccess() {
        return gridDistSuccess;
    }

    public void setGridDistSuccess(boolean gridDistSuccess) {
        this.gridDistSuccess = gridDistSuccess;
    }

    public List<PictureDTO> getPics() {
        return pics;
    }

    public void setPics(List<PictureDTO> pics) {
        this.pics = pics;
    }

    public SpeciesNatureObjectPersist getSpecie() {
        return specie;
    }

    public void setSpecie(SpeciesNatureObjectPersist specie) {
        this.specie = specie;
    }

    public List<ClassificationDTO> getClassifications() {
        return classifications;
    }

    public void setClassifications(List<ClassificationDTO> classifications) {
        this.classifications = classifications;
    }

    public String getAuthorDate() {
        return authorDate;
    }

    public void setAuthorDate(String authorDate) {
        this.authorDate = authorDate;
    }

    public String getGbifLink() {
        return gbifLink;
    }

    public void setGbifLink(String gbifLink) {
        this.gbifLink = gbifLink;
    }

    public String getGbifLink2() {
        return gbifLink2;
    }

    public void setGbifLink2(String gbifLink2) {
        this.gbifLink2 = gbifLink2;
    }

    public String getKingdomname() {
        return kingdomname;
    }

    public void setKingdomname(String kingdomname) {
        this.kingdomname = kingdomname;
    }

    public String getRedlistLink() {
        return redlistLink;
    }

    public void setRedlistLink(String redlistLink) {
        this.redlistLink = redlistLink;
    }

    public String getScientificNameURL() {
        return scientificNameURL;
    }

    public void setScientificNameURL(String scientificNameURL) {
        this.scientificNameURL = scientificNameURL;
    }

    public String getSpeciesName() {
        return speciesName;
    }

    public void setSpeciesName(String speciesName) {
        this.speciesName = speciesName;
    }

    public String getN2000id() {
        return n2000id;
    }

    public void setN2000id(String n2000id) {
        this.n2000id = n2000id;
    }

    public String getWormsid() {
        return wormsid;
    }

    public void setWormsid(String wormsid) {
        this.wormsid = wormsid;
    }

    public String getFaeu() {
        return faeu;
    }

    public void setFaeu(String faeu) {
        this.faeu = faeu;
    }

    public String getItisTSN() {
        return itisTSN;
    }

    public void setItisTSN(String itisTSN) {
        this.itisTSN = itisTSN;
    }

    public String getNcbi() {
        return ncbi;
    }

    public void setNcbi(String ncbi) {
        this.ncbi = ncbi;
    }

    public ArrayList<LinkDTO> getLinks() {
        return links;
    }

    public void setLinks(ArrayList<LinkDTO> links) {
        this.links = links;
    }

    public List<NationalThreatWrapper> getConsStatus() {
        return consStatus;
    }

    public void setConsStatus(List<NationalThreatWrapper> consStatus) {
        this.consStatus = consStatus;
    }

    public List<SpeciesNatureObjectPersist> getSubSpecies() {
        return subSpecies;
    }

    public void setSubSpecies(List<SpeciesNatureObjectPersist> subSpecies) {
        this.subSpecies = subSpecies;
    }

    public String getDomainName() {
        return domainName;
    }

    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }

    public Vector<GeographicalStatusWrapper> getBioRegions() {
        return bioRegions;
    }

    public void setBioRegions(Vector<GeographicalStatusWrapper> bioRegions) {
        this.bioRegions = bioRegions;
    }

    public boolean isShowGeoDistribution() {
        return showGeoDistribution;
    }

    public void setShowGeoDistribution(boolean showGeoDistribution) {
        this.showGeoDistribution = showGeoDistribution;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public UniqueVector getColorURL() {
        return colorURL;
    }

    public void setColorURL(UniqueVector colorURL) {
        this.colorURL = colorURL;
    }

    public String getMapserverURL() {
        return mapserverURL;
    }

    public void setMapserverURL(String mapserverURL) {
        this.mapserverURL = mapserverURL;
    }

    public String getParameters() {
        return parameters;
    }

    public void setParameters(String parameters) {
        this.parameters = parameters;
    }

    public Hashtable<String, String> getStatusColorPair() {
        return statusColorPair;
    }

    public void setStatusColorPair(Hashtable<String, String> statusColorPair) {
        this.statusColorPair = statusColorPair;
    }

    public List<VernacularNameWrapper> getVernNames() {
        return vernNames;
    }

    public void setVernNames(List<VernacularNameWrapper> vernNames) {
        this.vernNames = vernNames;
    }

    public List<SitesByNatureObjectPersist> getSpeciesSites() {
        return speciesSites;
    }

    public void setSpeciesSites(List<SitesByNatureObjectPersist> speciesSites) {
        this.speciesSites = speciesSites;
    }

    public String getMapIds() {
        return mapIds;
    }

    public void setMapIds(String mapIds) {
        this.mapIds = mapIds;
    }

    public List<SitesByNatureObjectPersist> getSubSpeciesSites() {
        return subSpeciesSites;
    }

    public void setSubSpeciesSites(List<SitesByNatureObjectPersist> subSpeciesSites) {
        this.subSpeciesSites = subSpeciesSites;
    }

    public String getSubMapIds() {
        return subMapIds;
    }

    public void setSubMapIds(String subMapIds) {
        this.subMapIds = subMapIds;
    }

    public int getSeniorIdSpecies() {
        return seniorIdSpecies;
    }

    public PublicationWrapper getSpeciesBook() {
        return speciesBook;
    }

    public List<ForeignDataQueryDTO> getQueries() {
        return queries;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public ArrayList<Map<String, Object>> getQueryResultCols() {
        return queryResultCols;
    }

    public ArrayList<HashMap<String, ResultValue>> getQueryResultRows() {
        return queryResultRows;
    }

    public String getAttribution() {
        return attribution;
    }

    public void setAttribution(String attribution) {
        this.attribution = attribution;
    }

    public String getFaoCode() {
        return faoCode;
    }

    public String getGbifCode() {
        return gbifCode;
    }

    /**
     *
     * @return natureObjectAttributesMap - map of natureObjectAttributes names and Chm62edtNatureObjectAttributesPersist objects.
     */
    public Map<String, List<Chm62edtNatureObjectAttributesPersist>> getNatureObjectAttributesMap() {

        if (natureObjectAttributesMap == null) {

            Integer currentNaturalObjectId = specie.getIdNatureObject();
            @SuppressWarnings("unchecked")
            List<Chm62edtNatureObjectAttributesPersist> natureObjectAttributes =
                    new Chm62edtNatureObjectAttributesDomain().findWhere("ID_NATURE_OBJECT= " + currentNaturalObjectId);

            natureObjectAttributesMap = new HashMap<String, List<Chm62edtNatureObjectAttributesPersist>>();
            for (Chm62edtNatureObjectAttributesPersist noa : natureObjectAttributes) {
                if (natureObjectAttributesMap.containsKey(noa.getName())) {
                    natureObjectAttributesMap.get(noa.getName()).add(noa);

                } else {
                    List<Chm62edtNatureObjectAttributesPersist> l = new ArrayList<Chm62edtNatureObjectAttributesPersist>();
                    l.add(noa);
                    natureObjectAttributesMap.put(noa.getName(), l);

                }

            }
        }
        return natureObjectAttributesMap;
    }

    public int getSynonymsCount() {
        return synonymsCount;
    }

    public void setSynonymsCount(int synonymsCount) {
        this.synonymsCount = synonymsCount;
    }

    public List getSynonyms() {
        return synonyms;
    }

    public void setSynonyms(List synonyms) {
        this.synonyms = synonyms;
    }

    public int getVernNamesCount() {
        return vernNamesCount;
    }

    public void setVernNamesCount(int vernNamesCount) {
        this.vernNamesCount = vernNamesCount;
    }

    public int getSpeciesSitesCount() {
        return speciesSitesCount;
    }

    public void setSpeciesSitesCount(int speciesSitesCount) {
        this.speciesSitesCount = speciesSitesCount;
    }

    public int getHabitatsCount() {
        return habitatsCount;
    }

    public void setHabitatsCount(int habitatsCount) {
        this.habitatsCount = habitatsCount;
    }

    public String getAuthorYear() {
        return authorYear;
    }

    public void setAuthorYear(String authorYear) {
        this.authorYear = authorYear;
    }

    public List<SpeciesNatureObjectPersist> getParentSpecies() {
        return parentSpecies;
    }

    public void setParentSpecies(List<SpeciesNatureObjectPersist> parentSpecies) {
        this.parentSpecies = parentSpecies;
    }

    /**
     * @return the consStatusWO
     */
    public NationalThreatWrapper getConsStatusWO() {
        return consStatusWO;
    }

    /**
     * @return the consStatusEU
     */
    public NationalThreatWrapper getConsStatusEU() {
        return consStatusEU;
    }

    /**
     * @return the consStatusE25
     */
    public NationalThreatWrapper getConsStatusE25() {
        return consStatusE25;
    }

    public List<LegalStatusWrapper> getLegalStatuses() {
        return legalStatuses;
    }

    public void setLegalStatuses(List<LegalStatusWrapper> legalStatuses) {
        this.legalStatuses = legalStatuses;
    }

    public String getPageUrl() {
        return pageUrl;
    }

    public void setPageUrl(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    public String getUnepWcmcPageLink() {
        return unepWcmcPageLink;
    }

    public void setUnepWcmcPageLink(String unepWcmcPageLink) {
        this.unepWcmcPageLink = unepWcmcPageLink;
    }

    public List<SitesByNatureObjectViewDTO> getSpeciesSitesTable() {
        return speciesSitesTable;
    }

    public void setSpeciesSitesTable(List<SitesByNatureObjectViewDTO> speciesSitesTable) {
        this.speciesSitesTable = speciesSitesTable;
    }

    public String getScientificNameUrlEncoded() {
        return scientificNameUrlEncoded;
    }

    public void setScientificNameUrlEncoded(String scientificNameUrlEncoded) {
        this.scientificNameUrlEncoded = scientificNameUrlEncoded;
    }

    public List<SitesByNatureObjectViewDTO> getSubSpeciesSitesTable() {
        return subSpeciesSitesTable;
    }

    public void setSubSpeciesSitesTable(List<SitesByNatureObjectViewDTO> subSpeciesSitesTable) {
        this.subSpeciesSitesTable = subSpeciesSitesTable;
    }

    public List<String> getBreadcrumbClassificationExpands() {
        return breadcrumbClassificationExpands;
    }

    public void setBreadcrumbClassificationExpands(List<String> breadcrumbClassificationExpands) {
        this.breadcrumbClassificationExpands = breadcrumbClassificationExpands;
    }

    public String getEnglishName() {
        return englishName;
    }

    public void setEnglishName(String englishName) {
        this.englishName = englishName;
    }

    public String getSpeciesTitle() {
        return speciesTitle;
    }

    public void setSpeciesTitle(String speciesTitle) {
        this.speciesTitle = speciesTitle;
    }

    /**
     * Lists the habitats for the species
     * todo: implement http://taskman.eionet.europa.eu/issues/17887
     * @return
     */
    public List<String> getHabitats(){
        return null;
    }

    /**
     * todo: implement http://taskman.eionet.europa.eu/issues/17887
     * @return
     */
    public boolean isProtectedByEUDirectives(){
        return false;
    }
}

