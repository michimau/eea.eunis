package eionet.eunis.dao.impl;


import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import eionet.eunis.dao.ISpeciesFactsheetDao;


/**
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SpeciesFactsheetDaoImpl extends MySqlBaseDao implements ISpeciesFactsheetDao {

    private static final Logger logger = Logger.getLogger(
            SpeciesFactsheetDaoImpl.class);

    public SpeciesFactsheetDaoImpl() {}

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
        String result = ExecuteSQL(sql);

        return StringUtils.isNumeric(result) && !StringUtils.isBlank(result)
        ? new Integer(result)
        : 0;
    }

    /**
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getScientificName(int)
     * {@inheritDoc}
     */
    public String getScientificName(int idSpecies) {
        String sql = "SELECT SCIENTIFIC_NAME FROM CHM62EDT_SPECIES WHERE ID_SPECIES = "
            + idSpecies;

        return ExecuteSQL(sql);
    }

    /**
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getCanonicalIdSpecies(int)
     * {@inheritDoc}
     */
    public int getCanonicalIdSpecies(int idSpecies) {
        // sanity checks
        if (idSpecies <= 0) {
            return 0;
        }
        String synonymSQL = "SELECT ID_SPECIES_LINK FROM CHM62EDT_SPECIES WHERE ID_SPECIES = "
            + idSpecies;
        String result = ExecuteSQL(synonymSQL);

        return StringUtils.isNumeric(result) && StringUtils.isNotBlank(result)
        ? new Integer(result)
        : 0;
    }

    /* (non-Javadoc)
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getSynonyms(int)
     */
    public List<Integer> getSynonyms(int idSpecies) {
        // sanity checks
        if (idSpecies <= 0) {
            return null;
        }
        String sql = "SELECT ID_SPECIES FROM CHM62EDT_SPECIES WHERE ID_SPECIES_LINK = ? AND ID_SPECIES <> ?";
        List<Object> params = new LinkedList<Object>();

        params.add(idSpecies);
        params.add(idSpecies);
        try {
            return executeQuery(sql, params);
        } catch (SQLException ignored) {
            logger.error(ignored);
            throw new RuntimeException(ignored);
        }
    }

    /* (non-Javadoc)
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getExpectedInSiteIds(int, int)
     */
    public List<String> getExpectedInSiteIds(int idNatureObject, int idSpecies, int limit) {
        // String sql = "SELECT DISTINCT ID_SITE FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE R " +
        // "INNER JOIN CHM62EDT_SITES S ON R.ID_NATURE_OBJECT=S.ID_NATURE_OBJECT " +
        // "WHERE ID_NATURE_OBJECT_LINK= ? ORDER BY ID_SITE ";
        String synonymsIDs = SpeciesFactsheet.getSpeciesSynonymsCommaSeparated(
                idNatureObject, idSpecies);

        String sql = "SELECT C.ID_SITE " + " FROM CHM62EDT_SPECIES AS A "
        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
        + " WHERE A.ID_NATURE_OBJECT IN ( " + synonymsIDs + " ) "
        + " GROUP BY C.ID_NATURE_OBJECT " + " ORDER BY C.ID_SITE";
        List<Object> params = new LinkedList<Object>();

        if (limit > 0) {
            sql += " LIMIT ?";
            params.add(limit);
        }
        try {
            return executeQuery(sql, params);
        } catch (SQLException ignored) {
            logger.error(ignored);
            throw new RuntimeException(ignored);
        }
    }

}
