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

  String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-altitude.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
 
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
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
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_altitude-result_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_altitude_location#sites-altitude.jsp,results_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
      <%--      <jsp:param name="printLink" value="<%=printLink%>"/>--%>
      <h1>
        <%=cm.cmsText("sites_altitude-result_01")%>
      </h1>
      <%=cm.cmsText("sites_altitude-result_02")%> <%=formBean.getMainSearchCriteria().toHumanString()%>
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
      <br />
      <%=cm.cmsText("sites_altitude-result_04")%> <strong><%=resultsCount%></strong><br />
<%
  Vector mapFields = new Vector();
  mapFields.addElement("criteriaSearch");
  mapFields.addElement("oper");
  mapFields.addElement("criteriaType");

  for (int i = 0; i < results.size(); i++)
  {
    AltitudePersist site = (AltitudePersist)results.get( i );
    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
    if ( longitude.lastIndexOf( "n/a" ) < 0 && latitude.lastIndexOf( "n/a" ) < 0 )
    {
%>
      <jsp:include page="sites-map.jsp">
        <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
        <jsp:param name="mapName" value="sites-altitude-map.jsp"/>
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
        <%=cm.cmsText("sites_altitude-result_05")%>
        <br />
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType0" class="noshow"><%=cm.cms("criteria_type_label")%></label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField" onchange="changeCriteria()" title="<%=cm.cms("criteria_type_title")%>">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=cm.cms("sites_altitude-result_06")%>
            </option>
<%
  }
  if (showName)
  {
%>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=cm.cms("sites_altitude-result_07")%>
            </option>
<%
  }
  if (showAltitude)
  {
%>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MEAN%>">
              <%=cm.cms("sites_altitude-result_08")%>
            </option>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MIN%>">
              <%=cm.cms("sites_altitude-result_09")%>
            </option>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_ALTITUDE_MAX%>">
              <%=cm.cms("sites_altitude-result_10")%>
            </option>
<%
  }
  if (showCountry)
  {
%>
            <option value="<%=AltitudeSearchCriteria.CRITERIA_COUNTRY%>">
              <%=cm.cms("sites_altitude-result_11")%>
            </option>
<%
  }
%>
          </select>
          <%=cm.cmsLabel("criteria_type_label")%>
          <%=cm.cmsTitle("criteria_type_title")%>
          <%=cm.cmsInput("sites_designations-result_09")%>
          <%=cm.cmsInput("sites_altitude-result_07")%>
          <%=cm.cmsInput("sites_altitude-result_08")%>
          <%=cm.cmsInput("sites_altitude-result_09")%>
          <%=cm.cmsInput("sites_altitude-result_10")%>
          <%=cm.cmsInput("sites_altitude-result_11")%>

          <label for="oper0" class="noshow"><%=cm.cms("operator_label")%></label>
          <select id="oper0" name="oper" class="inputTextField" title="<%=cm.cms("operator_title")%>">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
              <%=cm.cms("sites_altitude-result_12")%>
            </option>
          </select>
          <%=cm.cmsLabel("operator_label")%>
          <%=cm.cmsTitle("operator_title")%>
          <%=cm.cmsInput("sites_altitude-result_12")%>

          <label for="criteriaSearch0" class="noshow"><%=cm.cms("filter_label")%></label>
          <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" class="inputTextField" title="<%=cm.cms("filter_title")%>" />
          <%=cm.cmsLabel("filter_label")%>
          <%=cm.cmsTitle("filter_title")%>

          <a title="<%=cm.cms("refine_lov_title")%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cms("refine_lov_alt")%>" border="0" width="11" height="18" align="middle" /></a>
          <%=cm.cmsTitle("refine_lov_title")%>
          <%=cm.cmsAlt("refine_lov_alt")%>

          <label for="submit" class="noshow"><%=cm.cms("refine_btn_label")%></label>
          <input id="submit" name="Submit" type="submit" value="<%=cm.cms("refine_btn_value")%>" class="inputTextField" title="<%=cm.cms("refine_btn_title")%>" />
          <%=cm.cmsLabel("refine_btn_label")%>
          <%=cm.cmsTitle("refine_btn_title")%>
          <%=cm.cmsInput("refine_btn_value")%>
        </form>
        <%-- This is the code which shows the search filters --%>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=cm.cmsText("sites_altitude-result_14")%>
        <br />
<%
  }
  for (int i = criterias.length - 1; i > 0; i--)
  {
    AbstractSearchCriteria criteria = criterias[i];
    if (null != criteria && null != formBean.getCriteriaSearch())
    {
%>
        <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("removefilter_alt")%>" border="0" align="middle" /></a>
        <%=cm.cmsTitle("removefilter_title")%>
        <%=cm.cmsAlt("removefilter_alt")%>
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
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency( sortSourceDB, null == sortSourceDB )%>"><%=Utilities.getSortImageTag( sortSourceDB )%><%=cm.cmsText("sites_altitude-result_15")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency( sortCountry, null == sortCountry )%>"><%=Utilities.getSortImageTag( sortCountry )%><%=cm.cmsText("sites_altitude-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency( sortName, null == sortName )%>"><%=Utilities.getSortImageTag( sortName )%><%=cm.cmsText("sites_altitude-result_16")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_altitude-result_17")%>
          </th>
<%
  }
  if (showCoordinates)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_altitude-result_18")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_altitude-result_19")%>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MEAN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMean, sortAltitudeMean == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMean)%><%=cm.cmsText("sites_altitude-result_08")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MIN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMin, sortAltitudeMin == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMin)%><%=cm.cmsText("sites_altitude-result_20")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
           <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MAX%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMax, sortAltitudeMax == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMax)%><%=cm.cmsText("sites_altitude-result_21")%></a>
             <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if (showYear)
  {
%>
          <th class="resultHeader" style="text-align : right">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("sites_altitude-result_22")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
        </tr>
<%
  Iterator it = results.iterator();
  String bgColor;
  for (int i = 0; i < results.size(); i++)
  {
    bgColor = 0 == i % 2 ? "#EEEEEE" : "#FFFFFF";
    AltitudePersist site = (AltitudePersist)it.next();
%>
        <tr>
<%
    if (showSourceDB)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <strong>
              <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()),"&nbsp;")%>
            </strong>
          </td>
<%
    }
    if (showCountry)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <%=Utilities.formatString(site.getCountry(),"&nbsp;")%>
          </td>
<%
    }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString( site.getName(), "&nbsp;" )%></a>
            <%=cm.cmsTitle("open_site_factsheet")%>
          </td>
<%
    if (showDesignType)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <jsp:include page="sites-designations-detail.jsp">
              <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
              <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
              <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
              <jsp:param name="bgcolor" value="<%=bgColor%>"/>
              <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
            </jsp:include>
          </td>
<%
    }
    if (showCoordinates)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
          </td>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
          </td>
<%
    }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
             <%=Utilities.formatString(site.getAltMean(),"&nbsp;")%>
          </td>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=Utilities.formatString(site.getAltMin(),"&nbsp;")%>
          </td>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=Utilities.formatString(site.getAltMax(),"&nbsp;")%>
          </td>
<%
    if (showYear)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
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
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency( sortSourceDB, null == sortSourceDB )%>"><%=Utilities.getSortImageTag( sortSourceDB )%><%=cm.cmsText("sites_altitude-result_15")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency( sortCountry, null == sortCountry )%>"><%=Utilities.getSortImageTag( sortCountry )%><%=cm.cmsText("sites_altitude-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency( sortName, null == sortName )%>"><%=Utilities.getSortImageTag( sortName )%><%=cm.cmsText("sites_altitude-result_16")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_altitude-result_17")%>
          </th>
<%
  }
  if (showCoordinates)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_altitude-result_18")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_altitude-result_19")%>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MEAN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMean, sortAltitudeMean == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMean)%><%=cm.cmsText("sites_altitude-result_08")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MIN%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMin, sortAltitudeMin == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMin)%><%=cm.cmsText("sites_altitude-result_20")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_ALTITUDE_MAX%>&amp;ascendency=<%=formBean.changeAscendency(sortAltitudeMax, sortAltitudeMax == null )%>"><%=Utilities.getSortImageTag(sortAltitudeMax)%><%=cm.cmsText("sites_altitude-result_21")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if (showYear)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AltitudeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("sites_altitude-result_22")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
        </tr>
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
      <%=cm.cmsMsg("search_results")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-altitude-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>