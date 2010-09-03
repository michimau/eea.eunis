package eionet.eunis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import eionet.eunis.dto.SpeciesDTO;
import eionet.eunis.api.LookupSpeciesResult;
import eionet.eunis.api.SpeciesLookupSearchParam;

/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface ISpeciesDao {

	
	/**
	 * Returns list of all species as SpeciesDTO objects
	 */
	public List<SpeciesDTO> getAllSpecies() throws SQLException;
	
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