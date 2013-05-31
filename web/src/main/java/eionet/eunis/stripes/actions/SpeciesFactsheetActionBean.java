package eionet.eunis.stripes.actions;

import java.awt.Color;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Vector;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.ImageProcessing;
import ro.finsiel.eunis.factsheet.species.GeographicalStatusWrapper;
import ro.finsiel.eunis.factsheet.species.LegalStatusWrapper;
import ro.finsiel.eunis.factsheet.species.NationalThreatWrapper;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.factsheet.species.ThreatColor;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectAttributesDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectAttributesPersist;
import ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.DistributionWrapper;
import ro.finsiel.eunis.jrfTables.species.factsheet.ReportsDistributionStatusPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.UniqueVector;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.factsheet.PublicationWrapper;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.ClassificationDTO;
import eionet.eunis.dto.ForeignDataQueryDTO;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.dto.PictureDTO;
import eionet.eunis.dto.SpeciesDistributionDTO;
import eionet.eunis.rdf.LinkedData;
import eionet.eunis.stripes.viewdto.SitesByNatureObjectViewDTO;
import eionet.eunis.util.Constants;
import eionet.eunis.util.Pair;
import eionet.sparqlClient.helpers.ResultValue;

/**
 * ActionBean for species factsheet. Data is loaded from {@link ro.finsiel.eunis.factsheet.species.SpeciesFactsheet} and
 * {@link ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist}.
 *
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species/{idSpecies}/{tab}")
public class SpeciesFactsheetActionBean extends AbstractStripesAction {

    /** */
    private static final String[] tabs = {"General information", "Vernacular names", "Geographical information", "Population",
            "Trends", "Legal Instruments", "Habitat types", "Sites", "External data", "Conservation status"};

    /** */
    private static final Map<String, String[]> types = new HashMap<String, String[]>();
    static {
        types.put("GENERAL_INFORMATION", new String[] {"general", tabs[0]});
        types.put("VERNACULAR_NAMES", new String[] {"vernacular", tabs[1]});
        types.put("GEOGRAPHICAL_DISTRIBUTION", new String[] {"geo", tabs[2]});
        types.put("POPULATION", new String[] {"population", tabs[3]});
        types.put("TRENDS", new String[] {"trends", tabs[4]});
        // types.put("GRID_DISTRIBUTION", new String[] {"grid", "Grid distribution"});
        types.put("LEGAL_INSTRUMENTS", new String[] {"legal", tabs[5]});
        types.put("HABITATS", new String[] {"habitats", tabs[6]});
        types.put("SITES", new String[] {"sites", tabs[7]});
        types.put("LINKEDDATA", new String[] {"linkeddata", tabs[8]});
        types.put("CONSERVATION_STATUS", new String[] {"conservation_status", tabs[9]});
    }

    /** The argument given. Can be a species number or scientific name */
    private String idSpecies;
    private int idSpeciesLink;

    private SpeciesFactsheet factsheet;
    private String scientificName = "";
    private String author = "";

    /**
     * selected tab.
     */
    private String tab;
    /**
     * tabs to display.
     */
    private List<Pair<String, String>> tabsWithData = new ArrayList<Pair<String, String>>();
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
    private String gridImage;
    private boolean gridDistSuccess;
    private List<SpeciesDistributionDTO> speciesDistribution;

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
    private Vector legalInstruments;
    private int legalInstrumentCount;
    private int habitatsCount;
    private String authorYear;
    private String pageUrl;

    // Legals params
    private List<LegalStatusWrapper> legalStatuses;
    private String unepWcmcPageLink; 
    
    // Sites
    private List<SitesByNatureObjectViewDTO> speciesSitesTable;



    /**
     *
     * @return
     */
    @DefaultHandler
    public Resolution index() {
        String idSpeciesText = null;

        // Default tab is "general"
        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

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

            SQLUtilities sqlUtil = getContext().getSqlUtilities();

            // Decide what tabs to show, based on tab display settings in the database
            List<String> existingTabs =
                    sqlUtil.getExistingTabPages(factsheet.getSpeciesNatureObject().getIdNatureObject().toString(), "SPECIES");
            for (String tab : existingTabs) {
                if (types.containsKey(tab)) {
                    String[] tabData = types.get(tab);
                    tabsWithData.add(new Pair<String, String>(tabData[0], getContentManagement().cmsPhrase(tabData[1])));
                }
            }

            specie = factsheet.getSpeciesNatureObject();

            if (tab != null && tab.equals("general")) {
                generalTabActions(mainIdSpecies);
            }

            if (tab != null && tab.equals("vernacular")) {
                vernNames = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
            }

            if (tab != null && tab.equals("geo")) {
                geoTabActions();
            }

            if (tab != null && tab.equals("grid")) {
                gridDistributionTabActions();
            }

            if (tab != null && tab.equals("sites")) {
                setSites();
            }

            if (tab != null && tab.equals("linkeddata")) {
                linkeddataTabActions(mainIdSpecies, specie.getIdNatureObject());
            }

            if (tab != null && tab.equals("conservation_status")) {
                setConservationStatusDetails(mainIdSpecies, specie.getIdNatureObject());
            }
        }
        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,factsheet";

        setBtrail(btrail);

        // Set's all actionBean values for quickfactsheet
        setQuickFactSheetValues();
        // Set's all actionBean values for legals listing.
        setLegalInstruments();
        // Set's all actionBean values for sites
        setSites();
        

        setPictures();

        // Sets data about international threat status
        setConservationStatusData();

        // Sets country level and biogeo conservation status
        // TODO The methods executes SPARQL query. Consider caching the results or at least load the content with jQuery
        setConservationStatusDetails(mainIdSpecies, specie.getIdNatureObject());

        return new ForwardResolution("/stripes/species-factsheet/species-factsheet.layout.jsp");
    }

    /**
     * Prepares all specific information for quickFacktSheet
     *
     * @author Jaak Kapten
     */
    private void setQuickFactSheetValues() {
        authorYear = SpeciesFactsheet.getBookDate(factsheet.getTaxcodeObject().IdDcTaxcode());

        // SimpleDateFormat formatYear = new SimpleDateFormat("yyyy");
        // = formatYear.format(authorDate);

        scientificName = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getScientificName());
        author = StringEscapeUtils.escapeHtml(factsheet.getSpeciesNatureObject().getAuthor());
        pageUrl = this.getContext().getRequest().getRequestURL().toString();
        if (factsheet.exists()) {
            synonyms = factsheet.getSynonymsIterator();
            synonymsCount = synonyms.size();
            vernNames = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
            vernNamesCount = vernNames.size();
            speciesSites = factsheet.getSitesForSpecies();
            speciesSitesCount = speciesSites.size();
            legalInstruments = factsheet.getLegalStatus();
            legalInstrumentCount = legalInstruments.size();
            habitatsCount = factsheet.getHabitatsForSpecies().size();
        }
        
        // For later refactoring. The following parameteres are used in QuickFactSheet, but initialized outside this method.
        //
        // links = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectLinks(specie.getIdNatureObject());
        // ncbi
        // specie.scientificName
        // specie.genus
        // speciesName
        // faeu
        // wormsid
        // redlistLink
        // kingdomname
        // gbifLink2
        // gbifLink
        
    }

    /**
     * Set list of picture objects for gallery.
     */
    private void setPictures() {
        String picturePath = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");
        pics = factsheet.getPictures(picturePath);

    }

    /**
     * Load and parse species conservation status data.
     */
    private void setConservationStatusData() {

        if (factsheet != null) {

            consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
            Integer redlistCatIdDc = new Integer(getContext().getApplicationProperty("redlist.categories.id_dc"));

            // List of species national threat status.
            if (consStatus != null && consStatus.size() > 0) {
                List<NationalThreatWrapper> newConsStatusList = new ArrayList<NationalThreatWrapper>();
                for (int i = 0; i < consStatus.size(); i++) {
                    NationalThreatWrapper threat = consStatus.get(i);

                    if (threat.getReference() != null && threat.getReference().indexOf("IUCN") >= 0) {
                        scientificNameURL = scientificName.replace(' ', '+');
                    }
                    // String statusDesc =
                    // factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode(), threat.getIdConsStatus())
                    // .replaceAll("'", " ").replaceAll("\"", " ");
                    // threat.setStatusDesc(statusDesc);
                    newConsStatusList.add(threat);

                    //show only IUCN 2009 info in colored boxes
                    if (redlistCatIdDc.equals(threat.getIdDcConsStatus())) {
                        if ("WO".equals(threat.getEunisAreaCode())) {
                            consStatusWO = threat;
                        } else if ("EU".equals(threat.getEunisAreaCode())) {
                            consStatusEU = threat;
                        } else if ("E25".equals(threat.getEunisAreaCode())) {
                            consStatusE25 = threat;
                        }
                    }
                }
                consStatus = newConsStatusList;
            }
        }
    }


    /**
     * 
     * Prepares all specific information for legal instruments section
     * 
     * @author Jaak Kapten
     * @return
     */
    private void setLegalInstruments() {
        Vector legals = factsheet.getLegalStatus();

        legalStatuses = new ArrayList<LegalStatusWrapper>();
        for (int i = 0; i < legals.size(); i++) {
            LegalStatusWrapper legalStatus = (LegalStatusWrapper) legals.get(i);
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
        }
        

    }
    
    /**
     * Populate the member variables used in the "sites" tab.
     */
    private void setSites() {

        speciesSitesTable = new ArrayList<SitesByNatureObjectViewDTO>();
        
        // List of sites related to species.
        speciesSites = factsheet.getSitesForSpecies();
        
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
            
            speciesSitesTable.add(speciesSite);
        }
        
        
        
        mapIds = getIds(speciesSites);
        
        

        // List of sites related to subspecies.
        subSpeciesSites = factsheet.getSitesForSubpecies();
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

            classifications = factsheet.getClassifications();
            // Extract kingdom name
            if (classifications != null) {
                for (ClassificationDTO classif : classifications) {
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
                    (scientificName.trim().indexOf(" ") >= 0 ? scientificName.trim().substring(scientificName.indexOf(" ") + 1)
                            : scientificName);

            // World Register of Marine Species - also has seals etc.
            wormsid = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_WORMS);

            n2000id = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_N2000);

            if (kingdomname.equalsIgnoreCase("Animals")) {
                faeu = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_FAEU);
            }

            itisTSN = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_ITIS);
            ncbi = getNatObjectAttribute(specie.getIdNatureObject(), Constants.SAME_SYNONYM_NCBI);

            // Links to HMTL pages
            links = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectLinks(specie.getIdNatureObject());

            subSpecies = factsheet.getSubspecies();
            if (!subSpecies.isEmpty()) {
                List<SpeciesNatureObjectPersist> newList = new ArrayList<SpeciesNatureObjectPersist>();

                for (int i = 0; i < subSpecies.size(); i++) {
                    SpeciesNatureObjectPersist species = subSpecies.get(i);
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

                for (int i = 0; i < parentSpecies.size(); i++) {
                    SpeciesNatureObjectPersist species = parentSpecies.get(i);
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
    private void geoTabActions() {

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
            for (int i = 0; i < bioRegions.size(); i++) {
                GeographicalStatusWrapper aRow = bioRegions.get(i);
                statuses.addElement(aRow.getStatus());
            }
            // Compute distinct color for each status
            statusColorPair = ThreatColor.getColorsForMap(statuses);
            Vector<String> addedCountries = new Vector<String>();

            // fix to display in map legend only visible colours
            statuses.clear();
            for (int i = 0; i < bioRegions.size(); i++) {
                GeographicalStatusWrapper aRow = bioRegions.get(i);
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
        if (scientificName != null && scientificName.isEmpty() == false && layerNumber > 0) {

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
     * Populate the member variables used in the "grid" tab.
     */
    private void gridDistributionTabActions() {

        speciesDistribution = new ArrayList<SpeciesDistributionDTO>();

        DistributionWrapper dist = new DistributionWrapper(factsheet.getSpeciesNatureObject().getIdNatureObject());
        List d = dist.getDistribution();

        if (null != d && d.size() > 0) {
            String filename = getContext().getRequest().getSession().getId() + "_" + new Date().getTime() + "_europe.jpg";
            String tempDir = getContext().getInitParameter("TEMP_DIR");
            String inputFilename = getContext().getServletContext().getRealPath("/") + "gis/europe-bio.jpg";

            gridImage = tempDir + filename;
            String outputFilename = getContext().getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM) + gridImage;

            gridDistSuccess = false;
            try {
                ImageProcessing img = new ImageProcessing(inputFilename, outputFilename);

                img.init();
                for (int i = 0; i < d.size(); i += 2) {
                    ReportsDistributionStatusPersist dis;

                    if (i < d.size() - 1) {
                        dis = (ReportsDistributionStatusPersist) d.get(i + 1);
                        if (dis.getLatitude() != null && dis.getLongitude() != null && dis.getLatitude().doubleValue() != 0
                                && dis.getLongitude().doubleValue() != 0) {
                            double longitude = dis.getLongitude().doubleValue();
                            double latitude = dis.getLatitude().doubleValue();
                            int x;
                            int y;

                            // WEST +15
                            // EAST +44
                            // NORTH +73
                            // SOUTH +34
                            // PIC SIZE: 616 x 407
                            // the map goes from -15 to 44 in longitude
                            x = (int) ((616 * 15) / 59 + ((longitude * 616) / 59));
                            // the map goes from 34 to 73 in latitude
                            y = (int) (407 - ((((latitude - 34) * 407) / 39)));
                            int radius = 4;

                            img.drawPoint(x, y, Color.RED, radius);
                        }
                    }
                }
                img.save();
                gridDistSuccess = true;
            } catch (Throwable ex) {
                gridDistSuccess = false;
                ex.printStackTrace();
            }

            for (int i = 0; i < d.size(); i += 2) {
                SpeciesDistributionDTO gridDTO = new SpeciesDistributionDTO();

                ReportsDistributionStatusPersist dis = (ReportsDistributionStatusPersist) d.get(i);

                gridDTO.setName(dis.getIdLookupGrid());
                gridDTO.setStatus(dis.getDistributionStatus());
                gridDTO.setReference(dis.getIdDc().toString());
                if (i < d.size() - 1) {
                    dis = (ReportsDistributionStatusPersist) d.get(i + 1);
                    gridDTO.setLongitude(dis.getLongitude().toString());
                    gridDTO.setLatitude(dis.getLatitude().toString());
                }
                speciesDistribution.add(gridDTO);
            }
        }
    }

 

    /**
     * Populate the member variables used in the "linkeddata" tab.
     *
     * @param idSpecies - The species ID.
     */
    private void linkeddataTabActions(int idSpecies, Integer natObjId) {
        try {
            Properties props = new Properties();
            props.loadFromXML(getClass().getClassLoader().getResourceAsStream("externaldata_species.xml"));
            LinkedData fd = new LinkedData(props, natObjId, "_linkedDataQueries");
            queries = fd.getQueryObjects();
            if (!StringUtils.isBlank(query)) {

                fd.executeQuery(query, idSpecies);
                queryResultCols = fd.getCols();
                queryResultRows = fd.getRows();

                attribution = fd.getAttribution();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Run the queries to be executed on "Conservation status" tab.
     *
     * @param idSpecies
     * @param natObjId -ID_NATURE_OBJECT
     */
    private void setConservationStatusDetails(int idSpecies, Integer natObjId) {
        try {

            Properties props = new Properties();
            props.loadFromXML(getClass().getClassLoader().getResourceAsStream("conservationstatus_species.xml"));
            LinkedData ld = new LinkedData(props, natObjId, "_conservationStatusQueries");
            conservationStatusQueries = ld.getQueryObjects();
            for (int i = 0; i < conservationStatusQueries.size(); i++) {
                conservationStatusQuery = conservationStatusQueries.get(i).getId();
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
     *
     * @param sites
     * @return
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
     * @return the currentTab
     */
    public String getTab() {
        return tab;
    }

    /**
     * @param tab the currentTab to set
     */
    public void setTab(String tab) {
        this.tab = tab;
    }

    /**
     * @return the tabsWithData
     */
    public List<Pair<String, String>> getTabsWithData() {
        return tabsWithData;
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

    public List<SpeciesDistributionDTO> getSpeciesDistribution() {
        return speciesDistribution;
    }

    public String getGridImage() {
        return gridImage;
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

    public String[] getTabs() {
        return tabs;
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
            ;
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
}
