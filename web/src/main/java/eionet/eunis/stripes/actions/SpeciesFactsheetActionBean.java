package eionet.eunis.stripes.actions;

import java.awt.Color;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.ImageProcessing;
import ro.finsiel.eunis.factsheet.species.GeographicalStatusWrapper;
import ro.finsiel.eunis.factsheet.species.NationalThreatWrapper;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.factsheet.species.ThreatColor;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPictureDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPicturePersist;
import ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.DistributionWrapper;
import ro.finsiel.eunis.jrfTables.species.factsheet.ReportsDistributionStatusPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import ro.finsiel.eunis.search.UniqueVector;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.utilities.SQLUtilities;

import com.ibm.icu.util.StringTokenizer;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dto.ClassificationDTO;
import eionet.eunis.dto.DatatypeDto;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.dto.PictureDTO;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SpeciesDistributionDTO;
import eionet.eunis.dto.SpeciesFactsheetDto;
import eionet.eunis.dto.SpeciesSynonymDto;
import eionet.eunis.dto.TaxonomyTreeDTO;
import eionet.eunis.dto.VernacularNameDto;
import eionet.eunis.stripes.extensions.Redirect303Resolution;
import eionet.eunis.util.Constants;
import eionet.eunis.util.Pair;
import eionet.eunis.util.SimpleFrameworkUtils;
import eionet.sparqlClient.helpers.QueryExecutor;
import eionet.sparqlClient.helpers.QueryResult;

/**
 * ActionBean to replace old /species-factsheet.jsp.
 * 
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species/{idSpecies}/{tab}")
public class SpeciesFactsheetActionBean extends AbstractStripesAction {

    private static final String[] tabs = {"General information", "Vernacular names", "Geograpical distribution", "Population",
        "Trends", "References", "Legal Instruments", "Habitat types", "Sites", "GBIF observations", "Deliveries"};

    private static final Map<String, String[]> types = new HashMap<String, String[]>();
    static {
        types.put("GENERAL_INFORMATION", new String[] {"general", tabs[0]});
        types.put("VERNACULAR_NAMES", new String[] {"vernacular", tabs[1]});
        types.put("GEOGRAPHICAL_DISTRIBUTION", new String[] {"countries", tabs[2]});
        types.put("POPULATION", new String[] {"population", tabs[3]});
        types.put("TRENDS", new String[] {"trends", tabs[4]});
        types.put("REFERENCES", new String[] {"references", tabs[5]});
        // types.put("GRID_DISTRIBUTION", new String[] {"grid", "Grid distribution"});
        types.put("LEGAL_INSTRUMENTS", new String[] {"legal", tabs[6]});
        types.put("HABITATS", new String[] {"habitats", tabs[7]});
        types.put("SITES", new String[] {"sites", tabs[8]});
        types.put("GBIF", new String[] {"gbif", tabs[9]});
        types.put("DELIVERIES", new String[] {"deliveries", tabs[10]});
    }

    private static final String EXPECTED_IN_PREFIX = "http://eunis.eea.europa.eu/sites/";

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
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();
    /**
     * senior synonym name
     */
    private String seniorSpecies;

    /**
     * senior synonym ID
     */
    private int seniorIdSpecies;

    /**
     * General tab variables.
     */
    private PictureDTO pic;
    private SpeciesNatureObjectPersist specie;
    private List<ClassificationDTO> classifications;
    private String authorDate;
    private String gbifLink;
    private String gbifLink2;
    private String kingdomname;
    private String redlistLink;
    private String scientificNameURL;
    private String speciesName;
    /** World Register of Marine Species - also has seals etc. */
    private String wormsid;
    /** Natura 2000 identifier in chm62edt_nature_object_attributes */
    private String n2000id;
    private String faeu;
    /**
     * Hold ITIS TSN number
     */
    private String itisTSN;
    private String ncbi;
    private ArrayList<LinkDTO> links;
    private List<NationalThreatWrapper> consStatus;
    private List<SpeciesNatureObjectPersist> subSpecies;
    private String domainName;
    private String urlPic;

    // Vernacular names tab variables
    private List<VernacularNameWrapper> vernNames;

    // countries tab variables
    private Vector<GeographicalStatusWrapper> bioRegions;
    boolean showGeoDistribution = false;
    private String filename;
    private UniqueVector colorURL;
    private String mapserverURL;
    private String parameters;
    private Hashtable<String, String> statusColorPair;

    // Grid distribution tab variables
    private String gridImage;
    private boolean gridDistSuccess;
    private List<SpeciesDistributionDTO> speciesDistribution;

    // Sites distribution tab variables
    private List<SitesByNatureObjectPersist> speciesSites;
    private String mapIds;
    private List<SitesByNatureObjectPersist> subSpeciesSites;
    private String subMapIds;

    // Deliveries tab variables
    private QueryResult deliveries;

    @DefaultHandler
    public Resolution index() {
        String idSpeciesText = null;

        // Resolve what format should be returned - RDF or HTML
        if (idSpecies != null && idSpecies.length() > 0) {
            if (tab != null && tab.equals("rdf")) {
                return generateRdf();
            }

            domainName = getContext().getInitParameter("DOMAIN_NAME");

            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/species/" + idSpecies + "/rdf");
            }
        }

        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        ISpeciesFactsheetDao dao = DaoFactory.getDaoFactory().getSpeciesFactsheetDao();

        // sanity checks
        if (StringUtils.isBlank(idSpecies) && idSpeciesLink == 0) {
            factsheet = new SpeciesFactsheet(0, 0);
        }
        int mainIdSpecies = 0;

        // get idSpecies based on the request param.
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

            // Decide what tabs to show
            List<String> existingTabs =
                sqlUtil.getExistingTabPages(factsheet.getSpeciesNatureObject().getIdNatureObject().toString(), "SPECIES");
            for (String tab : existingTabs) {
                if (types.containsKey(tab)) {
                    String[] tabData = types.get(tab);
                    tabsWithData.add(new Pair<String, String>(tabData[0], getContentManagement().cmsPhrase(tabData[1])));
                }
            }

            // Always add deliveries tab
            tabsWithData.add(new Pair<String, String>("deliveries", getContentManagement().cmsPhrase("Deliveries")));

            specie = factsheet.getSpeciesNatureObject();

            if (tab != null && tab.equals("general")) {
                generalTabActions(mainIdSpecies);
            }

            if (tab != null && tab.equals("vernacular")) {
                vernNames = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
            }

            if (tab != null && tab.equals("countries")) {
                geoTabActions();
            }

            if (tab != null && tab.equals("grid")) {
                gridDistributionTabActions();
            }

            if (tab != null && tab.equals("sites")) {
                sitesTabActions();
            }

            if (tab != null && tab.equals("deliveries")) {
                deliveriesTabActions(mainIdSpecies);
            }
        }
        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,factsheet";

        setBtrail(btrail);
        return new ForwardResolution("/stripes/species-factsheet.layout.jsp");
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
     * Generates RDF for a species.
     */
    public Resolution generateRdf() {
        int speciesId = getSpeciesId();

        if (speciesId == 0) {
            return new ErrorResolution(404);
        }
        factsheet = new SpeciesFactsheet(speciesId, speciesId);
        if (!factsheet.exists()) {
            return new ErrorResolution(404);
        }

        SpeciesFactsheetDto dto = new SpeciesFactsheetDto();

        dto.setSpeciesId(factsheet.getSpeciesObject().getIdSpecies());
        dto.setScientificName(factsheet.getSpeciesObject().getScientificName());
        dto.setValidName(new DatatypeDto(factsheet.getSpeciesObject().getValidName(), "http://www.w3.org/2001/XMLSchema#boolean"));
        dto.setTypeRelatedSpecies(factsheet.getSpeciesObject().getTypeRelatedSpecies());
        dto.setGenus(factsheet.getSpeciesObject().getGenus());
        dto.setAuthor(factsheet.getSpeciesObject().getAuthor());

        TaxonomyTreeDTO taxonomyTree = factsheet.getTaxonomicTree(factsheet.getSpeciesObject().getIdTaxcode());
        if (taxonomyTree != null) {
            dto.setKingdom(taxonomyTree.getKingdom());
            dto.setPhylum(taxonomyTree.getPhylum());
            dto.setDwcClass(taxonomyTree.getDwcClass());
            dto.setOrder(taxonomyTree.getOrder());
            dto.setFamily(taxonomyTree.getFamily());
        }
        if (factsheet.getTaxcodeObject() != null && factsheet.getTaxcodeObject().IdDcTaxcode() != null) {
            dto.setNameAccordingToID(
                    new ResourceDto(
                            factsheet.getTaxcodeObject().IdDcTaxcode().toString(), "http://eunis.eea.europa.eu/documents/"));
        }

        dto.setDwcScientificName(dto.getScientificName() + ' ' + dto.getAuthor());
        dto.setDcmitype(new ResourceDto("", "http://purl.org/dc/dcmitype/Text"));

        if (!StringUtils.isBlank(factsheet.getSpeciesObject().getIdTaxcode())) {
            dto.setTaxonomy(new ResourceDto(factsheet.getSpeciesObject().getIdTaxcode(), "http://eunis.eea.europa.eu/taxonomy/"));
        }

        dto.setAttributes(DaoFactory.getDaoFactory().getSpeciesFactsheetDao()
                .getAttributesForNatureObject(factsheet.getSpeciesObject().getIdNatureObject()));
        dto.setHasLegalReferences(DaoFactory.getDaoFactory().getSpeciesFactsheetDao()
                .getLegalReferences(factsheet.getSpeciesObject().getIdNatureObject()));

        // setting expectedInLocations
        List<String> expectedLocations =
            DaoFactory
            .getDaoFactory()
            .getSpeciesFactsheetDao()
            .getExpectedInSiteIds(factsheet.getSpeciesObject().getIdNatureObject(),
                    factsheet.getSpeciesObject().getIdSpecies(), 0);

        if (expectedLocations != null && !expectedLocations.isEmpty()) {
            List<ResourceDto> expectedInSites = new LinkedList<ResourceDto>();

            for (String siteId : expectedLocations) {
                expectedInSites.add(new ResourceDto(siteId, EXPECTED_IN_PREFIX));
            }
            dto.setExpectedInLocations(expectedInSites);
        }

        List<VernacularNameWrapper> vernacularNames =
            SpeciesSearchUtility.findVernacularNames(factsheet.getSpeciesObject().getIdNatureObject());

        if (factsheet.getIdSpeciesLink() != null && !factsheet.getIdSpeciesLink().equals(factsheet.getIdSpecies())) {
            dto.setSynonymFor(new SpeciesSynonymDto(factsheet.getIdSpeciesLink()));
        }
        List<Integer> isSynonymFor = DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getSynonyms(factsheet.getIdSpecies());
        List<SpeciesSynonymDto> speciesSynonym = new LinkedList<SpeciesSynonymDto>();

        if (isSynonymFor != null && !isSynonymFor.isEmpty()) {
            for (Integer idSpecies : isSynonymFor) {
                speciesSynonym.add(new SpeciesSynonymDto(idSpecies));
            }
            dto.setHasSynonyms(speciesSynonym);
        }

        if (vernacularNames != null) {
            List<VernacularNameDto> vernacularDtos = new LinkedList<VernacularNameDto>();

            for (VernacularNameWrapper wrapper : vernacularNames) {
                vernacularDtos.add(new VernacularNameDto(wrapper));
            }
            dto.setVernacularNames(vernacularDtos);
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, SimpleFrameworkUtils.convertToString(
                SpeciesFactsheetDto.HEADER, dto, Constants.RDF_FOOTER));
    }

    private void generalTabActions(int mainIdSpecies) {

        consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
        urlPic = "idobject=" + specie.getIdSpecies() + "&amp;natureobjecttype=Species";

        List<Chm62edtNatureObjectPicturePersist> pictures =
            new Chm62edtNatureObjectPictureDomain().findWhere("MAIN_PIC = 1 AND ID_OBJECT = " + mainIdSpecies);

        if (pictures != null && !pictures.isEmpty()) {
            String mainPictureMaxWidth = pictures.get(0).getMaxWidth().toString();
            String mainPictureMaxHeight = pictures.get(0).getMaxHeight().toString();
            Integer mainPictureMaxWidthInt = Utilities.checkedStringToInt(mainPictureMaxWidth, new Integer(0));
            Integer mainPictureMaxHeightInt = Utilities.checkedStringToInt(mainPictureMaxHeight, new Integer(0));

            String styleAttr = "max-width:300px; max-height:400px;";

            if (mainPictureMaxWidthInt != null && mainPictureMaxWidthInt.intValue() > 0 && mainPictureMaxHeightInt != null
                    && mainPictureMaxHeightInt.intValue() > 0) {
                styleAttr =
                    "max-width: " + mainPictureMaxWidthInt.intValue() + "px; max-height: "
                    + mainPictureMaxHeightInt.intValue() + "px";
            }

            String desc = pictures.get(0).getDescription();

            if (desc == null || desc.equals("")) {
                desc = specie.getScientificName();
            }

            String picturePath = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");

            pic = new PictureDTO();
            pic.setFilename(pictures.get(0).getFileName());
            pic.setDescription(desc);
            pic.setSource(pictures.get(0).getSource());
            pic.setStyle(styleAttr);
            pic.setMaxwidth(mainPictureMaxWidth);
            pic.setMaxheight(mainPictureMaxHeight);
            pic.setPath(picturePath);
            pic.setDomain(domainName);
            pic.setUrl(urlPic);
        }

        List list = new Vector<Chm62edtTaxcodePersist>();

        try {
            list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + specie.getIdTaxcode() + "'");

            authorDate = SpeciesFactsheet.getBookAuthorDate(factsheet.getTaxcodeObject().IdDcTaxcode());
            classifications = new ArrayList<ClassificationDTO>();
            if (list != null && list.size() > 0) {
                Chm62edtTaxcodePersist t = (Chm62edtTaxcodePersist) list.get(0);
                String str = t.getTaxonomyTree();
                StringTokenizer st = new StringTokenizer(str, ",");
                int i = 0;

                while (st.hasMoreTokens()) {
                    StringTokenizer sts = new StringTokenizer(st.nextToken(), "*");
                    String classificationId = sts.nextToken();
                    String classificationLevel = sts.nextToken();
                    String classificationName = sts.nextToken();

                    if (classificationLevel.equalsIgnoreCase("kingdom")) {
                        kingdomname = classificationName;
                    }

                    ClassificationDTO classif = new ClassificationDTO();

                    classif.setId(classificationId);
                    classif.setLevel(classificationLevel);
                    classif.setName(classificationName);
                    classifications.add(classif);
                }
            }

            gbifLink = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_GBIF); // specie.getScientificName();
            gbifLink2 = specie.getScientificName();
            gbifLink2 = gbifLink2.replaceAll("\\.", "");
            gbifLink2 = URLEncoder.encode(gbifLink2, "UTF-8");

            String sn = scientificName;

            sn = sn.replaceAll("sp.", "").replaceAll("ssp.", "");

            if (kingdomname.equalsIgnoreCase("Animalia")) {
                kingdomname = "Animals";
            }
            if (kingdomname.equalsIgnoreCase("Plantae")) {
                kingdomname = "Plants";
            }
            if (kingdomname.equalsIgnoreCase("Fungi")) {
                kingdomname = "Mushrooms";
            }

            speciesName =
                (scientificName.trim().indexOf(" ") >= 0 ? scientificName.trim().substring(scientificName.indexOf(" ") + 1)
                        : scientificName);

            redlistLink = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SPECIES_REDLIST);

            // List of species national threat status.
            if (consStatus != null && consStatus.size() > 0) {
                for (int i = 0; i < consStatus.size(); i++) {
                    NationalThreatWrapper threat = consStatus.get(i);

                    if (threat.getReference() != null && threat.getReference().indexOf("IUCN") >= 0) {
                        scientificNameURL = scientificName.replace(' ', '+');
                    }
                }
            }

            // World Register of Marine Species - also has seals etc.
            wormsid = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_WORMS);

            n2000id = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_N2000);

            if (kingdomname.equalsIgnoreCase("Animals")) {
                faeu = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_FAEU);
            }

            itisTSN = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_ITIS);
            ncbi = factsheet.getLink(specie.getIdNatureObject(), Constants.SAME_SYNONYM_NCBI);

            String[][] linkTab =
            {
                    {Constants.ART17_SUMMARY, "Conservation status (art. 17)"},
                    {Constants.BBC_PAGE, "BBC page"}, // {Constants.BIOLIB_PAGE,"Biolib page"},
                    {Constants.BUG_GUIDE, "Bug Guide page"}, {"hasBirdActionPlan", "Bird action plan"},
                    {Constants.WIKIPEDIA_ARTICLE, "Wikipedia article"},
                    {Constants.WIKISPECIES_ARTICLE, "Wikispecies article"}};
            String linkUrl;

            links = new ArrayList<LinkDTO>();
            for (String[] linkSet : linkTab) {
                linkUrl = factsheet.getLink(specie.getIdNatureObject(), linkSet[0]);
                if (linkUrl != null && linkUrl.length() > 0) {
                    LinkDTO linkDTO = new LinkDTO();

                    linkDTO.setName(linkSet[1]);
                    linkDTO.setUrl(linkUrl);
                    links.add(linkDTO);
                }
            }

            if (consStatus.size() > 0) {
                List<NationalThreatWrapper> newList = new ArrayList<NationalThreatWrapper>();

                for (int i = 0; i < consStatus.size(); i++) {
                    NationalThreatWrapper threat = consStatus.get(i);
                    String statusDesc =
                        factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'", " ")
                        .replaceAll("\"", " ");

                    threat.setStatusDesc(statusDesc);
                    newList.add(threat);
                }
                consStatus = newList;
            }

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

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void geoTabActions() {
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
    }

    private void gridDistributionTabActions() {

        speciesDistribution = new ArrayList<SpeciesDistributionDTO>();

        DistributionWrapper dist = new DistributionWrapper(factsheet.getSpeciesNatureObject().getIdNatureObject());
        List d = dist.getDistribution();

        if (null != d && d.size() > 0) {
            String filename = getContext().getRequest().getSession().getId() + "_" + new Date().getTime() + "_europe.jpg";
            String tempDir = getContext().getInitParameter("TEMP_DIR");
            String inputFilename = getContext().getServletContext().getRealPath("/") + "gis/europe-bio.jpg";

            gridImage = tempDir + filename;
            String outputFilename = getContext().getServletContext().getRealPath("/") + gridImage;

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

    private void sitesTabActions() {

        // List of sites related to species.
        speciesSites = factsheet.getSitesForSpecies();
        mapIds = getIds(speciesSites);

        // List of sites related to subspecies.
        subSpeciesSites = factsheet.getSitesForSubpecies();
        subMapIds = getIds(subSpeciesSites);
    }

    private void deliveriesTabActions(int idSpecies) {

        String query =
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> " + "PREFIX dc: <http://purl.org/dc/elements/1.1/> "
            + "PREFIX dct: <http://purl.org/dc/terms/> "
            + "PREFIX e: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#> "
            + "PREFIX rod: <http://rod.eionet.europa.eu/schema.rdf#> "
            + "SELECT DISTINCT xsd:date(?released) AS ?released ?coverage ?envelope ?envtitle "
            + "IRI(bif:concat(?sourcefile,'/manage_document')) AS ?file ?filetitle " + "WHERE { "
            + "GRAPH ?sourcefile { " + "_:reference ?pred <http://eunis.eea.europa.eu/species/" + idSpecies + "> "
            + "OPTIONAL { _:reference rdfs:label ?label } " + "} " + "?envelope rod:hasFile ?sourcefile; "
            + "rod:released ?released; " + "rod:locality _:locurl; " + "dc:title ?envtitle . "
            + "_:locurl rdfs:label ?coverage . " + "?sourcefile dc:title ?filetitle " + "} ORDER BY DESC(?released)";

        String CRSparqlEndpoint = getContext().getApplicationProperty("cr.sparql.endpoint");
        if (!StringUtils.isBlank(CRSparqlEndpoint)) {
            QueryExecutor executor = new QueryExecutor();
            executor.executeQuery(CRSparqlEndpoint, query);
            deliveries = executor.getResults();
        }
    }

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
     * @return the factsheet
     */
    public SpeciesFactsheet getFactsheet() {
        return factsheet;
    }

    /**
     * @param factsheet
     *            the factsheet to set
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
     * @param tab
     *            the currentTab to set
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
     * @param idSpecies
     *            the idSpecies to set
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
     * @param idSpeciesLink
     *            the idSpeciesLink to set
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

    public PictureDTO getPic() {
        return pic;
    }

    public void setPic(PictureDTO pic) {
        this.pic = pic;
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

    public String getUrlPic() {
        return urlPic;
    }

    public void setUrlPic(String urlPic) {
        this.urlPic = urlPic;
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

    public QueryResult getDeliveries() {
        return deliveries;
    }

    public String[] getTabs() {
        return tabs;
    }

}
