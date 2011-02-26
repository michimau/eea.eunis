package ro.finsiel.eunis.dataimport;


import java.sql.SQLException;

import javax.xml.parsers.ParserConfigurationException;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.xml.sax.SAXException;

import ro.finsiel.eunis.dataimport.parsers.ImportParser;
import ro.finsiel.eunis.utilities.SQLUtilities;


public class ImportJob implements Job {

    public ImportJob() {}

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
            if (emptyTable) {
                if (table != null && table.equals("natura2000")) {
                    sql.ExecuteDelete("chm62edt_sites", "SOURCE_DB='NATURA2000'");
                } else {
                    sql.ExecuteDelete(table, null);
                }
            }

            if (table != null && table.equals("natura2000")) {
                table = "chm62edt_sites";
            }

            ImportParser iparser = new ImportParser();

            iparser.execute(tmpDir + "importXmlFile", table, sqlDrv, sqlUsr,
                    sqlPwd, sqlUrl);

            // List<String> success = sql.ExecuteMultipleInsert(table, tableRows);

            // uploadedStream.close();
        } catch (SAXException _ex) {
            _ex.printStackTrace();
            sql.addImportLogMessage("Import error: " + _ex.getMessage());
            throw new JobExecutionException(_ex.toString(), _ex);
        } catch (ParserConfigurationException _ex) {
            _ex.printStackTrace();
            sql.addImportLogMessage("Import error: " + _ex.getMessage());
            throw new JobExecutionException(_ex.toString(), _ex);
        } catch (SQLException _ex) {
            _ex.printStackTrace();
            sql.addImportLogMessage("Import error: " + _ex.getMessage());
            throw new JobExecutionException(_ex.toString(), _ex);
        } catch (Exception _ex) {
            _ex.printStackTrace();
            sql.addImportLogMessage("Import error: " + _ex.getMessage());
            throw new JobExecutionException(_ex.toString(), _ex);
        }
    }

}
