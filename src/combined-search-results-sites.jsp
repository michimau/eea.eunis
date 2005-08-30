<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Results page for 'Combined search' function when starting nature object was Sites.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.combined.CombinedSearchPaginator,
                 ro.finsiel.eunis.jrfTables.combined.SitesCombinedDomain,
                 ro.finsiel.eunis.jrfTables.combined.SitesCombinedPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSortCriteria" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_title", false)%>
  </title>
</head>
<%AbstractPaginator paginator = null;
  String searchedDatabase = formBean.getSearchedNatureObject();
  paginator = new CombinedSearchPaginator(new SitesCombinedDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "combined-search-results-sites.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showSourceDB = (columnsDisplayed.contains("showSourceDB")) ? true : false;
  boolean showCountry = (columnsDisplayed.contains("showCountry")) ? true : false;
  boolean showDesignationType = (columnsDisplayed.contains("showDesignationType")) ? true : false;
  boolean showName = (columnsDisplayed.contains("showName")) ? true : false;
  boolean showCoordinates = (columnsDisplayed.contains("showCoordinates")) ? true : false;
  boolean showSize = (columnsDisplayed.contains("showSize")) ? true : false;
  boolean showDesignationYear = (columnsDisplayed.contains("showDesignationYear")) ? true : false;
  boolean showLength = (columnsDisplayed.contains("showLength")) ? true : false;
  boolean showMinAltitude = (columnsDisplayed.contains("showMinAltitude")) ? true : false;
  boolean showMaxAltitude = (columnsDisplayed.contains("showMaxAltitude")) ? true : false;
  boolean showMeanAltitude = (columnsDisplayed.contains("showMeanAltitude")) ? true : false;
%>
<body>
<div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Combined search#combined-search.jsp,Results"/>
</jsp:include>
<table width="100%" border=0 cellspacing="0" cellpadding="0">
<tr>
<td>
<h5><%=contentManagement.getContent("generic_combined-search-results-sites_01")%></h5>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td>
    <%=contentManagement.getContent("generic_combined-search-results-sites_02")%>
  </td>
</tr>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinednatureobject1()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_03")%>
    <%=SessionManager.getCombinedexplainedcriteria1()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_04")%>
  </td>
</tr>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinedlistcriteria1() != null ? SessionManager.getCombinedlistcriteria1() : "&nbsp;"%>
  </td>
</tr>
<tr>
  <td bgcolor="#FFFFFF">
    <%=contentManagement.getContent("generic_combined-search-results-sites_05")%>
    <%=SessionManager.getSourcedb()%>
  </td>
</tr>
<%
  if(SessionManager.getCombinednatureobject2() != null) {
%>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinednatureobject2()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_03")%>
    <%=SessionManager.getCombinedexplainedcriteria2()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_04")%>
  </td>
</tr>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinedlistcriteria2() != null ? SessionManager.getCombinedlistcriteria2() : "&nbsp;"%>
  </td>
</tr>
<%
  }
%>
<%
  if(SessionManager.getCombinednatureobject3() != null) {
%>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinednatureobject3()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_03")%>
    <%=SessionManager.getCombinedexplainedcriteria3()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_04")%>
  </td>
</tr>
<tr>
  <td bgcolor="#FFFFFF">
    <%=SessionManager.getCombinedlistcriteria3() != null ? SessionManager.getCombinedlistcriteria3() : "&nbsp;"%>
  </td>
</tr>
<%
  }
%>
<%
  if(SessionManager.getCombinedcombinationtype() != null) {
%>
<tr>
  <td bgcolor="#FFFFFF">
    <%=contentManagement.getContent("generic_combined-search-results-sites_06")%>
    <%=SessionManager.getCombinedcombinationtype()%>
  </td>
</tr>
<%
} else {
  if(SessionManager.getCombinednatureobject2() != null) {
%>
<tr>
  <td bgcolor="#FFFFFF">
    <%=contentManagement.getContent("generic_combined-search-results-sites_06")%>
    <%=SessionManager.getCombinednatureobject1()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_07")%>
    <%=SessionManager.getCombinednatureobject2()%>
  </td>
</tr>
<%
  }
  if(SessionManager.getCombinednatureobject3() != null) {
%>
<tr>
  <td bgcolor="#FFFFFF">
    <%=contentManagement.getContent("generic_combined-search-results-sites_06")%>
    <%=SessionManager.getCombinednatureobject1()%>
    <%=contentManagement.getContent("generic_combined-search-results-sites_07")%>
    <%=SessionManager.getCombinednatureobject3()%>
  </td>
</tr>
<%
    }
  }
%>
</table>
<%
  if(results.isEmpty()) {
%>
<jsp:include page="noresults.jsp"/>
<%
    return;
  }
%>
<P>
  <%=contentManagement.getContent("generic_combined-search-results-sites_08")%>
  <strong>
    <%=resultsCount%>
  </strong>
  <br />
  <%// Prepare parameters for pagesize.jsp
    Vector pageSizeFormFields = new Vector();         /*  These fields are used by pagesize.jsp, included below.    */
    pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
    pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
    /*   to page '0' aka first page. */
  %>
  <jsp:include page="pagesize.jsp">
    <jsp:param name="guid" value="<%=guid + 1%>"/>
    <jsp:param name="pageName" value="<%=pageName%>"/>
    <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
  </jsp:include>
</P>
<%
  // Prepare the form parameters.
  Vector filterSearch = new Vector();
  filterSearch.addElement("sort");
  filterSearch.addElement("ascendency");
  filterSearch.addElement("pageSize");
%>
<br />
<%
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
  navigatorFormFields.addElement("ascendency");
%>
<jsp:include page="navigator.jsp">
  <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
  <jsp:param name="pageName" value="<%=pageName%>"/>
  <jsp:param name="guid" value="<%=guid%>"/>
  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
</jsp:include>
<table summary="Search results" border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortSiteName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SITE_NAME);
  AbstractSortCriteria sortDesignationType = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_DESIGNATION_TYPE);
  AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_COUNTRY);
  AbstractSortCriteria sortSize = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SIZE);
  AbstractSortCriteria sortLength = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_LENGTH);
  AbstractSortCriteria sortDesignationYear = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_DESIGNATION_YEAR);
  AbstractSortCriteria sortMinAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MIN_ALTITUDE);
  AbstractSortCriteria sortMaxAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MAX_ALTITUDE);
  AbstractSortCriteria sortMeanAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MEAN_ALTITUDE);

  // Expand/Collapse vernacular names
  Vector expand = new Vector();
  expand.addElement("sort");
  expand.addElement("ascendency");
  expand.addElement("pageSize");
  expand.addElement("currentPage");
  String expandURL = formBean.toURLParam(expand);
%>
<tr>
  <%if(showSourceDB) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, (null == sortSourceDB) ? true : false)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("generic_combined-search-results-sites_09")%></a>
  </th>
  <%}%>
  <%if(showName) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, (null == sortSiteName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=contentManagement.getContent("generic_combined-search-results-sites_10")%></a>
  </th>
  <%}%>
  <%if(showDesignationType) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, (null == sortDesignationType) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=contentManagement.getContent("generic_combined-search-results-sites_11")%></a>
  </th>
  <%}%>
  <%if(showCountry) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, (null == sortCountry) ? true : false)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("generic_combined-search-results-sites_12")%></a>
  </th>
  <%}%>
  <%if(showDesignationYear) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, (null == sortDesignationYear) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=contentManagement.getContent("generic_combined-search-results-sites_13")%></a>
  </th>
  <%}%>
  <%if(showCoordinates) {%>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("generic_combined-search-results-sites_14")%>
  </th>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("generic_combined-search-results-sites_15")%>
  </th>
  <%}%>
  <%if(showSize) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, (null == sortSize) ? true : false)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("generic_combined-search-results-sites_16")%></a>
  </th>
  <%}%>
  <%if(showLength) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, (null == sortLength) ? true : false)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("generic_combined-search-results-sites_17")%></a>
  </th>
  <%}%>
  <%if(showMinAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, (null == sortMinAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_18")%></a>
  </th>
  <%}%>
  <%if(showMaxAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, (null == sortMaxAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_19")%></a>
  </th>
  <%}%>
  <%if(showMeanAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, (null == sortMeanAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_20")%></a>
  </th>
  <%}%>
</tr>
<%
  String bgCol;
  int i = 0;
  while(it.hasNext()) {
    bgCol = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
    SitesCombinedPersist site = (SitesCombinedPersist) it.next();
    String designationType = Utilities.formatString(site.getDesign());
    String designationYear = SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB());
    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
    String size = Utilities.formatArea(site.getArea(), 5, 2, "&nbsp;");
    String length = Utilities.formatArea(site.getLength(), 5, 2, "&nbsp;");
%>
<tr>
  <%if(showSourceDB) {%>
  <td align="left" bgcolor="<%=bgCol%>"><%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>&nbsp;</td>
  <%}%>
  <%if(showName) {%>
  <td align="left" bgcolor="<%=bgCol%>">
    <a title="Open site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a></td>
  <%}%>
  <%if(showDesignationType) {%>
  <td align="left" bgcolor="<%=bgCol%>"><%=designationType%></td>
  <%}%>
  <%if(showCountry) {%>
  <td align="left" bgcolor="<%=bgCol%>"><%=site.getAreaNameEn()%></td>
  <%}%>
  <%if(showDesignationYear) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=designationYear%>
  </td>
  <%}%>
  <%if(showCoordinates) {%>
  <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap"><%=longitude%></td>
  <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap"><%=latitude%></td>
  <%}%>
  <%if(showSize) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=size%></td>
  <%}%>
  <%if(showLength) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=length%></td>
  <%}%>
  <%if(showMinAltitude) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMin())%></td>
  <%}%>
  <%if(showMaxAltitude) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMax())%></td>
  <%}%>
  <%if(showMeanAltitude) {%>
  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMean())%></td>
  <%}%>
</tr>
<%}%>
<tr>
  <%if(showSourceDB) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, (null == sortSourceDB) ? true : false)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("generic_combined-search-results-sites_09")%></a>
  </th>
  <%}%>
  <%if(showName) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, (null == sortSiteName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=contentManagement.getContent("generic_combined-search-results-sites_10")%></a>
  </th>
  <%}%>
  <%if(showDesignationType) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, (null == sortDesignationType) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=contentManagement.getContent("generic_combined-search-results-sites_11")%></a>
  </th>
  <%}%>
  <%if(showCountry) {%>
  <th class="resultHeader" align="left">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, (null == sortCountry) ? true : false)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("generic_combined-search-results-sites_12")%></a>
  </th>
  <%}%>
  <%if(showDesignationYear) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, (null == sortDesignationYear) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=contentManagement.getContent("generic_combined-search-results-sites_13")%></a>
  </th>
  <%}%>
  <%if(showCoordinates) {%>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("generic_combined-search-results-sites_14")%>
  </th>
  <th class="resultHeader" align="center">
    <%=contentManagement.getContent("generic_combined-search-results-sites_15")%>
  </th>
  <%}%>
  <%if(showSize) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, (null == sortSize) ? true : false)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("generic_combined-search-results-sites_16")%></a>
  </th>
  <%}%>
  <%if(showLength) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, (null == sortLength) ? true : false)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("generic_combined-search-results-sites_17")%></a>
  </th>
  <%}%>
  <%if(showMinAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, (null == sortMinAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_18")%></a>
  </th>
  <%}%>
  <%if(showMaxAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, (null == sortMaxAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_19")%></a>
  </th>
  <%}%>
  <%if(showMeanAltitude) {%>
  <th class="resultHeader" align="right">
    <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, (null == sortMeanAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=contentManagement.getContent("generic_combined-search-results-sites_20")%></a>
  </th>
  <%}%>
</tr>
<tr>
  <td>
    <jsp:include page="navigator.jsp">
      <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
      <jsp:param name="pageName" value="<%=pageName%>"/>
      <jsp:param name="guid" value="<%=guid + 1%>"/>
      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
    </jsp:include>
  </td>
</tr>
</table>
</td>
</tr>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="combined-search-results-sites.jsp"/>
</jsp:include>
</div>
</body>
</html>
