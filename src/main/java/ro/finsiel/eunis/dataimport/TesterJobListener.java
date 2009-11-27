package ro.finsiel.eunis.dataimport;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobListener;

import ro.finsiel.eunis.SendMail;

/**
 * 
 * @author altnyris
 *
 */
public class TesterJobListener implements JobListener{
	
	/** */
	private static Log logger = LogFactory.getLog(TesterJobListener.class);

	/*
	 * (non-Javadoc)
	 * @see org.quartz.JobListener#getName()
	 */
	public String getName() {
		return this.getClass().getSimpleName();
	}
	
	/*
	 * (non-Javadoc)
	 * @see org.quartz.JobListener#jobExecutionVetoed(org.quartz.JobExecutionContext)
	 */
	public void jobExecutionVetoed(JobExecutionContext context) {
		logger.info("Execution vetoed for job " + context.getJobDetail().getName());
	}

	/*
	 * (non-Javadoc)
	 * @see org.quartz.JobListener#jobToBeExecuted(org.quartz.JobExecutionContext)
	 */
	public void jobToBeExecuted(JobExecutionContext context) {
	}

	/*
	 * (non-Javadoc)
	 * @see org.quartz.JobListener#jobWasExecuted(org.quartz.JobExecutionContext, org.quartz.JobExecutionException)
	 */
	public void jobWasExecuted(JobExecutionContext context, JobExecutionException exception) {
		
		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		
		String smtpServer = dataMap.getString("smtpServer");
		String smtpUsername = dataMap.getString("smtpUsername");
		String smtpPassword = dataMap.getString("smtpPassword");
		String smtpSender = dataMap.getString("smtpSender");
		String email = dataMap.getString("email");
		
		String table = dataMap.getString("table");
		List<String> errors = (ArrayList<String>)dataMap.get("errors");
		
		if (exception!=null){
			logger.error("Exception thrown when executing job " + context.getJobDetail().getName() + ": " + exception.toString(), exception);
			errors.add("Table "+table+" test failed!");
			return;
		}
		String subject = "EUNIS - information about testing XML file for table "+table;
		String body = "";
		if(errors != null && errors.size() > 0){
			body += errors.size()+" errors found:";
			body += "\n";
			for(Iterator<String> it = errors.iterator(); it.hasNext(); ){
				String error = it.next();
				body += error;
				body += "\n";
			}
		} else {
			body += "No errors found.";
		}
		try{
			SendMail.sendMail(email, subject, body, smtpServer, smtpUsername, smtpPassword, smtpSender, null);
		} catch ( Exception _ex ) {
			_ex.printStackTrace( System.err );
			logger.error(_ex.getMessage());
		}
	}
}
