<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                 ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.references.ReferencesPaginator,
                 ro.finsiel.eunis.search.habitats.references.ReferencesSearchCriteria" %>
<%@ page import="ro.finsiel.eunis.search.habitats.references.ReferencesSortCriteria" %>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.references.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) {
    formBean.prepareFilterCriterias();
  }
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  ReferencesPaginator paginator = null;
  // Request parameter
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatsBooksDomain.SEARCH_EUNIS);
  // The main paginator
  paginator = new ReferencesPaginator(new HabitatsBooksDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), database));
  // Initialization
  int resultsCount = paginator.countResults();
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));

  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "habitats-books-result.jsp";
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
  String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-books.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,pick_habitat_type_show_references#habitats-books.jsp,results";
  if (results.isEmpty())
  {
    boolean fromRefine = false;
    if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
    {
      fromRefine = true;
    }
%>
    <jsp:forward page="emptyresults.jsp">
      <jsp:param name="location" value="<%=location%>" />
      <jsp:param name="fromRefine" value="<%=fromRefine%>" />
    </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_books-result_title")%>
  </title>
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
                  <jsp:param name="location" value="<%=location%>" />
                  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <h1><%=cm.cmsPhrase("Pick habitat type, show references")%></h1>
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
                    <li>
                      <a href="habitats-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <%
                    // Set search description
                    StringBuffer descr = Utilities.prepareHumanString("scientific name", formBean.getScientificName(), Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS));
                  %>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("You searched for references for")%>
                      <strong><%=Utilities.getSourceHabitat(database, HabitatsBooksDomain.SEARCH_ANNEX_I.intValue(), HabitatsBooksDomain.SEARCH_BOTH.intValue())%> <%=cm.cmsPhrase("habitat types with")%> <%=descr%></strong>
                    </td>
                  </tr>
                </table>
                <%=cm.cmsPhrase("Results found")%>:&nbsp;<strong><%=resultsCount%></strong>
                <%
                  // Prepare parameters for pagesize.jsp
                  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
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
                  filterSearch.addElement("pageSize");
                %>
                <br />
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <strong>
                        <%=cm.cmsPhrase("Refine your search")%>
                      </strong>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
                        <%=formBean.toFORMParam(filterSearch)%>
                        <label for="criteriaType" class="noshow"><%=cm.cms("Criteria")%></label>
                        <select title="<%=cm.cms("Criteria")%>" name="criteriaType" id="criteriaType">
                          <option value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>"><%=cm.cms("author")%></option>
                          <option value="<%=ReferencesSearchCriteria.CRITERIA_DATE%>"><%=cm.cms("date")%></option>
                          <option value="<%=ReferencesSearchCriteria.CRITERIA_TITLE%>" selected="selected"><%=cm.cms("title")%></option>
                          <option value="<%=ReferencesSearchCriteria.CRITERIA_EDITOR%>"><%=cm.cms("editor")%></option>
                          <option value="<%=ReferencesSearchCriteria.CRITERIA_PUBLISHER%>"><%=cm.cms("publisher")%></option>
                        </select>
                        <%=cm.cmsLabel("criteria")%>
                        <%=cm.cmsInput("author")%>
                        <%=cm.cmsInput("date")%>
                        <%=cm.cmsInput("title")%>
                        <%=cm.cmsInput("editor")%>
                        <%=cm.cmsInput("publisher")%>
                        <select title="<%=cm.cms("operator")%>" name="oper" id="oper">
                          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("is")%></option>
                          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("starts_with")%></option>
                          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                        </select>
                        <%=cm.cmsLabel("operator")%>
                        <%=cm.cmsInput("is")%>
                        <%=cm.cmsInput("starts_with")%>
                        <%=cm.cmsInput("contains")%>
                        <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_value")%></label>
                        <input title="<%=cm.cms("filter_value")%>" type="text" name="criteriaSearch" id="criteriaSearch" size="30" />
                        <%=cm.cmsTitle("filter_value")%>
                        <input title="<%=cm.cms("search")%>" type="submit" name="Submit" id="Submit" value="<%=cm.cms("search")%>" class="submitSearchButton" />
                        <%=cm.cmsTitle("search")%>
                        <%=cm.cmsInput("search")%>
                      </form>
                    </td>
                  </tr>
                  <%-- This is the code which shows the search filters --%>
                  <%
                    ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
                    if (criterias.length > 1) {
                  %>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <%=cm.cmsPhrase("Applied filters to the results")%>:
                    </td>
                  </tr>
                  <%
                    }
                    for (int i = criterias.length - 1; i > 0; i--) {
                      AbstractSearchCriteria criteria = criterias[i];
                      if (null != criteria && null != formBean.getCriteriaSearch()) {
                  %>
                  <tr>
                    <td bgcolor="#CCCCCC">
                      <a <%=cm.cms("delete_filter")%> href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
                        <img src="images/mini/delete.jpg" alt="<%=cm.cms("delete_filter")%>" border="0" style="vertical-align:middle" />
                      </a>
                      <%=cm.cmsTitle("delete_filter")%>&nbsp;&nbsp;
                      <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
                    </td>
                  </tr>
                  <%
                      }
                    }
                  %>
                </table>
                <br />
                <%
                  // Prepare parameters for navigator.jsp
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
                </td>
                </tr>
                <tr>
                <td>
                <%// Compute the sort criteria
                  Vector sortURLFields = new Vector();      /* Used for sorting */
                  sortURLFields.addElement("pageSize");
                  sortURLFields.addElement("criteriaSearch");
                  String urlSortString = formBean.toURLParam(sortURLFields);
                  AbstractSortCriteria sortAuthor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_AUTHOR);
                  AbstractSortCriteria sortDate = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_DATE);
                  AbstractSortCriteria sortTitle = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_TITLE);
                  AbstractSortCriteria sortEditor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_EDITOR);
                  AbstractSortCriteria sortPublisher = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_PUBLISHER);
                  Vector speciesURLFields = new Vector();
                  speciesURLFields.addElement("criteriaSearch");
                  String search = formBean.toURLParam(speciesURLFields);
                %>
                <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                  <thead>
                    <tr>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsPhrase("Author")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortDate)%><%=cm.cmsPhrase("Date")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th title="<%=cm.cms("sort_results_on_this_column")%>" scope="col">
                        <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
                          <%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsPhrase("Title")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsPhrase("Editor")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsPhrase("Publisher")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col" width="15%" style="text-align : center;">
                        <%=cm.cmsPhrase("Source type")%>
                      </th>
                      <th scope="col" width="20%" style="text-align : center;">
                        <%=cm.cmsPhrase("Habitat type(s)")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  // Display results
                  if (null != results)
                  {
                    int col = 0;
                    Iterator it = results.iterator();
                    while (it.hasNext())
                    {
                      String cssClass = col++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                      HabitatsBooksPersist book = (HabitatsBooksPersist) it.next();
                %>
                    <tr<%=cssClass%>>
                      <td>
                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getsource()), "&nbsp;")%>
                      </td>
                      <td style="text-align : center;">
                        <%=Utilities.formatString(Utilities.formatReferencesDate(book.getcreated() ), "&nbsp;")%>
                      </td>
                      <td>
                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.gettitle()), "&nbsp;")%>
                      </td>
                      <td style="white-space : nowrap">
                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.geteditor()), "&nbsp;")%>
                      </td>
                      <td>
                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getpublisher()), "&nbsp;")%>
                      </td>
                      <td style="text-align : center;">
                        <%=Utilities.returnSourceValueReferences(book.getHaveSource())%>
                      </td>
                      <td style="text-align : center;">
                      <%
                        // Request parameter
                        HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain(formBean.toSearchCriteria(), database);
                        // Set the result list
                        List resultsHabitats = habitatsBooks.getHabitatsByReferences(book.getidDC().toString(), true);


                        if (resultsHabitats != null && resultsHabitats.size() > 0)
                        {
                      %>
                        <table summary="<%=cm.cms("habitat_types")%>" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
                        <%
                          for (int ii = 0; ii < resultsHabitats.size(); ii++) {
                            TableColumns tableColumns = (TableColumns) resultsHabitats.get(ii);
                            String scientificName = (String) tableColumns.getColumnsValues().get(0);
                            String idHabitat = (String) tableColumns.getColumnsValues().get(1);
                        %>
                          <tr>
                            <td>
                              <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=idHabitat%>"><%=scientificName%></a>
                              <%=cm.cmsTitle("open_habitat_factsheet")%>
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
                  <%
                      }
                    }
                  %>
                  </tbody>
                  <thead>
                    <tr>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsPhrase("Author")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortDate)%><%=cm.cmsPhrase("Date")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th title="<%=cm.cms("sort_results_on_this_column")%>" scope="col">
                        <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
                          <%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsPhrase("Title")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsPhrase("Editor")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher) ? true : false)%>">
                          <%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsPhrase("Publisher")%>
                        </a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col" width="15%" style="text-align : center;">
                        <%=cm.cmsPhrase("Source type")%>
                      </th>
                      <th scope="col" width="20%" style="text-align : center;">
                        <%=cm.cmsPhrase("Habitat type(s)")%>
                      </th>
                    </tr>
                  </thead>
                </table>
                <br />
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
                <%=cm.cmsMsg("habitats_books-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_results")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitat_types")%>
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
                <jsp:param name="page_name" value="habitats-books-result.jsp" />
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
