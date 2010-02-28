package eionet.eunis.rdfexporter;

import java.util.List;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * Main class of RDF exporter.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class RdfExporter {
	private static final Logger logger = Logger.getLogger(RdfExporter.class);
	
	private static final String HEADER = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" 
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:cr=\"http://cr.eionet.europa.eu/ontologies/contreg.rdf#\"\n"
        + "xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">\n";
	
	private static final String FOOTER = "\n</rdf:RDF>";
	
	public static final String DEFAULT_NUM_OF_THREADS = "5";
	
	protected Properties exporterProperties;
	
	private int numOfThreads;
	private int limit;
	private int offset;
	private String fileName;
	
	private SQLUtilities sqlUtilities;
	
	/**
	 * Load properties from exporter.properties file and initialize SQLUtils
	 */
	public void init() {
		String jdbcDriver = null;;
		String jdbcUrl = null;
		String jdbcUser = null;
		String jdbcPassword = null;
		
		try {
			exporterProperties = new Properties();
			exporterProperties.load(getClass().getClassLoader().getResourceAsStream("exporter.properties"));
			
			numOfThreads = Integer.valueOf(exporterProperties.getProperty("NUMBER_OF_THREADS", DEFAULT_NUM_OF_THREADS));
			limit = Integer.valueOf(exporterProperties.getProperty("NUMBER_OF_SITES_TO_EXPORT", "0"));
			offset = Integer.valueOf(exporterProperties.getProperty("OFFSET", "0"));
			
			if(StringUtils.isBlank(exporterProperties.getProperty("FILE_NAME"))) {
				throw new RuntimeException("Pleace specify FILE_NAME property");
			} else {
				fileName = exporterProperties.getProperty("FILE_NAME");
			}
			
			if(StringUtils.isBlank(exporterProperties.getProperty("JDBC_DRV"))) {
				throw new RuntimeException("Pleace specify JDBC_DRV property");
			} else {
				jdbcDriver = exporterProperties.getProperty("JDBC_DRV");
			}
			if(StringUtils.isBlank(exporterProperties.getProperty("JDBC_URL"))) {
				throw new RuntimeException("Pleace specify JDBC_URL property");
			} else {
				jdbcUrl= exporterProperties.getProperty("JDBC_URL");
			}
			if(StringUtils.isBlank(exporterProperties.getProperty("JDBC_USR"))) {
				throw new RuntimeException("Pleace specify JDBC_USR property");
			} else {
				jdbcUser= exporterProperties.getProperty("JDBC_USR");
			}
			if(StringUtils.isBlank(exporterProperties.getProperty("JDBC_PWD"))) {
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
	 * Export sites to file
	 */
	public void export() {
		String countSitesQuery = "SELECT COUNT(ID_SITE) FROM CHM62EDT_SITES";
		String getSiteIdsQuery = "SELECT ID_SITE FROM CHM62EDT_SITES ORDER BY ID_SITE" + (limit > 0 ? " LIMIT " + (offset > 0 ? offset + "," : "") + limit : "");
		
		int totalNumberOfSites = Integer.valueOf(sqlUtilities.ExecuteSQL(countSitesQuery));
		
		logger.debug("Total number of sites in DB: " + totalNumberOfSites);
		if(limit > 0) logger.debug("Number of exported sites will be limited by " + limit + (offset > 0 ? " with offset " + offset :""));
		
		List<String> siteIds = sqlUtilities.SQL2Array(getSiteIdsQuery);
		
		CountDownLatch doneSignal = new CountDownLatch(limit > 0 ? limit : totalNumberOfSites);
		QueuedFileWriter fileWriter = new QueuedFileWriter(fileName, HEADER, FOOTER, doneSignal);
		ExecutorService executor = Executors.newFixedThreadPool(numOfThreads);

		new Thread(fileWriter).start();

		int counter = 0;
		for (String id: siteIds) {
			SiteExportTask task = new SiteExportTask(id, fileWriter);
			if(counter < numOfThreads) {
				try {
					//jrf connection pool needs some time to create new connection
					Thread.sleep(100L);
				} catch (InterruptedException e) {
					logger.error(e,e);
				}
				counter++;
			}
			
			executor.execute(task);
		}

		try {
			doneSignal.await();
		} catch (InterruptedException e) {
			logger.error(e,e);
		}
		
		executor.shutdown();
		fileWriter.shutdown();
	}
	

	/**
	 * main method
	 * 
	 * @param args
	 */
	public static void main (String... args) {
		logger.info("RDF exporter started");
		long startTime = System.currentTimeMillis();
		
		RdfExporter exporter = new RdfExporter();
		exporter.init();
		exporter.export();

		long endTime = System.currentTimeMillis();
		logger.info("Export finished in " + (endTime - startTime) + "ms. Totally exported " + SiteExportTask.getNumberOfExportedSites() + " sites.");
	}

}
