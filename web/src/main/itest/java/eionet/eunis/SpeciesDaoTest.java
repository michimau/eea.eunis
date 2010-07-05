package eionet.eunis;

import java.util.List;

import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dao.impl.SpeciesFactsheetDaoImpl;

/**
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SpeciesDaoTest extends SqlUtilitiesTest {
	
	
	public void testGetSynonymsFor() {
		ISpeciesFactsheetDao dao = new SpeciesFactsheetDaoImpl(sqlUtilities);
		List<Integer> tested = dao.getSynonyms(1015);
		assertNotNull(tested);
		assertEquals(951, (int) tested.get(0));
		tested = dao.getSynonyms(9968);
		assertNotNull(tested);
		assertEquals(11, tested.size());
	}
}
