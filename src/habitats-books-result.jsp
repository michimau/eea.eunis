<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
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
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.references.ReferencesBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_books-result_title", false)%>
  </title>
  <%
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
    String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-books.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,References#habitats-books.jsp,Results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h5><%=contentManagement.getContent("habitats_books-result_01")%></h5>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <%
    // Set search description
    StringBuffer descr = Utilities.prepareHumanString("scientific name", formBean.getScientificName(), Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS));
  %>
  <tr>
    <td>
      <%=contentManagement.getContent("habitats_books-result_02")%>
      <strong><%=Utilities.getSourceHabitat(database, HabitatsBooksDomain.SEARCH_ANNEX_I.intValue(), HabitatsBooksDomain.SEARCH_BOTH.intValue())%> <%=contentManagement.getContent("habitats_books-result_03")%> <%=descr%></strong>
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
<%=contentManagement.getContent("habitats_books-result_04")%>:&nbsp;<strong><%=resultsCount%></strong>
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
        <%=contentManagement.getContent("habitats_books-result_05")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow">Criteria</label>
        <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
          <option value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>"><%=contentManagement.getContent("habitats_books-result_06", false)%></option>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_DATE%>"><%=contentManagement.getContent("habitats_books-result_07", false)%></option>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_TITLE%>" selected="selected"><%=contentManagement.getContent("habitats_books-result_08", false)%></option>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_EDITOR%>"><%=contentManagement.getContent("habitats_books-result_09", false)%></option>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_PUBLISHER%>"><%=contentManagement.getContent("habitats_books-result_10", false)%></option>
        </select>
        <label for="oper" class="noshow">Operator</label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_books-result_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_books-result_12", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_books-result_13", false)%></option>
        </select>

        <label for="criteriaSearch" class="noshow">Search value</label>
        <input title="Search value" type="text" name="criteriaSearch" id="criteriaSearch" size="30" class="inputTextField" />
        <label for="Submit" class="noshow">Search</label>
        <input title="Search" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_books-result_14", false)%>" class="inputTextField" />
        <%=contentManagement.writeEditTag("habitats_books-result_14")%>
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
      <%=contentManagement.getContent("habitats_books-result_15")%>:
    </td>
  </tr>
  <%
    }
    for (int i = criterias.length - 1; i > 0; i--) {
      AbstractSearchCriteria criteria = criterias[i];
      if (null != criteria && null != formBean.getCriteriaSearch()) {
  %>
  <tr>
    <td bgcolor="#CCCCCC" align="left">
      <a href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
        <img src="images/mini/delete.jpg" alt="Delete" border="0" align="middle" />
      </a>
      &nbsp;&nbsp;
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
<table summary="Search results" border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
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
<tr>
  <th class="resultHeader" width="16%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortAuthor)%><%=contentManagement.getContent("habitats_books-result_06")%>
    </a>
  </th>
  <th class="resultHeader" width="7%" align="center">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortDate)%><%=contentManagement.getContent("habitats_books-result_07")%>
    </a>
  </th>
  <th class="resultHeader" width="19%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
      <%=Utilities.getSortImageTag(sortTitle)%><%=contentManagement.getContent("habitats_books-result_08")%>
    </a>
  </th>
  <th class="resultHeader" width="19%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortEditor)%><%=contentManagement.getContent("habitats_books-result_09")%>
    </a>
  </th>
  <th class="resultHeader" width="20%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortPublisher)%><%=contentManagement.getContent("habitats_books-result_10")%>
    </a>
  </th>
  <th class="resultHeader" width="15%" align="center">
    <%=contentManagement.getContent("habitats_books-result_16")%>
  </th>
  <th class="resultHeader" width="20%" align="center">
    <%=contentManagement.getContent("habitats_books-result_17")%>
  </th>
</tr>
<%
  // Display results
  if (null != results) {
    Iterator it = results.iterator();
    while (it.hasNext()) {
      HabitatsBooksPersist book = (HabitatsBooksPersist) it.next();
%>
<tr>
  <td align="left">
    &nbsp;<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getsource()))%>
  </td>
  <td align="center">
    &nbsp;<%=Utilities.formatReferencesDate(book.getcreated())%>
  </td>
  <td align="left">
    &nbsp;<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.gettitle()))%>
  </td>
  <td align="left" style="white-space:nowrap">
    &nbsp;<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.geteditor()))%>
  </td>
  <td align="left">
    &nbsp;<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getpublisher()))%>
  </td>
  <%--                <%--%>
  <%--                    String d = search + "&amp;id=" + book.getidDC()+"&amp;database="+formBean.getDatabase();--%>
  <%--                %>--%>
  <td align="center">
    &nbsp;<%=Utilities.returnSourceValueReferences(book.getHaveSource())%>
  </td>
  <td align="center">
    <%--                  <a href="javascript:openlink('habitats-books-detail.jsp?<%=d%>')"><img src="images/group/10.gif" border="0"></a>--%>
    <%
      // Request parameter
      HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain(formBean.toSearchCriteria(), database);
      // Set the result list
      List resultsHabitats = habitatsBooks.getHabitatsByReferences(book.getidDC().toString(), true);


      if (resultsHabitats != null && resultsHabitats.size() > 0) {
    %>
    <table summary="Habitat types" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
      <%
        for (int ii = 0; ii < resultsHabitats.size(); ii++) {
          TableColumns tableColumns = (TableColumns) resultsHabitats.get(ii);
          String scientificName = (String) tableColumns.getColumnsValues().get(0);
          String idHabitat = (String) tableColumns.getColumnsValues().get(1);
      %>
      <tr bgcolor="#FFFFFF">
        <td>
          <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=idHabitat%>"><%=scientificName%></a>
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
<tr>
  <th class="resultHeader" width="16%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortAuthor)%><%=contentManagement.getContent("habitats_books-result_06")%>
    </a>
  </th>
  <th class="resultHeader" width="7%" align="center">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortDate)%><%=contentManagement.getContent("habitats_books-result_07")%>
    </a>
  </th>
  <th class="resultHeader" width="19%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
      <%=Utilities.getSortImageTag(sortTitle)%><%=contentManagement.getContent("habitats_books-result_08")%>
    </a>
  </th>
  <th class="resultHeader" width="19%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortEditor)%><%=contentManagement.getContent("habitats_books-result_09")%>
    </a>
  </th>
  <th class="resultHeader" width="20%" align="left">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortPublisher)%><%=contentManagement.getContent("habitats_books-result_10")%>
    </a>
  </th>
  <th class="resultHeader" width="15%" align="center">
    <%=contentManagement.getContent("habitats_books-result_16")%>
  </th>
  <th class="resultHeader" width="20%" align="center">
    <%=contentManagement.getContent("habitats_books-result_17")%>
  </th>
</tr>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-books-result.jsp" />
</jsp:include>
  </div>
</body>
</html>