package ro.finsiel.eunis.jrfTables.species.national;


/**
 * Date: May 15, 2003
 * Time: 10:20:51 AM
 */

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.species.national.NationalSearchCriteria;
import ro.finsiel.eunis.search.species.national.NationalSortCriteria;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;

import java.util.List;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:17 $
 **/
public class NationalThreatStatusDomain extends AbstractDomain implements Paginable {

    /** Criterias applied for searching */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set

    /** Criterias applied for sorting */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

    /** Cache the results of a count to avoid overhead queries for counting */
    private Long _resultCount = new Long(-1);

    /* Cache the results of a choice count to avoid overhead queries for counting*/
    private Long _choiceCount = new Long(-1);

    private boolean showEUNISInvalidatedSpecies = false;

    /**
     * Normal constructor
     * @param searchCriteria The search criteria used to query the database
     * @param sortCriteria Sort criterias used for sorting the results
     */
    public NationalThreatStatusDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, boolean showEUNISInvalidatedSpecies) {
        this.searchCriteria = searchCriteria;
        this.sortCriteria = sortCriteria;
        this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    }

    public NationalThreatStatusDomain(AbstractSearchCriteria[] searchCriteria) {
        this.searchCriteria = searchCriteria;
    }

    public NationalThreatStatusDomain() {}

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new NationalThreatStatusPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_GROUP_SPECIES");
        this.setReadOnly(true);
        this.setTableAlias("D");

        this.addColumnSpec(
                new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies",
                "setIdGroupspecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("COMMON_NAME", "getCommonName",
                "setCommonName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName",
                "setScientificName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new ShortColumnSpec("SELECTION", "getSelection", "setSelection",
                null));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));

        // Joined tables
        JoinTable species = null;

        species = new JoinTable("CHM62EDT_SPECIES C", "ID_GROUP_SPECIES",
                "ID_GROUP_SPECIES");
        species.addJoinColumn(
                new IntegerJoinColumn("ID_SPECIES", "IdSpecies", "setIdSpecies"));
        species.addJoinColumn(
                new IntegerJoinColumn("ID_SPECIES_LINK", "IdSpeciesLink",
                "setIdSpeciesLink"));
        species.addJoinColumn(
                new StringJoinColumn("SCIENTIFIC_NAME", "scName", "setScName"));
        species.addJoinColumn(
                new IntegerJoinColumn("ID_NATURE_OBJECT", "IdNatObj",
                "setIdNatureObject"));
        this.addJoinTable(species);

        JoinTable reports = null;

        reports = new JoinTable("CHM62EDT_REPORTS E", "ID_NATURE_OBJECT",
                "ID_NATURE_OBJECT");
        species.addJoinTable(reports);

        JoinTable country = null;

        country = new JoinTable("CHM62EDT_COUNTRY F", "ID_GEOSCOPE",
                "ID_GEOSCOPE");
        country.addJoinColumn(
                new StringJoinColumn("AREA_NAME_EN", "country", "setCountry"));
        country.addJoinColumn(
                new IntegerJoinColumn("ID_COUNTRY", "idCountry", "setIdCountry"));
        reports.addJoinTable(country);

        JoinTable reporttype = null;

        reporttype = new JoinTable("CHM62EDT_REPORT_TYPE G", "ID_REPORT_TYPE",
                "ID_REPORT_TYPE");
        reports.addJoinTable(reporttype);

        JoinTable status = null;

        status = new JoinTable("CHM62EDT_CONSERVATION_STATUS H", "ID_LOOKUP",
                "ID_CONSERVATION_STATUS");
        status.addJoinColumn(
                new StringJoinColumn("NAME", "defAbrev", "setDefAbrev"));
        status.addJoinColumn(
                new IntegerJoinColumn("ID_CONSERVATION_STATUS", "idCons",
                "setIdCons"));
        status.addJoinColumn(
                new IntegerJoinColumn("ID_DC", "iddc", "setIdDCore"));
        reporttype.addJoinTable(status);

        OuterJoinTable family = null;

        family = new OuterJoinTable("CHM62EDT_TAXONOMY I", "ID_TAXONOMY",
                "ID_TAXONOMY");
        family.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomyName", "setTaxonomyName"));
        family.addJoinColumn(
                new StringJoinColumn("LEVEL", "taxonomyLevel",
                "setTaxonomyLevel"));
        family.addJoinColumn(
                new StringJoinColumn("TAXONOMY_TREE", "taxonomyTree",
                "setTaxonomyTree"));
        family.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameFamily",
                "setTaxonomicNameFamily"));
        family.addJoinColumn(
                new StringJoinColumn("NAME", "taxonomicNameOrder",
                "setTaxonomicNameOrder"));
        species.addJoinTable(family);

        // OuterJoinTable order = null;
        // order = new OuterJoinTable("CHM62EDT_TAXONOMY J", "ID_TAXONOMY_LINK", "ID_TAXONOMY");
        // order.addJoinColumn(new StringJoinColumn("NAME", "setOrder"));
        // family.addJoinTable(order);

    }

    public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {

        this.sortCriteria = sortCriteria;
        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
                    "I refuse to search, since you didn't say what.");
        }
        StringBuffer filterSQL = new StringBuffer("");

        filterSQL.append(_prepareWhereSearch());

        // filterSQL.append(" GROUP BY C.ID_NATURE_OBJECT ");

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

        if (searchCriteria.length < 1) {
            throw new CriteriaMissingException(
                    "I refuse to search, since you didn't say what.");
        }
        // Prepare the WHERE clause   put search Criteria
        StringBuffer filterSQL = new StringBuffer("");

        filterSQL.append(_prepareWhereSearch());

        filterSQL.append(" GROUP BY C.ID_NATURE_OBJECT ");

        List tempList = this.findWhere(filterSQL.toString());

        if (null != tempList) {
            return new Long(tempList.size());
        } else {
            return new Long(0);
        }

    }

    /**
     * This helper method is used to construct the string after WHERE...based on search criterias set. In another words
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

        filterSQL.append(
                "trim(F.ISO_2L)<>'' " + "AND F.ISO_2L<>'null' "
                + "AND F.ISO_2L IS NOT NULL "
                + "AND F.SELECTION <> 0 AND G.LOOKUP_TYPE = 'CONSERVATION_STATUS'");

        filterSQL.append(
                Utilities.showEUNISInvalidatedSpecies("AND C.VALID_NAME",
                showEUNISInvalidatedSpecies));
        // filterSQL.append(" AND I.LEVEL='FAMILY' AND J.LEVEL='ORDER' ");


        for (int i = 0; i < searchCriteria.length; i++) {
            NationalSearchCriteria aCriteria = (NationalSearchCriteria) searchCriteria[i]; // upcast

            filterSQL.append(
                    aCriteria.toSQL());
        }
        return filterSQL;
    }

    /**
     * Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
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
                    NationalSortCriteria criteria = (NationalSortCriteria) sortCriteria[i]; // Notice the upcast here

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

}
