package eionet.eunis.dao;

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

}