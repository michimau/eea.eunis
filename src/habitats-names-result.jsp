<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexDomain,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexPersist,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.names.NameBean,
                 ro.finsiel.eunis.search.habitats.names.NamePaginator,
                 ro.finsiel.eunis.search.habitats.names.NameSearchCriteria" %>
<%@ page import="ro.finsiel.eunis.search.habitats.names.NameSortCriteria" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.names.NameBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) {
    formBean.prepareFilterCriterias();
  }
  // Request parameters.
  boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), NameBean.HIDE);
  boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), NameBean.HIDE);
  boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), NameBean.HIDE);
  boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), NameBean.HIDE);
  boolean newName = Utilities.checkedStringToBoolean(formBean.getNewName(), false);
  boolean noSoundex = Utilities.checkedStringToBoolean( formBean.getNoSoundex(), false );
  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), NamesDomain.SEARCH_EUNIS);
  // The main paginator
  NamePaginator paginator = new NamePaginator(new NamesDomain(formBean.toSearchCriteria(), formBean.getMainSearchCriteriasExtra(), formBean.toSortCriteria(), database));
  // Initialization
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "habitats-names-result.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);

  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-names.jsp?" + formBean.toURLParam(reportFields) + "')";

  WebContentManagement cm = SessionManager.getWebContent();

  if (results.isEmpty() && !newName  && !noSoundex) {
    String sname = formBean.getSearchString();
    List list = new Vector();
    String cnstSoundex = new String(ro.finsiel.eunis.utilities.SQLUtilities.smartSoundex);
    cnstSoundex = cnstSoundex.replaceAll("<name>", sname.replaceAll("'", "''"));
    cnstSoundex = cnstSoundex.replaceAll("<object_type>", "HABITAT");
    list = new Chm62edtSoundexDomain().findCustom(cnstSoundex);
    if (list != null && list.size() > 0) {
      Chm62edtSoundexPersist t = (Chm62edtSoundexPersist) list.get(0);
      String soundexName = t.getName();
      try {
        String URL = "habitats-names-result.jsp?showScientificName=true&deleteIndex=-1&sort=3&ascendency=1&showLevel=true&showCode=true&relationOp=4&noSoundex=false&searchString=" + soundexName + "&database=" + database + "&useScientific=true&useVernacular=true&newName=true&oldName=" + sname;
        response.sendRedirect(URL);
        return;
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
    function openPopup(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }
  //-->
  </script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_names-result_title")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_names_location#habitats-names.jsp,results_location" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <h1>
      <%=cm.cmsText("habitats_names-result_01")%>
      </h1>
      <%AbstractSearchCriteria mainCriteria = formBean.getMainSearchCriteria();%>
      <table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <%
            if (!results.isEmpty()) {
              if (newName) {
                String searchDescription = "";
                if(!formBean.getOldName().equalsIgnoreCase(formBean.getSearchString())) {
                  searchDescription = cm.cms("no_match_was_found_for") + " <strong>" + formBean.getOldName() + "</strong>.&nbsp;";
                  searchDescription += cm.cms("the_closest_phonetic_match") + " <strong>" + formBean.getSearchString() + "</strong>";
                } else {
                  searchDescription += cm.cms("the_closest_phonetic_match") + " <strong>" + formBean.getSearchString() + "</strong>";
                }
            %>
            <%=searchDescription%>
            <%=cm.cmsMsg("no_match_was_found_for")%>
            <%=cm.cmsMsg("the_closest_phonetic_match")%>
            <%
            } else {
            %>
            <%=cm.cmsText("habitats_names-result_02")%>
            <strong>
              <%=Utilities.getSourceHabitat(database, NamesDomain.SEARCH_ANNEX_I.intValue(), NamesDomain.SEARCH_BOTH.intValue())%>
            </strong>
            <%=cm.cmsText("habitats_names-result_03")%>
            <strong>
              <%=mainCriteria.toHumanString()%>
            </strong>
            <%
              }
            }
            %>
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
      <%=cm.cmsText("habitats_names-result_04")%>: <strong><%=resultsCount%></strong>
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
        <jsp:param name="guid" value="<%=guid + 1%>" />
        <jsp:param name="pageName" value="<%=pageName%>" />
        <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
      </jsp:include>
      <br />
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
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=cm.cmsText("habitats_names-result_05")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td bgcolor="#EEEEEE">
            <form name="resultSearch" method="post" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="habitats-names-result.jsp">
            <input type="hidden" name="noSoundex" value="true" />
              <%=formBean.toFORMParam(filterSearch)%>
              <label for="criteriaType" class="noshow"><%=cm.cms("Criteria")%></label>
              <select name="criteriaType" id="criteriaType" title="<%=cm.cms("Criteria")%>" class="inputTextField">
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("habitats_names-result_06")%></option>
                <%}%>
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("habitats_names-result_07")%></option>
                <%}%>
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("habitats_names-result_06")%></option>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("habitats_names-result_07")%></option>
                <%}%>
                <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("habitats_names-result_08")%></option><%}%>
                <%if (showVernacularName) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_NAME%>"><%=cm.cms("habitats_names-result_09")%></option><%}%>
                <%if (showScientificName) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitats_names-result_10")%></option><%}%>
              </select>
              <%=cm.cmsLabel("Criteria")%>
              <%=cm.cmsInput("habitats_names-result_06")%>
              <%=cm.cmsInput("habitats_names-result_07")%>
              <%=cm.cmsInput("habitats_names-result_08")%>
              <%=cm.cmsInput("habitats_names-result_09")%>
              <%=cm.cmsInput("habitats_names-result_10")%>
              <label for="oper" class="noshow"><%=cm.cms("operator")%></label>
              <select title="<%=cm.cms("operator")%>" name="oper" id="oper" class="inputTextField">
                <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("habitats_names-result_11")%></option>
                <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("habitats_names-result_12")%></option>
                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("habitats_names-result_13")%></option>
              </select>
              <%=cm.cmsLabel("operator")%>
              <%=cm.cmsInput("habitats_names-result_11")%>
              <%=cm.cmsInput("habitats_names-result_12")%>
              <%=cm.cmsInput("habitats_names-result_13")%>
              <label for="criteriaSearch" class="noshow"><%=cm.cms("search_value")%></label>
              <input alt="<%=cm.cms("search_value")%>" title="<%=cm.cms("search_value")%>" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
              <%=cm.cmsTitle("search_value")%>
              <label for="Submit" class="noshow"><%=cm.cms("search")%></label>
              <input title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=cm.cms("habitats_names-result_14")%>" />
              <%=cm.cmsTitle("search")%>
              <%=cm.cmsInput("habitats_names-result_14")%>
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
            <%=cm.cmsText("habitats_names-result_15")%>:
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
            <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
              <img alt="<%=cm.cms("delete_filter")%>" title="<%=cm.cms("delete_filter")%>" src="images/mini/delete.jpg" border="0" align="middle" />
            </a>
            <%=cm.cms("delete_filter")%>&nbsp;&nbsp;
            <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
          </td>
        </tr>
        <%
            }
          }
        %>
        <% // Prepare parameters for navigator.jsp
          Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
          navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
          navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
          navigatorFormFields.addElement("ascendency");
          navigatorFormFields.addElement("criteriaSearch");
          navigatorFormFields.addElement("oper");
          navigatorFormFields.addElement("criteriaType");
          navigatorFormFields.addElement("expand");
        %>
        <tr>
          <td>
            <br />
            <br />
          </td>
        </tr>
        <tr>
          <td>
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
            <%// Compute the sort criteria
              Vector sortURLFields = new Vector();      /* Used for sorting */
              sortURLFields.addElement("pageSize");
              sortURLFields.addElement("criteriaSearch");
              sortURLFields.addElement("oper");
              sortURLFields.addElement("criteriaType");
              sortURLFields.addElement("currentPage");
              sortURLFields.addElement("expand");
              String urlSortString = formBean.toURLParam(sortURLFields);
              AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(NameSortCriteria.SORT_LEVEL);
              AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(NameSortCriteria.SORT_EUNIS_CODE);
              AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(NameSortCriteria.SORT_ANNEX_CODE);
              AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(NameSortCriteria.SORT_SCIENTIFIC_NAME);
              AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(NameSortCriteria.SORT_VERNACULAR_NAME);
            %>
              <tr>
              <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
                  <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_names-result_08")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <%}%>
              <%if (showCode) {%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_names-result_06")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_names-result_07")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </a>
              </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_names-result_06")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_names-result_07")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <%}%>
              <%}%>
              <%if (showScientificName) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
                  <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_names-result_10")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <%}%>
              <%if (showVernacularName) {%>
              <th class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
                  <%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitats_names-result_09")%>
                </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
              <%}%>
              </tr>
              <%
                int i = 0;
                Iterator it = results.iterator();
                while (it.hasNext()) {
                  NamesPersist habitat = (NamesPersist) it.next();
                  String bgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
                  int level = habitat.getHabLevel().intValue();
                  int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
                  boolean isEUNIS = idHabitat <= 10000;
                  String eunisCode = habitat.getEunisHabitatCode();
                  String annexCode = habitat.getCode2000();
                  if (isEUNIS) {
                    annexCode = "";
                  } else {
                    eunisCode = "";
                  }
              %>
              <tr>
                <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap;">
                  <%for (int iter = 0; iter < level; iter++) {%>
                  <img alt="" src="images/mini/lev_blank.gif" /><%}%><%=level%>
                </td>
                <%}%>
                <%if (showCode) {%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=eunisCode%></td>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=annexCode%>
                </td>
                <%}%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=eunisCode%>
                </td>
                <%}%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=annexCode%>
                </td>
                <%}%>
                <%}%>
                <%if (showScientificName) {%>
                  <td class="resultCell" style="background-color : <%=bgColor%>">
                    <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
                    <%=cm.cmsTitle("open_habitat_factsheet")%>
                  </td>
                <%}%>
                <%if (showVernacularName) {%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=habitat.getDescription()%>
                </td>
              <%}%>
              </tr>
              <%}%>
              <tr>
              <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
                  <%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("habitats_names-result_08")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
              <%}%>
              <%if (showCode) {%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_names-result_06")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_names-result_07")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("habitats_names-result_06")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("habitats_names-result_07")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
              <%}%>
              <%}%>
              <%if (showScientificName) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
                  <%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitats_names-result_10")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
                </th>
              <%}%>
              <%if (showVernacularName) {%>
                <th class="resultHeader">
                  <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
                  <%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitats_names-result_09")%>
                  </a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
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
    </td>
  </tr>
</table>
<%=cm.br()%>
<%=cm.cmsMsg("habitats_names-result_title")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-names-result.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
