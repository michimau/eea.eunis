package eionet.eunis;

import eionet.eunis.stripes.actions.UpdateTemplateActionBean;

/**
 * Integration test to verify {@link UpdateTemplateActionBean}.
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class UpdateTemplateActionLogicTest extends AbstractMockRoundtripTest {

	@Override
	protected String getMockRoundtripUrl() {
		return "/refreshtemplate";
	}
	
	public void testSimple() throws Exception {
		roundtrip.execute();
		UpdateTemplateActionBean tested = roundtrip.getActionBean(UpdateTemplateActionBean.class);
		assertNotNull(tested);
		assertTrue(tested.isCorrectlyUpdated());
	}

}
