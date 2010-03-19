package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.Map;

/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface ISitesDao {

	/**
	 * Deletes site
	 * @param Map sites
	 */
	void deleteSites(Map<String, String> sites) throws SQLException;
	
	public void updateCountrySitesFactsheet() throws SQLException;
	
	public void updateDesignationsTable() throws SQLException;

}