package eionet.eunis;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import junit.framework.TestCase;

/**
 * Integration tests to verify added columns are fetched correctly.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class GeoscopeDesignationIdDcFieldsTest extends TestCase {
	
	
	public void testGeoscopeDesignationFields() {
		SiteFactsheet factsheet = new SiteFactsheet("ES1120004");
		assertTrue(factsheet.exists());
		assertNotNull(factsheet.getSiteObject().getIdDesignation());
		assertEquals("IN09", factsheet.getSiteObject().getIdDesignation());
		assertNotNull(factsheet.getSiteObject().getIdGeoscope());
		assertEquals(new Integer(80),factsheet.getSiteObject().getIdGeoscope());
		assertNotNull(factsheet.getIdDc());
		assertEquals(new Integer(-1),factsheet.getIdDc());
	}

}
