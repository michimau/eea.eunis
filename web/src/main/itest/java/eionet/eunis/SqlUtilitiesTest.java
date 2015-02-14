package eionet.eunis;

import java.util.List;

import junit.framework.TestCase;
import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SqlUtilitiesTest extends TestCase {
	
	protected SQLUtilities sqlUtilities;

	public void setUp() {
		sqlUtilities = new SQLUtilities();
		sqlUtilities.Init();
	}
	
	
	public void testExecuteQuery() throws Exception {
		String sql = "select id_species from chm62edt_species";
		List<Integer> result = sqlUtilities.executeQuery(sql, null);
		assertNotNull(result);
	}

}
