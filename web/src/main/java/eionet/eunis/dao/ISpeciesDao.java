package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.Map;

import eionet.eunis.api.LookupSpeciesResult;
import eionet.eunis.api.SpeciesLookupSearchParam;

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

	/**
	 * Based on the SpeciesLookupSearchParam lookups species.
	 * 
	 * @param speciesLookupSearchParam - search parameter.
	 * @return search result.
	 */
	LookupSpeciesResult lookupSpecies(SpeciesLookupSearchParam speciesLookupSearchParam);
	

}