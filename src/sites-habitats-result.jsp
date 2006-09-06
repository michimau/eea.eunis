<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.sites.habitats.HabitatPaginator,
                 ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                 ro.finsiel.eunis.jrfTables.sites.habitats.HabitatPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.habitats.HabitatBean,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.habitats.HabitatBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
   // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), HabitatBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showSiteCode = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), HabitatBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), HabitatBean.HIDE);
  boolean showHabitat  = Utilities.checkedStringToBoolean(formBean.getShowHabitat(), true);
//    boolean[] source = {(formBean.getDB_NATURA2000()==null?false:true),
//                        (formBean.getDB_CORINE()==null?false:true),
//                        (formBean.getDB_DIPLOMA()==null?false:true),
//                        (formBean.getDB_CDDA_NATIONAL()==null?false:true),
//                        (formBean.getDB_CDDA_INTERNATIONAL()==null?false:true),
//                        (formBean.getDB_BIOGENETIC()==null?false:true),
//                        false,
//                        (formBean.getDB_EMERALD()==null?false:true)
//    };
  boolean[] source = { true, true, true, true, true, true, false, true }; // Default search in all data sets

  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitatSearchCriteria.SEARCH_NAME);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS);
  HabitatPaginator paginator = new HabitatPaginator(new HabitatDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS), source, searchAttribute));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-habitats-result.jsp";
  int guid = 0;

  int resultsCount = 0;
  int pagesCount = 0;
  List results = null;
  try
  {
    resultsCount = paginator.countResults();
    pagesCount = paginator.countPages();
    results = paginator.getPage(currentPage);
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-habitats.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String location = "home#index.jsp,habitat_types#habitats.jsp,sites_habitats_location#sites-habitats.jsp,results";
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
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_habitats-result_title")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=location%>"/>
                  <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
            <%--    <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>
                <h1>
                  <%=cm.cmsText("pick_habitat_type_show_sites")%>
                </h1>
                <%=cm.cmsText("sites_habitats-result_02")%>
                <%=Utilities.getSourceHabitat(database, HabitatDomain.SEARCH_ANNEX_I.intValue(), HabitatDomain.SEARCH_BOTH.intValue())%>
                <%=cm.cmsText("sites_habitats-result_03")%> <strong><%=formBean.getMainSearchCriteria().toHumanString()%>.</strong>
                <br />
                <br />
                <%=cm.cmsText("results_found_1")%>
                <strong>
                  <%=resultsCount%>
                </strong>
                <br />
            <%
              // Prepare parameters for pagesize.jsp
              Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
              pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
              pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
              pageSizeFormFields.addElement("criteriaSearch");/*   to page "0" aka first page. */
            %>
                <jsp:include page="pagesize.jsp">
                  <jsp:param name="guid" value="<%=guid%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
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
                <div class="grey_rectangle">
                  <%=cm.cmsText("refine_your_search")%>
                  <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
                    <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType" class="noshow"><%=cm.cms("criteria")%></label>
                    <select id="criteriaType" name="criteriaType" title="<%=cm.cms("criteria")%>">
            <%
              if (showSourceDB)
              {
            %>
                      <option value="<%=HabitatSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
            <%
              }
              if (showName)
              {
            %>
                      <option value="<%=HabitatSearchCriteria.CRITERIA_ENGLISH_NAME%>">
                        <%=cm.cms("site_name")%>
                      </option>
            <%
              }
              if (showHabitat)
              {
            %>
                      <option value="<%=HabitatSearchCriteria.CRITERIA_HABITAT%>">
                        <%=cm.cms("habitat_type_name")%>
                      </option>
            <%
              }
            %>
                    </select>
                    <%=cm.cmsLabel("criteria")%>
                    <%=cm.cmsTitle("criteria")%>
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("site_name")%>
                    <%=cm.cmsInput("habitat_type_name")%>

                    <label for="oper" class="noshow"><%=cm.cms("operator")%></label>
                    <select id="oper" name="oper" title="<%=cm.cms("operator")%>">
                      <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("is")%></option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("starts_with")%></option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                    </select>
                    <%=cm.cmsLabel("operator")%>
                    <%=cm.cmsTitle("operator")%>
                    <%=cm.cmsInput("is")%>
                    <%=cm.cmsInput("starts_with")%>
                    <%=cm.cmsInput("contains")%>

                    <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_value")%></label>
                    <input id="criteriaSearch" name="criteriaSearch" type="text" size="30" title="<%=cm.cms("filter_value")%>" />
                    <%=cm.cmsLabel("filter_value")%>
                    <%=cm.cmsTitle("filter_value")%>

                    <input id="submit" name="Submit" type="submit" value="<%=cm.cms("search")%>" class="searchButton" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </form>
            <%
              ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
              if (criterias.length > 1)
              {
            %>
                  <%=cm.cmsText("applied_filters_to_the_results_1")%>
                  <br />
            <%
              }
              for (int i = criterias.length - 1; i > 0; i--)
              {
                AbstractSearchCriteria criteria = criterias[i];
                if (null != criteria && null != formBean.getCriteriaSearch())
                {
            %>
                  <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete")%>" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("removefilter_title")%>
                  <%=cm.cmsAlt("delete")%>
                  <strong>
                    <%= i + ". " + criteria.toHumanString()%>
                  </strong>
                  <br />
            <%
                }
              }
            %>
                </div>
                <br />
            <%
              // Prepare parameters for navigator.jsp
              Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
              navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
              navigatorFormFields.addElement("sort");     /* <form name="..."> in the navigator.jsp!                               */
              navigatorFormFields.addElement("ascendency");
              navigatorFormFields.addElement("criteriaSearch");
            %>
                <jsp:include page="navigator.jsp">
                  <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                  <jsp:param name="pageName" value="<%=pageName%>"/>
                  <jsp:param name="guid" value="<%=guid%>"/>
                  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                </jsp:include>
            <%
              // Compute the sort criteria
              Vector sortURLFields = new Vector();      /* Used for sorting */
              sortURLFields.addElement("pageSize");
              sortURLFields.addElement("criteriaSearch");
              String urlSortString = formBean.toURLParam(sortURLFields);
              AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_SOURCE_DB);
              AbstractSortCriteria sortName = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_NAME);
              AbstractSortCriteria sortDesignType = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_DESIGNATION);
              AbstractSortCriteria sortHabitat = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_HABITAT);
              AbstractSortCriteria sortLat = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_LAT);
              AbstractSortCriteria sortLong = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_LONG);
            %>
                  <br />
                  <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                    <thead>
                      <tr>
            <%
              if (showSourceDB)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showDesignType)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("designation_type")%>
                        </th>
            <%
              }
              if (showSiteCode)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("site_code")%>
                        </th>
            <%
              }
              if (showName)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showCoord)
              {
            %>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsText("longitude")%>
                        </th>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsText("latitude")%>
                        </th>
            <%
              }
              if (showHabitat)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("habitat_types_1")%>
                        </th>
            <%
              }
            %>
                      </tr>
                    </thead>
                    <tbody>
            <%
              Iterator it = results.iterator();
              int i = 0; String bgCol;
              while (it.hasNext())
              {
                bgCol = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
                HabitatPersist site = (HabitatPersist)it.next();
            %>
                    <tr>
            <%
                if (showSourceDB)
                {
            %>
                      <td>
                        <strong>
                          <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()),"&nbsp;")%>
                        </strong>
                      </td>
            <%
                }
                if (showDesignType)
                {
            %>
                    <td>
                      <jsp:include page="sites-designations-detail.jsp">
                        <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
                        <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
                        <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
                        <jsp:param name="bgcolor" value="<%=bgCol%>"/>
                        <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
                      </jsp:include>
                    </td>
            <%
                }
                if (showSiteCode)
                {
            %>
                      <td>
                        <strong>
                          <%=site.getIdSite()%>
                        </strong>
                      </td>
            <%
                }
                if (showName)
                {
            %>
                      <td>
                        <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a>
                        <%=cm.cmsTitle("open_site_factsheet")%>
                      </td>
            <%
                }
                if (showCoord)
                {
            %>
                      <td style="text-align: center; white-space: nowrap;">
                        <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
                      </td>
                      <td style="text-align: center; white-space: nowrap;">
                        <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
                      </td>
            <%
              }
                if (showHabitat)
                {
                  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
                  boolean[] source_db = { true, true, true, true, true, true, false, true }; // Default search in all data sets
                  List resultsHabitats = new HabitatDomain().findHabitatsFromSpecifiedSite(
                      new HabitatSearchCriteria(searchAttribute,
                                                          formBean.getSearchString(),
                                                          relationOp),
                                                          searchAttribute,
                                                          source_db,
                                                          Utilities.formatString(site.getName(),""));
            %>
                      <td>
            <%
                  if (!resultsHabitats.isEmpty())
                  {
                    String SQL_DRV = application.getInitParameter("JDBC_DRV");
                    String SQL_URL = application.getInitParameter("JDBC_URL");
                    String SQL_USR = application.getInitParameter("JDBC_USR");
                    String SQL_PWD = application.getInitParameter("JDBC_PWD");

                    SQLUtilities sqlc = new SQLUtilities();
                    sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
            %>
                        <table border="0" cellspacing="0" cellpadding="0" summary="<%=cm.cms("habitat_types")%>">
            <%
                    for(int ii=0;ii<resultsHabitats.size();ii++)
                    {
                      String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";
                      String habitatName = (String) resultsHabitats.get(ii);
                      String idHabitat = sqlc.ExecuteSQL("SELECT ID_HABITAT FROM chm62edt_habitat WHERE    "+isGoodHabitat+" AND SCIENTIFIC_NAME='"+habitatName+"'");
            %>
                          <tr>
                            <td>
                              <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=idHabitat%>"><%=habitatName%></a>
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
            <%
                }
            %>
                    </tr>
            <%
              }
            %>
                    </tbody>
                    <thead>
                      <tr>
            <%
              if (showSourceDB)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showDesignType)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("designation_type")%>
                        </th>
            <%
              }
              if (showSiteCode)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("site_code")%>
                        </th>
            <%
              }
              if (showName)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showCoord)
              {
            %>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsText("longitude")%>
                        </th>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsText("latitude")%>
                        </th>
            <%
              }
              if (showHabitat)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsText("habitat_types_1")%>
                        </th>
            <%
              }
            %>
                      </tr>
                    </thead>
                  </table>
                  <jsp:include page="navigator.jsp">
                    <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                    <jsp:param name="pageName" value="<%=pageName%>"/>
                    <jsp:param name="guid" value="<%=guid + 1%>"/>
                    <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                  </jsp:include>

                  <%=cm.cmsMsg("sites_habitats-result_title")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("search_results")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("habitat_types")%>
                  <jsp:include page="footer.jsp">
                    <jsp:param name="page_name" value="sites-habitats-result.jsp" />
                  </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
