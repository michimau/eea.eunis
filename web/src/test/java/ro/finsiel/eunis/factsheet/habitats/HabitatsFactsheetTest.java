/*
 * HabitatsFactsheetTest.java
 * 
 * Created on Dec 19, 2014
 *            www.eworx.gr
 */
package ro.finsiel.eunis.factsheet.habitats;

import eionet.eunis.test.DbHelper;
import java.util.List;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist;

/**
 *
 * @author dev-nn
 */
public class HabitatsFactsheetTest {
    
    @BeforeClass
    public static void setUpClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-habitat_factsheet-nature_object.xml");
        DbHelper.handleSetUpOperation("seed-habitat_factsheet-habitat.xml");
        DbHelper.handleSetUpOperation("seed-habitat_factsheet-habitat_class_code.xml");
        DbHelper.handleSetUpOperation("seed-habitat_factsheet-class_code.xml");
    }
    
    /**
     * Test of getHabitatLegalInfo method, of class HabitatsFactsheet.
     */
    @Test
    public void testGetHabitatLegalInfo() throws Exception {
        final String idHabitat = "1007";
        HabitatsFactsheet instance = new HabitatsFactsheet(idHabitat);
        List infos = instance.getHabitatLegalInfo();
        
        assertEquals(1, infos.size());
        
        HabitatLegalPersist info = (HabitatLegalPersist)infos.get(0);
        
        // Test master entity id
        assertEquals(idHabitat, info.getIdHabitat());
        
        // Test related habitat code
        assertEquals("6230", info.getCode());
        
        // Test related habitat id
        assertEquals("10122", info.getRelatedIdHabitat());
    }
    
}
