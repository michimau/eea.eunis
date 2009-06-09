package ro.finsiel.eunis.dataimport;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.SimpleTrigger;
import org.xml.sax.SAXException;

import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.utilities.TableColumns;


public class DataImporter extends HttpServlet {
	
	/** ROOT of the application (relative to $INSTANCE_HOME env. variable.) */
	private static String BASE_DIR = "";
	/** The temporary dir where parts of the upload are stored temporary (if file size is bigger than memory buffer). */
	private static String TEMP_DIR = "temp";
	/** Maximum file size allowed to be uploaded to the server. */
	private static int MAX_FILE_SIZE = 512 * 1024 * 1024; // Default value
	/** Files with size smaller than this are written directly to disk, others through TEMP_DIR first. */
	private static int MAX_MEM_TRESHOLD = 4096;// Files smaller than 4k are directly written to disk
	
	private static List<String> errors = null;
	
	/**	
	* Overrides public method doPost of javax.servlet.http.HttpServlet.
	* @param request Request object
	* @param response Response object.
	*/
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String retPage = "dataimport/data-importer.jsp";
		
		HttpSession session = request.getSession(false);
		SessionManager sessionManager = (SessionManager) session.getAttribute("SessionManager");
		if (sessionManager.isAuthenticated() && sessionManager.isImportExportData_RIGHT()) {
			errors = new ArrayList<String>();
			
			String SQL_DRV = request.getSession().getServletContext().getInitParameter("JDBC_DRV");
			String SQL_URL = request.getSession().getServletContext().getInitParameter("JDBC_URL");
	        String SQL_USR = request.getSession().getServletContext().getInitParameter("JDBC_USR");
	        String SQL_PWD = request.getSession().getServletContext().getInitParameter("JDBC_PWD");
	        
			String table = "";
			boolean emptyTable = false;
			boolean runBackground = false;
			// Initialise the default settings
		    try
		    {
		      BASE_DIR = getServletContext().getInitParameter( "INSTANCE_HOME" );
		      TEMP_DIR = BASE_DIR + getServletContext().getInitParameter("TEMP_DIR");
		    } catch (Exception ex) {
		      ex.printStackTrace();
		    }
		    List items = new ArrayList();
		    boolean isMultipart = FileUpload.isMultipartContent(request);
		    DiskFileUpload upload = new DiskFileUpload();
		    upload.setSizeThreshold(MAX_MEM_TRESHOLD);
		    upload.setSizeMax(MAX_FILE_SIZE);
		    upload.setRepositoryPath(TEMP_DIR);
		    
		    if (isMultipart) {
				try {
					items = upload.parseRequest(request);
				} catch (FileUploadException ex) {
					ex.printStackTrace();
					errors.add(ex.getMessage());
					response.sendRedirect(retPage);
				}
	
		    	for (int i = 0; i < items.size(); i++) {
		            FileItem item = (FileItem) items.get(i);
		            if(item.isFormField()){
		            	String fieldName = item.getFieldName();
		                String fieldValue = item.getString();
		                if (null != fieldName && fieldName.equals("table")) {
		                	if(null != fieldValue && !fieldValue.equals("")){
		                		table = fieldValue;
		                	}else{
		                		errors.add("Please select table!");
	            	    		break;
		                	}
		                } else if(null != fieldName && fieldName.equals("empty")){
		                	if(null != fieldValue && fieldValue.equals("on"))
		                		emptyTable = true;
		                } else if(null != fieldName && fieldName.equals("back")){
		                	if(null != fieldValue && fieldValue.equals("on"))
		                		runBackground = true;
		                }
		            }
		    	}
		    	for (int i = 0; i < items.size(); i++) {
		    		FileItem item = (FileItem) items.get(i);
		    		if(!item.isFormField()){
		                try {
		                	File xmlFile = new File(TEMP_DIR + "importXmlFile");
		                	item.write(xmlFile);
		                	
		                	if(runBackground){
		                		SchedulerFactory schedFact = new org.quartz.impl.StdSchedulerFactory();
		                		Scheduler sched = schedFact.getScheduler();
		                		sched.start();

		                		JobDetail jobDetail = new JobDetail("importJob", null, ImportJob.class);
		                		jobDetail.getJobDataMap().put("sqlDrv", SQL_DRV);
		                		jobDetail.getJobDataMap().put("sqlUrl", SQL_URL);
		                		jobDetail.getJobDataMap().put("sqlUsr", SQL_USR);
		                		jobDetail.getJobDataMap().put("sqlPwd", SQL_PWD);
		                		jobDetail.getJobDataMap().put("tmpDir", TEMP_DIR);
		                		jobDetail.getJobDataMap().put("table", table);
		                		jobDetail.getJobDataMap().put("emptyTable", emptyTable);
		                		
		                		ImportJobListener listener = new ImportJobListener();
		                		jobDetail.addJobListener(listener.getName());
		                		sched.addJobListener(listener);
		                		
		                		SimpleTrigger trigger = new SimpleTrigger(jobDetail.getName(), null, new Date(), null, 0, 0L);
		                				                		
		                		sched.scheduleJob(jobDetail, trigger);
		                		
		                		retPage = "dataimport/import-log.jsp";
		                	} else {
		                		SQLUtilities sql = new SQLUtilities();
			                	sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
		                		if(emptyTable)
			                		sql.ExecuteDelete(table, null);
		                		
			                	ImportParser iparser = new ImportParser();
			                	iparser.execute(TEMP_DIR + "importXmlFile", table, SQL_DRV, SQL_USR, SQL_PWD, SQL_URL);
			                	
			                	//List<String> success = sql.ExecuteMultipleInsert(table, tableRows);
			                	/*if(success != null || success.size() > 0){
			                		errors.add("Data import failed!");
			                		errors.addAll(success);
			                	}*/
		                	
		                	}
		                	
		                	//uploadedStream.close();
		    	    	} catch (SAXException _ex) {
		    	    		_ex.printStackTrace();
		    	    		errors.add("Data import failed!");
		    	    		errors.add(_ex.getMessage());
		    	    	} catch (ParserConfigurationException _ex) {
		    	    		_ex.printStackTrace();
		    	    		errors.add("Data import failed!");
		    	    		errors.add(_ex.getMessage());
		    	    	} catch (SQLException _ex) {
		    	    		_ex.printStackTrace();
		    	    		errors.add("Data import failed!");
		    	    		errors.add(_ex.getMessage());
		    	    	} catch (Exception _ex) {
		    	    		_ex.printStackTrace();
		    	    		errors.add("Data import failed!");
		    	    		errors.add(_ex.getMessage());
		    	    	}
		            }
		    	}
		    	if(!runBackground){
					if(errors != null && errors.size() > 0)
						session.setAttribute("errors", errors);
					else
						session.setAttribute("success", "Successfully imported!");
		    	}
		    }
		}
		response.sendRedirect(retPage);
	}
	
}
