package ro.finsiel.eunis.jrfTables.species.groups;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.jrfTables.DBUtilities;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;

import java.util.List;


/**
 * @author finsiel
 * @version 1.0
 * @since 07.01.2003
 */
public final class GroupsDomain extends AbstractDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);

    private boolean showEUNISInvalidatedSpecies = false;

    /**
     * Normal constructor
     * @param searchCriteria
     * @param sortCriteria
     */
    public GroupsDomain(AbstractSearchCriteria[] searchCriteria,
            AbstractSortCriteria[] sortCriteria,
            boolean showEUNISInvalidatedSpecies) {
        this.searchCriteria = searchCriteria;
        this.sortCriteria = sortCriteria;
        this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    }

    /****/
    public PersistentObject newPersistentObject() {
        return new GroupsPersist();
    }

     /****/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_species");
        this.setTableAlias("A");

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
                "setIdSpeciesLink", DEFAULT_TO_ZERO, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies",
                "setIdGroupspecies", DEFAULT_TO_ZERO, REQUIRED));

        // Faster performance
        setReadOnly(true);

        JoinTable groupSpecies;

        groupSpecies = new JoinTable("chm62edt_group_species D",
                "ID_GROUP_SPECIES", "ID_GROUP_SPECIES");
        groupSpecies.addJoinColumn(
                new StringJoinColumn("COMMON_NAME", "commonName",
                "setCommonName"));
        this.addJoinTable(groupSpecies);

        OuterJoinTable taxCodeFamily;
        OuterJoinTable taxCodeOrder;

        // Join the table with chm62edt_taxonomy
        taxCodeFamily = new OuterJoinTable("chm62edt_taxonomy B", "ID_TAXONOMY",
                "ID_TAXONOMY");
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomyName", "setTaxonomyName"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("LEVEL", "taxonomyLevel",
                "setTaxonomyLevel"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("TAXONOMY_TREE", "taxonomyTree",
                "setTaxonomyTree"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameFamily",
                "setTaxonomicNameFamily"));
        taxCodeFamily.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameOrder",
                "setTaxonomicNameOrder"));
        this.addJoinTable(taxCodeFamily);
        // // Join the resulted table with chm62edt_taxonomy
        // taxCodeOrder = new OuterJoinTable("chm62edt_taxonomy C", "ID_TAXONOMY_LINK", "ID_TAXONOMY");
        // taxCodeOrder.addJoinColumn(new StringJoinColumn("NAME", "taxonomicNameOrder", "setTaxonomicNameOrder"));
        // taxCodeFamily.addJoinTable(taxCodeOrder);
    }

     /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
     * index offset.
     * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
     * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
     * @return A list of objects which match query criteria
     */
    public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {
        this.sortCriteria = sortCriteria;
        // Prepare the WHERE clause
        StringBuffer filterSQL = DBUtilities.prepareWhereSearch(searchCriteria);

        filterSQL.append(
                Utilities.showEUNISInvalidatedSpecies("AND A.VALID_NAME",
                showEUNISInvalidatedSpecies));
        filterSQL.append(" AND A.TYPE_RELATED_SPECIES='Species' ");

        if (sortCriteria.length > 0) {
            filterSQL.append(DBUtilities.prepareWhereSort(this.sortCriteria));
        }

        // Pagination
        if (pageSize != 0) {
            filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
        }

        // System.out.println( "filterSQL = " + filterSQL );

        List tempList = this.findWhere(filterSQL.toString());

        // After each query, reset the _resultCount, so countResults do correct numbering
        _resultCount = new Long(-1);
        return tempList;
    }

    /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
     * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
     * @return Number of results found
     */

    public Long countResults() throws CriteriaMissingException {
        return _rawCount();
    }

    /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
     * in your code that this method is called (in ideal way) only once and results are cached. This is what
     * countResults() method does in this class
     * @see ro.finsiel.eunis.jrfTables.species.country.RegionDomain#countResults
     * @return count of the total list of results from a query as Long
     * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
     */
    private Long _rawCount() throws CriteriaMissingException {
        StringBuffer sql = new StringBuffer();

        // Set the main QUERY
        sql.append(
                "SELECT COUNT(*) FROM chm62edt_species AS A "
                        + "INNER JOIN chm62edt_taxonomy AS B ON A.ID_TAXONOMY = B.ID_TAXONOMY "
                        + "LEFT JOIN chm62edt_taxonomy AS C ON B.ID_TAXONOMY_LINK = C.ID_TAXONOMY WHERE ");
        // Apply WHERE CLAUSE
        sql.append(DBUtilities.prepareWhereSearch(searchCriteria));
        sql.append(
                Utilities.showEUNISInvalidatedSpecies("AND A.VALID_NAME",
                showEUNISInvalidatedSpecies));
        sql.append(" AND A.TYPE_RELATED_SPECIES='Species' ");
        Long ret = findLong(sql.toString());

        if (null == ret) {
            return new Long(0);
        }
        return ret;
    }
}
