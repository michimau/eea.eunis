package eionet.eunis.test.seedcreator;

import eionet.eunis.test.seedcreator.seedimpl.RedlistSpeciesTestCaseSeed;
import eionet.eunis.test.seedcreator.seedimpl.SitesSearchTestCaseSeed;


/**
 * 
 * ENUM for database testset seed configurations.
 * 
 * @author Jaak
 */
public enum DbTestSeed {

    SITES_SEARCH("seed-sites-search.xml", "sites-search", SitesSearchTestCaseSeed.class),
    REDLIST_SPECIES("seed-redlist-species.xml", "redlist-species", RedlistSpeciesTestCaseSeed.class);

    private final static String resourcesFolder = "src/test/resources/";
    private final static String seedsFolder = "";

    private String filename;
    private String commandLineCode;
    private Class implementationClass;

    private DbTestSeed(String filename, String commandLineCode, Class implementationClass) {
        this.filename = filename;
        this.commandLineCode = commandLineCode;
        this.implementationClass = implementationClass; 
    }

    public String getFullFilename() {
        return resourcesFolder + seedsFolder + this.filename;
    }

    public String getLocalFilename() {
        return seedsFolder + this.filename;
    }

    public static DbTestSeed getSeed(String commandLineCode) {
        for (DbTestSeed seed : DbTestSeed.values()) {
            if (seed.commandLineCode.equals(commandLineCode)) {
                return seed;
            }
        }
        return null;
    }

   
    public TestCaseSeedBase getSeedImplementation(){
        try {
            return (TestCaseSeedBase) implementationClass.newInstance();
        } catch (Exception ex){
            return null;
        }
    }

}
