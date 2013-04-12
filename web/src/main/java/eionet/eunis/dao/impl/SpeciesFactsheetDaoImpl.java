package eionet.eunis.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import eionet.eunis.dao.ISpeciesFactsheetDao;

/**
 * @author Aleksandr Ivanov <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class SpeciesFactsheetDaoImpl extends MySqlBaseDao implements ISpeciesFactsheetDao {

    /** */
    private static final Logger LOGGER = Logger.getLogger(SpeciesFactsheetDaoImpl.class);

    /**
     * Simple constructor.
     */
    public SpeciesFactsheetDaoImpl() {
        // Simple constructor.
    }

    /**
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getIdSpeciesForScientificName(java.lang.String) {@inheritDoc}
     */
    @Override
    public int getIdSpeciesForScientificName(String idSpecies) {
        if (StringUtils.isBlank(idSpecies)) {
            return 0;
        }
        String sql =
                "SELECT ID_SPECIES FROM CHM62EDT_SPECIES WHERE SCIENTIFIC_NAME = '"
                        + StringEscapeUtils.escapeSql(StringEscapeUtils.unescapeHtml(idSpecies)) + "'";
        String result = ExecuteSQL(sql);

        return StringUtils.isNumeric(result) && !StringUtils.isBlank(result) ? new Integer(result) : 0;
    }

    /**
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getScientificName(int) {@inheritDoc}
     */
    @Override
    public String getScientificName(int idSpecies) {
        String sql = "SELECT SCIENTIFIC_NAME FROM CHM62EDT_SPECIES WHERE ID_SPECIES = " + idSpecies;

        return ExecuteSQL(sql);
    }

    /**
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getCanonicalIdSpecies(int) {@inheritDoc}
     */
    @Override
    public int getCanonicalIdSpecies(int idSpecies) {
        // sanity checks
        if (idSpecies <= 0) {
            return 0;
        }
        String synonymSQL = "SELECT ID_SPECIES_LINK FROM CHM62EDT_SPECIES WHERE ID_SPECIES = " + idSpecies;
        String result = ExecuteSQL(synonymSQL);

        return StringUtils.isNumeric(result) && StringUtils.isNotBlank(result) ? new Integer(result) : 0;
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getSynonyms(int)
     */
    @Override
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
            LOGGER.error(ignored);
            throw new RuntimeException(ignored);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#getExpectedInSiteIds(int, int)
     */
    @Override
    public List<String> getExpectedInSiteIds(int idNatureObject, int idSpecies, int limit) {
        // String sql = "SELECT DISTINCT ID_SITE FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE R " +
        // "INNER JOIN CHM62EDT_SITES S ON R.ID_NATURE_OBJECT=S.ID_NATURE_OBJECT " +
        // "WHERE ID_NATURE_OBJECT_LINK= ? ORDER BY ID_SITE ";
        String synonymsIDs = SpeciesFactsheet.getSpeciesSynonymsCommaSeparated(idNatureObject, idSpecies);

        String sql =
                "SELECT C.ID_SITE " + " FROM CHM62EDT_SPECIES AS A "
                        + " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK "
                        + " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "
                        + " WHERE A.ID_NATURE_OBJECT IN ( " + synonymsIDs + " ) " + " GROUP BY C.ID_NATURE_OBJECT "
                        + " ORDER BY C.ID_SITE";
        List<Object> params = new LinkedList<Object>();

        if (limit > 0) {
            sql += " LIMIT ?";
            params.add(limit);
        }
        try {
            return executeQuery(sql, params);
        } catch (SQLException ignored) {
            LOGGER.error(ignored);
            throw new RuntimeException(ignored);
        }
    }

    /*
     * @return OBJECT list from chm62edt_nature_object_attributes
     */
    @Override
    public String getNatObjAttribute(Integer natObjId, String name) {
        String query =
                "SELECT OBJECT FROM chm62edt_nature_object_attributes WHERE NAME = '" + name + "' AND ID_NATURE_OBJECT = "
                        + natObjId;
        return ExecuteSQL(query);
    }

    /*
     * Check that certain query or queries exist
     */
    @Override
    public boolean queryResultExists(Integer natObjId, String queryId, String queriesName) {
        boolean ret = false;
        String query =
                "SELECT OBJECT FROM chm62edt_nature_object_attributes WHERE NAME = '" + queriesName + "' "
                        + "AND ID_NATURE_OBJECT = " + natObjId;
        String result = ExecuteSQL(query);
        if (!StringUtils.isBlank(result) && result.contains(queryId)) {
            ret = true;
        }
        return ret;
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#insertNatureObjAttrForAll(java.lang.String)
     */
    @Override
    public void insertNatureObjAttrForAll(String attrName) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();

            ps =
                    con.prepareStatement("insert into chm62edt_nature_object_attributes (ID_NATURE_OBJECT, NAME) "
                            + "(SELECT ID_NATURE_OBJECT,'" + attrName + "' FROM chm62edt_species)");
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAllResources(con, ps, null);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#appendToNatureObjAttr(java.lang.String, java.lang.String, java.lang.String)
     */
    @Override
    public void appendToNatureObjAttr(String speciesIds, String attrName, String attrValue) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();

            ps =
                    con.prepareStatement("UPDATE chm62edt_nature_object_attributes " + "SET OBJECT=CONCAT_WS(',',OBJECT,'"
                            + attrValue + "') WHERE NAME='" + attrName + "' AND ID_NATURE_OBJECT IN "
                            + "(SELECT DISTINCT ID_NATURE_OBJECT FROM chm62edt_species WHERE ID_SPECIES IN (" + speciesIds + ")) "
                            + "AND FIND_IN_SET('" + attrValue + "', OBJECT)=0");

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAllResources(con, ps, null);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#deleteEmptyNatureObjAttrsForAll(java.lang.String)
     */
    @Override
    public void deleteEmptyNatureObjAttrsForAll(String attrName) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();

            ps =
                    con.prepareStatement("delete from chm62edt_nature_object_attributes where NAME = '" + attrName
                            + "' AND LENGTH(OBJECT) = 0");
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAllResources(con, ps, null);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see eionet.eunis.dao.ISpeciesFactsheetDao#removeAllNatOb(java.lang.String)
     */
    @Override
    public void deleteNatureObjAttrsForAll(String attrName) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();
            ps = con.prepareStatement("delete from chm62edt_nature_object_attributes where NAME = '" + attrName + "'");
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAllResources(con, ps, null);
        }
    }

}
