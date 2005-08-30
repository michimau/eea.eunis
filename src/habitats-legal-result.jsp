<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
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
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
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

    String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-legal.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_legal-result_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Legal instruments#habitats-legal.jsp,Results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h5><%=contentManagement.getContent("habitats_legal-result_01")%></h5>
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <%LegalSearchCriteria mainSearch = (LegalSearchCriteria) formBean.getMainSearchCriteria();%>
    <%String realSearch = (null != formBean.getSearchString() && formBean.getSearchString().equalsIgnoreCase("%")) ? "" : " for which " + mainSearch.toHumanString();
      String scientName = HabitatsSearchUtility.getHabitatLevelName(formBean.getHabitatType());%>
    <tr>
      <td>
        <%=contentManagement.getContent("habitats_legal-result_02")%>
        '<strong><%=scientName%>'
        <%=realSearch%>
        <%=contentManagement.getContent("habitats_legal-result_03")%>
        '<%=formBean.getLegalText()%>'
        <%=contentManagement.getContent("habitats_legal-result_04")%>
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
<%=contentManagement.getContent("habitats_legal-result_05")%>:<strong><%=resultsCount%></strong>
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
        <%=contentManagement.getContent("habitats_legal-result_06")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow">Criteria</label>
        <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
          <%if (showCode) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=contentManagement.getContent("habitats_legal-result_07", false)%></option><%}%>
          <%if (showScientificName) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_legal-result_08", false)%></option><%}%>
          <%if (showLegalText) {%>
          <option value="<%=LegalSearchCriteria.CRITERIA_LEGAL_TEXT%>"><%=contentManagement.getContent("habitats_legal-result_09", false)%></option><%}%>
        </select>
        <label for="oper" class="noshow">Operator</label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_legal-result_10", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_legal-result_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_legal-result_12", false)%></option>
        </select>
        <label for="criteriaSearch" class="noshow">Search value</label>
        <input title="Search value" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <label for="Submit" class="noshow">Search</label>
        <input title="Search" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_legal-result_13",false)%>" />
        <%=contentManagement.writeEditTag("habitats_legal-result_13")%>
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
      <%=contentManagement.getContent("habitats_legal-result_14")%>
    </td>
  </tr>
  <%
    }
    for (int i = criterias.length - 1; i > 0; i--) {
      AbstractSearchCriteria criteria = criterias[i];
      if (null != criteria && null != formBean.getCriteriaSearch()) {
  %>
  <tr>
    <td bgcolor="#EEEEEE" align="left">
      <a title="Delete filter" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
        <img src="images/mini/delete.jpg" alt="Delete filter" border="0" align="middle" /></a>&nbsp;&nbsp;
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
  AbstractSortCriteria codeCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria legalTxtCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_LEGAL_INSTRUMENTS);
  AbstractSortCriteria sortLevel = formBean.lookupSortCriteria(LegalSortCriteria.SORT_LEVEL);
%>
<tr>
  <th class="resultHeader" align="left" width="20%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortLevel)%><%=contentManagement.getContent("habitats_legal-result_15")%>
    </a>
  </th>
  <%if (showCode) {%>
  <th class="resultHeader" align="left" valign="top" width="10%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(codeCrit, (null == codeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(codeCrit)%><%=contentManagement.getContent("habitats_legal-result_07")%>
    </a>
  </th>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" align="left" valign="top" width="29%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_legal-result_08")%>
    </a>
  </th>
  <%}%>
  <%if (showLegalText) {%>
  <th class="resultHeader" align="left" valign="top" width="20%">
    <%=contentManagement.getContent("habitats_legal-result_09")%>
  </th>
  <%}%>
</tr>
<%
  for (int i = 0; i < results.size(); i++) {
    EUNISLegalPersist habitat = (EUNISLegalPersist) results.get(i);
    int level = habitat.getHabLevel().intValue();
    String bgColor = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
%>
<tr align="center" valign="middle" bgcolor="<%=bgColor%>">
  <td align="left" width="20%" style="white-space:nowrap">
    <%for (int iter = 0; iter < level; iter++) {
    %>
    <img alt="" src="images/mini/lev_blank.gif" />
    <%
      }
    %>
    <%=level%>
  </td>
  <%if (showCode) {%>
  <td width="10%" align="left"><%=habitat.getEunisHabitatCode()%></td><%}%>
  <%if (showScientificName) {
  %>
  <td width="29%" align="left">
    <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
  </td>
  <%}%>
  <%if (showLegalText) {%>
  <td valign="top">
    <table summary="Legal instruments" border="0" cellpadding="0" cellspacing="0" width="100%">
      <%
        List legalTexts = HabitatsSearchUtility.findHabitatLegalInstrument(habitat.getIdHabitat());
        for (int j = 0; j < legalTexts.size(); j++) {
          String legalBgColor = (0 == j % 2) ? "#FFFFFF" : "#EEEEEE";
          EUNISLegalPersist legalText = (EUNISLegalPersist) legalTexts.get(j);
      %>
      <tr bgcolor="<%=legalBgColor%>">
        <td width="20%" align="left">
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
  <th class="resultHeader" align="left" width="20%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>">
      <%=Utilities.getSortImageTag(sortLevel)%><%=contentManagement.getContent("habitats_legal-result_15")%>
    </a>
  </th>
  <%if (showCode) {%>
  <th class="resultHeader" align="left" valign="top" width="10%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(codeCrit, (null == codeCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(codeCrit)%><%=contentManagement.getContent("habitats_legal-result_07")%>
    </a>
  </th>
  <%}%>
  <%if (showScientificName) {%>
  <th class="resultHeader" align="left" valign="top" width="29%">
    <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>">
      <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_legal-result_08")%>
    </a>
  </th>
  <%}%>
  <%if (showLegalText) {%>
  <th class="resultHeader" align="left" valign="top" width="20%">
    <%=contentManagement.getContent("habitats_legal-result_09")%>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-legal-result.jsp" />
</jsp:include>
    </div>
  </body>
</html>