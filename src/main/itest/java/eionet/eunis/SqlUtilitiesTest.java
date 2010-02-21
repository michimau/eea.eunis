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
	
	private static final String SQL_DRIVER_NAME = "org.gjt.mm.mysql.Driver";
	private static final String SQL_DRIVER_URL = "jdbc:mysql://localhost/eunis?autoReconnect=true&amp;useUnicode=true&amp;characterEncoding=utf8";
	private static final String SQL_DRIVER_USERNAME = "eunisuser";
	private static final String SQL_DRIVER_PASSWORD = "password";
	protected SQLUtilities sqlUtilities;

	public void setUp() {
		sqlUtilities = new SQLUtilities();
		sqlUtilities.Init(SQL_DRIVER_NAME, SQL_DRIVER_URL, SQL_DRIVER_USERNAME, SQL_DRIVER_PASSWORD);
	}
	
	
	public void testExecuteQuery() throws Exception {
		String sql = "select id_species from chm62edt_species";
		List<Integer> result = sqlUtilities.executeQuery(sql, null);
		assertNotNull(result);
	}

}
