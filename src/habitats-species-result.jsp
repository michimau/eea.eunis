<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show habitat types' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.species.ScientificNameDomain,
                 ro.finsiel.eunis.jrfTables.habitats.species.ScientificNamePersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.species.SpeciesBean,
                 ro.finsiel.eunis.search.habitats.species.SpeciesPaginator,
                 ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.species.SpeciesSortCriteria,
                 ro.finsiel.eunis.utilities.TableColumns,
                 java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  <!--
    function MM_openBrWindow(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }
  //-->
  </script>
  <%
    // Prepare the search in results (fix)
    if(null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    // Request parameters.
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), SpeciesBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), SpeciesBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), true);
    boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), SpeciesBean.HIDE);

    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), ScientificNameDomain.SEARCH_EUNIS);
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
    // The main paginator
    SpeciesPaginator paginator = new SpeciesPaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
                                                                               formBean.toSortCriteria(),
                                                                               database,
                                                                               SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                               searchAttribute));
    // Initialisation
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-species-result.jsp";
    int pagesCount = paginator.countPages();// This is used in @page include...
    int guid = 0;// This is used in @page include...
    // Now extract the results for the current page.
    List results = paginator.getPage(currentPage);
    // Set number criteria for the search result
    int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

    // Prepare parameters for tsvlink
    Vector reportFields = new Vector();
    reportFields.addElement("sort");
    reportFields.addElement("ascendency");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("oper");
    reportFields.addElement("criteriaType");

    String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-species.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_species-result_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Habitats#habitats-species.jsp,Results" />
  <jsp:param name="helpLink" value="species-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<%--      <jsp:param name="printLink" value="<%=pdfLink%>" />--%>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h5><%=contentManagement.getContent("habitats_species-result_01")%></h5>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <%SpeciesSearchCriteria mainCriteria = (SpeciesSearchCriteria) formBean.getMainSearchCriteria();%>
  <tr>
    <td>
      <%=contentManagement.getContent("habitats_species-result_02")%>
      <strong>
        <%=Utilities.getSourceHabitat(database, ScientificNameDomain.SEARCH_ANNEX_I.intValue(), ScientificNameDomain.SEARCH_BOTH.intValue())%>
      </strong>
      <%=contentManagement.getContent("habitats_species-result_03")%>:
      <strong>
        <%=mainCriteria.toHumanString()%>
      </strong>.
    </td>
  </tr>
</table>
 <%
          if (results.isEmpty())
          {
             boolean fromRefine = false;
             if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
               fromRefine = true;

      %>

             <jsp:include page="noresults.jsp" >
               <jsp:param name="fromRefine" value="<%=fromRefine%>" />
             </jsp:include>
       <%
               return;
           }
       %>
<%=contentManagement.getContent("habitats_species-result_04")%>:
<strong>
  <%=resultsCount%>
</strong>
<%// Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
  pageSizeFormFields.addElement("oper");
  pageSizeFormFields.addElement("criteriaType");
  pageSizeFormFields.addElement("expand");
%>
<jsp:include page="pagesize.jsp">
  <jsp:param name="guid" value="<%=guid%>" />
  <jsp:param name="pageName" value="<%=pageName%>" />
  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
</jsp:include>
<%
  // Prepare the form parameters.
  Vector filterSearch = new Vector();
  filterSearch.addElement("sort");
  filterSearch.addElement("ascendency");
  filterSearch.addElement("criteriaSearch");
  filterSearch.addElement("oper");
  filterSearch.addElement("criteriaType");
  filterSearch.addElement("pageSize");
  filterSearch.addElement("expand");
%>
<br />
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=contentManagement.getContent("habitats_species-result_05")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow">Criteria</label>
        <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
          <%if(showCode && 0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS)) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_species-result_06", false)%></option><%}%>
          <%if(showCode && 0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I)) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_species-result_07", false)%></option><%}%>
          <%if(showCode && 0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH)) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_species-result_06", false)%></option>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_species-result_07", false)%></option>
          <%}%>
          <%if(showLevel && formBean.getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString())) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_LEVEL%>"><%=contentManagement.getContent("habitats_species-result_08", false)%></option><%}%>
          <%if(showVernacularName) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_NAME%>"><%=contentManagement.getContent("habitats_species-result_09", false)%></option><%}%>
          <%if(showScientificName) {%>
          <option value="<%=SpeciesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_species-result_10", false)%></option><%}%>
        </select>
        <label for="oper" class="noshow">Operator</label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_species-result_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_species-result_12", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_species-result_13", false)%></option>
        </select>
        <label for="criteriaSearch" class="noshow">Search value</label>
        <input title="Search value" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <label for="Submit" class="noshow">Search</label>
        <input title="Search" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_species-result_14", false )%>" />
        <%=contentManagement.writeEditTag("habitats_species-result_14")%>
      </form>
    </td>
  </tr>
    <%-- This is the code which shows the search filters --%>
    <%ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();%>
    <%if(criterias.length > 1) {%>
  <tr>
    <td bgcolor="#EEEEEE">
      <%=contentManagement.getContent("habitats_species-result_15")%>:
    </td>
  </tr>
  <%}%>
  <%for(int i = criterias.length - 1; i > 0; i--) {%>
  <%AbstractSearchCriteria criteria = criterias[i];%>
  <%if(null != criteria && null != formBean.getCriteriaSearch()) {%>
  <tr>
    <td bgcolor="#CCCCCC" align="left">
      <a title="Delete criteria" href="<%=pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
        <img alt="Delete" src="images/mini/delete.jpg" border="0" align="middle" />
      </a>&nbsp;&nbsp;
      <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
    </td>
  </tr>
  <%}%>
  <%}%>
</table>
<%
  // Prepare parameters for navigator.jsp
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
  navigatorFormFields.addElement("ascendency");
  navigatorFormFields.addElement("criteriaSearch");
  navigatorFormFields.addElement("oper");
  navigatorFormFields.addElement("criteriaType");
  navigatorFormFields.addElement("expand");
%>
<jsp:include page="navigator.jsp">
  <jsp:param name="pagesCount" value="<%=pagesCount%>" />
  <jsp:param name="pageName" value="<%=pageName%>" />
  <jsp:param name="guid" value="<%=guid%>" />
  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
</jsp:include>
<table border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  sortURLFields.addElement("oper");
  sortURLFields.addElement("criteriaType");
  sortURLFields.addElement("currentPage");
  sortURLFields.addElement("expand");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_LEVEL);
  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_ANNEX_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_VERNACULAR_NAME);
%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%if(showLevel && (formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString())) {%>
  <th class="resultHeader" align="left" width="56">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_species-result_16")%></a>
  </th>
  <%}%>
  <%if(showCode) {%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_species-result_06")%></a>
  </th>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_species-result_07")%></a>
  </th>
  <%}%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_species-result_06")%></a>
  </th>
  <%}%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_species-result_07")%></a>
  </th>
  <%}%>
  <%}%>
  <%if(showScientificName) {%>
  <th class="resultHeader" align="left" width="261">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_species-result_17")%></a>
  </th>
  <%}%>
  <%if(showVernacularName) {%>
  <th class="resultHeader" align="left" width="166">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_species-result_09")%></a>
  </th>
  <%}%>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("habitats_species-result_18")%>
  </th>
</tr>
<%
  int i = 0;
  Iterator it = results.iterator();
  while(it.hasNext()) {
    ScientificNamePersist habitat = (ScientificNamePersist) it.next();
    String rowBgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
    int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
    boolean isEUNIS = idHabitat <= 10000;
    String eunisCode = habitat.getEunisHabitatCode();
    //String annexCode = habitat.getCodeAnnex1();
    String annexCode = habitat.getCode2000();
    if(isEUNIS) {
      annexCode = "";
    } else {
      eunisCode = "";
    }
%>
<tr bgcolor="<%=rowBgColor%>">
  <%
    if(showLevel && formBean.getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString())) {
      int level = habitat.getHabLevel().intValue();
  %>
  <td align="left" width="90" style="white-space:nowrap"><%for(int iter = 0; iter < level; iter++) {%>
    <img alt="" src="images/mini/lev_blank.gif" /><%}%><%=habitat.getHabLevel()%>
  </td>
  <%
    }
    if(showCode) {
      if(0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH)) {
  %>
  <td align="left" width="30"><%=eunisCode%></td>
  <td align="left" width="30"><%=annexCode%></td>
  <%
    }
    if(0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS)) {
  %>
  <td align="left" width="30"><%=eunisCode%></td>
  <%
    }
    if(0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I)) {
  %>
  <td align="left" width="30"><%=annexCode%></td>
  <%
      }
    }
    if(showScientificName) {
  %>
  <td align="left" width="261">
    <a href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
  </td>
  <%
    }
    if(showVernacularName) {
  %>
  <td align="left" width="166"><%=habitat.getDescription()%></td>
  <%
    }
  %>
  <td align="left">
    <%
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
      Integer idNatureObject = habitat.getIdNatureObject();
      // List of species attributes.
      List resultsSpecies = new ScientificNameDomain().findSpeciesFromHabitat(new SpeciesSearchCriteria(searchAttribute,
                                                                                                        formBean.getScientificName(),
                                                                                                        relationOp),
                                                                              database,
                                                                              SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                              idNatureObject,
                                                                              searchAttribute);

      if(resultsSpecies != null && resultsSpecies.size() > 0) {
    %>
    <table summary="Species" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
      <%
        for(int ii = 0; ii < resultsSpecies.size(); ii++) {
          TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
          String scientificName = (String) tableColumns.getColumnsValues().get(0);
          Integer idSpecies = (Integer) tableColumns.getColumnsValues().get(1);
          Integer idSpeciesLink = (Integer) tableColumns.getColumnsValues().get(2);
      %>
      <tr bgcolor="#FFFFFF">
        <td>
          <a title="Open species factsheet" href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"><%=scientificName%></a>
        </td>
      </tr>
      <%
        }
      %>
    </table>
    <%
      }
    %>
  </td>
</tr>
<%}%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%if(showLevel && (formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString())) {%>
  <th class="resultHeader" align="left" width="56">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_species-result_16")%></a>
  </th>
  <%}%>
  <%if(showCode) {%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_species-result_06")%></a>
  </th>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_species-result_07")%></a>
  </th>
  <%}%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_species-result_06")%></a>
  </th>
  <%}%>
  <%if(0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I)) {%>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_species-result_07")%></a>
  </th>
  <%}%>
  <%}%>
  <%if(showScientificName) {%>
  <th class="resultHeader" align="left" width="261">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_species-result_17")%></a>
  </th>
  <%}%>
  <%if(showVernacularName) {%>
  <th class="resultHeader" align="left" width="166">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_species-result_09")%></a>
  </th>
  <%}%>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("habitats_species-result_18")%>
  </th>
</tr>
</table>
</td>
</tr>
<tr>
  <td>
    <jsp:include page="navigator.jsp">
      <jsp:param name="pagesCount" value="<%=pagesCount%>" />
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="guid" value="<%=guid + 1%>" />
      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
    </jsp:include>
  </td>
</tr>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-species-result.jsp" />
</jsp:include>
    </div>
  </body>
</html>