<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Results page for 'Combined search' function when starting nature object was Habitats.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.combined.CombinedSearchPaginator,
                 ro.finsiel.eunis.jrfTables.combined.HabitatsCombinedDomain,
                 ro.finsiel.eunis.jrfTables.combined.HabitatsCombinedPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSortCriteria" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,combined_search#combined-search.jsp,results";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("generic_combined-search-results-habitats_title")%>
  </title>
</head>
<%
  // Database where to search. Possible values are: Species, Habitats or Sites
  String searchedDatabase = formBean.getSearchedNatureObject();
  AbstractPaginator paginator = new CombinedSearchPaginator(new HabitatsCombinedDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "combined-search-results-habitats.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showLevel = (columnsDisplayed.contains("showLevel")) ? true : false;
  boolean showEUNISCode = (columnsDisplayed.contains("showEUNISCode")) ? true : false;
  boolean showANNEXCode = (columnsDisplayed.contains("showANNEXCode")) ? true : false;
  boolean showScientificName = (columnsDisplayed.contains("showScientificName")) ? true : false;
  boolean showEnglishName = (columnsDisplayed.contains("showEnglishName")) ? true : false;
  boolean showLegalInstruments = (columnsDisplayed.contains("showLegalInstruments")) ? true : false;
  boolean showCountry = (columnsDisplayed.contains("showCountry")) ? true : false;
  boolean showRegion = (columnsDisplayed.contains("showRegion")) ? true : false;
  boolean showReferences = (columnsDisplayed.contains("showReferences")) ? true : false;
  boolean showDiagram = (columnsDisplayed.contains("showDiagram")) ? true : false;
%>
<body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase("Habitat types combined search results")%></h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border=0 cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="3">
                      <%=cm.cmsPhrase("You searched for habitat types<br />")%>
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("You searched habitat types using combined search criteria")%>
                          </td>
                        </tr>
                        <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinednatureobject1()%>
                          <%=cm.cmsPhrase(" combination used:&nbsp;")%>
                          <%=SessionManager.getCombinedexplainedcriteria1()%>
                          <%=cm.cmsPhrase(", where:")%>
                        </td>
                      </tr>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinedlistcriteria1() != null ? SessionManager.getCombinedlistcriteria1() : "&nbsp;"%>
                        </td>
                      </tr>
                <%
                  if(SessionManager.getCombinednatureobject2() != null)
                  {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinednatureobject2()%>
                          <%=cm.cmsPhrase(" combination used:&nbsp;")%>
                          <%=SessionManager.getCombinedexplainedcriteria2()%>
                          <%=cm.cmsPhrase(", where:")%>
                        </td>
                      </tr>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinedlistcriteria2() != null ? SessionManager.getCombinedlistcriteria2() : "&nbsp;"%>
                        </td>
                      </tr>
                <%
                    if(SessionManager.getCombinednatureobject2().equalsIgnoreCase("Sites"))
                    {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=cm.cmsPhrase("Source data sets:")%>
                          <%=SessionManager.getSourcedb()%>
                        </td>
                      </tr>
                <%
                    }
                  }
                %>
                <%
                  if(SessionManager.getCombinednatureobject3() != null)
                  {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinednatureobject3()%>
                          <%=cm.cmsPhrase(" combination used:&nbsp;")%>
                          <%=SessionManager.getCombinedexplainedcriteria3()%>
                          <%=cm.cmsPhrase(", where:")%>
                        </td>
                      </tr>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=SessionManager.getCombinedlistcriteria3() != null ? SessionManager.getCombinedlistcriteria3() : "&nbsp;"%>
                        </td>
                      </tr>
                <%
                    if(SessionManager.getCombinednatureobject3().equalsIgnoreCase("Sites"))
                    {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=cm.cmsPhrase("Source data sets:")%>
                          <%=SessionManager.getSourcedb()%>
                        </td>
                      </tr>
                <%
                    }
                  }
                %>
                <%
                  if(SessionManager.getCombinedcombinationtype() != null)
                  {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=cm.cmsPhrase("Combination type: ")%>
                          <%=SessionManager.getCombinedcombinationtype()%>
                        </td>
                      </tr>
                <%
                } else {
                  if(SessionManager.getCombinednatureobject2() != null)
                  {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=cm.cmsPhrase("Combination type: ")%>
                          <%=SessionManager.getCombinednatureobject1()%>
                          <%=cm.cmsPhrase(" related to ")%>
                          <%=SessionManager.getCombinednatureobject2()%>
                        </td>
                      </tr>
                <%
                  }
                  if(SessionManager.getCombinednatureobject3() != null)
                  {
                %>
                      <tr>
                        <td bgcolor="#FFFFFF">
                          <%=cm.cmsPhrase("Combination type: ")%>
                          <%=SessionManager.getCombinednatureobject1()%>
                          <%=cm.cmsPhrase(" related to ")%>
                          <%=SessionManager.getCombinednatureobject3()%>
                        </td>
                      </tr>
                <%
                  }
                }
                %>
                    </table>

                    <%=cm.cmsPhrase("Results found")%>
                    <strong>
                      <%=resultsCount%>
                    </strong>
                    <br />
                <%
                  // Prepare parameters for pagesize.jsp
                  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
                %>
                <jsp:include page="pagesize.jsp">
                  <jsp:param name="guid" value="<%=guid + 1%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
                </jsp:include>
                <%
                  // Prepare the form parameters.
                  Vector filterSearch = new Vector();
                  filterSearch.addElement("sort");
                  filterSearch.addElement("ascendency");
                  filterSearch.addElement("criteriaSearch");
                  filterSearch.addElement("pageSize");
                %>
                    <br />
                <%
                  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                  navigatorFormFields.addElement("ascendency");
                  navigatorFormFields.addElement("criteriaSearch");
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
                AbstractSortCriteria sortLevel = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_LEVEL);
                AbstractSortCriteria sortEunisCode = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_EUNIS_CODE);
                AbstractSortCriteria sortAnnexCode = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ANNEX_CODE);
                AbstractSortCriteria sortScientificName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SCIENTIFIC_NAME);
                AbstractSortCriteria sortEnglishName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ENGLISH_NAME);
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
                      if(showLevel)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsPhrase("Level")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showEUNISCode)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showANNEXCode)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showScientificName)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsPhrase("Name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showEnglishName)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsPhrase("English name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                        </tr>
                      </thead>
                      <tbody>
                    <%
                      int i = 0;
                      while ( it.hasNext() )
                      {
                        HabitatsCombinedPersist habitat = ( HabitatsCombinedPersist )it.next();
                        String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                        int level = habitat.getHabLevel().intValue();
                        //boolean isEUNIS = (Utilities.EUNIS_HABITAT.intValue() == (Utilities.getHabitatType(habitat.getCodeAnnex1()).intValue())) ? true : false;
                        int idHabitat = Utilities.checkedStringToInt( habitat.getIdHabitat(), -1 );
                        boolean isEUNIS = idHabitat <= 10000;
                    %>
                        <tr<%=cssClass%>>
                    <%
                        if(showLevel)
                        {
                    %>
                          <td style="white-space: nowrap;">
                    <%
                                for(int iter = 0; iter < level; iter++)
                                {
                    %>
                            <img alt="" src="images/mini/lev_blank.gif">
                    <%
                                  }
                    %>
                                <%=level%>
                          </td>
                    <%
                        }
                    %>
                    <%
                        if(showEUNISCode)
                        {
                    %>
                          <td>
                            <%=(isEUNIS) ? habitat.getEunisHabitatCode() : "&nbsp;"%>
                          </td>
                    <%
                        }
                    %>
                    <%
                      if(showANNEXCode)
                      {
                    %>
                          <td>
                            <%=(isEUNIS) ? "&nbsp;" : habitat.getCodeAnnex1()%>
                          </td>
                    <%
                      }
                    %>
                    <%
                      if(showScientificName)
                      {
                    %>
                          <td>
                            <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </td>
                    <%
                      }
                    %>
                    <%
                      if(showEnglishName)
                      {
                    %>
                          <td>
                            <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getDescription()%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
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
                      if(showLevel)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsPhrase("Level")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showEUNISCode)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showANNEXCode)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showScientificName)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsPhrase("Name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                    <%
                      if(showEnglishName)
                      {
                    %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsPhrase("English name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                    <%
                      }
                    %>
                        </tr>
                      </thead>
                    </table>
                  </td>
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
                <%=cm.cmsMsg("generic_combined-search-results-habitats_title")%>
                <%=cm.br()%>
                <%=cm.cmsTitle("search_results")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="combined-search-results-habitats.jsp"/>
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
