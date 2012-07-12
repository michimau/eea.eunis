<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites altitude" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.sites.altitude.AltitudePaginator,
                 ro.finsiel.eunis.jrfTables.sites.altitude.AltitudeDomain,
                 ro.finsiel.eunis.jrfTables.sites.altitude.AltitudePersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.altitude.AltitudeBean,
                 ro.finsiel.eunis.search.sites.altitude.AltitudeSearchCriteria,
                 ro.finsiel.eunis.search.sites.altitude.AltitudeSortCriteria,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.SitesSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.altitude.AltitudeBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  // Prepare the search in results
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
 // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), AltitudeBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), AltitudeBean.HIDE);
  boolean showCoordinates = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), AltitudeBean.HIDE);
  boolean showAltitude  = Utilities.checkedStringToBoolean(formBean.getShowAltitude(), AltitudeBean.HIDE);
  boolean showCountry  = Utilities.checkedStringToBoolean(formBean.getShowCountry(), AltitudeBean.HIDE);
  boolean showYear  = Utilities.checkedStringToBoolean(formBean.getShowYear(), AltitudeBean.HIDE);
  // Contains true values if proper sourceDB checkbox was check
  boolean[] source =
      {
          formBean.getDB_NATURA2000() != null,
          formBean.getDB_CORINE() != null,
          formBean.getDB_DIPLOMA() != null,
          formBean.getDB_CDDA_NATIONAL() != null,
          formBean.getDB_CDDA_INTERNATIONAL() != null,
          formBean.getDB_BIOGENETIC() != null,
          false,
          formBean.getDB_EMERALD()!= null
      };
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  AltitudePaginator paginator = new AltitudePaginator(new AltitudeDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int guid = 0;// This is used in @page include...
  final String pageName = "sites-altitude-result.jsp";
  int resultsCount = 0, pagesCount = 0;
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
  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  WebContentManagement cm = SessionManager.getWebContent();
  String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-altitude.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,altitude#sites-altitude.jsp,results";
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
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-names.js"></script>
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
          var SOURCE_DB = <%=SitesSearchCriteria.CRITERIA_SOURCE_DB%>;
          var COUNTRY = <%=SitesSearchCriteria.CRITERIA_COUNTRY%>;
          var NAME = <%=SitesSearchCriteria.CRITERIA_ENGLISH_NAME%>;
          var MEAN_ALTITUDE = <%=SitesSearchCriteria.CRITERIA_ALTITUDE_MEAN%>;
          var MIN_ALTITUDE = <%=SitesSearchCriteria.CRITERIA_ALTITUDE_MIN%>;
          var MAX_ALTITUDE = <%=SitesSearchCriteria.CRITERIA_ALTITUDE_MAX%>;
          removeElementsFromList(operList);
          var optIS = document.createElement("OPTION");
          optIS.text = "is";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "starts";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "contains";
          optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
          var optGREAT = document.createElement("OPTION");
          optGREAT.text = "greater";
          optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
          var optSMALL = document.createElement("OPTION");
          optSMALL.text = "smaller";
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
          // Site mean altitude
          if (criteriaType == MEAN_ALTITUDE) {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
            document.getElementById("binocular").style.visibility = "visible";
          }
          // Site min altitude
          if (criteriaType == MIN_ALTITUDE) {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
            document.getElementById("binocular").style.visibility = "visible";
          }
          // Site max altitude
          if (criteriaType == MAX_ALTITUDE) {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
            document.getElementById("binocular").style.visibility = "visible";
          }
        }
      //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_altitude-result_title")%>
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
                  <jsp:param name="location" value="<%=location%>"/>
                  <jsp:param name="mapLink" value="show"/>
                  <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("Site altitude")%>
                </h1>
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
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
                <%=cm.cmsPhrase("You searched sites for which")%> <%=formBean.getMainSearchCriteria().toHumanString()%>
                <br />
                <%=cm.cmsPhrase("Results found")%> <strong><%=resultsCount%></strong><br />
          <%
            Vector mapFields = new Vector();
            mapFields.addElement("criteriaSearch");
            mapFields.addElement("oper");
            mapFields.addElement("criteriaType");

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
                <br class="brClear" />
                <div class="grey_rectangle_bold">
                  <%=cm.cmsPhrase("Refine your search")%>
                  <br />
                  <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
                  <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType0" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                    <select id="criteriaType0" name="criteriaType" onchange="changeCriteria()" title="<%=cm.cmsPhrase("Criteria")%>">
          <%
            if (showSourceDB)
            {
          %>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
          <%
            }
            if (showName)
            {
          %>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_ENGLISH_NAME%>">
                        <%=cm.cms("name")%>
                      </option>
          <%
            }
            if (showAltitude)
            {
          %>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MEAN%>">
                        <%=cm.cms("mean_altitude_m")%>
                      </option>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MIN%>">
                        <%=cm.cms("minimum_altitude")%>
                      </option>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MAX%>">
                        <%=cm.cms("maximum_altitude_m")%>
                      </option>
          <%
            }
            if (showCountry)
            {
          %>
                      <option value="<%=AltitudeSearchCriteria.CRITERIA_COUNTRY%>">
                        <%=cm.cmsPhrase("Country")%>
                      </option>
          <%
            }
          %>
                    </select>
                    <%=cm.cmsInput("name")%>
                    <%=cm.cmsInput("mean_altitude_m")%>
                    <%=cm.cmsInput("minimum_altitude")%>
                    <%=cm.cmsInput("maximum_altitude_m")%>

                    <select id="oper0" name="oper" title="<%=cm.cmsPhrase("Operator")%>">
                      <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cmsPhrase("is")%>
                      </option>
                    </select>

                    <label for="criteriaSearch0" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                    <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" title="<%=cm.cmsPhrase("Filter value")%>" />

                    <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cmsPhrase("List of values")%>" border="0" width="11" height="18" style="vertical-align:middle" /></a>

                    <input id="submit" name="Submit" type="submit" value="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                  </form>
                  <%-- This is the code which shows the search filters --%>
          <%
            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
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
            Vector sortURLFields = new Vector();
            sortURLFields.addElement("pageSize");
            sortURLFields.addElement("criteriaSearch");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_SOURCE_DB);
            AbstractSortCriteria sortName = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_NAME);
            AbstractSortCriteria sortAltitudeMean = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_ALTITUDE_MEAN);
            AbstractSortCriteria sortAltitudeMin = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_ALTITUDE_MIN);
            AbstractSortCriteria sortAltitudeMax = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_ALTITUDE_MAX);
            AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_COUNTRY);
            AbstractSortCriteria sortLat = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_LAT);
            AbstractSortCriteria sortLong = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_LONG);
            AbstractSortCriteria sortYear = formBean.lookupSortCriteria(AltitudeSortCriteria.SORT_YEAR);
          %>
                <br />
                <br />
                <table class="sortable" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency( sortSourceDB, null == sortSourceDB )%>"><%=Utilities.getSortImageTag( sortSourceDB )%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency( sortCountry, null == sortCountry )%>"><%=Utilities.getSortImageTag( sortCountry )%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
          %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency( sortName, null == sortName )%>"><%=Utilities.getSortImageTag( sortName )%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            if (showDesignType)
            {
          %>
                      <th scope="col">
                        <%=cm.cmsPhrase("Designation type")%>
                      </th>
          <%
            }
            if (showCoordinates)
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
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MEAN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMean, sortAltitudeMean == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMean)%><%=cm.cmsPhrase("Mean Altitude(m)")%></a>
                      </th>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MIN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMin, sortAltitudeMin == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMin)%><%=cm.cmsPhrase("Min Altitude(m)")%></a>
                      </th>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MAX%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMax, sortAltitudeMax == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMax)%><%=cm.cmsPhrase("Max Altitude(m)")%></a>
                      </th>
          <%
            if (showYear)
            {
          %>
                      <th scope="col" style="text-align : right">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                  <tbody>
          <%
            Iterator it = results.iterator();
            for (int i = 0; i < results.size(); i++)
            {
              String cssClass = i % 2 == 0 ? " class=\"zebraeven\"" : "";
              AltitudePersist site = (AltitudePersist)it.next();
          %>
                    <tr<%=cssClass%>>
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
              if (showCountry)
              {
          %>
                    <td>
                      <%=Utilities.formatString(site.getCountry(),"&nbsp;")%>
                    </td>
          <%
              }
          %>
                    <td>
                      <a href="sites/<%=site.getIdSite()%>"><%=Utilities.formatString( site.getName(), "&nbsp;" )%></a>
                    </td>
          <%
              if (showDesignType)
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
              if (showCoordinates)
              {
          %>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
                    </td>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
                    </td>
          <%
              }
          %>
                    <td style="text-align : right;">
                       <%=Utilities.formatString(site.getAltMean(),"&nbsp;")%>
                    </td>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(site.getAltMin(),"&nbsp;")%>
                    </td>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(site.getAltMax(),"&nbsp;")%>
                    </td>
          <%
              if (showYear)
              {
          %>
                    <td style="text-align : center;">
                      <%=Utilities.formatString( site.getYear(), "&nbsp;" )%>
                      <%=SitesSearchUtility.parseDesignationYear(site.getYear(), site.getSourceDB())%>
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
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency( sortSourceDB, null == sortSourceDB )%>"><%=Utilities.getSortImageTag( sortSourceDB )%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency( sortCountry, null == sortCountry )%>"><%=Utilities.getSortImageTag( sortCountry )%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
          %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency( sortName, null == sortName )%>"><%=Utilities.getSortImageTag( sortName )%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            if (showDesignType)
            {
          %>
                      <th scope="col">
                        <%=cm.cmsPhrase("Designation type")%>
                      </th>
          <%
            }
            if (showCoordinates)
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
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MEAN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMean, sortAltitudeMean == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMean)%><%=cm.cmsPhrase("Mean Altitude(m)")%></a>
                      </th>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MIN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMin, sortAltitudeMin == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMin)%><%=cm.cmsPhrase("Min Altitude(m)")%></a>
                      </th>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MAX%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMax, sortAltitudeMax == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMax)%><%=cm.cmsPhrase("Max Altitude(m)")%></a>
                      </th>
          <%
            if (showYear)
            {
          %>
                      <th scope="col" style="text-align : right">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
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

                <%=cm.cmsMsg("sites_altitude-result_title")%>
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
                <jsp:param name="page_name" value="sites-altitude-result.jsp" />
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
