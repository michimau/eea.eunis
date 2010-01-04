package eionet.eunis;

import junit.framework.TestCase;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.mock.MockHttpServletRequest;
import net.sourceforge.stripes.mock.MockHttpServletResponse;
import eionet.eunis.stripes.actions.SitesActionBean;

/**
 * Integration test to test sites-factsheet rdf export.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SitesFactsheetLogicTest extends TestCase {
	
	
	private SitesActionBean action;
	private EunisTestActionBeanContext context;
	private MockHttpServletRequest fakeRequest;
	private MockHttpServletResponse fakeResponse;

	public void setUp(){
		action = new SitesActionBean();
		context = new EunisTestActionBeanContext();
		fakeRequest = new MockHttpServletRequest("", "");
		context.setFakeRequest(fakeRequest);
		action.setContext(context);
		fakeResponse = new MockHttpServletResponse();
	}
	
	public void testSimple() {
		fakeRequest.addHeader("accept", "text/html");
		Resolution resolution = action.defaultAction();
		assertNotNull(resolution);
		assertTrue(resolution instanceof RedirectResolution);
	}
	
	public void testRdfExport() throws Exception {
		fakeRequest.addHeader("accept", "application/rdf+xml");
		action.setIdsite("ES1120004");
		Resolution resolution = action.defaultAction();
		assertNotNull(resolution);
		assertTrue(resolution instanceof StreamingResolution);
		StreamingResolution stream = (StreamingResolution) resolution;
		stream.execute(fakeRequest, fakeResponse);
		assertTrue(fakeResponse.getOutputString().contains("siteFactsheetDto"));
		assertTrue(fakeResponse.getOutputString().contains("ES1120004"));
	}
	
	public void testIdSiteNotFound() throws Exception {
		fakeRequest.addHeader("accept", "application/rdf+xml");
		action.setIdsite("ES1120004asdasd");
		Resolution resolution = action.defaultAction();
		assertNotNull(resolution);
		assertTrue(resolution instanceof ErrorResolution);
	}

}
