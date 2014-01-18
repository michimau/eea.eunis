package ro.finsiel.eunis.dataimport.parsers;

import eionet.eunis.test.DbHelper;
import junit.framework.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import ro.finsiel.eunis.utilities.SQLUtilities;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.util.Map;

/**
 * CDDA Sites import parser test
 */
public class CddaSitesImportParserTest {

    private static SQLUtilities sqlUtilities;

    @BeforeClass
    public static void setUpBeforeClass(){
        sqlUtilities = DbHelper.getSqlUtilities();
    }

    /**
     * Loads a Site from a file and checks the loaded data
     */
    @Test
    public void loadSitesTest(){
        if(true) return;         // todo: implement when we have the data
        try{
            CddaSitesImportParser parser = new CddaSitesImportParser(
                    sqlUtilities);
            InputStream inputStream = DbHelper.class.getClassLoader().getResourceAsStream("TEST_DATA");
            BufferedInputStream bis = new BufferedInputStream(inputStream);

            Map<String, String> sites = parser.execute(bis);
            bis.close();

            for(String s: sites.keySet())     {
                System.out.println("Site " + s);
                System.out.println("  " + sites.get(s));
            }

        } catch(Exception e){
            e.printStackTrace();
            Assert.assertTrue(false);
        }

    }
}
