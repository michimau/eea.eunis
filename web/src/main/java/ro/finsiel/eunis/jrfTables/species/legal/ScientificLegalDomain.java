package ro.finsiel.eunis.jrfTables.species.legal;


import java.util.List;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.legal.LegalSearchCriteria;
import ro.finsiel.eunis.search.species.legal.LegalSortCriteria;


/**
 * @author finsiel
 * @version 1.0
 * @since 10.01.2003
 */
public class ScientificLegalDomain extends AbstractDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);

    private boolean showEUNISInvalidatedSpecies = false;

    public ScientificLegalDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, boolean showEUNISInvalidatedSpecies) {
        this.searchCriteria = searchCriteria;
        this.sortCriteria = sortCriteria;
        this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    }

    public ScientificLegalDomain() {}

    /****/
    public PersistentObject newPersistentObject() {
        return new ScientificLegalPersist();
    }

    /****/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SPECIES");
        this.setTableAlias("E");

        /** Table's columns specifications */
        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES", "getIdSpecies",
                        "setIdSpecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                        "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName",
                        "setScientificName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink",
                        "setIdSpeciesLink", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies",
                        "setIdGroupspecies", DEFAULT_TO_ZERO, REQUIRED));
        // Faster performance
        setReadOnly(true);

        // Joined tables
        JoinTable reports = null;
        JoinTable reportType = null;
        JoinTable legalStatus = null;
        JoinTable dcIndex = null;
        JoinTable groupSpecies = null;

        // table join: "TABLE_NAME ALIAS", "MAIN_TABLE_COLUMN", "SECOND_TABLE_COLUMN");
        reports = new JoinTable("CHM62EDT_REPORTS A", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
        reports.addJoinColumn(new IntegerJoinColumn("ID_NATURE_OBJECT", "idNatureObjReports", "setIdNatureObjectReports"));
        reports.addJoinColumn(new IntegerJoinColumn("ID_REPORT_TYPE", "idReportTypeRep", "setIdReportTypeRep"));
        reports.addJoinColumn(new IntegerJoinColumn("ID_DC", "idDcRep", "setIdDcRep"));
        this.addJoinTable(reports);

        reportType = new JoinTable("CHM62EDT_REPORT_TYPE B", "ID_REPORT_TYPE", "ID_REPORT_TYPE");
        reportType.addJoinColumn(new IntegerJoinColumn("ID_REPORT_TYPE", "idReportType", "setIdReportType"));
        reports.addJoinTable(reportType);

        legalStatus = new JoinTable("CHM62EDT_LEGAL_STATUS C", "ID_LOOKUP", "ID_LEGAL_STATUS");
        legalStatus.addJoinColumn(new StringJoinColumn("ANNEX", "annex", "setAnnex"));
        legalStatus.addJoinColumn(new StringJoinColumn("COMMENT", "comment", "setComment"));
        reportType.addJoinTable(legalStatus);

        dcIndex = new JoinTable("DC_INDEX D", "ID_DC", "ID_DC");
        dcIndex.addJoinColumn(new StringJoinColumn("ALTERNATIVE", "Alternative", "setAlternative"));
        dcIndex.addJoinColumn(new StringJoinColumn("TITLE", "title", "setTitle"));
        dcIndex.addJoinColumn(new StringJoinColumn("URL", "setUrl"));
        reports.addJoinTable(dcIndex);

        groupSpecies = new JoinTable("CHM62EDT_GROUP_SPECIES F", "ID_GROUP_SPECIES", "ID_GROUP_SPECIES");
        groupSpecies.addJoinColumn(new StringJoinColumn("COMMON_NAME", "commonName", "setCommonName"));
        this.addJoinTable(groupSpecies);
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
        // Prepare the WHERE clause
        StringBuffer filterSQL = _prepareWhereSearch();

        // Add GROUP BY clause for unique results
        // Add the ORDER BY clause to do the sorting
        if (sortCriteria.length > 0) {
            filterSQL.append(_prepareWhereSort());
        }
        // Add the LIMIT clause to return only the wanted results
        if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
            filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
        }
        List tempList = this.findWhere(filterSQL.toString());

        _resultCount = new Long(-1); // After each query, reset the _resultCount, so countResults do correct numbering.
        return tempList;
    }

    /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
     * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
     * @return SQL string
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
     */
    private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
        StringBuffer filterSQL = new StringBuffer();

        if (searchCriteria.length <= 0) {
            throw new CriteriaMissingException(
            "No criteria set for searching. Search interrupted.");
        }
        for (int i = 0; i < searchCriteria.length; i++) {
            if (i > 0) {
                filterSQL.append(" AND ");
            }
            LegalSearchCriteria aCriteria = (LegalSearchCriteria) searchCriteria[i]; // upcast

            filterSQL.append(
                    aCriteria.toSQL());
        }
        filterSQL.append(
                Utilities.showEUNISInvalidatedSpecies("AND E.VALID_NAME",
                        showEUNISInvalidatedSpecies));
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
                    LegalSortCriteria criteria = (LegalSortCriteria) sortCriteria[i]; // Notice the upcast here

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
     * @see ro.finsiel.eunis.jrfTables.species.country.RegionDomain#countResults
     * @return
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
     */
    private Long _rawCount() throws CriteriaMissingException {
        StringBuffer sql = new StringBuffer();

        // Set the main QUERY
        sql.append(
                "SELECT COUNT(*) FROM CHM62EDT_SPECIES AS E "
                + "INNER JOIN  CHM62EDT_REPORTS AS A ON E.ID_NATURE_OBJECT = A.ID_NATURE_OBJECT "
                + "INNER JOIN CHM62EDT_REPORT_TYPE AS B ON A.ID_REPORT_TYPE = B.ID_REPORT_TYPE "
                + "INNER JOIN CHM62EDT_LEGAL_STATUS AS C ON B.ID_LOOKUP = C.ID_LEGAL_STATUS "
                + "INNER JOIN DC_INDEX AS D ON A.ID_DC = D.ID_DC "
                + "INNER JOIN CHM62EDT_GROUP_SPECIES AS F ON E.ID_GROUP_SPECIES = F.ID_GROUP_SPECIES "
                + "WHERE ");
        // Apply WHERE CLAUSE
        sql.append(_prepareWhereSearch().toString());
        // Apply SORT CLAUSE - DON'T NEED IT FOR COUNT...
        Long ret = findLong(sql.toString());

        if (null == ret) {
            return new Long(0);
        }
        return ret;
    }
}
