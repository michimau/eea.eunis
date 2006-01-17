<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show habitats' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain,
                 ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesBean,
                 ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesPaginator,
                 ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesSortCriteria,
                 java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
    function MM_openBrWindow(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }

      function openPopup(theURL,winName,features) {
        window.open(theURL,winName,features);
    }
  //-->
  </script>
  <%
    // Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    // Requets parameters
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), ReferencesBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), ReferencesBean.HIDE);
    //boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), ReferencesBean.HIDE);
    boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), ReferencesBean.HIDE);

    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), RefDomain.SEARCH_EUNIS);
    Integer source = Utilities.checkedStringToInt(formBean.getSource(), RefDomain.SOURCE);
    // Initialization
    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);

    // The main paginator
    ReferencesPaginator paginator = new ReferencesPaginator(new RefDomain(formBean.toSearchCriteria(),
      formBean.toSortCriteria(),
      database, source));

    //SpeciesPaginator paginator = new SpeciesPaginator(new InternationalThreatStatusDomain(formBean.toSearc);

    //paginator = new ReferencesPaginator(new InternationalThreatStatusDomain(formBean.toSearchCriteria()));
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-references-result.jsp";
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

    String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-references.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_references-result_title")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_references_location#habitats-references.jsp,results_location" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h1>
  <%=cm.cmsText("habitats_references-result_01")%>
</h1>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <%
    // Create mainCriteria object for main criteria description
    ReferencesSearchCriteria mainCriteria = (ReferencesSearchCriteria) formBean.getMainSearchCriteria();
  %>
  <tr>
    <td>
      <%=cm.cmsText("habitats_references-result_02")%>
      <strong><%=Utilities.getSourceHabitat(database, RefDomain.SEARCH_ANNEX_I.intValue(), RefDomain.SEARCH_BOTH.intValue())%></strong>
      <%=cm.cmsText("habitats_references-result_03")%>
      (
      <strong>
        <%
          if (0 == source.compareTo(RefDomain.SOURCE)) {
        %>
        <%=cm.cmsText("habitats_references-result_04")%>
        <%
        } else {
        %>
        <%=cm.cmsText("habitats_references-result_05")%>
        <%
          }
        %>
      </strong>)
      <%
        if (mainCriteria.toHumanString().length() > 0) {
      %>
      (
      <%=cm.cmsText("habitats_references-result_06")%>
      <strong>
        <%=mainCriteria.toHumanString()%>
      </strong>
      )
      <%
        }
      %>
      <%=cm.cmsText("habitats_references-result_07")%>
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
<%=cm.cmsText("habitats_references-result_08")%>:&nbsp;<strong><%=resultsCount%></strong>
<%
  // Prepare parameters for pagesize.jsp
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
<%
  // Prepare the form parameters.
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
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=cm.cmsText("habitats_references-result_09")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow"><%=cm.cms("Criteria")%></label>
        <select title="<%=cm.cms("Criteria")%>" name="criteriaType" id="criteriaType" class="inputTextField">
          <%
            if (showCode && 0 == database.compareTo(RefDomain.SEARCH_EUNIS)) {
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("habitats_references-result_10")%></option>
          <%
            }
            if (showCode && 0 == database.compareTo(RefDomain.SEARCH_ANNEX_I)) {
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("habitats_references-result_11")%></option>
          <%
            }
            if (showCode && 0 == database.compareTo(RefDomain.SEARCH_BOTH)) {
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("habitats_references-result_10")%></option>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("habitats_references-result_11")%></option>
          <%
            }
            if (showLevel && formBean.getDatabase().equalsIgnoreCase(RefDomain.SEARCH_EUNIS.toString())) {
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("habitats_references-result_12")%></option>
          <%
            }
            if (showVernacularName) {
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_NAME%>"><%=cm.cms("habitats_references-result_13")%></option>
          <%
            }
          %>
          <option value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitats_references-result_14")%></option>
        </select>
        <%=cm.cms("Criteria")%>
        <%=cm.cmsInput("habitats_references-result_10")%>
        <%=cm.cmsInput("habitats_references-result_11")%>
        <%=cm.cmsInput("habitats_references-result_12")%>
        <%=cm.cmsInput("habitats_references-result_13")%>
        <%=cm.cmsInput("habitats_references-result_14")%>
        <label for="oper" class="noshow"><%=cm.cms("operator")%></label>
        <select title="<%=cm.cms("operator")%>" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("habitats_references-result_15")%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("habitats_references-result_16")%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("habitats_references-result_17")%></option>
        </select>
        <%=cm.cms("operator")%>
        <%=cm.cmsInput("habitats_references-result_15")%>
        <%=cm.cmsInput("habitats_references-result_16")%>
        <%=cm.cmsInput("habitats_references-result_17")%>
        <label for="criteriaSearch" class="noshow"><%=cm.cms("search_value")%></label>
        <input title="<%=cm.cms("search_value")%>" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <%=cm.cmsTitle("search_value")%>
        <input title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=cm.cms("habitats_references-result_18")%>" />
        <%=cm.cmsTitle("search")%>
        <%=cm.cmsInput("habitats_references-result_18")%>
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
      <%=cm.cmsText("habitats_references-result_19")%>:
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
      <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_filter")%>" src="images/mini/delete.jpg" border="0" align="middle" /></a>
      <%=cm.cmsTitle("delete_filter")%>&nbsp;&nbsp;
      <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
    </td>
  </tr>
  <%
      }
    }
  %>
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
</td>
</tr>
<tr>
<td>
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
  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_LEVEL);
  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_ANNEX_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_VERNACULAR_NAME);
%>
<tr>
  <%
    if (showLevel && formBean.getDatabase().equalsIgnoreCase(RefDomain.SEARCH_EUNIS.toString())) {
  %>
  <th class="resultHeader" width="56">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_references-result_12")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (showCode) {
      if (0 == database.compareTo(RefDomain.SEARCH_BOTH)) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_references-result_10")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_references-result_11")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_references-result_10")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_ANNEX_I)) {
  %>
  <th title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeader" width="30">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_references-result_11")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
      }
    }
  %>
  <th class="resultHeader" width="261">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_references-result_14")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    if (showVernacularName) {
  %>
  <th class="resultHeader" width="166">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
      <%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitats_references-result_13")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
</tr>
<%
  int i = 0;
  Iterator it = results.iterator();
  // Display the result list
  while (it.hasNext()) {
    RefPersist habitat = (RefPersist) it.next();
    String bgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
    String eunisCode = habitat.getEunisCode();
    //String annexCode = habitat.getAnnex1Code();
    String annexCode = habitat.getCode2000();
    int level = habitat.getLevel().intValue();
    int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
    boolean isEUNIS = (idHabitat > 10000) ? false : true;
    if (isEUNIS) {
      annexCode = "";
    } else {
      eunisCode = "";
    }
%>
<tr>
  <%
    if (showLevel && formBean.getDatabase().equalsIgnoreCase(RefDomain.SEARCH_EUNIS.toString())) {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap;">
    <%
      for (int iter = 0; iter < level; iter++) {
    %>
    <img alt="" src="images/mini/lev_blank.gif" />
    <%
      }
    %>
    <%=habitat.getLevel()%>
  </td>
  <%
    }
    if (showCode) {
      if (0 == database.compareTo(RefDomain.SEARCH_BOTH)) {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=eunisCode%>
  </td>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=annexCode%>
  </td>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_EUNIS)) {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=eunisCode%>
  </td>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_ANNEX_I)) {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=annexCode%>
  </td>
  <%
      }
    }
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScName()%></a>
    <%=cm.cmsTitle("open_habitat_factsheet")%>
  </td>
  <%
    if (showVernacularName) {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=habitat.getDescription()%>
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
    if (showLevel && formBean.getDatabase().equalsIgnoreCase(RefDomain.SEARCH_EUNIS.toString())) {
  %>
  <th class="resultHeader" width="56">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
      <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_references-result_12")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (showCode) {
      if (0 == database.compareTo(RefDomain.SEARCH_BOTH)) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_references-result_10")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_references-result_11")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader" width="30">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
      <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_references-result_10")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
    if (0 == database.compareTo(RefDomain.SEARCH_ANNEX_I)) {
  %>
  <th title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeader" width="30">
    <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
      <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_references-result_11")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
      }
    }
  %>
  <th class="resultHeader" width="261">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_references-result_14")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    if (showVernacularName) {
  %>
  <th class="resultHeader" width="166">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
      <%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitats_references-result_13")%>
    </a>
  <%=cm.cmsTitle("sort_results_on_this_column")%>
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
<%=cm.cmsMsg("habitats_references-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("search_results")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-references-result.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
</body>
</html>