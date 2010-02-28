package eionet.eunis;

/**
 * @author alex
 *
 * &lt;a href="mailto:aleks21@gmail.com"&gt;contact&lt;a&gt;
 */
public class SpeciesRdfExportTest extends AbstractMockRoundtripTest {

	@Override
	protected String getMockRoundtripUrl() {
		return "/species/9968/";
	}
	
	public void testSimple() throws Exception {
		roundtrip.getRequest().addHeader("accept", "application/rdf+xml");
		roundtrip.addParameter("idSpecies", "9968");
		roundtrip.addParameter("tab", "");
		roundtrip.execute();
		System.out.println(roundtrip.getResponse().getOutputString());
		//404 should be returned
		assertEquals(200,roundtrip.getResponse().getStatus());
	}

}
