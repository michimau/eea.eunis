package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.Map;

/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface ISpeciesDao {

	/**
	 * Deletes species
	 * @param List speciesIds
	 */
	void deleteSpecies(Map<String, String> species) throws SQLException;

}