<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
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

  String tsvLink = "javascript:openlink('reports/habitats/tsv-habitats-names.jsp?" + formBean.toURLParam(reportFields) + "')";

  WebContentManagement contentManagement = SessionManager.getWebContent();

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
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
    function openPopup(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }
  //-->
  </script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_names-result_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Names#habitats-names.jsp,Results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <h5>
      <%=contentManagement.getContent("habitats_names-result_01")%>
      </h5>
      <%-- Here are the main search criterias displayed to the user --%>
      <%AbstractSearchCriteria mainCriteria = formBean.getMainSearchCriteria();%>
      <table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <%
              if (newName) {
                String searchDescription = "";
                searchDescription = "No match was found for <strong>" + formBean.getOldName() + "</strong>.&nbsp;";
                searchDescription += "The closest phonetic match we found is: <strong>" + formBean.getSearchString() + "</strong>";
            %>
            <%=searchDescription%>
            <%
            } else {
            %>
            <%=contentManagement.getContent("habitats_names-result_02")%>
            <strong>
              <%=Utilities.getSourceHabitat(database, NamesDomain.SEARCH_ANNEX_I.intValue(), NamesDomain.SEARCH_BOTH.intValue())%>
            </strong>
            <%=contentManagement.getContent("habitats_names-result_03")%>
            <strong>
              <%=mainCriteria.toHumanString()%>
            </strong>
            <%
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
      <%=contentManagement.getContent("habitats_names-result_04")%>: <strong><%=resultsCount%></strong>
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
      <table summary="Refine search criteria" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=contentManagement.getContent("habitats_names-result_05")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td bgcolor="#EEEEEE">
            <form title="refine search results" name="resultSearch" method="post" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="habitats-names-result.jsp">
            <input type="hidden" name="noSoundex" value="true" />
              <%=formBean.toFORMParam(filterSearch)%>
              <label for="criteriaType" class="noshow">Criteria</label>
              <select name="criteriaType" id="criteriaType" title="Column to apply filter" class="inputTextField">
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=contentManagement.getContent("habitats_names-result_06", false)%></option>
                <%}%>
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=contentManagement.getContent("habitats_names-result_07", false)%></option>
                <%}%>
                <%if (showCode && 0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_EUNIS%>"><%=contentManagement.getContent("habitats_names-result_06", false)%></option>
                <option value="<%=NameSearchCriteria.CRITERIA_CODE_ANNEX%>"><%=contentManagement.getContent("habitats_names-result_07", false)%></option>
                <%}%>
                <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_LEVEL%>"><%=contentManagement.getContent("habitats_names-result_08", false)%></option><%}%>
                <%if (showVernacularName) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_NAME%>"><%=contentManagement.getContent("habitats_names-result_09", false)%></option><%}%>
                <%if (showScientificName) {%>
                <option value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_names-result_10", false)%></option><%}%>
              </select>
              <label for="oper" class="noshow">Operator</label>
              <select title="Operator" name="oper" id="oper" class="inputTextField">
                <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("habitats_names-result_11", false)%></option>
                <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("habitats_names-result_12", false)%></option>
                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_names-result_13", false)%></option>
              </select>
              <label for="criteriaSearch" class="noshow">Search value</label>
              <input alt="Value" title="Value" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
              <label for="Submit" class="noshow">Apply filter</label>
              <input title="Apply filter" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("habitats_names-result_14", false)%>" />
              <%=contentManagement.writeEditTag("habitats_names-result_14")%>
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
            <%=contentManagement.getContent("habitats_names-result_15")%>:
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
            <a title="Remove filter" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
              <img alt="Delete" title="Delete" src="images/mini/delete.jpg" border="0" align="middle" /></a>&nbsp;&nbsp;
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
            <table summary="Search results" border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
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
              <tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
              <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
              <th class="resultHeader" align="left" bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
                  <%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_names-result_08")%>
                </a>
              </th>
              <%}%>
              <%if (showCode) {%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_names-result_06")%>
                </a>
              </th>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_names-result_07")%>
                </a>
              </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_names-result_06")%>
                </a>
              </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_names-result_07")%>
                </a>
              </th>
              <%}%>
              <%}%>
              <%if (showScientificName) {%>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
                  <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_names-result_10")%>
                </a>
              </th>
              <%}%>
              <%if (showVernacularName) {%>
              <th class="resultHeader" align="left">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
                  <%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_names-result_09")%>
                </a>
              </th>
              <%}%>
              </tr>
              <%
                int i = 0;
                Iterator it = results.iterator();
                while (it.hasNext()) {
                  NamesPersist habitat = (NamesPersist) it.next();
                  String rowBgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
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
              <tr bgcolor="<%=rowBgColor%>">
                <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <td align="left" style="white-space:nowrap"><%for (int iter = 0; iter < level; iter++) {%>
                  <img alt="" src="images/mini/lev_blank.gif" /><%}%><%=level%>
                </td>
                <%}%>
                <%if (showCode) {%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <td align="left"><%=eunisCode%></td>
                <td align="left"><%=annexCode%></td>
                <%}%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <td align="left"><%=eunisCode%></td>
                <%}%>
                <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <td align="left"><%=annexCode%></td>
                <%}%>
                <%}%>
                <%if (showScientificName) {%><td align="left">
                <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a></td><%}%>
                <%if (showVernacularName) {%><td align="left" width="166"><%=habitat.getDescription()%></td><%}%>
              </tr>
              <%}%>
              <tr bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
              <%if (showLevel && 0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <th class="resultHeader" align="left" bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>">
                  <%=Utilities.getSortImageTag(levelCrit)%><%=contentManagement.getContent("habitats_names-result_08")%>
                  </a>
                </th>
              <%}%>
              <%if (showCode) {%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_BOTH)) {%>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_names-result_06")%>
                  </a>
                </th>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_names-result_07")%>
                  </a>
                </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_EUNIS)) {%>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit))%>">
                  <%=Utilities.getSortImageTag(eunisCodeCrit)%><%=contentManagement.getContent("habitats_names-result_06")%>
                  </a>
                </th>
              <%}%>
              <%if (0 == database.compareTo(NamesDomain.SEARCH_ANNEX_I)) {%>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit))%>">
                  <%=Utilities.getSortImageTag(annexCodeCrit)%><%=contentManagement.getContent("habitats_names-result_07")%>
                  </a>
                </th>
              <%}%>
              <%}%>
              <%if (showScientificName) {%>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>">
                  <%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("habitats_names-result_10")%>
                  </a>
                </th>
              <%}%>
              <%if (showVernacularName) {%>
                <th class="resultHeader" align="left">
                  <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>">
                  <%=Utilities.getSortImageTag(nameCrit)%><%=contentManagement.getContent("habitats_names-result_09")%>
                  </a>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-names-result.jsp" />
</jsp:include>
    </div>
  </body>
</html>