package eionet.eunis;

/**
 * @author Aleksandr Ivanov
 * <a href="mailto:aleks21@gmail.com">contact</a>
 */

public class LookupSpeciesTest extends AbstractMockRoundtripTest {

	public void testNoSpeciesName() throws Exception {
		roundtrip.getRequest().addHeader("accept", "text/html");
		roundtrip.execute();
		//404 should be returned
		assertEquals(404, roundtrip.getResponse().getStatus());
	}
	
	public void testExactMatch() throws Exception {
		roundtrip.addParameter("speciesName", "Vipera");
		roundtrip.addParameter("author", "test");
		roundtrip.execute();
		assertEquals(200, roundtrip.getResponse().getStatus());
		System.out.println(roundtrip.getResponse().getOutputString());
	}
	
	
	@Override
	protected String getMockRoundtripUrl() {
		return "/api/lookup-species";
	}

}
