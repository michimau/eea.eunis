package eionet.eunis.rdfexporter;

import java.io.PrintStream;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.dto.DoubleDTO;
import eionet.eunis.rdf.GenerateDesignationRDF;
import eionet.eunis.rdf.GenerateHabitatRDF;
import eionet.eunis.rdf.GenerateSiteRDF;
import eionet.eunis.rdf.GenerateSpeciesRDF;
import eionet.eunis.rdf.GenerateTaxonomyRDF;
import eionet.eunis.util.Constants;

/**
 * Main class of RDF exporter.
 *
 * @author Risto Alt
 */
public class RdfExporter {

    private static final Logger logger = Logger.getLogger(RdfExporter.class);
    /** Number of parallel connections to the database. */
    public static final String DEFAULT_NUM_OF_THREADS = "5";

    protected Properties exporterProperties;

    /** Number of parallel connections to the database. */
    private int numOfThreads;
    private int limit;
    private int offset;
    private String fileNameSites;
    private String fileNameSpecies;
    private String fileNameTaxonomies;
    private String fileNameHabitats;
    private String fileNameDesignations;

    private SQLUtilities sqlUtilities;

    /**
     * Load properties from exporter.properties file and initialize SQLUtils.
     *
     * @param numberOfObjectsToImport - Number of objects to export.
     * @param offset into the database query
     */
    public void init(String numberOfObjectsToImport, String offset) {
        String jdbcDriver = null;
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
                limit = Integer.valueOf(exporterProperties.getProperty("NUMBER_OF_OBJECTS_TO_EXPORT", "0"));

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

            if (StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME_DESIGNATIONS"))) {
                throw new RuntimeException("Pleace specify FILE_NAME_DESIGNATIONS property");
            } else {
                fileNameDesignations = exporterProperties.getProperty("FILE_NAME_DESIGNATIONS");
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
        QueuedFileWriter fileWriter = new QueuedFileWriter(
                fileNameSites, GenerateSiteRDF.HEADER, Constants.RDF_FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (String id : siteIds) {
            SiteExportTask task = new SiteExportTask(id, fileWriter);
            if (counter < numOfThreads) {
                try {
                    // jrf connection pool needs some time to create new connection
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
        QueuedFileWriter fileWriter = new QueuedFileWriter(
                fileNameHabitats, GenerateHabitatRDF.HEADER, Constants.RDF_FOOTER, doneSignal);
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
     * Export designations to file.
     */
    public void exportDesignations() {
        String countDesignationsQuery = "SELECT COUNT(*) FROM CHM62EDT_DESIGNATIONS";
        String getIdsQuery =
            "SELECT ID_DESIGNATION, ID_GEOSCOPE FROM CHM62EDT_DESIGNATIONS ORDER BY ID_DESIGNATION"
            + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");

        int totalNumberOfDesignations = Integer.valueOf(sqlUtilities.ExecuteSQL(countDesignationsQuery));

        logger.debug("Total number of designations in DB: " + totalNumberOfDesignations);
        if (limit > 0)
            logger.debug("Number of exported designations will be limited by " + limit
                    + (offset > 0 ? " with offset " + offset : ""));

        List<DoubleDTO> ids = sqlUtilities.SQL2ListOfDoubles(getIdsQuery, "ID_DESIGNATION", "ID_GEOSCOPE");

        CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfDesignations);
        QueuedFileWriter fileWriter = new QueuedFileWriter(
                fileNameDesignations, GenerateDesignationRDF.HEADER, Constants.RDF_FOOTER, doneSignal);
        ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

        new Thread(fileWriter).start();

        int counter = 0;
        for (DoubleDTO d : ids) {
            DesignationExportTask task = new DesignationExportTask(d.getOne(), d.getTwo(), fileWriter);
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
        QueuedFileWriter fileWriter = new QueuedFileWriter(
                fileNameSpecies, GenerateSpeciesRDF.HEADER, Constants.RDF_FOOTER, doneSignal);
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
        QueuedFileWriter fileWriter = new QueuedFileWriter(
                fileNameTaxonomies, GenerateTaxonomyRDF.HEADER, Constants.RDF_FOOTER, doneSignal);
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
     * @param args - Command line arguments
     */
    public static void main(String... args) {
        if (args.length == 0) {
            logger.error("Missing argument what to import: sites/species/taxonomies/habitats/designations");
            //      } else if (!args[0].equals("sites") && !args[0].equals("species") && !args[0].equals("taxonomies")
            //              && !args[0].equals("habitats") && !args[0].equals("designations")) {
            //          logger.error("Usage: rdfExporter {sites|species|taxonomies|habitats|designations} [limit] [offset]");
        } else {
            logger.info("RDF exporter started");
            long startTime = System.currentTimeMillis();

            String what = null;
            String numberOfObjectsToImport = null; //TODO: Remove
            String offset = null; //TODO: Remove
            //TODO: Add the ability to export one object

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

            //TODO: Remove count of exported objects
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
            } else if ("designations".equals(what)) {
                exporter.exportDesignations();
                exportedCnt = "Totally exported " + DesignationExportTask.getNumberOfExportedDesignations() + " designations.";
            } else {
                try {
                    PrintStream outputStream = new PrintStream(what + ".rdf");
                    GenerateRDF r = new GenerateRDF(outputStream);
                    r.exportTable(what);
                    r.close();
                    exportedCnt = "";
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            long endTime = System.currentTimeMillis();
            logger.info("Export finished in " + (endTime - startTime) + "ms. " + exportedCnt);
        }
    }

}
