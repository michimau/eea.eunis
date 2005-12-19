<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.code.CodeBean" scope="page">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    boolean showExpanded = Utilities.checkedStringToBoolean(request.getParameter("expanded"),false);
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), CodeBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), CodeBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), CodeBean.HIDE);
    boolean showOtherCodes = Utilities.checkedStringToBoolean(formBean.getShowOtherCodes(), CodeBean.HIDE);
    String searchedClassification = formBean.getClassificationCode();
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

    //String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-code.jsp?" + formBean.toURLParam(reportFields) + "')";
    String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-code.jsp?" + formBean.toURLParam(reportFields) + "')";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_code-result_title")%>
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
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_code_location#habitats-code.jsp,results_location" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h1>
  <%=cm.cmsText("habitats_code-result_01")%>
</h1>
<%-- Here are the main search criterias displayed to the user --%>
<%AbstractSearchCriteria mainCriteria = formBean.getMainSearchCriteria();%>
<table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <%=cm.cmsText("habitats_code-result_02")%>
      <strong>
        <%=Utilities.getSourceHabitat(database, CodeDomain.SEARCH_ANNEX.intValue(), CodeDomain.SEARCH_BOTH.intValue())%>
      </strong>
      <%=cm.cmsText("habitats_code-result_03")%>
      <strong>
        <%=mainCriteria.toHumanString()%> <strong><%=cm.cmsText("in_the_classification")%> <%=HabitatsSearchUtility.getClassificationName(formBean.getClassificationCode())%></strong>
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
<%=cm.cmsText("habitats_code-result_04")%>: <strong><%=resultsCount%></strong>
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
        <%=cm.cmsText("habitats_code-result_05")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="habitats-code-result.jsp">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow"><%=cm.cms("criteria")%></label>
        <select title="<%=cm.cms("criteria")%>" id="criteriaType" name="criteriaType" class="inputTextField">
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_EUNIS)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=cm.cms("habitats_code-result_06")%></option>
          <%
            }
          %>
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_ANNEX)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=cm.cms("habitats_code-result_07")%></option>
          <%
            }
          %>
          <%
            if (showCode && 0 == database.compareTo(CodeDomain.SEARCH_BOTH)) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=cm.cms("habitats_code-result_06")%></option>
          <option value="<%=CodeSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=cm.cms("habitats_code-result_07")%></option>
          <%
            }
          %>
          <%
            if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("habitats_code-result_08")%></option>
          <%
            }
          %>
          <%
            if (showScientificName) {
          %>
          <option value="<%=CodeSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitats_code-result_09")%></option>
          <%
            }
          %>
        </select>
        <%=cm.cmsLabel("criteria")%>
        <%=cm.cmsInput("habitats_code-result_06")%>
        <%=cm.cmsInput("habitats_code-result_07")%>
        <%=cm.cmsInput("habitats_code-result_08")%>
        <label for="oper" class="noshow"><%=cm.cms("operator")%></label>
        <select title="<%=cm.cms("operator")%>" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("habitats_code-result_10")%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("habitats_code-result_11")%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("habitats_code-result_12")%></option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsInput("habitats_code-result_10")%>
        <%=cm.cmsInput("habitats_code-result_11")%>
        <%=cm.cmsInput("habitats_code-result_12")%>
        <label for="criteriaSearch" class="noshow"><%=cm.cms("search_value")%></label>
        <input title="<%=cm.cms("search_value")%>" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <%=cm.cmsLabel("search_value")%>
        <label for="Submit" class="noshow"><%=cm.cms("search")%></label>
        <input title="Search" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=cm.cms("habitats_code-result_13")%>" />
        <%=cm.cmsLabel("search")%>
        <%=cm.cmsInput("habitats_code-result_13")%>
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
      <%=cm.cmsText("habitats_code-result_14")%>:
    </td>
  </tr>
  <%
    }
  %>
  <%for (int i = criterias.length - 1; i > 0; i--) {%>
  <%AbstractSearchCriteria criteria = criterias[i];%>
  <%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
  <tr>
    <td bgcolor="#CCCCCC">
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

<%
// Expand/Collapse other classifications
    Vector expand = new Vector();
    expand.addElement("sort");
    expand.addElement("ascendency");
    expand.addElement("criteriaSearch");
    expand.addElement("oper");
    expand.addElement("criteriaType");
    expand.addElement("pageSize");
    expand.addElement("currentPage");
    String expandURL = formBean.toURLParam(expand);

  if (showOtherCodes && !showExpanded)
  {
%>
   <a title="<%=cm.cms("show_habitats_codes_in_other_classifications")%>" href="<%=pageName + "?expanded=" + !showExpanded + expandURL%>"><%=cm.cmsText("show_habitats_codes_in_other_classifications")%></a>
<%
  }
%>
<table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%
  // Compute the sort criteria
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
<tr>
  <%
    if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
  %>
  <th class="resultHeader" width="56">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_code-result_08")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_code-result_06")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_code-result_07")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader" width="180">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_code-result_09")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showOtherCodes) {
  %>
  <th class="resultHeader" style="text-align : center;" width="361">

      <%=cm.cmsText("habitats_code-result_15")%>
  <%
     if(showExpanded) {
  %>
     <br />
     [<a title="<%=cm.cms("show_habitats_codes_in_other_classifications")%>" href="<%=pageName + "?expanded=" + !showExpanded + expandURL%>"><%=cm.cmsText("hide_other_classifications")%></a>]
      <%=cm.cmsTitle("show_habitats_codes_in_other_classifications")%>
  <%
      }
  %>
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
    String bgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
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
<tr>
  <%if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space:nowrap">
    <%for (int iter = 0; iter < level; iter++) {%>
    <img title="" src="images/mini/lev_blank.gif" alt="" style="vertical-align:middle" />
    <%}%>
    <%=level%>
  </td>
  <%}%>
  <%if (showCode) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=eunisCode%>
  </td>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=annexCode%>
  </td>
  <%}%>
  <%if (showScientificName) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
    <%=cm.cmsTitle("open_habitat_factsheet")%>
  </td>
  <%}%>
  <%
    if (showOtherCodes) {
      List otherClassifications = HabitatsSearchUtility.findOtherClassifications(idHabitat, relationOp, formBean.getSearchString());
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <table summary="layout" width="100%" border="1" cellspacing="0" cellpadding="0">
      <%
        int jj = 0;
        for (int j = 0; j < otherClassifications.size(); j++) {
          String bgColor1 = (0 == (jj++ % 2)) ? "#EEEEEE" : "#FFFFFF";
          OtherClassWrapper classification = (OtherClassWrapper) otherClassifications.get(j);

          if(!showExpanded) {
            if(!classification.getClassificationCode().equalsIgnoreCase(searchedClassification)) {
              continue;
            }
          }
         String beginStrong = "";
         String endStrong = "";

         if(showExpanded && classification.getClassificationCode().equalsIgnoreCase(searchedClassification))
         {
            beginStrong = "<strong>";
            endStrong = "</strong>";
         }
      %>
        <tr style="background-color:<%=bgColor1%>">
          <td><%=beginStrong%><%=classification.getCode()%><%=endStrong%></td>
          <td><%=beginStrong%><%=classification.getClassificatioName()%><%=endStrong%></td>
          <td><%=beginStrong%><%=classification.getRelationDecoded()%><%=endStrong%></td>
        </tr>
        <tr style="background-color:<%=bgColor1%>">
         <td colspan="3" style="text-align:left">
            <%=beginStrong%><%=Utilities.formatString(classification.getTitle(),"&nbsp;")%><%=endStrong%>
         </td>
        </tr>
      <%
        }
      %>
    </table>
  </td>
  <%
    }
  %>
</tr>
<%
  }
%>
<tr>
  <%
    if (0 == database.compareTo(CodeDomain.SEARCH_EUNIS) && showLevel) {
  %>
  <th class="resultHeader" width="56">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_code-result_08")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_code-result_06")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_code-result_07")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader" width="180">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CodeSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_code-result_09")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showOtherCodes) {
  %>
  <th class="resultHeader" style="text-align : center;" width="361">

      <%=cm.cmsText("habitats_code-result_15")%>
  <%
     if(showExpanded) {
  %>
     <br />
     [<a title="<%=cm.cms("show_habitats_codes_in_other_classifications")%>" href="<%=pageName + "?expanded=" + !showExpanded + expandURL%>"><%=cm.cmsText("hide_other_classifications")%></a>]
      <%=cm.cmsTitle("show_habitats_codes_in_other_classifications")%>
  <%
      }
  %>
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
  <%=cm.br()%>
  <%=cm.cmsMsg("habitats_code-result_title")%>
  <%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-code-result.jsp" />
</jsp:include>
  </div>
  </div>
  </div>
</body>
</html>
