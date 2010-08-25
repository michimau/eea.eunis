package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import eionet.eunis.dto.AttributeDto;

/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface ISitesDao {

	/**
	 * Deletes site
	 * @param List siteIds
	 */
	void deleteSites(Map<String, String> sites) throws SQLException;
	
	/**
	 * Deletes site
	 * @param Map sites
	 */
	void deleteSitesCdda(Map<String, String> sites) throws SQLException;
	
	public void updateCountrySitesFactsheet() throws SQLException;
	
	public void updateDesignationsTable() throws SQLException;

	/**
	 * For given idSite fetches related attributes.
	 * 
	 * @param idSite - site id.
	 * @return
	 */
	public List<AttributeDto> getAttributes(String idSite);

}