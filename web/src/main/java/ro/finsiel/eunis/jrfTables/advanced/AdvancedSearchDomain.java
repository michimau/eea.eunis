package ro.finsiel.eunis.jrfTables.advanced;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;

import java.util.List;

/**
 * Date: 23.07.2003
 * Time: 13:30:54
 */
public class AdvancedSearchDomain extends AbstractDomain {

    /** Criterias applied for searching. */
    private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set
    /** Criterias applied for sorting. */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted
    /** Cache the results of a count to avoid overhead queries for counting. */
    private Long _resultCount = new Long(-1);

    private String whereString = null;

    private String idSession = "";
    private String natureObject = "";

    /**
     * This is the default constructor and is used only when you want to call the find* methods for this object, for
     * example.
     * Note: The AdvancedSearchDomain class has an initialisation problem. The Java initialisation process is:
     * <ul>
     * <li>First all the member variables are set to binary null.</li>
     * <li>Then the base-class is initialised and the base-class constructor is called. It calls <code>setup()</code></li>
     * <li>Then the member variables are initialised to their definition values</li>
     * <li>Finally the constructor of AdvancedSearchDomain is executed.</li>
     * </ul>
     * This means that <code>setup()</code> is called with natureObject set to null.
     * Since the authors have included a constructor in AdvancedSearchDomain, shouldn't it be callable?
     */
    public AdvancedSearchDomain(String idSession, String natureObject) {
        this.searchCriteria = null;
        this.sortCriteria = null;
        this.idSession = idSession;
        this.natureObject = natureObject;
    }

    /****/
    public PersistentObject newPersistentObject() {
        return new AdvancedSearchPersist();
    }

    public void setup() {
        // Species
        if ("species".equalsIgnoreCase(natureObject)) {
            this.setTableName("CHM62EDT_SPECIES");
            this.setTableAlias("A");
            this.setReadOnly(true);

            // Table declaration
            this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES", "getIdSpecies", "setIdSpecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
            this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
            this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
            this.addColumnSpec(new ShortColumnSpec("VALID_NAME", "getValidName", "setValidName", null, REQUIRED));
            this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink", "setIdSpeciesLink", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("TYPE_RELATED_SPECIES", "getTypeRelatedSpecies", "setTypeRelatedSpecies", DEFAULT_TO_NULL));
            this.addColumnSpec(new ShortColumnSpec("TEMPORARY_SELECT", "getTemporarySelect", "setTemporarySelect", null));
            this.addColumnSpec(new StringColumnSpec("SPECIES_MAP", "getSpeciesMap", "setSpeciesMap", DEFAULT_TO_NULL));
            this.addColumnSpec(new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies", "setIdGroupspecies", DEFAULT_TO_ZERO, REQUIRED));
            this.addColumnSpec(new StringColumnSpec("ID_TAXONOMY", "getIdTaxcode", "setIdTaxcode", DEFAULT_TO_NULL));

            // Joined tables
            OuterJoinTable groupSpecies = null;
            groupSpecies = new OuterJoinTable("CHM62EDT_GROUP_SPECIES B", "ID_GROUP_SPECIES", "ID_GROUP_SPECIES");
            groupSpecies.addJoinColumn(new StringJoinColumn("COMMON_NAME", "commonName", "setCommonName"));
            this.addJoinTable(groupSpecies);

            JoinTable taxCodeFamily = null;
            taxCodeFamily = new JoinTable("CHM62EDT_TAXONOMY C", "ID_TAXONOMY", "ID_TAXONOMY");
            taxCodeFamily.addJoinColumn(new StringJoinColumn("NAME", "taxonomicNameFamily", "setTaxonomicNameFamily"));
            taxCodeFamily.addJoinColumn(new StringJoinColumn("LEVEL", "taxonomicLevel", "setTaxonomicLevel"));
            this.addJoinTable(taxCodeFamily);

            OuterJoinTable taxCodeOrder = null;
            taxCodeOrder = new OuterJoinTable("CHM62EDT_TAXONOMY D", "ID_TAXONOMY_LINK", "ID_TAXONOMY");
            taxCodeOrder.addJoinColumn(new StringJoinColumn("NAME", "taxonomicNameOrder", "setTaxonomicNameOrder"));
            taxCodeFamily.addJoinTable(taxCodeOrder);
        }
        // Habitats
        if ("habitats".equalsIgnoreCase(natureObject)) {
            this.setTableName("CHM62EDT_HABITAT");
            this.setTableAlias("A");
            this.setReadOnly(true);

            this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
            this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
            this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("CODE_ANNEX1", "getCodeAnnex1", "setCodeAnnex1", DEFAULT_TO_NULL));
            this.addColumnSpec(new ShortColumnSpec("PRIORITY", "getPriority", "setPriority", null, REQUIRED));
            this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("CLASS_REF", "getClassRef", "setClassRef", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("CODE_PART_2", "getCodePart2", "setCodePart2", DEFAULT_TO_NULL));
            this.addColumnSpec(new IntegerColumnSpec("LEVEL", "getHabLevel", "setHabLevel", DEFAULT_TO_NULL));

            // Add the join only if the search is also done in descriptions
            OuterJoinTable habitatDescr = new OuterJoinTable("CHM62EDT_HABITAT_DESCRIPTION B", "ID_HABITAT", "ID_HABITAT");
            this.addJoinTable(habitatDescr);
        }
        if ("sites".equalsIgnoreCase(natureObject)) {
            this.setTableName("CHM62EDT_SITES");
            this.setTableAlias("A");
            this.setReadOnly(true);

            this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
            this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("RESPONDENT", "getRespondent", "setRespondent", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
            this.addColumnSpec(new StringColumnSpec("MANAGER", "getManager", "setManager", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("COMPLEX_NAME", "getComplexName", "setComplexName", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("DISTRICT_NAME", "getDistrictName", "setDistrictName", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("OWNERSHIP", "getOwnership", "setOwnership", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("HISTORY", "getHistory", "setHistory", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("CHARACTER", "getCharacter", "setCharacter", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("MANAGEMENT_PLAN", "getManagementPlan", "setManagementPlan", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("IUCNAT", "getIucnat", "setIucnat", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("DESIGNATION_DATE", "getDesignationDate", "setDesignationDate", null));
            this.addColumnSpec(new StringColumnSpec("COMPILATION_DATE", "getCompilationDate", "setCompilationDate", null));
            this.addColumnSpec(new StringColumnSpec("PROPOSED_DATE", "getProposedDate", "setProposedDate", null));
            this.addColumnSpec(new StringColumnSpec("CONFIRMED_DATE", "getConfirmedDate", "setConfirmedDate", null));
            this.addColumnSpec(new StringColumnSpec("UPDATE_DATE", "getUpdateDate", "setUpdateDate", null));
            this.addColumnSpec(new StringColumnSpec("SPA_DATE", "getSpaDate", "setSpaDate", null));
            this.addColumnSpec(new StringColumnSpec("SAC_DATE", "getSacDate", "setSacDate", null));
            this.addColumnSpec(new StringColumnSpec("NATIONAL_CODE", "getNationalCode", "setNationalCode", null));
            this.addColumnSpec(new StringColumnSpec("NATURA_2000", "getNatura2000", "setNatura2000", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("NUTS", "getNuts", "setNuts", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("AREA", "getArea", "setArea", null));
            this.addColumnSpec(new StringColumnSpec("LENGTH", "getLength", "setLength", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("ALT_MEAN", "getAltMean", "setAltMean", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("ALT_MAX", "getAltMax", "setAltMax", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("ALT_MIN", "getAltMin", "setAltMin", DEFAULT_TO_NULL));

            this.addColumnSpec(new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude", DEFAULT_TO_NULL));
            this.addColumnSpec(new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_NULL));

            OuterJoinTable natureObjectGeoscope = new OuterJoinTable("CHM62EDT_NATURE_OBJECT_GEOSCOPE B ", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
            this.addJoinTable(natureObjectGeoscope);

            OuterJoinTable country = new OuterJoinTable("CHM62EDT_COUNTRY C", "ID_GEOSCOPE", "ID_GEOSCOPE");
            country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
            natureObjectGeoscope.addJoinTable(country);

            OuterJoinTable designations = new OuterJoinTable("CHM62EDT_DESIGNATIONS E ", "ID_DESIGNATION", "ID_DESIGNATION");
            designations.addJoinColumn(new StringJoinColumn("DESCRIPTION", "setDesign"));
            this.addJoinTable(designations);
        }
        JoinTable advSearchResults = new JoinTable("EUNIS_ADVANCED_SEARCH_RESULTS", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
        this.addJoinTable(advSearchResults);
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
      String filterSQL = " 1=1 ";
      if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
        filterSQL += "GROUP BY A.ID_SITE, IF(B.ID_GEOSCOPE IS NULL, '', B.ID_GEOSCOPE) LIMIT " + offsetStart + ", " + pageSize;
      }
      List tempList = this.findWhere(filterSQL.toString());
      _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
      return tempList;
    }

    /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
     * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
     * @return The total number of results
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
     */
    private Long _rawCount() {
      StringBuffer sql = new StringBuffer();
      sql.append("SELECT COUNT(DISTINCT A.ID_SITE, IF(B.ID_GEOSCOPE IS NULL, '', B.ID_GEOSCOPE)) FROM CHM62EDT_SITES A "
            + " LEFT OUTER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE B ON A.ID_NATURE_OBJECT=B.ID_NATURE_OBJECT "
            + " LEFT OUTER JOIN CHM62EDT_COUNTRY C ON B.ID_GEOSCOPE=C.ID_GEOSCOPE "
            + " LEFT OUTER JOIN CHM62EDT_DESIGNATIONS E ON (A.ID_DESIGNATION=E.ID_DESIGNATION AND A.ID_GEOSCOPE=E.ID_GEOSCOPE) "
            + " INNER JOIN EUNIS_ADVANCED_SEARCH_RESULTS F ON A.ID_NATURE_OBJECT=F.ID_NATURE_OBJECT "
            + " WHERE 1=1");
      // Apply SORT CLAUSE - DON'T NEED IT FOR COUNT...
      Long ret = findLong(sql.toString());
      if (null == ret) return new Long(0);
      return ret;
    }

    /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
     * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
     * @return SQL string
     */
    private String _prepareWhereSearch() {

        StringBuffer sql = new StringBuffer();
        sql.append(whereString);
        //System.out.println(whereString);
        return sql.toString();
    }
}
