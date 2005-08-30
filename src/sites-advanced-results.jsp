<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites advanced search results.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.advanced.DictionaryPaginator,
                 ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <%
       // Web content manager used in this page.
        WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_advanced-results_01", false )%></title>
  </head>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  AbstractPaginator paginator;
  //String searchedDatabase = formBean.getSearchedNatureObject();
  String searchedDatabase = "Sites";
//  System.out.println("searchedDatabase = " + searchedDatabase);
  paginator = new DictionaryPaginator(new DictionaryDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "sites-advanced-results.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showSourceDB = columnsDisplayed.contains( "showSourceDB" );
  boolean showCountry = columnsDisplayed.contains( "showCountry" );
  boolean showDesignationType = columnsDisplayed.contains( "showDesignationType" );
  boolean showName = columnsDisplayed.contains( "showName" );
  boolean showCoordinates = columnsDisplayed.contains( "showCoordinates" );
  boolean showSize = columnsDisplayed.contains( "showSize" );
  boolean showDesignationYear = columnsDisplayed.contains( "showDesignationYear" );
  boolean showLength = columnsDisplayed.contains( "showLength" );
  boolean showMinAltitude = columnsDisplayed.contains( "showMinAltitude" );
  boolean showMaxAltitude = columnsDisplayed.contains( "showMaxAltitude" );
  boolean showMeanAltitude = columnsDisplayed.contains( "showMeanAltitude" );
  //new fields added for advanced search
  boolean showRespondent = columnsDisplayed.contains( "showRespondent" );
  boolean showManager = columnsDisplayed.contains( "showManager" );
  boolean showOwnership = columnsDisplayed.contains( "showOwnership" );
  boolean showCharacter = columnsDisplayed.contains( "showCharacter" );
  boolean showCompilationDate = columnsDisplayed.contains( "showCompilationDate" );
  boolean showProposedDate = columnsDisplayed.contains( "showProposedDate" );

  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openlink('reports/sites/tsv-sites-advanced.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
<body>
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Advanced Search#sites-advanced.jsp,Results"/>
    <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
  </jsp:include>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
    <tr>
      <td>
        <%
          String paragraph01 = contentManagement.getContent("sites_advanced-results_01");
          if (null != paragraph01) out.print("<h5>"+paragraph01+"</h5>");
        %>
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%=contentManagement.getContent("sites_advanced-results_03")%>
            </td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF"><%=contentManagement.getContent("sites_advanced-results_04")%> <%=SessionManager.getExplainedcriteria()%><%=contentManagement.getContent("sites_advanced-results_05")%>
            </td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF"><%=SessionManager.getListcriteria()%>
            </td>
            </tr>
          <tr>
            <td bgcolor="#FFFFFF"><%=contentManagement.getContent("sites_advanced-results_06")%> <%=SessionManager.getSourcedb()%>
            </td>
          </tr>
        </table>
        <%if (results.isEmpty()) {%><jsp:include page="noresults.jsp" /><%return;}%>
        <br />
        <%=contentManagement.getContent("sites_advanced-results_07")%>&nbsp;<strong><%=resultsCount%></strong><br />
        <%// Prepare parameters for pagesize.jsp
          Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
          pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
          pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                                                          /*   to page '0' aka first page. */
        %>
        <jsp:include page="pagesize.jsp">
          <jsp:param name="guid" value="<%=guid%>"/>
          <jsp:param name="pageName" value="<%=pageName%>"/>
          <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
          <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
        </jsp:include>
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

          AbstractSortCriteria sortRespondent = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_RESPONDENT);
          AbstractSortCriteria sortManager = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MANAGER);
          AbstractSortCriteria sortOwnership = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_OWNERSHIP);
          AbstractSortCriteria sortCharacter = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_CHARACTER);
          AbstractSortCriteria sortCompilationDate = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_COMPILATION_DATE);
          AbstractSortCriteria sortProposedDate = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_PROPOSED_DATE);

          // Expand/Collapse vernacular names
          Vector expand = new Vector();
          expand.addElement("sort");
          expand.addElement("ascendency");
          expand.addElement("pageSize");
          expand.addElement("currentPage");
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
            <th align="left" class="resultHeader">
              <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_advanced-results_08")%></a>
            </th>
<%}%>
          <%if (showName) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, null == sortSiteName)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=contentManagement.getContent("sites_advanced-results_09")%></a></th>
          <%}%>
          <%if (showDesignationType) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, null == sortDesignationType)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=contentManagement.getContent("sites_advanced-results_10")%></a></th>
          <%}%>
          <%if (showCountry) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_advanced-results_11")%></a></th>
          <%}%>
          <%if (showDesignationYear) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, null == sortDesignationYear)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=contentManagement.getContent("sites_advanced-results_12")%></a></th>
          <%}%>
          <%if (showCoordinates) {%>
            <th align="center" class="resultHeader"><%=contentManagement.getContent("sites_advanced-results_23")%></th>
            <th align="center" class="resultHeader"><%=contentManagement.getContent("sites_advanced-results_24")%></th>
          <%}%>
          <%if (showSize) {%>
            <th align="right" class="resultHeader"><a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_advanced-results_13")%></a></th>
          <%}%>
          <%if (showLength) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("sites_advanced-results_14")%></a></th>
          <%}%>
          <%if (showMinAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, null == sortMinAltitude)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=contentManagement.getContent("sites_advanced-results_15")%></a></th>
          <%}%>
          <%if (showMaxAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, null == sortMaxAltitude)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=contentManagement.getContent("sites_advanced-results_16")%></a></th>
          <%}%>
          <%if (showMeanAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, null == sortMeanAltitude)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=contentManagement.getContent("sites_advanced-results_17")%></a></th>
          <%}%>
          <%if (showRespondent) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_RESPONDENT%>&amp;ascendency=<%=formBean.changeAscendency(sortRespondent, null == sortRespondent)%>"><%=Utilities.getSortImageTag(sortRespondent)%>Respondent</a></th>
          <%}%>
          <%if (showManager) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MANAGER%>&amp;ascendency=<%=formBean.changeAscendency(sortManager, null == sortManager)%>"><%=Utilities.getSortImageTag(sortManager)%>Manager</a></th>
          <%}%>
          <%if (showOwnership) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_OWNERSHIP%>&amp;ascendency=<%=formBean.changeAscendency(sortOwnership, null == sortOwnership)%>"><%=Utilities.getSortImageTag(sortOwnership)%>Ownership</a></th>
          <%}%>
          <%if (showCharacter) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_CHARACTER%>&amp;ascendency=<%=formBean.changeAscendency(sortCharacter, null == sortCharacter)%>"><%=Utilities.getSortImageTag(sortCharacter)%>Character</a></th>
          <%}%>
          <%if (showCompilationDate) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COMPILATION_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortCompilationDate, null == sortCompilationDate)%>"><%=Utilities.getSortImageTag(sortCompilationDate)%>Compilation Date</a></th>
          <%}%>
          <%if (showProposedDate) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PROPOSED_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortProposedDate, null == sortProposedDate)%>"><%=Utilities.getSortImageTag(sortProposedDate)%>Proposed Date</a></th>
          <%}%>
        </tr>
        <%
          String bgCol;
          int i = 0;
          while (it.hasNext()) {
            bgCol = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
            ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryPersist site = (ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryPersist)it.next();
            String designationType = Utilities.formatString(site.getDesign());
            String designationYear = SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB());
            String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
            String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
            String size = Utilities.formatArea(site.getArea(), 5, 2, "&nbsp;");
            String length = Utilities.formatArea(site.getLength(), 5, 2, "&nbsp;");
        %>
              <tr align="center" valign="top">
                <%if (showSourceDB) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><strong><%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>&nbsp;</strong></td>
                <%}%>
                <%if (showName) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><a title="Open site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a></td>
                <%}%>
                <%if (showDesignationType) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=designationType%></td>
                <%}%>
                <%if (showCountry) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=site.getAreaNameEn()%></td>
                <%}%>
                <%if (showDesignationYear) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=designationYear%>
                </td>
                <%}%>
                <%if (showCoordinates) {%>
                  <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap"><%=longitude%></td>
                  <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap"><%=latitude%></td>
                <%}%>
                <%if (showSize) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=size%></td>
                <%}%>
                <%if (showLength) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=length%></td>
                <%}%>
                <%if (showMinAltitude) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMin())%></td>
                <%}%>
                <%if (showMaxAltitude) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMax())%></td>
                <%}%>
                <%if (showMeanAltitude) {%>
                  <td align="right" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getAltMean())%></td>
                <%}%>
                <%if (showRespondent) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getRespondent())%></td>
                <%}%>
                <%if (showManager) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getManager())%></td>
                <%}%>
                <%if (showOwnership) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getOwnership())%></td>
                <%}%>
                <%if (showCharacter) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getCharacter())%></td>
                <%}%>
                <%if (showCompilationDate) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getCompilationDate())%></td>
                <%}%>
                <%if (showProposedDate) {%>
                  <td align="left" bgcolor="<%=bgCol%>"><%=Utilities.formatString(site.getProposedDate())%></td>
                <%}%>
              </tr>
          <%}%>
        <tr>
          <%if (showSourceDB) {%>
            <th align="left" class="resultHeader">
              <a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_advanced-results_08")%></a>
            </th>
          <%}%>
          <%if (showName) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, null == sortSiteName)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=contentManagement.getContent("sites_advanced-results_09")%></a></th>
          <%}%>
          <%if (showDesignationType) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, null == sortDesignationType)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=contentManagement.getContent("sites_advanced-results_10")%></a></th>
          <%}%>
          <%if (showCountry) {%>
            <th align="left" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_advanced-results_11")%></a></th>
          <%}%>
          <%if (showDesignationYear) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, null == sortDesignationYear)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=contentManagement.getContent("sites_advanced-results_12")%></a></th>
          <%}%>
          <%if (showCoordinates) {%>
            <th align="center" class="resultHeader"><%=contentManagement.getContent("sites_advanced-results_23")%></th>
            <th align="center" class="resultHeader"><%=contentManagement.getContent("sites_advanced-results_24")%></th>
          <%}%>
          <%if (showSize) {%>
            <th align="right" class="resultHeader"><a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_advanced-results_13")%></a></th>
          <%}%>
          <%if (showLength) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("sites_advanced-results_14")%></a></th>
          <%}%>
          <%if (showMinAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, null == sortMinAltitude)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=contentManagement.getContent("sites_advanced-results_15")%></a></th>
          <%}%>
          <%if (showMaxAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, null == sortMaxAltitude)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=contentManagement.getContent("sites_advanced-results_16")%></a></th>
          <%}%>
          <%if (showMeanAltitude) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, null == sortMeanAltitude)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=contentManagement.getContent("sites_advanced-results_17")%></a></th>
          <%}%>
          <%if (showRespondent) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_RESPONDENT%>&amp;ascendency=<%=formBean.changeAscendency(sortRespondent, null == sortRespondent)%>"><%=Utilities.getSortImageTag(sortRespondent)%>Respondent</a></th>
          <%}%>
          <%if (showManager) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MANAGER%>&amp;ascendency=<%=formBean.changeAscendency(sortManager, null == sortManager)%>"><%=Utilities.getSortImageTag(sortManager)%>Manager</a></th>
          <%}%>
          <%if (showOwnership) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_OWNERSHIP%>&amp;ascendency=<%=formBean.changeAscendency(sortOwnership, null == sortOwnership)%>"><%=Utilities.getSortImageTag(sortOwnership)%>Ownership</a></th>
          <%}%>
          <%if (showCharacter) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_CHARACTER%>&amp;ascendency=<%=formBean.changeAscendency(sortCharacter, null == sortCharacter)%>"><%=Utilities.getSortImageTag(sortCharacter)%>Character</a></th>
          <%}%>
          <%if (showCompilationDate) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COMPILATION_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortCompilationDate, null == sortCompilationDate)%>"><%=Utilities.getSortImageTag(sortCompilationDate)%>Compilation Date</a></th>
          <%}%>
          <%if (showProposedDate) {%>
            <th align="right" class="resultHeader"><a title="Sort results on this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PROPOSED_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortProposedDate, null == sortProposedDate)%>"><%=Utilities.getSortImageTag(sortProposedDate)%>Proposed Date</a></th>
          <%}%>
        </tr>
    </table>
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
  <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="sites-advanced-results.jsp" />
    </jsp:include>
    </div>
  </body>
</html>