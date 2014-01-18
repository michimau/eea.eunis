package ro.finsiel.eunis.dataimport.parsers;

import eionet.eunis.test.DbHelper;
import junit.framework.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import ro.finsiel.eunis.utilities.SQLUtilities;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.util.List;

/**
 * Tests the Natura2000 import parser
 */
public class Natura2000ImportParserTest {

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
        try{
            // check that the row is not already in the db
            int exists = Integer.parseInt(DbHelper.getSqlUtilities().ExecuteSQL("select count(*) from chm62edt_sites where ID_SITE='CY6000002'"));
            Assert.assertEquals(0, exists);

            Natura2000ImportParser parser = new Natura2000ImportParser(sqlUtilities);
            InputStream inputStream = DbHelper.class.getClassLoader().getResourceAsStream("natura2000_CY6000002.xml");
            BufferedInputStream bis = new BufferedInputStream(inputStream);

            List<String> errors = parser.execute(bis);

            bis.close();

            for(String s : errors)
                System.out.println("   Import error: "+ s);

            Assert.assertEquals(0, errors.size());

            // check that it was imported
            int count = Integer.parseInt(DbHelper.getSqlUtilities().ExecuteSQL("select count(*) from chm62edt_sites where ID_SITE='CY6000002'"));
            Assert.assertEquals(1, count);

            // check that latitude and longitude data is imported (#17806)
            String latitude = DbHelper.getSqlUtilities().ExecuteSQL("select latitude from chm62edt_sites where ID_SITE='CY6000002'");
            String longitude = DbHelper.getSqlUtilities().ExecuteSQL("select longitude from chm62edt_sites where ID_SITE='CY6000002'");
            Assert.assertEquals("34.883333000", latitude);
            Assert.assertEquals("33.622222000", longitude);

        } catch(Exception e){
            e.printStackTrace();
            Assert.assertTrue(false);
        }
    }
}
