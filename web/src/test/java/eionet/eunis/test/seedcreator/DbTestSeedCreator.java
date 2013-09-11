package eionet.eunis.test.seedcreator;

import java.io.FileOutputStream;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSet;

import ro.finsiel.eunis.admin.FileUtils;
import eionet.eunis.test.DbHelper;

/**
 * Helper application to create database test xml files.
 * 
 * @author Jaak Kapten
 */
public class DbTestSeedCreator extends DbHelper {

    /**
     * exctract data from DB and create xml files.
     * 
     * Add module name as first keyword to command line.
     * 
     * @param command
     *            line args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        if (args.length > 0) {

            String testcaseName = args[0];

            IDatabaseConnection dbConnection = null;
            // database connection
            try {
                dbConnection = getConnection(true);
                
                DbTestSeed seed = DbTestSeed.getSeed(testcaseName);
                
                if (seed != null){
                
                    String filename = seed.getFullFilename();
                    if (!FileUtils.exists(filename)) {
                        TestCaseSeedBase testCaseSeed = seed.getSeedImplementation();
                        QueryDataSet partialDataSet = testCaseSeed.prepareCase(dbConnection);
                        FlatXmlDataSet.write(partialDataSet, new FileOutputStream(filename));
                        System.out.println("Testcase: " + testcaseName + " completed");
                    } else {
                        throw new Exception("File already generated. To regenerate, delete the old file.");
                    }
                } else {
                    throw new Exception("Seed with the specified name " + testcaseName + " is not defined in the system.");
                }
                
            } catch (Exception ex) {
                throw new Exception("Seed generation failed: " + ex.getMessage());
            } finally {
                if (dbConnection != null) {
                    dbConnection.close();
                }
            }
        } else {
            throw new Exception("The application must have at least 1 commandline parameter to select dataset.");
        }

    }

}
