package eionet.eunis.dao;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SpeciesFactsheetDaoImpl extends BaseDaoImpl implements ISpeciesFactsheetDao {

	public SpeciesFactsheetDaoImpl(SQLUtilities sqlUtilities) {
		super(sqlUtilities);
	}

	/** 
	 * @see eionet.eunis.dao.ISpeciesFactsheetDao#getIdSpeciesForScientificName(java.lang.String)
	 * {@inheritDoc}
	 */
	public int getIdSpeciesForScientificName(String idSpecies) {
		if (StringUtils.isBlank(idSpecies)) {
			return 0;
		}
		String sql = "SELECT ID_SPECIES FROM CHM62EDT_SPECIES WHERE SCIENTIFIC_NAME = '" 
				+ StringEscapeUtils.escapeSql(
						StringEscapeUtils.unescapeHtml(idSpecies)) 
				+ "'";
		String result = getSqlUtils().ExecuteSQL(sql);
		return StringUtils.isNumeric(result) && !StringUtils.isBlank(result)
				? new Integer(result)
				: 0;
	}

	/** 
	 * @see eionet.eunis.dao.ISpeciesFactsheetDao#getScientificName(int)
	 * {@inheritDoc}
	 */
	public String getScientificName(int idSpecies) {
		SQLUtilities utils = getSqlUtils();
		String sql = "SELECT SCIENTIFIC_NAME FROM CHM62EDT_SPECIES WHERE ID_SPECIES = " + idSpecies;
		return utils.ExecuteSQL(sql);
	}

	/** 
	 * @see eionet.eunis.dao.ISpeciesFactsheetDao#getCanonicalIdSpecies(int)
	 * {@inheritDoc}
	 */
	public int getCanonicalIdSpecies(int idSpecies) {
		//sanity checks
		if (idSpecies <= 0) {
			return 0;
		}
		SQLUtilities utils = getSqlUtils();
		String synonymSQL = "SELECT ID_SPECIES_LINK FROM CHM62EDT_SPECIES WHERE ID_SPECIES = " + idSpecies;
		String result = utils.ExecuteSQL(synonymSQL);
		
		return StringUtils.isNumeric(result) && StringUtils.isNotBlank(result) 
				? new Integer(result)
				: 0;
	}

}
