package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import ro.finsiel.eunis.jrfTables.Chm62edtSpeciesPersist;

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