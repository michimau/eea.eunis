package eionet.eunis;

import java.util.HashMap;
import java.util.Map;

import junit.framework.TestCase;
import net.sourceforge.stripes.controller.DispatcherServlet;
import net.sourceforge.stripes.controller.StripesFilter;
import net.sourceforge.stripes.mock.MockHttpServletResponse;
import net.sourceforge.stripes.mock.MockRoundtrip;
import net.sourceforge.stripes.mock.MockServletContext;

/**
 * Integration test to test sites-factsheet rdf export.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SitesFactsheetLogicTest extends TestCase {
	

	private MockServletContext context;
	private MockRoundtrip roundtrip;

	public void setUp(){
		context = new MockServletContext("test");
		// Add the Stripes Filter
		Map<String,String> filterParams = new HashMap<String,String>();
		filterParams.put("ActionResolver.Packages", "eionet.eunis.stripes.actions");
		filterParams.put("Extension.Packages", "eionet.eunis.stripes.extensions");
		filterParams.put("ActionBeanContext.Class", "eionet.eunis.stripes.EunisActionBeanContext");
		context.addFilter(StripesFilter.class, "StripesFilter", filterParams);
		// Add the Stripes Dispatcher
		context.setServlet(DispatcherServlet.class, "StripesDispatcher", null);
		roundtrip = new MockRoundtrip(context, "/sites-factsheet.jsp");
	}

	/** 
	 * @see junit.framework.TestCase#tearDown()
	 * {@inheritDoc}
	 */
	@Override
	protected void tearDown() throws Exception {
		roundtrip = null;
		context = null;
	}

	
	
	public void testSimple() throws Exception {
		roundtrip.getRequest().addHeader("accept", "text/html");
		roundtrip.execute();
		//404 should be returned
		assertEquals(200,roundtrip.getResponse().getStatus());
	}
	
	public void testRdfExport() throws Exception {
		MockHttpServletResponse fakeResponse = getResponse("application/rdf+xml", "ES1120004");
		assertTrue(fakeResponse.getOutputString().contains("siteFactsheetDto rdf:about=\"http://eunisimport.eea.europa.eu/sites-factsheet.jsp?idsite=ES1120004\""));
		assertTrue(fakeResponse.getOutputString().contains("ES1120004"));
		assertTrue(fakeResponse.getOutputString().contains("hasDesignation rdf:resource=\"http://eunis.eea.europa.eu/designations/IN09\"/>"));
		assertTrue(fakeResponse.getOutputString().contains("hasGeoscope rdf:resource=\"http://eunis.eea.europa.eu/geoscope/80\"/>"));
		assertTrue(!fakeResponse.getOutputString().contains("hasSource rdf:resource"));
	}
	
	public void testIdSiteNotFound() throws Exception {
		roundtrip.getRequest().addHeader("accept", "application/rdf+xml");
		roundtrip.addParameter("idsite", "ES1120004asdasd");
		roundtrip.execute();
		assertEquals(404, roundtrip.getResponse().getStatus());
	}

	public void testIdSiteNull() throws Exception {
		roundtrip.getRequest().addHeader("accept", "application/rdf+xml");
		roundtrip.addParameter("idsite", "");
		roundtrip.execute();
		assertEquals(404, roundtrip.getResponse().getStatus());
	}
	
	private MockHttpServletResponse getResponse(String acceptHeader, String idsite) throws Exception {
		roundtrip.getRequest().addHeader("accept", acceptHeader);
		roundtrip.addParameter("idsite", idsite);
		roundtrip.execute();
		return  roundtrip.getResponse();
	}
	
	public void testSiocHeader() throws Exception {
		MockHttpServletResponse fakeResponse = getResponse("application/rdf+xml, application/x-turtle, */*; q=0.1", "ES1120004");
		assertTrue(fakeResponse.getOutputString().contains("siteFactsheetDto rdf:about=\"http://eunisimport.eea.europa.eu/sites-factsheet.jsp?idsite=ES1120004\""));
		assertTrue(fakeResponse.getOutputString().contains("ES1120004"));
		assertTrue(fakeResponse.getOutputString().contains("hasDesignation rdf:resource=\"http://eunis.eea.europa.eu/designations/IN09\"/>"));
		assertTrue(fakeResponse.getOutputString().contains("hasGeoscope rdf:resource=\"http://eunis.eea.europa.eu/geoscope/80\"/>"));
		assertTrue(!fakeResponse.getOutputString().contains("hasSource rdf:resource"));
	}

	public void testCrHeader() throws Exception {
		MockHttpServletResponse fakeResponse = getResponse("application/rdf+xml, text/xml, */*", "ES1120004");
		assertTrue(fakeResponse.getOutputString().contains("siteFactsheetDto rdf:about=\"http://eunisimport.eea.europa.eu/sites-factsheet.jsp?idsite=ES1120004\""));
		assertTrue(fakeResponse.getOutputString().contains("ES1120004"));
		assertTrue(fakeResponse.getOutputString().contains("hasDesignation rdf:resource=\"http://eunis.eea.europa.eu/designations/IN09\"/>"));
		assertTrue(fakeResponse.getOutputString().contains("hasGeoscope rdf:resource=\"http://eunis.eea.europa.eu/geoscope/80\"/>"));
		assertTrue(!fakeResponse.getOutputString().contains("hasSource rdf:resource"));
	}

}
