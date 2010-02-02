<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites coordinates" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.sites.coordinates.CoordinatesPaginator,
                 ro.finsiel.eunis.jrfTables.sites.coordinates.CoordinatesDomain,
                 ro.finsiel.eunis.search.sites.coordinates.CoordinatesBean,
                 ro.finsiel.eunis.search.sites.coordinates.CoordinatesSearchCriteria,
                 java.util.List,
                 ro.finsiel.eunis.search.sites.coordinates.CoordinatesSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.coordinates.CoordinatesPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector,
                 ro.finsiel.eunis.search.*,
                 java.util.ArrayList"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.coordinates.CoordinatesBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), CoordinatesBean.HIDE);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), CoordinatesBean.HIDE);
  boolean showCountry = Utilities.checkedStringToBoolean(formBean.getShowCountry(), CoordinatesBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), CoordinatesBean.HIDE);
  boolean showSize = Utilities.checkedStringToBoolean(formBean.getShowSize(), CoordinatesBean.HIDE);
  boolean[] source =
      {
          formBean.getDB_NATURA2000() != null,
          formBean.getDB_CORINE() != null,
          formBean.getDB_DIPLOMA() != null,
          formBean.getDB_CDDA_NATIONAL() != null,
          formBean.getDB_CDDA_INTERNATIONAL() != null,
          formBean.getDB_BIOGENETIC() != null,
          false,
          formBean.getDB_EMERALD() != null
      };
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  CoordinatesPaginator paginator = new CoordinatesPaginator(new CoordinatesDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getUsername(), source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-coordinates-result.jsp";

  int resultsCount = 0;
  int pagesCount = 0;
  int guid = 0;
  List results = new ArrayList();
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
  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);

  String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-coordinates.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,coordinates#sites-coordinates.jsp,results";
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
      <%=cm.cms("sites_coordinates-result_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      // Change the operator list according to criteria selected element from criteria type list
      function changeCriteria() {
        var criteriaType = document.getElementById("criteriaType0").options[document.getElementById("criteriaType0").selectedIndex].value;
        var operList = document.getElementById("oper0");
        changeOperatorList(criteriaType, operList);
      }

      // Reconstruct the list items depending on the selected item
      function changeOperatorList(criteriaType, operList) {
        var SOURCE_DB = <%=CoordinatesSearchCriteria.CRITERIA_SOURCE_DB%>;
        var COUNTRY = <%=CoordinatesSearchCriteria.CRITERIA_COUNTRY%>;
        var NAME = <%=CoordinatesSearchCriteria.CRITERIA_ENGLISH_NAME%>;
        var SIZE = <%=CoordinatesSearchCriteria.CRITERIA_AREA%>;
        var LENGTH = <%=CoordinatesSearchCriteria.CRITERIA_LENGTH%>;
        removeElementsFromList(operList);
        var optIS = document.createElement("OPTION");
        optIS.text = "<%=cm.cms("is")%>";
        optIS.value = "<%=Utilities.OPERATOR_IS%>";
        var optSTART = document.createElement("OPTION");
        optSTART.text = "<%=cm.cms("starts")%>";
        optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
        var optCONTAIN = document.createElement("OPTION");
        optCONTAIN.text = "<%=cm.cms("contains")%>";
        optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
        var optGREAT = document.createElement("OPTION");
        optGREAT.text = "<%=cm.cms("greater")%>";
        optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
        var optSMALL = document.createElement("OPTION");
        optSMALL.text = "<%=cm.cms("smaller")%>";
        optSMALL.value = "<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>";
        // Source data set
        if (criteriaType == SOURCE_DB) {
          operList.add(optIS, 0);
          document.getElementById("binocular").style.visibility = "visible";
        }
        // Country
        if (criteriaType == COUNTRY) {
          operList.add(optIS, 0);
          document.getElementById("binocular").style.visibility = "visible";
        }
        // Site name
        if (criteriaType == NAME) {
          operList.add(optIS, 0);
          operList.add(optSTART, 1);
          operList.add(optCONTAIN, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
        // Site size
        if (criteriaType == SIZE) {
          operList.add(optIS, 0);
          operList.add(optGREAT, 1);
          operList.add(optSMALL, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
        // Site length
        if (criteriaType == LENGTH) {
          operList.add(optIS, 0);
          operList.add(optGREAT, 1);
          operList.add(optSMALL, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
      }
    //]]>
    </script>
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
                  <jsp:param name="location" value="<%=location%>"/>
                  <jsp:param name="mapLink" value="show"/>
                  <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1><%=cm.cmsPhrase("Sites coordinates")%></h1>
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
                <%=cm.cmsPhrase("You searched sites for which &nbsp;")%><%=formBean.getMainSearchCriteria().toHumanString()%> <%=cm.cmsPhrase("(dec. deg.)")%>
                <br />
                <%=cm.cmsPhrase("Results found")%> <strong><%=resultsCount%></strong>
                <br />
          <%
            Vector mapFields = new Vector();
            mapFields.addElement("criteriaSearch");
            mapFields.addElement("oper");
            mapFields.addElement("criteriaType");

            for (int i = 0; i < results.size(); i++)
            {
              CoordinatesPersist site = (CoordinatesPersist)results.get(i);
              String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
              String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
              if ( longitude.lastIndexOf( "n/a" ) < 0 && latitude.lastIndexOf( "n/a" ) < 0 )
              {
          %>
                <jsp:include page="sites-map.jsp">
                  <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
                  <jsp:param name="mapName" value="sites-coordinates-map.jsp"/>
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(mapFields)%>"/>
                </jsp:include>
          <%
                break;
              };
            }

            // Prepare parameters for pagesize.jsp
            Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
            pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
            pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
            pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
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
                <br class="brClear" />
                <div class="grey_rectangle_bold">
                  <%=cm.cmsPhrase("Refine your search")%>
                  <form title="refine search results" name="criteriaSearch" onsubmit="return(check(<%=noCriteria%>));" method="get" action="">
                    <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType0" class="noshow"><%=cm.cms("criteria")%></label>
                    <select id="criteriaType0" name="criteriaType" onchange="changeCriteria()" title="<%=cm.cms("criteria")%>">
          <%
            if ( showSourceDB )
            {
          %>
                      <option value="<%=CoordinatesSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
          <%
            }
            if ( showCountry )
            {
          %>
                      <option value="<%=CoordinatesSearchCriteria.CRITERIA_COUNTRY%>">
                        <%=cm.cms("country")%>
                      </option>
          <%
            }
          %>          <option value="<%=CoordinatesSearchCriteria.CRITERIA_ENGLISH_NAME%>">
                        <%=cm.cms("name")%>
                      </option>
          <%
            if ( showSize )
            {
          %>
                      <option value="<%=CoordinatesSearchCriteria.CRITERIA_AREA%>">
                        <%=cm.cms("size")%>
                      </option>
          <%
            }
          %>
                    </select>
                    <%=cm.cmsLabel("criteria")%>
                    <%=cm.cmsTitle("criteria")%>
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("country")%>
                    <%=cm.cmsInput("name")%>
                    <%=cm.cmsInput("size")%>

                    <select id="oper0" name="oper" title="<%=cm.cms("operator")%>">
                      <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cms("is")%>
                      </option>
                    </select>
                    <%=cm.cmsLabel("operator")%>
                    <%=cm.cmsTitle("operator")%>
                    <%=cm.cmsInput("is")%>

                    <label for="criteriaSearch0" class="noshow"><%=cm.cms("filter_value")%></label>
                    <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" title="<%=cm.cms("filter_value")%>" />
                    <%=cm.cmsLabel("filter_value")%>
                    <%=cm.cmsTitle("filter_value")%>

                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" border="0" width="11" height="18" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("list_of_values")%>
                    <%=cm.cmsAlt("list_of_values")%>

                    <input id="submit" name="Submit" type="submit" value="<%=cm.cms("search")%>" class="submitSearchButton" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </form>
          <%
            AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
            if (criterias.length > 1)
            {
          %>
                  <%=cm.cmsPhrase("Applied filters to the results:")%>
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
            navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
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
            AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_SOURCE_DB);
            AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_COUNTRY);
            AbstractSortCriteria sortName = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_NAME);
            AbstractSortCriteria sortSize = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_SIZE);
            AbstractSortCriteria sortLat = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_LAT);
            AbstractSortCriteria sortLong = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_LONG);
            AbstractSortCriteria sortYear = formBean.lookupSortCriteria(CoordinatesSortCriteria.SORT_YEAR);
          %>
                <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                  <thead>
                    <tr>
          <%
            if ( showSourceDB )
            {
          %>
                       <th scope="col">
                         <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                         <%=cm.cmsTitle("sort_results_on_this_column")%>
                       </th>
          <%
            }
            if ( showCountry )
            {
          %>
                       <th scope="col">
                         <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                         <%=cm.cmsTitle("sort_results_on_this_column")%>
                       </th>
          <%
            }
          %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
          <%
            if ( showDesignType )
            {
          %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Designation type")%>
                        </th>
          <%
            }
            if ( showCoord )
            {
          %>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsPhrase("Longitude")%>
                        </th>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsPhrase("Latitude")%>
                        </th>
          <%
            }
            if ( showSize )
            {
          %>
                        <th scope="col" style="text-align : right;">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Area(ha)")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
          <%
            }
          %>
                        <th scope="col" style="text-align : right;">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
          <%
            for (int i = 0; i < results.size(); i++)
            {
              String cssClass = i % 2 == 0 ? " class=\"zebraeven\"" : "";
              CoordinatesPersist site = (CoordinatesPersist)results.get(i);
          %>
                      <tr<%=cssClass%>>
          <%
              if ( showSourceDB )
              {
          %>
                        <td>
                          <strong>
                            <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
                          </strong>
                        </td>
          <%
              }
              if ( showCountry )
              {
          %>
                        <td>
                          <%=site.getAreaNameEn()%>
                        </td>
          <%
              }
          %>
                        <td>
                          <a href="sites/<%=site.getIdSite()%>"><%=site.getName()%></a>
                        </td>
          <%
              if ( showDesignType )
              {
          %>
                        <td>
                          <jsp:include page="sites-designations-detail.jsp">
                            <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
                            <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
                            <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
                            <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
                          </jsp:include>
                        </td>
          <%
              }
              if ( showCoord )
              {
          %>
                        <td style="text-align : center; white-space : nowrap">
                          <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
                        </td>
                        <td style="text-align : center; white-space : nowrap">
                          <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
                        </td>
          <%
              }
              if ( showSize )
              {
          %>
                        <td style="text-align : right;">
                          <%=Utilities.formatArea(site.getArea(), 9, 2, "&nbsp;")%>
                        </td>
          <%
              }
          %>
                        <td style="text-align : right;">
                          <%=SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB())%>
                        </td>
                      </tr>
          <%
            }
          %>
                    </tbody>
                  <thead>
                    <tr>
          <%
            if ( showSourceDB )
            {
          %>
                       <th scope="col">
                         <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                         <%=cm.cmsTitle("sort_results_on_this_column")%>
                       </th>
          <%
            }
            if ( showCountry )
            {
          %>
                       <th scope="col">
                         <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                         <%=cm.cmsTitle("sort_results_on_this_column")%>
                       </th>
          <%
            }
          %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
          <%
            if ( showDesignType )
            {
          %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Designation type")%>
                        </th>
          <%
            }
            if ( showCoord )
            {
          %>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsPhrase("Longitude")%>
                        </th>
                        <th scope="col" style="text-align : center; white-space:nowrap;">
                          <%=cm.cmsPhrase("Latitude")%>
                        </th>
          <%
            }
            if ( showSize )
            {
          %>
                        <th scope="col" style="text-align : right;">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Area(ha)")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
          <%
            }
          %>
                        <th scope="col" style="text-align : right;">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CoordinatesSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
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
                <%=cm.cmsMsg("sites_coordinates-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_results")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("is")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("starts")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("contains")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("greater")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("smaller")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-coordinates-result.jsp" />
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
