package ro.finsiel.eunis.dataimport;


import java.util.ArrayList;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import ro.finsiel.eunis.utilities.SQLUtilities;


public class TesterJob implements Job {

    public TesterJob() {}

    public void execute(JobExecutionContext context) throws JobExecutionException {

        JobDataMap dataMap = context.getJobDetail().getJobDataMap();

        String sqlDrv = dataMap.getString("sqlDrv");
        String sqlUrl = dataMap.getString("sqlUrl");
        String sqlUsr = dataMap.getString("sqlUsr");
        String sqlPwd = dataMap.getString("sqlPwd");

        SQLUtilities sql = new SQLUtilities();

        sql.Init();

        String filePath = dataMap.getString("filePath");

        List<String> glob_errors = (ArrayList<String>) dataMap.get("errors");

        String table = dataMap.getString("table");

        try {

            Tester tester = new Tester();
            List<String> errors = tester.test(filePath, table, sqlDrv, sqlUrl,
                    sqlUsr, sqlPwd);

            if (errors != null && errors.size() > 0) {
                glob_errors.addAll(errors);
            }

        } catch (Exception _ex) {
            _ex.printStackTrace();
            throw new JobExecutionException(_ex.toString(), _ex);
        }
    }

}
