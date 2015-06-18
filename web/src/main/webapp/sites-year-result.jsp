<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites year" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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

  SourceDb sourceDb = SourceDb.fromArray(source);

  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  YearPaginator paginator = new YearPaginator(new YearDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),sourceDb));
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

  WebContentManagement cm = SessionManager.getWebContent();
  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-year.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_year#sites-year.jsp,results";
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
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("sites_year-result_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="sites-help.jsp" pageTitle="${title}" downloadLink="<%= tsvLink%>" btrail="<%= location%>">
<stripes:layout-component name="head">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-names.js"></script>
    <script language="JavaScript" type="text/javascript">
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
          optIS.text = "<%=cm.cmsPhrase("is")%>";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "<%=cm.cms("starts")%>";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "<%=cm.cmsPhrase("contains")%>";
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
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
          <%=cm.cmsPhrase("Site designation year")%>
        </h1>
<!-- MAIN CONTENT -->
                <%=cm.cmsPhrase("You searched sites with designation year")%>
                <strong>
                  <%=formBean.getMainSearchCriteria().toHumanString()%>
                </strong>
                <br />
                <%=cm.cmsPhrase("Results found")%>
                <strong>
                  <%=resultsCount%>
                </strong>
                <br />
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
                <br />
                <div class="grey_rectangle">
                  <strong>
                    <%=cm.cmsPhrase("Refine your search")%>
                  </strong>
                  <form title="refine search results" name="criteriaSearch" onsubmit="return(check(<%=noCriteria%>));" method="get" action="">
                  <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType0" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                    <select id="criteriaType0" name="criteriaType" onchange="changeCriteria()" title="<%=cm.cmsPhrase("Criteria")%>">
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
                        <%=cm.cmsPhrase("Country")%>
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
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("name")%>
                    <%=cm.cmsInput("size")%>
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
                <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            if(showDesignType)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Designation type")%>
                      </th>
          <%
            }
            if (showCoord)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LONG%>&amp;ascendency=<%=formBean.changeAscendency(sortLong, null == sortLong)%>"><%=Utilities.getSortImageTag(sortLong)%><%=cm.cmsPhrase("Longitude")%></a>
                      </th>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LAT%>&amp;ascendency=<%=formBean.changeAscendency(sortLat, null == sortLat)%>"><%=Utilities.getSortImageTag(sortLat)%><%=cm.cmsPhrase("Latitude")%></a>
                      </th>
          <%
            }
            if (showSize)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
          <%
            Iterator it = results.iterator();
            int i = 0;
            while (it.hasNext())
            {
              YearPersist site = (YearPersist)it.next();
          %>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <td>
                        <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
                      </td>
          <%
            }
            if (showCountry)
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
            if (showCoord)
            {
          %>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatLongitude(site.getLongitude())%>
                    </td>
                    <td style="white-space : nowrap; text-align : center;">
                      <%=SitesSearchUtility.formatLatitude(site.getLatitude())%>
                    </td>
          <%
            }
            if (showSize)
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
            if (showSourceDB)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            if(showDesignType)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Designation type")%>
                      </th>
          <%
            }
            if (showCoord)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LONG%>&amp;ascendency=<%=formBean.changeAscendency(sortLong, null == sortLong)%>"><%=Utilities.getSortImageTag(sortLong)%><%=cm.cmsPhrase("Longitude")%></a>
                      </th>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_LAT%>&amp;ascendency=<%=formBean.changeAscendency(sortLat, null == sortLat)%>"><%=Utilities.getSortImageTag(sortLat)%><%=cm.cmsPhrase("Latitude")%></a>
                      </th>
          <%
            }
            if (showSize)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=YearSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
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

                <%=cm.cmsMsg("starts")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("greater")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("smaller")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_year-result_title")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
