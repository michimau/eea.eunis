package ro.finsiel.eunis.dataimport;

import java.sql.SQLException;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.xml.sax.SAXException;

import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.utilities.TableColumns;

public class ImportJob implements Job {
	
	public ImportJob() {
		
	}
	
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		
		String sqlDrv = dataMap.getString("sqlDrv");
		String sqlUrl = dataMap.getString("sqlUrl");
		String sqlUsr = dataMap.getString("sqlUsr");
		String sqlPwd = dataMap.getString("sqlPwd");
		
		SQLUtilities sql = new SQLUtilities();
    	sql.Init(sqlDrv, sqlUrl, sqlUsr, sqlPwd);
		
		String tmpDir = dataMap.getString("tmpDir");

		String table = dataMap.getString("table");
		boolean emptyTable = dataMap.getBoolean("emptyTable");
		try {
			ImportParser iparser = new ImportParser();
        	List<TableColumns> tableRows = iparser.getTableRows(tmpDir + "importXmlFile");
	    	
	    	if(emptyTable)
	    		sql.ExecuteDelete(table, null);
	    	List<String> success = sql.ExecuteMultipleInsert(table, tableRows);
	    	if(success != null || success.size() > 0){
	    		sql.addImportLogMessage("Import error: "+success.get(0));
        	}
	    	
	    	//uploadedStream.close();
		} catch (SAXException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (ParserConfigurationException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (SQLException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (Exception _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		}
	}


}
