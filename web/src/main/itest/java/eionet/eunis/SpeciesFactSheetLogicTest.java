package eionet.eunis;

import junit.framework.TestCase;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import eionet.eunis.stripes.actions.SpeciesFactsheetActionBean;

/**
 * Integration test to test {@link SpeciesFactsheetActionBean}.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SpeciesFactSheetLogicTest extends TestCase  {
	
	private SpeciesFactsheetActionBean action = new SpeciesFactsheetActionBean();
	private Resolution tested;
	
	public void setUp(){
		action.setContext(new EunisTestActionBeanContext()); 		
	}
	
	public void testDefaultLogic(){
		//border case, when params are not set.
		Resolution tested = action.index();
		assertTrue(tested instanceof ForwardResolution);
	}
	
	public void testRedirectFromId(){
		//redirect from 951 -> 1015
		action.setIdSpecies("951");
		action.setIdSpeciesLink(0);
		tested = action.index();
		assertTrue(tested instanceof RedirectResolution);
		RedirectResolution redirect = (RedirectResolution) tested;
		assertNotNull(redirect.getParameters());
		assertEquals(1015, ((Object [])redirect.getParameters().get("idSpecies"))[0]);
	}
	
	public void testBadIdSpecies() {
		action.setIdSpecies("dafsdkgsg");
		tested = action.index();
		assertFalse(action.getFactsheet().exists());
	}
	
	public void testBadIdSpeciesNumber() {
		action.setIdSpecies("-1");
		tested = action.index();
		assertFalse(action.getFactsheet().exists());
	}
	
	public void testRedirectFromName(){
		//redirect from Casmerodius albus -> 1015
		action.setIdSpecies("Casmerodius albus");
		tested = action.index();
		assertTrue(tested instanceof RedirectResolution);
		RedirectResolution redirect = (RedirectResolution) tested;
		assertNotNull(redirect.getParameters());
		assertEquals(1015, ((Object [])redirect.getParameters().get("idSpecies"))[0]);
	}
	
	public void testForwardFromName(){
		//forward from idSpecies=Egretta alba -> idSpecies=1015
		action.setIdSpecies("Egretta alba");
		tested = action.index();
		assertNull(action.getReferedFromName());
		assertTrue(tested instanceof ForwardResolution);
	}
	
	public void testForwardFromId(){
		//forward from idSpecies=1015
		action.setIdSpecies("1015");
		tested = action.index();
		assertTrue(tested instanceof ForwardResolution);
	}
	
}
