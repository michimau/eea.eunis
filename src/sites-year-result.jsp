<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites year" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.year.YearBean,
                 ro.finsiel.eunis.search.sites.year.YearPaginator,
                 ro.finsiel.eunis.search.sites.year.YearSearchCriteria,
                 ro.finsiel.eunis.search.sites.year.YearSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.year.YearPersist,
                 ro.finsiel.eunis.jrfTables.sites.year.YearDomain,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.search.sites.SitesSearchCriteria"%>
<%@ page import="java.util.ArrayList"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.year.YearBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), YearBean.HIDE);
  boolean showCountry = Utilities.checkedStringToBoolean(formBean.getShowCountry(), YearBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), YearBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), YearBean.HIDE);
  boolean showSize = Utilities.checkedStringToBoolean(formBean.getShowSize(), YearBean.HIDE);
  boolean[] source = {
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
  YearPaginator paginator = new YearPaginator(new YearDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)

  int resultsCount = 0;
  final String pageName = "sites-year-result.jsp";
  int pagesCount = 0;
  int guid = 0;// This is used in @page include...
  List results = new ArrayList();
  try
  {
    resultsCount = paginator.countResults();
    pagesCount = paginator.countPages();// This is used in @page include...
    results = paginator.getPage(currentPage);
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);

  String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-year.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
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
          var SIZE = <%=SitesSearchCriteria.CRITERIA_SIZE%>;
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
        }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_year-result_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,designation_year#sites-year.jsp,results"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
<%--      <jsp:param name="printLink" value="<%=printLink%>"/>--%>
      <h1>
        <%=cm.cmsText("site_designation_year")%>
      </h1>
      <%=cm.cmsText("sites_year-result_06")%>
      <strong>
        <%=formBean.getMainSearchCriteria().toHumanString()%>
      </strong>
<%
    if (results.isEmpty())
    {
       boolean fromRefine = false;
       if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
         fromRefine = true;

%>
       <br />
       <jsp:include page="noresults.jsp" >
         <jsp:param name="fromRefine" value="<%=fromRefine%>" />
       </jsp:include>
<%
         return;
     }
%>
      <br />
      <%=cm.cmsText("results_found_1")%>
      <strong>
        <%=resultsCount%>
      </strong>
      <br />
<%
  Vector mapFields = new Vector();
  mapFields.addElement("criteriaSearch");
  mapFields.addElement("oper");
  mapFields.addElement("criteriaType");

  for (int i = 0; i < results.size(); i++)
  {
    YearPersist site = (YearPersist)results.get( i );
    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
    if ( longitude.lastIndexOf( "n/a" ) < 0 && latitude.lastIndexOf( "n/a" ) < 0 )
    {
%>
      <jsp:include page="sites-map.jsp">
        <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
        <jsp:param name="mapName" value="sites-year-map.jsp"/>
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
      <br />
      <div class="grey_rectangle">
        <strong>
          <%=cm.cmsText("refine_your_search")%>
        </strong>
        <form title="refine search results" name="criteriaSearch" onsubmit="return(check(<%=noCriteria%>));" method="get" action="">
        <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType0" class="noshow"><%=cm.cms("criteria")%></label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField" onchange="changeCriteria()" title="<%=cm.cms("criteria")%>">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=YearSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=cm.cms("database_source")%>
            </option>
<%
  }
  if (showCountry)
  {
%>
            <option value="<%=YearSearchCriteria.CRITERIA_COUNTRY%>">
              <%=cm.cms("country")%>
            </option>
<%
  }
  if (showName)
  {
%>
            <option value="<%=YearSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=cm.cms("name")%>
            </option>
<%
  }
  if (showSize)
  {
%>
            <option value="<%=YearSearchCriteria.CRITERIA_SIZE%>">
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
          <label for="oper0" class="noshow"><%=cm.cms("operator")%></label>
          <select id="oper0" name="oper" class="inputTextField" title="<%=cm.cms("operator")%>">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
              <%=cm.cms("is")%>
            </option>
          </select>
          <%=cm.cmsLabel("operator")%>
          <%=cm.cmsTitle("operator")%>
          <%=cm.cmsInput("is")%>
          <label for="criteriaSearch0" class="noshow"><%=cm.cms("filter_value")%></label>
          <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" class="inputTextField" title="<%=cm.cms("filter_value")%>" />
          <%=cm.cmsLabel("filter_value")%>
          <%=cm.cmsTitle("filter_value")%>

          <a title="<%=cm.cms("list_of_values")%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" border="0" width="11" height="18" style="vertical-align:middle" /></a>
          <%=cm.cmsTitle("list_of_values")%>
          <%=cm.cmsAlt("list_of_values")%>

          <input id="submit" name="Submit" type="submit" value="<%=cm.cms("search")%>" class="inputTextField" title="<%=cm.cms("search")%>" />
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
        <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete")%>"  border="0" style="vertical-align:middle" /></a>
        <%=cm.cmsTitle("removefilter_title")%>
        <%=cm.cmsAlt("delete")%>
        <strong><%= i + ". " + criteria.toHumanString()%></strong>
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
        navigatorFormFields.addElement("criteriaSearch");%>
        <jsp:include page="navigator.jsp">
          <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
          <jsp:param name="pageName" value="<%=pageName%>"/>
          <jsp:param name="guid" value="<%=guid%>"/>
          <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
          <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
          <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
        </jsp:include>
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(YearSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(YearSortCriteria.SORT_COUNTRY);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(YearSortCriteria.SORT_NAME);
  AbstractSortCriteria sortSize = formBean.lookupSortCriteria(YearSortCriteria.SORT_SIZE);
  //AbstractSortCriteria sortDesign = formBean.lookupSortCriteria(YearSortCriteria.SORT_DESIGN);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(YearSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(YearSortCriteria.SORT_LONG);
  AbstractSortCriteria sortYear = formBean.lookupSortCriteria(YearSortCriteria.SORT_YEAR);
%>
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if(showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("designation_type")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LONG%>&amp;ascendency=<%=formBean.changeAscendency(sortLong, null == sortLong)%>"><%=Utilities.getSortImageTag(sortLong)%><%=cm.cmsText("longitude")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LAT%>&amp;ascendency=<%=formBean.changeAscendency(sortLat, null == sortLat)%>"><%=Utilities.getSortImageTag(sortLat)%><%=cm.cmsText("latitude")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size_ha")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("designation_year")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
        </tr>
<%
  Iterator it = results.iterator();
  int i = 0; String bgColor;
  while (it.hasNext())
  {
    bgColor = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
    YearPersist site = (YearPersist)it.next();
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <strong>
              <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
            </strong>
          </td>
<%
  }
  if (showCountry)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <%=site.getAreaNameEn()%>
          </td>
<%
  }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a>
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
  if (showCoord)
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
  if (showSize)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=Utilities.formatArea(site.getArea(), 9, 2, "&nbsp;")%>
          </td>
<%
  }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB())%>
          </td>
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
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if(showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("designation_type")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("longitude")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("latitude")%>
          </th>
<%
  }
  if (showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size_ha")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("designation_year")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
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

      <%=cm.cmsMsg("is")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("starts")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("contains")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("greater")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("smaller")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("search_results")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-year-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>