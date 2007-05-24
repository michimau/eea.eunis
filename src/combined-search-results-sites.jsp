<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Results page for 'Combined search' function when starting nature object was Sites.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist"%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("generic_combined-search-results-sites_title")%>
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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,combined_search#combined-search.jsp,results";
  if(results.isEmpty())
  {
%>
    <jsp:forward page="emptyresults.jsp">
      <jsp:param name="location" value="<%=location%>" />
    </jsp:forward>
<%
  }
%>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=location%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table width="100%" border=0 cellspacing="0" cellpadding="0">
                <tr>
                <td>
                <h1><%=cm.cmsText("generic_combined-search-results-sites_01")%></h1>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <%=cm.cmsText("generic_combined-search-results-sites_02")%>
                  </td>
                </tr>
                <tr>
                  <td>
                    <%=SessionManager.getCombinednatureobject1()%>
                    <%=cm.cmsText("generic_combined-search-results-sites_03")%>
                    <%=SessionManager.getCombinedexplainedcriteria1()%>
                    <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                  </td>
                </tr>
                <tr>
                  <td>
                    <%=SessionManager.getCombinedlistcriteria1() != null ? SessionManager.getCombinedlistcriteria1() : "&nbsp;"%>
                  </td>
                </tr>
                <tr>
                  <td>
                    <%=cm.cmsText("source_data_sets")%>
                    <%=SessionManager.getSourcedb()%>
                  </td>
                </tr>
                <%
                  if(SessionManager.getCombinednatureobject2() != null) {
                %>
                <tr>
                  <td>
                    <%=SessionManager.getCombinednatureobject2()%>
                    <%=cm.cmsText("generic_combined-search-results-sites_03")%>
                    <%=SessionManager.getCombinedexplainedcriteria2()%>
                    <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                  </td>
                </tr>
                <tr>
                  <td>
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
                  <td>
                    <%=SessionManager.getCombinednatureobject3()%>
                    <%=cm.cmsText("generic_combined-search-results-sites_03")%>
                    <%=SessionManager.getCombinedexplainedcriteria3()%>
                    <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                  </td>
                </tr>
                <tr>
                  <td>
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
                  <td>
                    <%=cm.cmsText("combination_type")%>
                    <%=SessionManager.getCombinedcombinationtype()%>
                  </td>
                </tr>
                <%
                } else {
                  if(SessionManager.getCombinednatureobject2() != null) {
                %>
                <tr>
                  <td>
                    <%=cm.cmsText("combination_type")%>
                    <%=SessionManager.getCombinednatureobject1()%>
                    <%=cm.cmsText("related_to")%>
                    <%=SessionManager.getCombinednatureobject2()%>
                  </td>
                </tr>
                <%
                  }
                  if(SessionManager.getCombinednatureobject3() != null) {
                %>
                <tr>
                  <td>
                    <%=cm.cmsText("combination_type")%>
                    <%=SessionManager.getCombinednatureobject1()%>
                    <%=cm.cmsText("related_to")%>
                    <%=SessionManager.getCombinednatureobject3()%>
                  </td>
                </tr>
                <%
                    }
                  }
                %>
                </table>
                <p>
                  <%=cm.cmsText("results_found_1")%>
                  <strong>
                    <%=resultsCount%>
                  </strong>
                <%
                  Vector mapFields = new Vector();
                  mapFields.addElement("criteriaSearch");
                  mapFields.addElement("oper");
                  mapFields.addElement("criteriaType");
                %>
                  <jsp:include page="sites-map.jsp">
                    <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
                    <jsp:param name="mapName" value="combined-search-map.jsp" />
                    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(mapFields)%>" />
                  </jsp:include>
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
                </p>
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
                <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                  <thead>
                    <tr>
                  <%
                    if(showSourceDB)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, (null == sortSourceDB) ? true : false)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showName) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, (null == sortSiteName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=cm.cmsText("site_name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showDesignationType) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, (null == sortDesignationType) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=cm.cmsText("designation_type")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showCountry) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, (null == sortCountry) ? true : false)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showDesignationYear) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, (null == sortDesignationYear) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=cm.cmsText("designation_year")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showCoordinates) {%>
                      <th scope="col" style="text-align : center;">
                        <%=cm.cmsText("longitude")%>
                      </th>
                      <th scope="col" style="text-align : center;">
                        <%=cm.cmsText("latitude")%>
                      </th>
                  <%}%>
                  <%if(showSize) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, (null == sortSize) ? true : false)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showLength) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, (null == sortLength) ? true : false)%>"><%=Utilities.getSortImageTag(sortLength)%><%=cm.cmsText("length")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMinAltitude) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, (null == sortMinAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_18")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMaxAltitude) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, (null == sortMaxAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_19")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMeanAltitude) {%>
                      <th style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, (null == sortMeanAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_20")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  int i = 0;
                  while(it.hasNext()) {
                    String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                    SitesCombinedPersist site = (SitesCombinedPersist) it.next();
                    String designationType = Utilities.formatString(site.getDesign());
                    String designationYear = SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB());
                    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
                    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
                    String size = Utilities.formatArea(site.getArea(), 5, 2, "&nbsp;");
                    String length = Utilities.formatArea(site.getLength(), 5, 2, "&nbsp;");
                %>
                  <tr<%=cssClass%>>
                    <%
                      if(showSourceDB)
                      {
                    %>
                    <td>
                      <strong>
                        <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
                      </strong>
                    </td>
                  <%
                      }
                  %>
                  <%
                      if(showName)
                      {
                  %>
                    <td>
                      <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a>
                      <%=cm.cmsTitle("open_site_factsheet")%>
                    </td>
                  <%
                    }
                  %>
                  <%
                    if(showDesignationType) {
                      if(!site.getSourceDB().equalsIgnoreCase("NATURA2000") || !SitesSearchUtility.getSiteType(site.getIdSite()).equalsIgnoreCase("C"))
                      {
                  %>
                    <td>
                      <%=designationType%>
                    </td>
                    <%
                        } else {
                          List desigs = SitesSearchUtility.findDesignationsTypeC();
                          String des = "";
                          for(int ii=0;ii<desigs.size();ii++)
                          {
                            Chm62edtDesignationsPersist dp = (Chm62edtDesignationsPersist) desigs.get(ii);
                            des += dp.getDescriptionEn();
                            if(ii < desigs.size()-1)
                            {
                              des += "<hr />";
                            }
                          }
                    %>
                    <td>
                      <%=des%>
                    </td>
                    <%
                        }
                      }
                    %>
                    <%
                      if(showCountry)
                      {
                    %>
                    <td>
                      <%=site.getAreaNameEn()%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showDesignationYear)
                      {
                    %>
                    <td>
                      <%=designationYear%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showCoordinates)
                      {
                    %>
                    <td style="white-space:nowrap; text-align : center;">
                      <%=longitude%>
                    </td>
                    <td style="white-space:nowrap; text-align : center;">
                      <%=latitude%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showSize)
                      {
                    %>
                    <td style="text-align : right;">
                      <%=size%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showLength)
                      {
                    %>
                    <td style="text-align : right;">
                      <%=length%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showMinAltitude)
                      {
                    %>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(site.getAltMin())%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showMaxAltitude)
                      {
                    %>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(site.getAltMax())%>
                    </td>
                    <%
                      }
                    %>
                    <%
                      if(showMeanAltitude)
                      {
                    %>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(site.getAltMean())%>
                    </td>
                    <%
                      }
                    %>
                  </tr>
                <%
                  }
                %>
                </tbody>
                  <thead>
                    <tr>
                  <%
                    if(showSourceDB)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, (null == sortSourceDB) ? true : false)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showName) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, (null == sortSiteName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=cm.cmsText("site_name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showDesignationType) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, (null == sortDesignationType) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=cm.cmsText("designation_type")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showCountry) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, (null == sortCountry) ? true : false)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showDesignationYear) {%>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, (null == sortDesignationYear) ? true : false)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=cm.cmsText("designation_year")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showCoordinates) {%>
                      <th scope="col" style="text-align : center;">
                        <%=cm.cmsText("longitude")%>
                      </th>
                      <th scope="col" style="text-align : center;">
                        <%=cm.cmsText("latitude")%>
                      </th>
                  <%}%>
                  <%if(showSize) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, (null == sortSize) ? true : false)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showLength) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, (null == sortLength) ? true : false)%>"><%=Utilities.getSortImageTag(sortLength)%><%=cm.cmsText("length")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMinAltitude) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, (null == sortMinAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_18")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMaxAltitude) {%>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, (null == sortMaxAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_19")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                  <%if(showMeanAltitude) {%>
                      <th style="text-align : right;">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, (null == sortMeanAltitude) ? true : false)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=cm.cmsText("generic_combined-search-results-sites_20")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%}%>
                    </tr>
                  </thead>
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
                  <%=cm.cmsMsg("generic_combined-search-results-sites_title")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("search_results")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="combined-search-results-sites.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
