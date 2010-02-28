<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species advanced search results.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.jrfTables.species.advanced.DictionaryPersist,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.JavaSorter,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.advanced.DictionaryPaginator,
                 ro.finsiel.eunis.jrfTables.species.advanced.DictionaryDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  AbstractPaginator paginator = null;
  //String searchedDatabase = formBean.getSearchedNatureObject();
  paginator = new DictionaryPaginator(new DictionaryDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "species-advanced-results.jsp";
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
//  boolean showDistribution = (columnsDisplayed.contains("showDistribution")) ? true : false;
//  boolean showThreat = (columnsDisplayed.contains("showThreat")) ? true : false;
//  boolean showCountry = (columnsDisplayed.contains("showCountry")) ? true : false;
//  boolean showRegion = (columnsDisplayed.contains("showRegion")) ? true : false;
//  boolean showSynonyms = (columnsDisplayed.contains("showSynonyms")) ? true : false;
//  boolean showReferences = (columnsDisplayed.contains("showReferences")) ? true : false;
  boolean showSource = (columnsDisplayed.contains("showSource")) ? true : false;
  boolean showEditor = (columnsDisplayed.contains("showEditor")) ? true : false;
  boolean showBookTitle = (columnsDisplayed.contains("showBookTitle")) ? true : false;


  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String downloadLink = "javascript:openTSVDownload('reports/species/tsv-species-advanced.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,advanced_search#species-advanced.jsp,results";
  if (results.isEmpty())
  {
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
      </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=cm.cms("species_advanced_search_results")%></title>
  </head>
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
                  <jsp:param name="location" value="<%=location%>"/>
                  <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <h1>
                  <%=cm.cmsText("species_advanced_search_results")%>
                </h1>
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
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <%=cm.cmsText("species_advanced_result_02")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("criteria_combination_used")%> <%=SessionManager.getExplainedcriteria()%><%=cm.cmsText("generic_combined-search-results-habitats_04")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=SessionManager.getListcriteria()%>
                    </td>
                  </tr>
                </table>
              <br />
              <%=cm.cmsText("results_found_1")%> <strong><%=resultsCount%></strong>
              <br />
          <%
            // Prepare parameters for pagesize.jsp
            Vector pageSizeFormFields = new Vector();
            pageSizeFormFields.addElement("sort");
            pageSizeFormFields.addElement("ascendency");
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
            Vector navigatorFormFields = new Vector();
            navigatorFormFields.addElement("pageSize");
            navigatorFormFields.addElement("sort");
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
          <%
            Vector sortURLFields = new Vector();
            sortURLFields.addElement("pageSize");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_GROUP);
            AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ORDER);
            AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_FAMILY);
            AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SCIENTIFIC_NAME);
          %>
              <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                <thead>
                  <tr>
          <%
            if (showGroup)
            {
          %>
                    <th scope="col">
                      <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
                      <%=cm.cmsTitle("sort_results_on_this_column")%>
                    </th>
          <%
            }
            if (showOrder)
            {
          %>
                    <th scope="col">
                      <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, null == sortOrder)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order_column")%></a>
                      <%=cm.cmsTitle("sort_results_on_this_column")%>
                    </th>
          <%
            }
            if (showFamily)
            {
          %>
                    <th scope="col">
                      <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, null == sortFamily)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
                      <%=cm.cmsTitle("sort_results_on_this_column")%>
                    </th>
          <%
            }
            if (showScientificName)
            {
          %>
                    <th scope="col">
                      <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
                      <%=cm.cmsTitle("sort_results_on_this_column")%>
                    </th>
          <%
            }
            if (showVernacularName)
            {
          %>
                    <th scope="col">
                      <%=cm.cmsText("vernacular_name")%>
                    </th>
          <%
            }
            if (showSource)
            {
          %>
                    <th scope="col">
                      <%=cm.cmsText("source")%>
                    </th>
          <%
            }
            if (showEditor)
            {
          %>
                    <th scope="col">
                      <%=cm.cmsText("editor")%>
                    </th>
          <%
            }
            if (showBookTitle)
            {
          %>
                    <th scope="col">
                      <%=cm.cmsText("title")%>
                    </th>
          <%
            }
          %>
                  </tr>
                </thead>
                <tbody>
          <%
            int col = 0;
            while (it.hasNext())
            {
              String cssClass = col++ % 2 == 0 ? " class=\"zebraeven\"" : "";
              DictionaryPersist specie = (DictionaryPersist)it.next();
              String order = Utilities.formatString(specie.getTaxonomicNameOrder());
              String family = Utilities.formatString(specie.getTaxonomicNameFamily());
              Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
              Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
          %>
                <tr<%=cssClass%>>
          <%
            if (showGroup)
            {
          %>
                  <td>
                    <%=specie.getCommonName()%>
                  </td>
          <%
            }
            if (showOrder)
            {
          %>
                  <td>
                    <%=order%>
                  </td>
          <%
            }
            if (showFamily)
            {
          %>
                  <td>
                    <%=family%>
                  </td>
          <%
            }
            if (showScientificName)
            {
          %>
                  <td>
                    <a href="species/<%=specie.getIdSpecies()%>"><%=specie.getScientificName()%></a>
                  </td>
          <%
            }
            if (showVernacularName)
            {
          %>
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <%
              String bgColor1 = "";
              for (int i = 0; i < sortVernList.size(); i++)
              {
                VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
                String vernacularName = aVernName.getName();
                bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
          %>
                      <tr>
                        <td bgcolor="<%=bgColor1%>">
                          <%=aVernName.getLanguage()%>
                        </td>
                        <td bgcolor="<%=bgColor1%>">
                          <%=vernacularName%>
                        </td>
                      </tr>
          <%
              }
          %>
                    </table>
                  </td>
          <%
            }
            if (showSource)
            {
          %>
                  <td>
                    <%=specie.getSource()%>
                  </td>
          <%
            }
            if (showEditor)
            {
          %>
                  <td>
                    <%=specie.getEditor()%>
                  </td>
          <%
            }
            if (showBookTitle) {%>
                  <td>
                    <%=specie.getBookTitle()%>&nbsp;
                  </td>
          <%
            }
          %>
                </tr>
              </tbody>
              <thead>
          <%
            }
          %>
                <tr>
          <%
            if (showGroup)
            {
          %>
                  <th scope="col">
                    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
                    <%=cm.cmsTitle("sort_results_on_this_column")%>
                  </th>
          <%
            }
            if (showOrder)
            {
          %>
                  <th scope="col">
                    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, null == sortOrder)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order_column")%></a>
                    <%=cm.cmsTitle("sort_results_on_this_column")%>
                  </th>
          <%
            }
            if (showFamily)
            {
          %>
                  <th scope="col">
                    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, null == sortFamily)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
                    <%=cm.cmsTitle("sort_results_on_this_column")%>
                  </th>
          <%
            }
            if (showScientificName)
            {
          %>
                  <th scope="col">
                    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
                    <%=cm.cmsTitle("sort_results_on_this_column")%>
                  </th>
          <%
            }
            if (showVernacularName)
            {
          %>
                  <th scope="col">
                    <%=cm.cmsText("vernacular_name")%>
                  </th>
          <%
            }
            if (showSource)
            {
          %>
                  <th scope="col">
                    <%=cm.cmsText("source")%>
                  </th>
          <%
            }
            if (showEditor)
            {
          %>
                  <th scope="col">
                    <%=cm.cmsText("editor")%>
                  </th>
          <%
            }
            if (showBookTitle)
            {
          %>
                  <th scope="col">
                    <%=cm.cmsText("title")%>
                  </th>
          <%
            }
          %>
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
              <%=cm.br()%>
              <%=cm.cmsMsg("species_advanced_search_results")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("search_results")%>
              <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-advanced-results.jsp" />
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
