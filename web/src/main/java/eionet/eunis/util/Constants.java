package eionet.eunis.util;


public interface Constants {

    /** */
    // Warning messages
    public static final int SEVERITY_INFO = 1;
    public static final int SEVERITY_CAUTION = 2;
    public static final int SEVERITY_WARNING = 3;
    public static final int SEVERITY_ERROR = 4;

    // Link info constants
    public static final String GEOSPECIES_IDENTIFIER = "GEOSPECIES_IDENTIFIER";
    public static final String GBIF_PAGE = "hasGBIF";
    public static final String BIOLIB_PAGE = "hasBioLibPage";
    public static final String BBC_PAGE = "hasBBCPage";
    public static final String EOL_PAGE = "hasEOLPage";
    public static final String WIKIPEDIA_ARTICLE = "hasWikipediaArticle";
    public static final String WIKISPECIES_ARTICLE = "hasWikispeciesArticle";
    public static final String BUG_GUIDE = "hasBugGuidePage";
    public static final String ART17_SUMMARY = "art17SummaryPage";

    // Same Species
    public static final String SAME_SPECIES_EOL = "sameSpeciesEOL"; // www.eol.org
    public static final String SAME_SPECIES_GBIF = "sameSpeciesGBIF"; // www.gbif.org
    public static final String SAME_SPECIES_ITIS = "sameSpeciesITIS"; // www.itis.gov
    public static final String SAME_SPECIES_NCBI = "sameSpeciesNCBI"; // www.ncbi.nlm.nih.gov
    public static final String SAME_SPECIES_REDLIST = "sameSpeciesRedlist"; // IUCN Red list
    public static final String SAME_SPECIES_FIFAO = "sameSpeciesFIFAO"; // FAO aquatic species distribution

    // Same Synonym
    public static final String SAME_SYNONYM_EOL = "sameSynonymEOL";
    public static final String SAME_SYNONYM_GBIF = "sameSynonymGBIF";
    public static final String SAME_SYNONYM_ITIS = "sameSynonymITIS";
    public static final String SAME_SYNONYM_NCBI = "sameSynonymNCBI";
    public static final String SAME_SYNONYM_FAEU = "sameSynonymFaEu"; // Fauna Europaea
    public static final String SAME_SYNONYM_WORMS = "sameSynonymWorMS"; // World Register of Marine Species

    // BioRegions
    public static final String ALPINE = "ALPINE";
    public static final String ANATOL = "ANATOL";
    public static final String ARCTIC = "ARCTIC";
    public static final String ATLANTIC = "ATLANTIC";
    public static final String BOREAL = "BOREAL";
    public static final String CONTINENT = "CONTINENT";
    public static final String MACARONES = "MACARONES";
    public static final String MEDITERRANIAN = "MEDITERRANIAN";
    public static final String PANNONIC = "PANNONIC";
    public static final String PONTIC = "PONTIC";
    public static final String STEPPIC = "STEPPIC";

    // ReportAttributes - habitats
    public static final String REPORT_ATTRIBUTE_HABITAT_COVER = "COVER";
    public static final String REPORT_ATTRIBUTE_HABITAT_REPRESENTATIVITY = "REPRESENTATIVITY";
    public static final String REPORT_ATTRIBUTE_HABITAT_RELATIVE_SURFACE = "RELATIVE_SURFACE";
    public static final String REPORT_ATTRIBUTE_HABITAT_CONSERVATION = "CONSERVATION";
    public static final String REPORT_ATTRIBUTE_HABITAT_GLOBAL = "GLOBAL";
    public static final String REPORT_ATTRIBUTE_HABITAT_SOURCE_TABLE = "SOURCE_TABLE";

    // ReportAttributes - species
    public static final String REPORT_ATTRIBUTE_SPECIES_RESIDENT = "RESIDENT";
    public static final String REPORT_ATTRIBUTE_SPECIES_POPULATION = "POPULATION";
    public static final String REPORT_ATTRIBUTE_SPECIES_CONSERVATION = "CONSERVATION";
    public static final String REPORT_ATTRIBUTE_SPECIES_ISOLATION = "ISOLATION";
    public static final String REPORT_ATTRIBUTE_SPECIES_GLOBAL = "GLOBAL";
    public static final String REPORT_ATTRIBUTE_SPECIES_STAGING = "STAGING";
    public static final String REPORT_ATTRIBUTE_SPECIES_WINTER = "WINTERING";
    public static final String REPORT_ATTRIBUTE_SPECIES_BREEDING = "BREEDING";
    public static final String REPORT_ATTRIBUTE_SPECIES_OTHER_SPECIES = "OTHER_SPECIES";
    public static final String REPORT_ATTRIBUTE_SPECIES_SOURCE_TABLE = "SOURCE_TABLE";

    public static final String REPORT_ATTRIBUTE_OTHER_SPECIES_POPULATION = "OTHER_POPULATION";
    public static final String REPORT_ATTRIBUTE_OTHER_SPECIES_MOTIVATION = "OTHER_MOTIVATION";

    // Site Factsheet tab names
    public static final String SITES_TAB_GENERAL = "GENERAL_INFORMATION";
    public static final String SITES_TAB_FAUNA_FLORA = "FAUNA_FLORA";
    public static final String SITES_TAB_DESIGNATION = "DESIGNATION";
    public static final String SITES_TAB_HABITAT_TYPES = "HABITATS";
    public static final String SITES_TAB_SITES = "SITES";
    public static final String SITES_TAB_OTHER_INFO = "OTHER";

    // SOURCE_TABLE values
    public static final String SPECIES_SOURCE_TABLE_BIRD = "Bird";
    public static final String SPECIES_SOURCE_TABLE_MAMMAL = "Mammal";
    public static final String SPECIES_SOURCE_TABLE_AMPREP = "Amprep";
    public static final String SPECIES_SOURCE_TABLE_FISHES = "Fishes";
    public static final String SPECIES_SOURCE_TABLE_INVERT = "invert";
    public static final String SPECIES_SOURCE_TABLE_PLANT = "Plant";

    // RDF datatypes
    public static final String XSD_DECIMAL = "http://www.w3.org/2001/XMLSchema#decimal";
    public static final String XSD_INTEGER = "http://www.w3.org/2001/XMLSchema#integer";

    // RDF header
    public static final String ACCEPT_RDF_HEADER = "application/rdf+xml";

    // RDF footer
    public static final String RDF_FOOTER = "\n</rdf:RDF>\n";

    /** The name of the webapp init-parameter that stands for application home. */
    public static final String APP_HOME_INIT_PARAM = "APP_HOME";
}
