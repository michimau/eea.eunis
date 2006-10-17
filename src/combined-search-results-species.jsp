<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Results page for 'Combined search' function when starting nature object was Species.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.JavaSorter,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.combined.CombinedSearchPaginator,
                 ro.finsiel.eunis.jrfTables.combined.SpeciesCombinedDomain,
                 ro.finsiel.eunis.jrfTables.combined.SpeciesCombinedPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSortCriteria" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,combined_search#combined-search.jsp,results";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("generic_combined-search-results-species_title")%>
  </title>
</head>
<%
  AbstractPaginator paginator = null;
  // Database where to search. Possible values are: Species, Habitat types or Sites
  ////// SPECIES //////
  //  Utilities.dumpRequestParams(request);
  String searchedDatabase = formBean.getSearchedNatureObject();
  paginator = new CombinedSearchPaginator(new SpeciesCombinedDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "combined-search-results-species.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showGroup = (columnsDisplayed.contains("showGroup")) ? true : false;
  boolean showOrder = (columnsDisplayed.contains("showOrder")) ? true : false;
  boolean showFamily = (columnsDisplayed.contains("showFamily")) ? true : false;
  boolean showScientificName = (columnsDisplayed.contains("showScientificName")) ? true : false;
  boolean showVernacularName = (columnsDisplayed.contains("showVernacularName")) ? true : false;
  boolean showDistribution = (columnsDisplayed.contains("showDistribution")) ? true : false;
  boolean showThreat = (columnsDisplayed.contains("showThreat")) ? true : false;
  boolean showReferences = (columnsDisplayed.contains("showReferences")) ? true : false;
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
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <table summary="layout" width="100%" border=0 cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <h1>
                        <%=cm.cmsText("generic_combined-search-results-species_01")%>
                      </h1>
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <strong><%=cm.cmsText("generic_combined-search-results-species_02")%></strong>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinednatureobject1()%>
                            <%=cm.cmsText("generic_combined-search-results-species_03")%>
                            <%=SessionManager.getCombinedexplainedcriteria1()%>
                            <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinedlistcriteria1() != null ? SessionManager.getCombinedlistcriteria1() : "&nbsp;"%>
                          </td>
                        </tr>
                <%
                  if(SessionManager.getCombinednatureobject2() != null) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinednatureobject2()%>
                            <%=cm.cmsText("generic_combined-search-results-species_03")%>
                            <%=SessionManager.getCombinedexplainedcriteria2()%>
                            <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinedlistcriteria2() != null ? SessionManager.getCombinedlistcriteria2() : "&nbsp;"%>
                          </td>
                        </tr>
                <%
                  if(SessionManager.getCombinednatureobject2().equalsIgnoreCase("Sites")) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=cm.cmsText("source_data_sets")%>
                            <%=SessionManager.getSourcedb()%>
                          </td>
                        </tr>
                <%
                    }
                  }
                %>
                <%
                  if(SessionManager.getCombinednatureobject3() != null) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinednatureobject3()%>
                            <%=cm.cmsText("generic_combined-search-results-species_03")%>
                            <%=SessionManager.getCombinedexplainedcriteria3()%>
                            <%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=SessionManager.getCombinedlistcriteria3() != null ? SessionManager.getCombinedlistcriteria3() : "&nbsp;"%>
                          </td>
                        </tr>
                <%
                  if(SessionManager.getCombinednatureobject3().equalsIgnoreCase("Sites")) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=cm.cmsText("source_data_sets")%>
                            <%=SessionManager.getSourcedb()%>
                          </td>
                        </tr>
                <%
                    }
                  }
                %>
                <%
                  if(SessionManager.getCombinedcombinationtype() != null) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
                            <%=cm.cmsText("combination_type")%>
                            <%=SessionManager.getCombinedcombinationtype()%>
                          </td>
                        </tr>
                <%
                } else {
                  if(SessionManager.getCombinednatureobject2() != null) {
                %>
                        <tr>
                          <td bgcolor="#FFFFFF">
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
                          <td bgcolor="#FFFFFF">
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
                      <br />
                      <%=cm.cmsText("results_found_1")%>
                      <strong><%=resultsCount%></strong>
                      <br />
                <%// Prepare parameters for pagesize.jsp
                  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
                %>
                      <jsp:include page="pagesize.jsp">
                        <jsp:param name="guid" value="<%=guid + 1%>" />
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
                        <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                        <jsp:param name="pageName" value="<%=pageName%>" />
                        <jsp:param name="guid" value="<%=guid%>" />
                        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                      </jsp:include>
                  <%// Compute the sort criteria
                  Vector sortURLFields = new Vector();      /* Used for sorting */
                  sortURLFields.addElement("pageSize");
                  String urlSortString = formBean.toURLParam(sortURLFields);
                  AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_GROUP);
                  AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ORDER);
                  AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_FAMILY);
                  AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SCIENTIFIC_NAME);

                  // Expand/Collapse vernacular names
                  Vector expand = new Vector();
                  expand.addElement("sort");
                  expand.addElement("ascendency");
                  expand.addElement("pageSize");
                  expand.addElement("currentPage");
                  String expandURL = formBean.toURLParam(expand);%>
                  <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                    <thead>
                      <tr>
                        <%
                          if(showGroup)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showOrder)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, (null == sortOrder) ? true : false)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order_column")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showFamily)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, (null == sortFamily) ? true : false)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showScientificName)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showVernacularName)
                          {
                        %>
                        <th scope="col">
                          <%=Utilities.getSortImageTag(sortSciName)%>
                          <%=cm.cmsText("vernacular_names")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showThreat || showDistribution || showReferences) {
                        %>
                        <th scope="col" style="text-align : center;">
                          <%=cm.cmsText("other_info")%>
                        </th>
                        <%
                          }
                        %>
                      </tr>
                    </thead>
                    <tbody>
                <%
                  int col = 0;
                  while(it.hasNext()) {
                    String cssClass = col++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                    SpeciesCombinedPersist specie = (SpeciesCombinedPersist) it.next();
                    String order = Utilities.formatString(specie.getTaxonomicNameOrder());
                    String family = Utilities.formatString(specie.getTaxonomicNameFamily());
                    Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                    Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
                %>
                      <tr<%=cssClass%>>
                    <%
                      if(showGroup)
                      {
                    %>
                        <td>
                          <%=specie.getCommonName()%>
                        </td>
                    <%
                      }
                    %>
                    <%
                      if(showOrder)
                      {
                    %>
                        <td>
                          <%=order%>&nbsp;
                        </td>
                    <%
                      }
                    %>
                    <%
                      if(showFamily)
                      {
                    %>
                        <td>
                          <%=family%>&nbsp;
                        </td>
                    <%
                      }
                    %>
                    <%
                      if(showScientificName)
                      {
                    %>
                        <td>
                          <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=specie.getScientificName()%></a>
                          <%=cm.cmsTitle("open_species_factsheet")%>
                        </td>
                    <%
                      }
                    %>
                    <%
                      if(showVernacularName)
                      {
                    %>
                        <td>
                          <table summary="<%=cm.cms("vernacular_names")%>" width="100%" border="0" cellspacing="0" cellpadding="0">
                            <%
                              String bgColor1 = "";
                              for(int i = 0; i < sortVernList.size(); i++) {
                                VernacularNameWrapper aVernName = (VernacularNameWrapper) sortVernList.get(i);
                                String vernacularName = aVernName.getName();
                                bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";%>
                            <tr>
                              <td bgcolor="<%=bgColor1%>">&nbsp;<%=aVernName.getLanguage()%></td>
                              <td bgcolor="<%=bgColor1%>">&nbsp;<%=vernacularName%></td>
                            </tr>
                            <%
                              }
                            %>
                          </table>
                        </td>
                    <%
                      }
                    %>
                    <%
                      if(showThreat || showDistribution || showReferences)
                      {
                    %>
                        <td style="text-align : center;">
                    <%
                        if(showDistribution)
                        {
                    %>
                          <a title="<%=cm.cms("show_species_geographical_distribution")%>" href="javascript:MM_openBrWindow('species-factsheet-geo.jsp?name=<%=specie.getScientificName()%>&amp;idSpecies=<%=specie.getIdSpecies()%>&amp;idNatureObject=<%=specie.getIdNatureObject()%>','','scrollbars=yes,resizable=yes,width=640,height=480')"><img alt="Species geographical distribution" src="images/mini/globe.gif" border="0" /></a>
                          <%=cm.cmsTitle("show_species_geographical_distribution")%>
                    <%
                        }
                    %>
                    <%
                      if(showThreat)
                      {
                    %>
                          <a title="<%=cm.cms("show_species_threat_status")%>" href="javascript:openlink('species-factsheet-threat.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;scName=<%=specie.getScientificName()%>');"><img alt="Show species threat status" src="images/mini/threat.gif" border="0" /></a>
                          <%=cm.cmsTitle("show_species_threat_status")%>
                    <%
                      }
                    %>
                    <%
                      if(showReferences)
                      {
                    %>
                          <a title="<%=cm.cms("show_species_references")%>" href="javascript:openlink('species-factsheet-references.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>&amp;name=<%=specie.getScientificName()%>&amp;idNatureObject=<%=specie.getIdNatureObject()%>')"><img alt="Show species references" src="images/mini/references.gif" border="0" /></a>
                          <%=cm.cmsTitle("show_species_references")%>
                    <%
                      }
                    %>
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
                          if(showGroup)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showOrder)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, (null == sortOrder) ? true : false)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order_column")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showFamily)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, (null == sortFamily) ? true : false)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showScientificName)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
                          <%=cm.cmsMsg("sort_results_on_this_column")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showVernacularName)
                          {
                        %>
                        <th scope="col">
                          <%=Utilities.getSortImageTag(sortSciName)%>
                          <%=cm.cmsText("vernacular_names")%>
                        </th>
                        <%
                          }
                        %>
                        <%
                          if(showThreat || showDistribution || showReferences) {
                        %>
                        <th scope="col" style="text-align : center;">
                          <%=cm.cmsText("other_info")%>
                        </th>
                        <%
                          }
                        %>
                      </tr>
                    </thead>
                  </table>
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
                  <%=cm.cmsMsg("generic_combined-search-results-species_title")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("search_results")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("vernacular_names")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="combined-search-results-species.jsp" />
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
