package ro.finsiel.eunis.dataimport;

import java.sql.SQLException;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import ro.finsiel.eunis.utilities.SQLUtilities;

public class PostImportScriptsJob implements Job {
	
	public PostImportScriptsJob() {
		
	}
	
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		
		String sqlDrv = dataMap.getString("sqlDrv");
		String sqlUrl = dataMap.getString("sqlUrl");
		String sqlUsr = dataMap.getString("sqlUsr");
		String sqlPwd = dataMap.getString("sqlPwd");
		
		SQLUtilities sql = new SQLUtilities();
    	sql.Init(sqlDrv, sqlUrl, sqlUsr, sqlPwd);
		
    	String sites = dataMap.getString("sites");
        String empty_digir = dataMap.getString("empty_digir");
        String digir = dataMap.getString("digir");
        String statistics = dataMap.getString("statistics");
        String spiecesTab = dataMap.getString("spiecesTab");
        String habitatsTab = dataMap.getString("habitatsTab");
        String sitesTab = dataMap.getString("sitesTab");
        
		try {
			
			if(sites != null && sites.equals("on"))
    			sql.runPostImportSitesScript();
    		
    		if(empty_digir != null && empty_digir.equals("on"))
    			sql.emptyDigiTable();
    		
    		if(digir != null && digir.equals("on")){
    			PopulateDigir pd = new PopulateDigir();
    			pd.Init(sqlDrv, sqlUrl, sqlUsr, sqlPwd);
    			pd.populate();
    		}     
    		
    		if(statistics != null && statistics.equals("on"))
    			sql.generateDigirStatistics();
    		
    		TabScripts scripts = new TabScripts();
    		scripts.Init(sqlDrv, sqlUrl, sqlUsr, sqlPwd);
    		
    		if(spiecesTab != null && spiecesTab.equals("on"))
    			scripts.setTabSpecies();
    		
    		if(habitatsTab != null && habitatsTab.equals("on"))
    			scripts.setTabHabitats();
    		
    		if(sitesTab != null && sitesTab.equals("on"))
    			scripts.setTabSites();
	    	
		} catch (SQLException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Post import script error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (Exception _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Post import script error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		}
	}


}
