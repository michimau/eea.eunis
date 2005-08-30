<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.sites.SitesBean,
                 ro.finsiel.eunis.search.habitats.sites.SitesPaginator,
                 ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.sites.SitesSortCriteria,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.sites.SitesBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
  function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
  }
  //-->
  </script>
  <%// Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), SitesBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), SitesBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), true);
    //boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), SitesBean.HIDE);
    boolean showVernacularName = false;

//    System.out.println("showVernacularName = " + showVernacularName);
    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    // The main paginator
//    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatsSitesDomain.SEARCH_EUNIS);
    Integer database = HabitatsSitesDomain.SEARCH_BOTH;
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
    boolean[] source_db = {true, true, true, true, true, true, true, true};

    SitesPaginator paginator = new SitesPaginator(new HabitatsSitesDomain(formBean.toSearchCriteria(),
      formBean.toSortCriteria(),
      searchAttribute,
      database,
      source_db));

    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-sites-result.jsp";
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

    String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-sites.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_sites-result_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Habitats#habitats-sites.jsp,Results" />
  <jsp:param name="helpLink" value="sites-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h5><%=contentManagement.getContent("habitats_sites-result_01")%></h5>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <%
    SitesSearchCriteria mainCriteria = (SitesSearchCriteria) formBean.getMainSearchCriteria();
    String criteriaStr = "You searched";
    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {
      criteriaStr += " <strong> EUNIS </strong>";
    }
    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {
      criteriaStr += " <strong> ANNEX I </strong>";
    }
    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {
      criteriaStr += " both <strong> EUNIS </strong> and <strong>ANNEX I</strong>";
    }
    criteriaStr += " habitat types within sites with <strong>" + mainCriteria.toHumanString() + "</strong>";
  %>
  <tr>
    <td width="741">
      <%=criteriaStr%>
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
<%=contentManagement.getContent("habitats_sites-result_02")%>:
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td bgcolor="#EEEEEE">
    <strong>
      <%=contentManagement.getContent("habitats_sites-result_03")%>
    </strong>
  </td>
</tr>
<tr>
  <td bgcolor="#EEEEEE">
    <form name="refineSearch" method="get" onsubmit="return( validateRefineForm(<%=noCriteria%>) );" action="">
      <%=formBean.toFORMParam(filterSearch)%>
      <label for="criteriaType" class="noshow">Criteria</label>
      <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
        <%
          if (showCode) {
        %>
        <%
          if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_sites-result_04", false)%></option>
        <option value="<%=SitesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_sites-result_05", false)%></option>
        <%
          }
        %>
        <%
          if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_sites-result_04", false)%></option>
        <%
          }
        %>
        <%                if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_sites-result_05", false)%></option>
        <%
          }
        %>
        <%
          }
        %>
        <%
          if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue()) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_LEVEL%>"><%=contentManagement.getContent("habitats_sites-result_06", false)%></option>
        <%
          }
        %>
        <%
          if (showVernacularName) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_NAME%>"><%=contentManagement.getContent("habitats_sites-result_07", false)%></option>
        <%
          }
        %>
        <%
          if (showScientificName) {
        %>
        <option value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_sites-result_08", false)%></option>
        <%
          }
        %>
      </select>
      <label for="oper" class="noshow">Operator</label>
      <select title="Operator" name="oper" id="oper" class="inputTextField">
        <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_sites-result_09", false)%></option>
        <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_sites-result_10", false)%></option>
        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_sites-result_11", false)%></option>
      </select>
      <label for="criteriaSearch" class="noshow">Search value</label>
      <input title="Search value" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
      <label for="Submit" class="noshow">Search</label>
      <input title="Search" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_sites-result_12", false)%>" />
      <%=contentManagement.writeEditTag("habitats_sites-result_12")%>
    </form>
  </td>
</tr>
<%-- This is the code which shows the search filters --%>
<%ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();%>
<%
  if (criterias.length > 1) {
%>
<tr>
  <td bgcolor="#EEEEEE">
    <%=contentManagement.getContent("habitats_sites-result_13")%>:
  </td>

</tr>
<%
  }
%>
<%
  for (int i = criterias.length - 1; i > 0; i--) {
%>
<%AbstractSearchCriteria criteria = criterias[i];%>
<%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
<tr>
  <td bgcolor="#CCCCCC" align="left">
    <a title="Delete criteria" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
      <img title="Delete" alt="Delete" src="images/mini/delete.jpg" border="0" align="middle" />
    </a>
    &nbsp;&nbsp;
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
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <jsp:include page="navigator.jsp">
        <jsp:param name="pagesCount" value="<%=pagesCount%>" />
        <jsp:param name="pageName" value="<%=pageName%>" />
        <jsp:param name="guid" value="<%=guid%>" />
        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
      </jsp:include>
    </td>
  </tr>
</table>
<table summary="Search results" width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  sortURLFields.addElement("oper");
  sortURLFields.addElement("criteriaType");
  sortURLFields.addElement("currentPage");
  sortURLFields.addElement("expand");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_LEVEL);
  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_ANNEX_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_VERNACULAR_NAME);
%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue()) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_sites-result_06")%></a>
  </th>
  <%}%>
  <%if (showCode) {%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_04")%></a>
  </th>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_05")%></a>
  </th>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_04")%></a>
  </th>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_05")%></a>
  </th>
  <%}%>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_sites-result_08")%></a>
  </th>
  <%}%>
  <%
    if (showVernacularName)
    {
  %>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_sites-result_07")%></a>
  </th>
  <%}%>
  <th class="resultHeader" width="130" align="left">
    <strong><%=contentManagement.getContent("habitats_sites-result_14")%>
    </strong>
  </th>
</tr>
<%
  int i = 0;
  Iterator it = results.iterator();
  while (it.hasNext()) {
    HabitatsSitesPersist habitat = (HabitatsSitesPersist) it.next();
    String rowBgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
    String eunisCode = habitat.getEunisHabitatCode();
    //String annexCode = habitat.getCodeAnnex1();
    String annexCode = habitat.getCode2000();
%>
<tr bgcolor="<%=rowBgColor%>">
  <%if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue()) {%>
  <%int level = habitat.getHabLevel().intValue();%>
  <td align="left" style="white-space:nowrap">
    <%for (int iter = 0; iter < level; iter++) {%>
    <img alt="" src="images/mini/lev_blank.gif" />
    <%}%><%=habitat.getHabLevel()%>
  </td>
  <%}%>
  <%if (showCode) {%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {%>
  <td align="left"><%=eunisCode%></td>
  <td align="left"><%=annexCode%></td>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {%>
  <td align="left"><%=eunisCode%></td>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {%>
  <td align="left"><%=annexCode%></td>
  <%}%>
  <%}%>
  <%if (showScientificName) {%>
  <td align="left">
    <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
  </td>
  <%}%>
  <%if (showVernacularName) {%>
  <td align="left"><%=habitat.getDescription()%></td>
  <%}%>
  <td align="left">
    <%
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
      Integer idNatureObject = habitat.getIdNatureObject();
      // List of habitats from the specified site
      List resultsSites = new HabitatsSitesDomain().findSitesWithHabitats(
        new SitesSearchCriteria(searchAttribute,
          formBean.getScientificName(),
          relationOp),
        source_db,
        searchAttribute,
        idNatureObject,
        database);
      if (resultsSites != null && resultsSites.size() > 0) {
        String SQL_DRV = application.getInitParameter("JDBC_DRV");
        String SQL_URL = application.getInitParameter("JDBC_URL");
        String SQL_USR = application.getInitParameter("JDBC_USR");
        String SQL_PWD = application.getInitParameter("JDBC_PWD");

        SQLUtilities sqlc = new SQLUtilities();
        sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
    %>
    <table summary="Sites" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
      <%
        for (int ii = 0; ii < resultsSites.size(); ii++) {
          List l = (List) resultsSites.get(ii);
          String siteName = (String) l.get(0);
          String siteSourceDb = (String) l.get(1);
          String idSite = sqlc.ExecuteSQL("select ID_SITE FROM chm62edt_sites WHERE NAME='" + siteName.replaceAll("'", "''") + "'");
      %>
      <tr bgcolor="#FFFFFF">
        <td align="left">
          <a href="sites-factsheet.jsp?idsite=<%=idSite%>" title="Open site factsheet"><%=siteName%></a>&nbsp;(<%=siteSourceDb%>
          )
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
  <%--                  <td align="center">--%>
  <%--                    <%if (habitat.getHabLevel().intValue()>0 && habitat.getHabLevel().intValue()<3) {%>--%>
  <%--                      <a href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=habitat.getEunisHabitatCode()%>','','toolbar=yes,scrollbars=yes,resizable=yes')"><img src="images/mini/diagram_out.png" alt='Diagram...' width='20' height='20' border='0"></a>--%>
  <%--                    <%}%>--%>
  <%--                  </td>--%>
</tr>
<%}%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue()) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_sites-result_06")%></a>
  </th>
  <%}%>
  <%if (showCode) {%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_04")%></a>
  </th>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_05")%></a>
  </th>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_04")%></a>
  </th>
  <%}%>
  <%if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_sites-result_05")%></a>
  </th>
  <%}%>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_sites-result_08")%></a>
  </th>
  <%}%>
  <%if (showVernacularName) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_sites-result_07")%></a>
  </th>
  <%}%>
  <th class="resultHeader" width="130" align="left">
    <strong><%=contentManagement.getContent("habitats_sites-result_14")%>
    </strong>
  </th>
</tr>
</table>
</td>
</tr>
<tr>
  <td>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
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
  </td>
</tr>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-sites-result.jsp" />
</jsp:include>
    </div>
  </body>
</html>