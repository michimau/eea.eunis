<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.sites.SitesBean,
                 ro.finsiel.eunis.search.habitats.sites.SitesPaginator,
                 ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.sites.SitesSortCriteria,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.sites.SitesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  if (null != formBean.getRemoveFilterIndex())
  {
    formBean.prepareFilterCriterias();
  }
  boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), SitesBean.HIDE);
  boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), SitesBean.HIDE);
  boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), true);
  //boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), SitesBean.HIDE);
  boolean showVernacularName = false;

//    System.out.println("showVernacularName = " + showVernacularName);
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  // The main paginator
//    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatsSitesDomain.SEARCH_EUNIS);
  Integer database = HabitatsSitesDomain.SEARCH_BOTH;
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
  boolean[] source_db = {true, true, true, true, true, true, true, true};

  SitesPaginator paginator = new SitesPaginator(new HabitatsSitesDomain(formBean.toSearchCriteria(),
    formBean.toSortCriteria(),
    searchAttribute,
    database,
    source_db));

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "habitats-sites-result.jsp";
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

  String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-sites.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,habitat_types#habitats-sites.jsp,results";
  if (results.isEmpty())
  {
    boolean fromRefine = formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0;
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
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
  function MM_openBrWindow(theURL,winName,features) { //v2.0
    window.open(theURL,winName,features);
  }
  //]]>
  </script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("pick_sites_show_habitat_types")%>
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
                <h1><%=cm.cmsPhrase("Pick sites, show habitat types")%></h1>
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
                      <a href="sites-help.jsp"><img src="images/help_icon.gif"
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
                    SitesSearchCriteria mainCriteria = (SitesSearchCriteria) formBean.getMainSearchCriteria();
                    String criteriaStr = cm.cms("you_searched");
                    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {
                      criteriaStr += " <strong> EUNIS </strong>";
                    }
                    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {
                      criteriaStr += " <strong> ANNEX I </strong>";
                    }
                    if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {
                      criteriaStr += " " + cm.cms("both_eunis_and_annex1");
                    }
                    criteriaStr += " " + cm.cms("habitats_within_sites") + " <strong>" + mainCriteria.toHumanString() + "</strong>";
                  %>
                  <tr>
                    <td width="100%">
                      <%=criteriaStr%>
                    </td>
                  </tr>
                </table>
                <%=cm.cmsPhrase("Results found")%>&nbsp;<strong><%=resultsCount%></strong>
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
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td bgcolor="#EEEEEE">
                    <strong>
                      <%=cm.cmsPhrase("Refine your search")%>
                    </strong>
                  </td>
                </tr>
                <tr>
                  <td bgcolor="#EEEEEE">
                    <form name="refineSearch" method="get" onsubmit="return( validateRefineForm(<%=noCriteria%>) );" action="">
                      <%=formBean.toFORMParam(filterSearch)%>
                      <label for="criteriaType" class="noshow"><%=cm.cms("Criteria")%></label>
                      <select title="<%=cm.cms("Criteria")%>" name="criteriaType" id="criteriaType">
                        <%
                          if (showCode) {
                        %>
                        <%
                          if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH)) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=cm.cms("eunis_code")%></option>
                        <option value="<%=SitesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=cm.cms("annex_code")%></option>
                        <%
                          }
                        %>
                        <%
                          if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS)) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_EUNIS_CODE%>"><%=cm.cms("eunis_code")%></option>
                        <%
                          }
                        %>
                        <%
                          if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I)) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_ANNEX_CODE%>"><%=cm.cms("annex_code")%></option>
                        <%
                          }
                        %>
                        <%
                          }
                        %>
                        <%
                          if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue()) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("generic_index_07")%></option>
                        <%
                          }
                        %>
                        <%
                          if (showVernacularName) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_NAME%>"><%=cm.cms("english_name")%></option>
                        <%
                          }
                        %>
                        <%
                          if (showScientificName) {
                        %>
                        <option value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitat_type")%></option>
                        <%
                          }
                        %>
                      </select>
                      <%=cm.cmsLabel("Criteria")%>
                      <%=cm.cmsInput("eunis_code")%>
                      <%=cm.cmsInput("annex_code")%>
                      <%=cm.cmsInput("generic_index_07")%>
                      <%=cm.cmsInput("english_name")%>
                      <%=cm.cmsInput("habitat_type")%>
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
                      <input title="<%=cm.cms("filter_value")%>" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
                      <%=cm.cmsTitle("filter_value")%>
                      <input title="<%=cm.cms("search")%>" class="submitSearchButton" type="submit" name="Submit" id="Submit" value="<%=cm.cms("search")%>" />
                      <%=cm.cmsTitle("search")%>
                      <%=cm.cmsInput("search")%>
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
                    <%=cm.cmsPhrase("Applied filters to the results")%>:
                  </td>

                </tr>
                <%
                  }
                %>
                <%
                  for (int i = criterias.length - 1; i > 0; i--) {
                %>
                <%AbstractSearchCriteria criteria = criterias[i];%>
                <%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
                <tr>
                  <td bgcolor="#CCCCCC">
                    <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
                      <img title="<%=cm.cms("delete_filter")%>" alt="<%=cm.cms("delete_filter")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" />
                    </a>
                    <%=cm.cmsTitle("delete_filter")%>&nbsp;&nbsp;
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
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
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
                </table>
                <%// Compute the sort criteria
                  Vector sortURLFields = new Vector();      /* Used for sorting */
                  sortURLFields.addElement("pageSize");
                  sortURLFields.addElement("criteriaSearch");
                  sortURLFields.addElement("oper");
                  sortURLFields.addElement("criteriaType");
                  sortURLFields.addElement("currentPage");
                  sortURLFields.addElement("expand");
                  String urlSortString = formBean.toURLParam(sortURLFields);
                  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_LEVEL);
                  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_EUNIS_CODE);
                  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_ANNEX_CODE);
                  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_SCIENTIFIC_NAME);
                  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(SitesSortCriteria.SORT_VERNACULAR_NAME);
                %>
                <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                  <thead>
                    <tr>
                  <%
                    if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue())
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsPhrase("Level")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showCode)
                    {
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Habitat type")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showVernacularName)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsPhrase("English name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                      <th scope="col">
                        <%=cm.cmsPhrase("Sites")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  int i = 0;
                  Iterator it = results.iterator();
                  int col = 0;
                  while (it.hasNext())
                  {
                    String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                    HabitatsSitesPersist habitat = (HabitatsSitesPersist) it.next();
                    String eunisCode = habitat.getEunisHabitatCode();
                    //String annexCode = habitat.getCodeAnnex1();
                    String annexCode = habitat.getCode2000();
                %>
                    <tr<%=cssClass%>>
                  <%
                    if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue())
                    {
                      int level = habitat.getHabLevel().intValue();
                  %>
                      <td style="white-space : nowrap">
                  <%
                      for (int iter = 0; iter < level; iter++)
                      {
                  %>
                        <img alt="" src="images/mini/lev_blank.gif" />
                  <%
                      }
                  %>
                        <%=habitat.getHabLevel()%>
                      </td>
                  <%
                    }
                  %>
                  <%
                    if (showCode)
                    {
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH))
                      {
                  %>
                      <td>
                        <%=eunisCode%>
                      </td>
                      <td>
                        <%=annexCode%>
                      </td>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS))
                      {
                  %>
                      <td>
                        <%=eunisCode%>
                      </td>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I))
                      {
                  %>
                      <td>
                        <%=annexCode%>
                      </td>
                  <%
                      }
                  %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName)
                    {
                  %>
                      <td>
                        <a href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
                      </td>
                  <%
                    }
                  %>
                  <%
                    if (showVernacularName)
                    {
                  %>
                      <td>
                        <%=habitat.getDescription()%>
                      </td>
                  <%
                    }
                  %>
                      <td>
                    <%
                      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
                      Integer idNatureObject = habitat.getIdNatureObject();
                      // List of habitats from the specified site
                      List resultsSites = new HabitatsSitesDomain().findSitesWithHabitats(
                        new SitesSearchCriteria(searchAttribute,
                          formBean.getScientificName(),
                          relationOp),
                        source_db,
                        searchAttribute,
                        idNatureObject,
                        database);
                      if (resultsSites != null && resultsSites.size() > 0) {
                        String SQL_DRV = application.getInitParameter("JDBC_DRV");
                        String SQL_URL = application.getInitParameter("JDBC_URL");
                        String SQL_USR = application.getInitParameter("JDBC_USR");
                        String SQL_PWD = application.getInitParameter("JDBC_PWD");

                        SQLUtilities sqlc = new SQLUtilities();
                        sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
                    %>
                        <table summary="<%=cm.cms("sites")%>" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
                      <%
                        for (int ii = 0; ii < resultsSites.size(); ii++) {
                          List l = (List) resultsSites.get(ii);
                          String siteName = (String) l.get(0);
                          String siteSourceDb = (String) l.get(1);
                          String idSite = sqlc.ExecuteSQL("select ID_SITE FROM chm62edt_sites WHERE NAME='" + siteName.replaceAll("'", "''") + "'");
                      %>
                          <tr>
                            <td>
                              <a href="sites/<%=idSite%>"><%=siteName%></a> (<%=siteSourceDb%>
                              )
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
                %>
                  </tbody>
                  <thead>
                    <tr>
                  <%
                    if (showLevel && database.intValue() == HabitatsSitesDomain.SEARCH_EUNIS.intValue())
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit) ? true : false)%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsPhrase("Level")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showCode)
                    {
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_BOTH))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_EUNIS))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(HabitatsSitesDomain.SEARCH_ANNEX_I))
                      {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                      }
                  %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Habitat type")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showVernacularName)
                    {
                  %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsPhrase("English name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
                  <%
                    }
                  %>
                      <th scope="col">
                        <%=cm.cmsPhrase("Sites")%>
                      </th>
                    </tr>
                  </thead>
                </table>
                </td>
                </tr>
                <tr>
                  <td>
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
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
                <%=cm.cmsMsg("pick_sites_show_habitat_types")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_results")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("you_searched")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("both_eunis_and_annex1")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitats_within_sites")%>
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
                <jsp:param name="page_name" value="habitats-sites-result.jsp" />
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
