<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.formBeans.AbstractFormBean,
                 ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalDomain,
                 ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 ro.finsiel.eunis.search.habitats.legal.LegalPaginator,
                 ro.finsiel.eunis.search.habitats.legal.LegalSearchCriteria,
                 ro.finsiel.eunis.search.habitats.legal.LegalSortCriteria,
                 java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.legal.LegalBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <%
    // Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    // Request parameters
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), AbstractFormBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), AbstractFormBean.HIDE);
    boolean showLegalText = Utilities.checkedStringToBoolean(formBean.getShowLegalText(), AbstractFormBean.HIDE);
    // Set number criteria for the search result
    int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    // The main paginator
    LegalPaginator paginator = new LegalPaginator(new EUNISLegalDomain(formBean.toSearchCriteria(), formBean.toSortCriteria()));
    // Initialization
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-legal-result.jsp";
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

    String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-legal.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_legal-result_title")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,legal_instruments#habitats-legal.jsp,results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h1><%=cm.cmsText("legal_instruments")%></h1>
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <%LegalSearchCriteria mainSearch = (LegalSearchCriteria) formBean.getMainSearchCriteria();%>
    <%String realSearch = (null != formBean.getSearchString() && formBean.getSearchString().equalsIgnoreCase("%")) ? "" : " for which " + mainSearch.toHumanString();
      String scientName = HabitatsSearchUtility.getHabitatLevelName(formBean.getHabitatType());%>
    <tr>
      <td>
        <%=cm.cmsText("habitats_legal-result_02")%>
        '<strong><%=scientName%>'
        <%=realSearch%>
        <%=cm.cmsText("habitats_legal-result_03")%>
        '<%=formBean.getLegalText()%>'
        <%=cm.cmsText("legal_text")%>
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
<%=cm.cmsText("results_found_1")%>:&nbsp;<strong><%=resultsCount%></strong>
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
<br />
<%
  // Prepare the form parameters.
  Vector filterSearch = new Vector();
  filterSearch.addElement("sort");
  filterSearch.addElement("ascendency");
  filterSearch.addElement("criteriaSearch");
  filterSearch.addElement("oper");
  filterSearch.addElement("criteriaType");
  filterSearch.addElement("pageSize");
  filterSearch.addElement("expand");%>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=cm.cmsText("refine_your_search")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow"><%=cm.cms("Criteria")%></label>
        <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
          <%if (showCode) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=cm.cms("eunis_code")%></option><%}%>
          <%if (showScientificName) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitat_type_name")%></option><%}%>
          <%if (showLegalText) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_LEGAL_TEXT%>"><%=cm.cms("legal_text")%></option><%}%>
        </select>
        <%=cm.cmsMsg("Criteria")%>
        <%=cm.cmsInput("eunis_code")%>
        <%=cm.cmsInput("habitat_type_name")%>
        <%=cm.cmsInput("legal_text")%>
        <label for="oper" class="noshow"><%=cm.cms("Criteria")%></label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("is")%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("starts_with")%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
        </select>
        <%=cm.cmsLabel("Criteria")%>
        <%=cm.cmsInput("is")%>
        <%=cm.cmsInput("starts_with")%>
        <%=cm.cmsInput("contains")%>
        <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_value")%></label>
        <input title="<%=cm.cms("filter_value")%>" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <%=cm.cmsTitle("filter_value")%>
        <input title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=cm.cms("search")%>" />
        <%=cm.cms("search")%>
        <%=cm.cmsInput("search")%>
      </form>
    </td>
  </tr>
  <%-- This is the code which shows the search filters --%>
  <%
    AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
    if (criterias.length > 1) {
  %>
  <tr>
    <td bgcolor="#EEEEEE">
      <%=cm.cmsText("habitats_legal-result_14")%>
    </td>
  </tr>
  <%
    }
    for (int i = criterias.length - 1; i > 0; i--) {
      AbstractSearchCriteria criteria = criterias[i];
      if (null != criteria && null != formBean.getCriteriaSearch()) {
  %>
  <tr>
    <td bgcolor="#EEEEEE">
      <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
        <img src="images/mini/delete.jpg" alt="<%=cm.cms("delete_filter")%>" border="0" style="vertical-align:middle" />
      </a>
      <%=cm.cms("delete_filter")%>&nbsp;&nbsp;
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
<table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  sortURLFields.addElement("oper");
  sortURLFields.addElement("criteriaType");
  sortURLFields.addElement("currentPage");
  sortURLFields.addElement("expand");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria codeCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria legalTxtCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_LEGAL_INSTRUMENTS);
  AbstractSortCriteria sortLevel = formBean.lookupSortCriteria(LegalSortCriteria.SORT_LEVEL);
%>
<tr>
  <th class="resultHeader" width="20%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsText("generic_index_07")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%if (showCode) {%>
  <th class="resultHeader" valign="top" width="10%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(codeCrit, (null == codeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(codeCrit)%><%=cm.cmsText("eunis_code")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" valign="top" width="29%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitat_type_name")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%}%>
  <%if (showLegalText) {%>
  <th class="resultHeader" valign="top" width="20%">
    <%=cm.cmsText("legal_text")%>
  </th>
  <%}%>
</tr>
<%
  for (int i = 0; i < results.size(); i++) {
    EUNISLegalPersist habitat = (EUNISLegalPersist) results.get(i);
    int level = habitat.getHabLevel().intValue();
    String bgColor = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
%>
<tr valign="middle" bgcolor="<%=bgColor%>">
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap;">
<%
  for (int iter = 0; iter < level; iter++)
  {
%>
    <img alt="" src="images/mini/lev_blank.gif" />
<%
  }
%>
    <%=level%>
  </td>
  <%if (showCode) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=habitat.getEunisHabitatCode()%>
  </td>
<%
  }
  if (showScientificName)
  {
%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
    <%=cm.cmsTitle("open_habitat_factsheet")%>
  </td>
  <%}%>
  <%if (showLegalText) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>;">
    <table summary="<%=cm.cms("legal_instruments")%>" border="0" cellpadding="0" cellspacing="0" width="100%">
      <%
        List legalTexts = HabitatsSearchUtility.findHabitatLegalInstrument(habitat.getIdHabitat());
        for (int j = 0; j < legalTexts.size(); j++) {
          String legalBgColor = (0 == j % 2) ? "#FFFFFF" : "#EEEEEE";
          EUNISLegalPersist legalText = (EUNISLegalPersist) legalTexts.get(j);
      %>
      <tr bgcolor="<%=legalBgColor%>">
        <td width="20%">
          <%=legalText.getLegalName()%>
        </td>
      </tr>
      <%
        }
      %>
    </table>
  </td>
  <%}%>
</tr>
<%}%>
<tr>
  <th class="resultHeader" width="20%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsText("generic_index_07")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%if (showCode) {%>
  <th class="resultHeader" valign="top" width="10%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(codeCrit, (null == codeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(codeCrit)%><%=cm.cmsText("eunis_code")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" valign="top" width="29%">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitat_type_name")%>
    </a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%}%>
  <%if (showLegalText) {%>
  <th class="resultHeader" valign="top" width="20%">
    <%=cm.cmsText("legal_text")%>
  </th>
  <%}%>
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
<%=cm.cmsMsg("habitats_legal-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("legal_instruments")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-legal-result.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
</body>
</html>