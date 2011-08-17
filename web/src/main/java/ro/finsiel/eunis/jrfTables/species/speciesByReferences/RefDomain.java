package ro.finsiel.eunis.jrfTables.species.speciesByReferences;


/**
 * Date: Aug 19, 2003
 * Time: 3:54:00 PM
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.speciesByReferences.ReferencesSearchCriteria;
import ro.finsiel.eunis.search.species.speciesByReferences.ReferencesSortCriteria;
import ro.finsiel.eunis.search.species.speciesByReferences.SpeciesRefWrapper;


public class RefDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);
    private boolean showInvalidatedSpecies = false;
    String SQL_DRV = "";
    String SQL_URL = "";
    String SQL_USR = "";
    String SQL_PWD = "";
    Vector ListOfIdSpecies = new Vector();

    public RefDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, boolean showInvalidatedSpecies, String SQL_DRV, String SQL_URL, String SQL_USR, String SQL_PWD) {
        this.searchCriteria = searchCriteria;
        this.showInvalidatedSpecies = showInvalidatedSpecies;
        this.sortCriteria = sortCriteria;
        this.SQL_DRV = SQL_DRV;
        this.SQL_PWD = SQL_PWD;
        this.SQL_URL = SQL_URL;
        this.SQL_USR = SQL_USR;
    }

    /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
     * index offset.
     * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
     * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
     * @param sortCriteria The criteria used for sorting
     * @return A list of objects which match query criteria
     */
    public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {

        this.sortCriteria = sortCriteria;
        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
            "Unable to search because no search criteria was specified...");
        }

        // add filter from results page
        StringBuffer filterSQL = _prepareWhereSearch("SpeciesPart");
        // Add the ORDER BY clause to do the sorting
        StringBuffer sortOrderAndLimit = new StringBuffer();

        if (sortCriteria.length > 0) {
            sortOrderAndLimit.append(_prepareWhereSort());
        }
        // Add the LIMIT clause to return only the wanted results
        if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
            sortOrderAndLimit.append(" LIMIT " + offsetStart + ", " + pageSize);
        }

        Vector results = new Vector();

        try {
            results = getResultsByIdSpecies(filterSQL, sortOrderAndLimit,
                    ListOfIdSpecies);
        } catch (Exception e) {
            e.printStackTrace();
        }

        List tempList = results;

        _resultCount = new Long(-1); // After each query, reset the _resultCount, so countResults do correct numbering.
        return tempList;
    }

    private Vector getIdSpeciesList(StringBuffer SQLfilter) {
        Vector results = new Vector();
        String SQL = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String condition = (SQLfilter.length() > 0 ? " AND " + SQLfilter : "");

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            SQL = "SELECT DISTINCT H.ID_SPECIES "
                + "FROM DC_INDEX A "
                + "INNER JOIN CHM62EDT_NATURE_OBJECT B ON A.ID_DC=B.ID_DC "
                + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT "
                + "WHERE 1=1 " + condition + " UNION "
                + "SELECT DISTINCT H.ID_SPECIES " + "FROM DC_INDEX A "
                + "INNER JOIN CHM62EDT_REPORTS B ON A.ID_DC=B.ID_DC "
                + "INNER JOIN CHM62EDT_REPORT_TYPE K ON B.ID_REPORT_TYPE = K.ID_REPORT_TYPE "
                + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT "
                + "WHERE 1=1 " + condition
                + " AND K.LOOKUP_TYPE IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND') "
                + "UNION "
                + "SELECT DISTINCT H.ID_SPECIES "
                + "FROM DC_INDEX A "
                + "INNER JOIN CHM62EDT_TAXONOMY B ON A.ID_DC=B.ID_DC "
                + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_TAXONOMY = H.ID_TAXONOMY "
                + "WHERE  1=1 " + condition;
            // System.out.println("id list="+SQL);
            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery(SQL);

            if (rs.isBeforeFirst()) {

                while (!rs.isLast()) {
                    rs.next();
                    results.addElement(new Integer(rs.getInt(1)));
                }
            }

            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    private Vector getResultsByIdSpecies(StringBuffer SQLfilter, StringBuffer sortOrderAndLimit, Vector idSpeciesList) {
        Vector results = new Vector();
        String SQL = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String condition = (SQLfilter.length() > 0 ? " AND " + SQLfilter : "");

        String conditionIn = "";

        try {
            if (idSpeciesList.size() > 0) {
                conditionIn += " AND H.ID_SPECIES IN (";
                for (int i = 0; i < idSpeciesList.size(); i++) {
                    if (i < idSpeciesList.size() - 1) {
                        conditionIn += ((Integer) idSpeciesList.get(i)).toString()
                        + ",";
                    } else {
                        conditionIn += ((Integer) idSpeciesList.get(i)).toString()
                        + ")";
                    }
                }

                Class.forName(SQL_DRV);
                con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
                SQL = "SELECT H.ID_SPECIES,H.ID_SPECIES_LINK,H.ID_NATURE_OBJECT,H.SCIENTIFIC_NAME,A.COMMON_NAME,B.NAME,B.LEVEL,B.TAXONOMY_TREE "
                    + "FROM CHM62EDT_SPECIES H "
                    + "LEFT JOIN CHM62EDT_GROUP_SPECIES A ON H.ID_GROUP_SPECIES=A.ID_GROUP_SPECIES "
                    + "LEFT JOIN CHM62EDT_TAXONOMY B ON (H.ID_TAXONOMY = B.ID_TAXONOMY ) "
                    + // "LEFT JOIN CHM62EDT_TAXONOMY C ON (B.ID_TAXONOMY_LINK=C.ID_TAXONOMY ) " +
                    "WHERE 1=1 " + conditionIn + condition
                    + sortOrderAndLimit;

                ps = con.prepareStatement(SQL);
                rs = ps.executeQuery(SQL);
                if (rs.isBeforeFirst()) {
                    while (!rs.isLast()) {
                        rs.next();

                        results.addElement(
                                new SpeciesRefWrapper(new Integer(rs.getInt(1)),
                                        new Integer(rs.getInt(2)),
                                        new Integer(rs.getInt(3)), rs.getString(4),
                                        rs.getString(5),
                                        getTaxonomicName(rs.getString(7),
                                                rs.getString(6), rs.getString(8), "order_column"),
                                                getTaxonomicName(rs.getString(7),
                                                        rs.getString(6), rs.getString(8), "family")));
                    }
                }
                ps.close();
                con.close();
            } else {
                results = new Vector();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    private Long getCountResultsByIdSpecies(StringBuffer SQLfilter, Vector idSpeciesList) {
        Long results = new Long(-1);
        String SQL = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String condition = (SQLfilter.length() > 0 ? " AND " + SQLfilter : "");

        String conditionIn = "";

        try {
            if (idSpeciesList.size() > 0) {
                conditionIn += " AND H.ID_SPECIES IN (";
                for (int i = 0; i < idSpeciesList.size(); i++) {
                    if (i < idSpeciesList.size() - 1) {
                        conditionIn += ((Integer) idSpeciesList.get(i)).toString()
                        + ",";
                    } else {
                        conditionIn += ((Integer) idSpeciesList.get(i)).toString()
                        + ")";
                    }
                }

                Class.forName(SQL_DRV);
                con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

                SQL = "SELECT count(ID_SPECIES) " + "FROM CHM62EDT_SPECIES H "
                + "LEFT JOIN CHM62EDT_GROUP_SPECIES A ON H.ID_GROUP_SPECIES=A.ID_GROUP_SPECIES "
                + "LEFT JOIN CHM62EDT_TAXONOMY B ON (H.ID_TAXONOMY = B.ID_TAXONOMY ) "
                + // "LEFT JOIN CHM62EDT_TAXONOMY C ON (B.ID_TAXONOMY_LINK=C.ID_TAXONOMY ) " +
                "WHERE 1=1 " + conditionIn + condition;
                // System.out.println("sql1="+SQL);
                ps = con.prepareStatement(SQL);
                rs = ps.executeQuery(SQL);
                if (rs.isBeforeFirst()) {
                    while (!rs.isLast()) {
                        rs.next();
                        results = new Long(rs.getInt(1));
                    }
                }

                ps.close();
                con.close();
            } else {
                results = new Long(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
     * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
     * @return Number of results found
     */
    public Long countResults() throws CriteriaMissingException {
        if (-1 == _resultCount.longValue()) {
            _resultCount = _rawCount();
        }
        return _resultCount;
    }

    /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
     * in your code that this method is called (in ideal way) only once and results are cached. This is what
     * countResults() method does in this class
     * @return
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
     */
    private Long _rawCount() throws CriteriaMissingException {
        Long result = new Long(0);

        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
            "Unable to search because no search criteria was specified...");
        }

        StringBuffer filterSQL = _prepareWhereSearch("ReferencesPart");

        try {
            ListOfIdSpecies = getIdSpeciesList(filterSQL);
        } catch (Exception e) {
            e.printStackTrace();
        }

        StringBuffer speciesFilterSQL = _prepareWhereSearch("SpeciesPart");

        try {
            result = getCountResultsByIdSpecies(speciesFilterSQL,
                    ListOfIdSpecies);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
     * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
     * @return SQL string
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
     */
    private StringBuffer _prepareWhereSearch(String whatPart) throws CriteriaMissingException {
        StringBuffer filterSQL = new StringBuffer();

        if (searchCriteria.length <= 0) {
            throw new CriteriaMissingException(
            "No criteria set for searching. Search interrupted.");
        }

        filterSQL.append(Utilities.showEUNISInvalidatedSpecies(" H.VALID_NAME", showInvalidatedSpecies));
        for (int i = 0; i < searchCriteria.length; i++) {
            ReferencesSearchCriteria aCriteria = (ReferencesSearchCriteria) searchCriteria[i]; // upcast

            if (aCriteria != null) {
                aCriteria.setPart(whatPart);
                if (aCriteria.toSQL().length() > 0 && filterSQL.length() > 0) {
                    filterSQL.append(" AND ");
                }
                filterSQL.append(aCriteria.toSQL());
            }
        }
        return filterSQL;
    }

    /** Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
     * the sortCriteria[] array.
     * @return SQL representation of the sorting.
     */
    private StringBuffer _prepareWhereSort() {
        StringBuffer filterSQL = new StringBuffer();

        try {
            boolean useSort = false;

            if (sortCriteria.length > 0) {
                int i = 0;

                do {
                    if (i > 0) {
                        filterSQL.append(", ");
                    }
                    ReferencesSortCriteria criteria = (ReferencesSortCriteria) sortCriteria[i]; // Notice the upcast here

                    if (!criteria.getCriteriaAsString().equals("none")) { // Do not add if criteria is sort to NOT SORT
                        if (!criteria.getAscendencyAsString().equals("none")) { // Don't add if ascendency is set to none, nasty hacks
                            filterSQL.append(
                                    criteria.toSQL());
                            useSort = true;
                        }
                    }
                    i++;
                } while (i < sortCriteria.length);
            }
            if (useSort) { // If a sort criteria was indeed used, then insert ORDER BY clause at the start of the string
                filterSQL.insert(0, " ORDER BY ");
            }
        } catch (InitializationException e) {
            e.printStackTrace(); // To change body of catch statement use Options | File Templates.
        } finally {
            return filterSQL;
        }
    }

    private String getTaxonomicName(String taxonomyLevel, String taxonomyName, String taxonomyTree, String what) {
        String level = taxonomyLevel;

        if (level != null && level.equalsIgnoreCase(what)) {
            return taxonomyName;
        } else {
            String result = "";
            String str = taxonomyTree;

            StringTokenizer st = new StringTokenizer(str, ",");

            while (st.hasMoreTokens()) {
                StringTokenizer sts = new StringTokenizer(st.nextToken(), "*");
                String classification_id = sts.nextToken();
                String classification_level = sts.nextToken();
                String classification_name = sts.nextToken();

                if (classification_level != null
                        && classification_level.equalsIgnoreCase(what)) {
                    result = classification_name;
                    break;
                }
            }

            return result;
        }
    }

}
