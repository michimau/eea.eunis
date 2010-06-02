package eionet.eunis.dao;

import java.util.List;

import eionet.eunis.dto.SpeciesAttributeDto;
import eionet.eunis.stripes.actions.SpeciesFactsheetActionBean;

/**
 * Helper Dao interface for {@link SpeciesFactsheetActionBean}.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public interface ISpeciesFactsheetDao {

	/**
	 * For given scientific name tries to find species id 
	 * @param scientificName - scientific name.
	 * 
	 * @return species Id or 0 if not found.
	 */
	int getIdSpeciesForScientificName(String scientificName);

	/**
	 * For given species id returns scientific name
	 * @param idSpecies id species.
	 * @return scientific name or empty string, if nothing is found.
	 */
	String getScientificName(int idSpecies);

	/**
	 * For given id species returns canonical id species.
	 * If given id species is a synonym to another specie - id of that specie is returned.
	 * If given id species is a canonical id species - it is returned.
	 * If given id is not found - 0 is returned.
	 * 
	 * @param idSpecies id species.
	 * @return
	 */
	int getCanonicalIdSpecies(int idSpecies);
	
	
	/**
	 * Fetch all species ids who are synonyms to given id species.
	 * @param idSpecies - species id.
	 * @return - null, IFF nothing is found, list of integers otherwise.
	 */
	List<Integer> getSynonyms(int idSpecies);

	/**
	 * Fetch  all attributes for given idNatureObject.
	 * @param idNatureObject
	 * @return
	 */
	List<SpeciesAttributeDto> getAttributesForNatureObject(int idNatureObject);
	
	/**
	 * for given species returns the list of site id locations where it can be expected.
	 * 
	 * @param idSpecies species id
	 * @param limit - limit the number of returned results
	 * @return ID_SITE locations
	 */
	List<String> getExpectedInSiteIds(int idNatureObject, int idSpecies, int limit);

}