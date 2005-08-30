<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain,
                 ro.finsiel.eunis.jrfTables.habitats.code.CodePersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 ro.finsiel.eunis.search.habitats.code.*,
                 java.util.Iterator" %>
<%@ page import="java.util.List" %><%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.code.CodeBean" scope="page">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <%
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), CodeBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), CodeBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), CodeBean.HIDE);
    boolean showOtherCodes = Utilities.checkedStringToBoolean(formBean.getShowOtherCodes(), CodeBean.HIDE);
    //boolean showEnglishName = Utilities.checkedStringToBoolean(formBean.getShowEnglishName(), CodeBean.HIDE);
    // Set number criteria for the search result
    int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);

    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), CodeDomain.SEARCH_EUNIS);
    // The main paginator
    CodePaginator paginator = new CodePaginator(new CodeDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), database));
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-code-result.jsp";
    int pagesCount = paginator.countPages();// This is used in @page include...
    int guid = 0;// This is used in @page include...
    // Now extract the results for the current page.
    List results = paginator.getPage(currentPage);

    // Prepare parameters for tsvlink
    Vector reportFields = new Vector();
    reportFields.addElement("sort");
    reportFields.addElement("ascendency");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("oper");
    reportFields.addElement("criteriaType");

    String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-code.jsp?" + formBean.toURLParam(reportFields) + "')";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_code-result_title", false)%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
  function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
  }
  //-->
  </script>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Code#habitats-code.jsp,Results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<%--  <jsp:param name="printLink" value="<%=pdfLink%>" />--%>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h5>
  <%=contentManagement.getContent("habitats_code-result_01")%>
</h5>
<%-- Here are the main search criterias displayed to the user --%>
<%AbstractSearchCriteria mainCriteria = formBean.getMainSearchCriteria();%>
<table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <%=contentManagement.getContent("habitats_code-result_02")%>
      <strong>
        <%=Utilities.getSourceHabitat(database, CodeDomain.SEARCH_ANNEX.intValue(), CodeDomain.SEARCH_BOTH.intValue())%>
      </strong>
      <%=contentManagement.getContent("habitats_code-result_03")%>
      <strong>
        <%=mainCriteria.toHumanString()%>
      </strong>
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
<%=contentManagement.getContent("habitats_code-result_04")%>:<strong><%=resultsCount%></strong>
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
<%// Prepare the form parameters.
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
<table width="100%" border="0" summary="layout" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=contentManagement.getContent("habitats_code-result_05")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="habitats-code-result.jsp">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow">Criteria</label>
        <select title="Criteria" id="criteriaType" name="criteriaType" class="inputTextField">
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_EUNIS)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_code-result_06", false)%></option>
          <%
            }
          %>
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_ANNEX)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_code-result_07", false)%></option>
          <%
            }
          %>
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_BOTH)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_code-result_06", false)%></option>
          <option value="<%=CodeSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=contentManagement.getContent("habitats_code-result_07", false)%></option>
          <%
            }
          %>
          <%
            if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_LEVEL%>"><%=contentManagement.getContent("habitats_code-result_08", false)%></option>
          <%
            }
          %>
          <%
            if (showScientificName) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_code-result_09", false)%></option>
          <%
            }
          %>
        </select>
        <label for="oper" class="noshow">Operator</label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_code-result_10", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_code-result_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_code-result_12", false)%></option>
        </select>
        <label for="criteriaSearch" class="noshow">Search value</label>
        <input title="Search value" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <label for="Submit" class="noshow">Search</label>
        <input title="Search" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_code-result_13", false)%>" />
        <%=contentManagement.writeEditTag("habitats_code-result_13")%>
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
      <%=contentManagement.getContent("habitats_code-result_14")%>:
    </td>
  </tr>
  <%
    }
  %>
  <%for (int i = criterias.length - 1; i > 0; i--) {%>
  <%AbstractSearchCriteria criteria = criterias[i];%>
  <%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
  <tr>
    <td bgcolor="#CCCCCC" align="left">
      <a title="Delete filter" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
        <img alt="Delete filter" src="images/mini/delete.jpg" border="0" align="middle" />
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
  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(CodeSortCriteria.SORT_LEVEL);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(CodeSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(CodeSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(CodeSortCriteria.SORT_ANNEX_CODE);
%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%
    if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
  %>
  <th class="resultHeader" align="left" width="56">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_code-result_08")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_code-result_06")%>
    </a>
  </th>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_code-result_07")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader" align="left" width="180">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_code-result_09")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showOtherCodes) {
  %>
  <th class="resultHeader" align="center" width="361">

      <%=contentManagement.getContent("habitats_code-result_15")%>

  </th>
  <%
    }
  %>
</tr>
<%
  int i = 0;
  Iterator it = results.iterator();
  while (it.hasNext()) {
    CodePersist habitat = (CodePersist) it.next();
    String rowBgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
    int level = habitat.getHabLevel().intValue();
    String eunisCode = habitat.getEunisHabitatCode();
    //String annexCode = habitat.getCodeAnnex1();
    String annexCode = habitat.getCode2000();
    int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
    boolean isEUNIS = idHabitat <= 10000;
    if (isEUNIS) {
      annexCode = "&nbsp;";
    } else {
      eunisCode = "&nbsp;";
    }
%>
<tr bgcolor="<%=rowBgColor%>">
  <%if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {%>
  <td align="left" width="90" style="white-space:nowrap">
    <%for (int iter = 0; iter < level; iter++) {%>
    <img title="" src="images/mini/lev_blank.gif" alt="" style="vertical-align:middle" />
    <%}%>
    <%=level%>
  </td>
  <%}%>
  <%if (showCode) {%>
  <td align="left" width="30"><%=eunisCode%></td>
  <td align="left" width="30"><%=annexCode%></td>
  <%}%>
  <%if (showScientificName) {%>
  <td align="left" width="180">
    <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
  </td>
  <%}%>
  <%
    if (showOtherCodes) {
      List otherClassifications = HabitatsSearchUtility.findOtherClassifications(idHabitat, relationOp, formBean.getSearchString());
  %>
  <td align="left" width="361">
    <table width="100%">
      <%for (int j = 0; j < otherClassifications.size(); j++) {
        OtherClassWrapper classification = (OtherClassWrapper) otherClassifications.get(j);%>
      <tr>
        <td align="left"><%=classification.getCode()%></td>
        <td align="left"><%=classification.getClassificatioName()%></td>
        <td align="left">(<%=classification.getRelationDecoded()%>)</td>
      </tr>
      <%}%>
    </table>
  </td>
  <%
    }
  %>
</tr>
<%
  }
%>
<tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
  <%
    if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
  %>
  <th class="resultHeader" align="left" width="56">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_code-result_08")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_code-result_06")%>
    </a>
  </th>
  <th class="resultHeader" align="left" width="30">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_code-result_07")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader" align="left" width="180">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_code-result_09")%>
    </a>
  </th>
  <%
    }
  %>
  <%
    if (showOtherCodes) {
  %>
  <th class="resultHeader" align="center" width="361">

      <%=contentManagement.getContent("habitats_code-result_15")%>

  </th>
  <%
    }
  %>
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
  <jsp:param name="page_name" value="habitats-code-result.jsp" />
</jsp:include>
  </div>
</body>
</html>