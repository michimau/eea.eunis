package eionet.eunis.rdfexporter;

import java.util.List;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.rdf.GenerateHabitatRDF;

/**
 * Main class of RDF exporter.
 *
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class RdfExporter {
    private static final Logger logger = Logger.getLogger(RdfExporter.class);

    private static final String HEADER_SITES = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + " xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + " xmlns:cr=\"http://cr.eionet.europa.eu/ontologies/contreg.rdf#\"\n"
        + " xmlns:geo=\"http://www.w3.org/2003/01/geo/wgs84_pos#\"\n"
        + " xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">\n";

    private static final String HEADER_SPECIES = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + " xmlns:cr=\"http://cr.eionet.europa.eu/ontologies/contreg.rdf#\"\n"
        + " xmlns:dwc=\"http://rs.tdwg.org/dwc/terms/\"\n"
        + " xmlns =\"http://eunis.eea.europa.eu/rdf/species-schema.rdf#\">\n";

    private static final String HEADER_TAXONOMIES = "<rdf:RDF xmlns=\"http://eunis.eea.europa.eu/rdf/taxonomies-schema.rdf#\"\n"
        + " xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + " xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    private static final String FOOTER = "\n</rdf:RDF>";

    public static final String DEFAULT_NUM_OF_THREADS = "5";

    protected Properties exporterProperties;

    private int numOfThreads;
    private int limit;
    private int offset;
    private String fileNameSites;
    private String fileNameSpecies;
    private String fileNameTaxonomies;
    private String fileNameHabitats;

    private SQLUtilities sqlUtilities;

    /**
     * Load properties from exporter.properties file and initialize SQLUtils.
     *
     * @param numberOfObjectsToImport
     * @param offset
     */
    public void init(String numberOfObjectsToImport, String offset) {
        String jdbcDriver = null;
        ;
        String jdbcUrl = null;
        String jdbcUser = null;
        String jdbcPassword = null;

        try {
            exporterProperties = new Properties();
            exporterProperties.load(getClass().getClassLoader().getResourceAsStream("exporter.properties"));

            numOfThreads = Integer.valueOf(exporterProperties.getProperty("NUMBER_OF_THREADS", DEFAULT_NUM_OF_THREADS));

            if (numberOfObjectsToImport != null && numberOfObjectsToImport.length() > 0)
                limit = Integer.valueOf(numberOfObjectsToImport);
            else
                limit = Integer.valueOf(exporterProperties.getProperty("NUMBER_OF_SITES_TO_EXPORT", "0"));

            if (offset != null && offset.length() > 0)
                this.offset = Integer.valueOf(offset);
            else
                this.offset = Integer.valueOf(exporterProperties.getProperty("OFFSET", "0"));

            if (StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME_SITES"))) {
                throw new RuntimeException("Pleace specify FILE_NAME_SITES property");
            } else {
                fileNameSites = exporterProperties.getProperty("FILE_NAME_SITES");
            }

            if (StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME_SPECIES"))) {
                throw new RuntimeException("Pleace specify FILE_NAME_SPECIES property");
            } else {
                fileNameSpecies = exporterProperties.getProperty("FILE_NAME_SPECIES");
            }

            if (StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME_TAXONOMIES"))) {
                throw new RuntimeException("Pleace specify FILE_NAME_TAXONOMIES property");
            } else {
                fileNameTaxonomies = exporterProperties.getProperty("FILE_NAME_TAXONOMIES");
            }

            if (StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME_HABITATS"))) {
                throw new RuntimeException("Pleace specify FILE_NAME_HABITATS property");
            } else {
                fileNameHabitats = exporterProperties.getProperty("FILE_NAME_HABITATS");
            }

            if (StringUtils.isBlank(exporterProperties.getProperty("JDBC_DRV"))) {
                throw new RuntimeException("Pleace specify JDBC_DRV property");
            } else {
                jdbcDriver = exporterProperties.getProperty("JDBC_DRV");
            }
            if (StringUtils.isBlank(exporterProperties.getProperty("JDBC_URL"))) {
                throw new RuntimeException("Pleace specify JDBC_URL property");
            } else {
                jdbcUrl = exporterProperties.getProperty("JDBC_URL");
            }
            if (StringUtils.isBlank(exporterProperties.getProperty("JDBC_USR"))) {
                throw new RuntimeException("Pleace specify JDBC_USR property");
            } else {
                jdbcUser = exporterProperties.getProperty("JDBC_USR");
            }
            if (StringUtils.isBlank(exporterProperties.getProperty("JDBC_PWD"))) {
                throw new RuntimeException("Pleace specify JDBC_PWD property");
            } else {
                jdbcPassword = exporterProperties.getProperty("JDBC_PWD");
            }
        } catch (Exception e) {
            logger.error("Error on loading configuration.", e);
            System.exit(1);
        }

        sqlUtilities = new SQLUtilities();
        sqlUtilities.Init(jdbcDriver, jdbcUrl, jdbcUser, jdbcPassword);
    }

    /**
     * Export sites to file.
     */
    public void exportSites() {
        String countSitesQuery = "SELECT COUNT(ID_SITE) FROM CHM62EDT_SITES";
        String getSiteIdsQuery =
            "SELECT ID_SITE FROM CHM62EDT_SITES ORDER BY ID_SITE"
            + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");

        int totalNumberOfSites = Integer.valueOf(sqlUtilities.ExecuteSQL(countSitesQuery));

        logger.debug("Total number of sites in DB: " + totalNumberOfSites);
        if (limit > 0)
            logger.debug("Number of exported sites will be limited by " + limit + (offset > 0 ? " with offset " + offset : ""));

        List<String> siteIds = sqlUtilities.SQL2Array(getSiteIdsQuery);

        CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfSites);
        QueuedFileWriter fileWriter = new QueuedFileWriter(fileNameSites, HEADER_SITES, FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (String id : siteIds) {
            SiteExportTask task = new SiteExportTask(id, fileWriter);
            if (counter < numOfThreads) {
                try {
                    // jrf connection pool needs some time to create new
                    // connection
                    Thread.sleep(100L);
                } catch (InterruptedException e) {
                    logger.error(e, e);
                }
                counter++;
            }

            executor.execute(task);
        }

        try {
            doneSignal.await();
        } catch (InterruptedException e) {
            logger.error(e, e);
        }

        executor.shutdown();
        fileWriter.shutdown();
    }

    /**
     * Export habitats to file.
     */
    public void exportHabitats() {
        String countHabitatQuery = "SELECT COUNT(ID_HABITAT) FROM CHM62EDT_HABITAT";
        String getHabitatIdsQuery =
            "SELECT ID_HABITAT FROM CHM62EDT_HABITAT ORDER BY ID_HABITAT"
            + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");

        int totalNumberOfHabitat = Integer.valueOf(sqlUtilities.ExecuteSQL(countHabitatQuery));

        logger.debug("Total number of habitat types in DB: " + totalNumberOfHabitat);
        if (limit > 0)
            logger.debug("Number of exported habitat types will be limited by " + limit
                    + (offset > 0 ? " with offset " + offset : ""));

        List<String> habitatIds = sqlUtilities.SQL2Array(getHabitatIdsQuery);

        CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfHabitat);
        QueuedFileWriter fileWriter = new QueuedFileWriter(fileNameHabitats, GenerateHabitatRDF.HEADER, FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (String id : habitatIds) {
            HabitatExportTask task = new HabitatExportTask(id, fileWriter);
            if (counter < numOfThreads) {
                try {
                    // jrf connection pool needs some time to create new
                    // connection
                    Thread.sleep(100L);
                } catch (InterruptedException e) {
                    logger.error(e, e);
                }
                counter++;
            }

            executor.execute(task);
        }

        try {
            doneSignal.await();
        } catch (InterruptedException e) {
            logger.error(e, e);
        }

        executor.shutdown();
        fileWriter.shutdown();
    }

    /**
     * Export species to file.
     */
    public void exportSpecies() {
        String countSpeciesQuery = "SELECT COUNT(ID_SPECIES) FROM CHM62EDT_SPECIES";
        String getSpeciesIdsQuery =
            "SELECT ID_SPECIES FROM CHM62EDT_SPECIES ORDER BY ID_SPECIES"
            + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");

        int totalNumberOfSpecies = Integer.valueOf(sqlUtilities.ExecuteSQL(countSpeciesQuery));

        logger.debug("Total number of species in DB: " + totalNumberOfSpecies);
        if (limit > 0)
            logger.debug("Number of exported species will be limited by " + limit + (offset > 0 ? " with offset " + offset : ""));

        List<String> speciesIds = sqlUtilities.SQL2Array(getSpeciesIdsQuery);

        CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfSpecies);
        QueuedFileWriter fileWriter = new QueuedFileWriter(fileNameSpecies, HEADER_SPECIES, FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (String id : speciesIds) {
            SpeciesExportTask task = new SpeciesExportTask(id, fileWriter);
            if (counter < numOfThreads) {
                try {
                    // jrf connection pool needs some time to create new
                    // connection
                    Thread.sleep(100L);
                } catch (InterruptedException e) {
                    logger.error(e, e);
                }
                counter++;
            }

            executor.execute(task);
        }

        try {
            doneSignal.await();
        } catch (InterruptedException e) {
            logger.error(e, e);
        }

        executor.shutdown();
        fileWriter.shutdown();
    }

    /**
     * Export taxonomy to file.
     */
    public void exportTaxonomies() {
        String countTaxonomyQuery = "SELECT COUNT(ID_TAXONOMY) FROM CHM62EDT_TAXONOMY";
        String getTaxonomyIdsQuery =
            "SELECT ID_TAXONOMY FROM CHM62EDT_TAXONOMY ORDER BY ID_TAXONOMY"
            + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");

        int totalNumberOfTaxonomy = Integer.valueOf(sqlUtilities.ExecuteSQL(countTaxonomyQuery));

        logger.debug("Total number of species in DB: " + totalNumberOfTaxonomy);
        if (limit > 0)
            logger.debug("Number of exported taxonomies will be limited by " + limit
                    + (offset > 0 ? " with offset " + offset : ""));

        List<String> taxonomyIds = sqlUtilities.SQL2Array(getTaxonomyIdsQuery);

        CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfTaxonomy);
        QueuedFileWriter fileWriter = new QueuedFileWriter(fileNameTaxonomies, HEADER_TAXONOMIES, FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (String id : taxonomyIds) {
            TaxonomyExportTask task = new TaxonomyExportTask(id, fileWriter);
            if (counter < numOfThreads) {
                try {
                    // jrf connection pool needs some time to create new
                    // connection
                    Thread.sleep(100L);
                } catch (InterruptedException e) {
                    logger.error(e, e);
                }
                counter++;
            }
            executor.execute(task);
        }

        try {
            doneSignal.await();
        } catch (InterruptedException e) {
            logger.error(e, e);
        }

        executor.shutdown();
        fileWriter.shutdown();
    }

    /**
     * main method.
     *
     * @param args
     */
    public static void main(String... args) {
        if (args.length == 0) {
            logger.error("Missing argument what to import: sites/species/taxonomies/habitats");
        } else if (!args[0].equals("sites") && !args[0].equals("species") && !args[0].equals("taxonomies")
                && !args[0].equals("habitats")) {
            logger.error("Usage: rdfExporter {sites|species|taxonomies|habitats} [limit] [offset]");
        } else {
            logger.info("RDF exporter started");
            long startTime = System.currentTimeMillis();

            String what = null;
            String numberOfObjectsToImport = null;
            String offset = null;

            int i = 0;
            for (String arg : args) {
                if (i == 0)
                    what = arg;
                else if (i == 1)
                    numberOfObjectsToImport = arg;
                else if (i == 2)
                    offset = arg;
                i++;
            }

            RdfExporter exporter = new RdfExporter();
            exporter.init(numberOfObjectsToImport, offset);

            String exportedCnt = "";
            if (what != null && what.equals("sites")) {
                exporter.exportSites();
                exportedCnt = "Totally exported " + SiteExportTask.getNumberOfExportedSites() + " sites.";
            } else if (what != null && what.equals("species")) {
                exporter.exportSpecies();
                exportedCnt = "Totally exported " + SpeciesExportTask.getNumberOfExportedSpecies() + " species.";
            } else if (what != null && what.equals("taxonomies")) {
                exporter.exportTaxonomies();
                exportedCnt = "Totally exported " + TaxonomyExportTask.getNumberOfExportedTaxonomies() + " taxonomies.";
            } else if (what != null && what.equals("habitats")) {
                exporter.exportHabitats();
                exportedCnt = "Totally exported " + HabitatExportTask.getNumberOfExportedHabitats() + " habitat types.";
            }

            long endTime = System.currentTimeMillis();
            logger.info("Export finished in " + (endTime - startTime) + "ms. " + exportedCnt);
        }
    }

}
