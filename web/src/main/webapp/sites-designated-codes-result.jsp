<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
- Description : "Sites by designation types" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.designation_code.DesignationPaginator,
                 ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.designation_code.DesignationBean,
                 ro.finsiel.eunis.search.sites.designation_code.DesignationSearchCriteria,
                 ro.finsiel.eunis.search.sites.designation_code.DesignationSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.designation_code.DesignationBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
//      Utilities.dumpRequestParams(request);
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), DesignationBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), DesignationBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), DesignationBean.HIDE);
  boolean showSize = Utilities.checkedStringToBoolean(formBean.getShowSize(), DesignationBean.HIDE);
  boolean showYear  = Utilities.checkedStringToBoolean(formBean.getShowYear(), true);
  boolean showCountry  = Utilities.checkedStringToBoolean(formBean.getShowCountry(), DesignationBean.HIDE);
  // Contains true values if proper sourceDB checkbox was check
  boolean[] source = {
      formBean.getDB_NATURA2000() != null ,
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
  DesignationPaginator paginator = new DesignationPaginator(new DesignationDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-designated-codes-result.jsp";

  int resultsCount = 0;
  int pagesCount = 0;
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = new ArrayList();
  try
  {
    resultsCount = paginator.countResults();
    pagesCount = paginator.countPages();
    results = paginator.getPage(currentPage);
  }
  catch ( Exception ex )
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

  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-designated-codes.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,sites_designated_codes_location#sites-designated-codes.jsp,results";
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
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("sites_designated-codes-result_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="sites-help.jsp" pageTitle="${title}" downloadLink="<%= tsvLink%>" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-designated-codes.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">

        <a name="documentContent"></a>
        <h1>
          <%=cm.cmsPhrase("Sites by designation types")%>
        </h1>
<!-- MAIN CONTENT -->
                <%=((DesignationSearchCriteria)formBean.getMainSearchCriteria()).toHumanStringMain()%>
                <br />
                Results found: <strong><%=resultsCount%></strong><br />

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
                  <%=cm.cmsPhrase("Refine your search")%>
                  <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
                    <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType0" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                    <select id="criteriaType0" name="criteriaType" title="<%=cm.cmsPhrase("Criteria")%>">
          <%
            if (showSourceDB)
            {
          %>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
          <%
            }
            if (showName)
            {
          %>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_ENGLISH_NAME%>">
                        <%=cm.cms("site_name")%>
                      </option>
          <%
            }
            if (showDesignType)
            {
          %>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_DESIGN_TYPE%>">
                        <%=cm.cms("designation_name")%>
                      </option>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_DESIGN_TYPE_EN%>">
                        <%=cm.cms("english_designation_name")%>
                      </option>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_DESIGN_TYPE_FR%>">
                        <%=cm.cms("french_designation_name")%>
                      </option>
          <%
            }
            if (showCountry)
            {
          %>
                      <option value="<%=DesignationSearchCriteria.CRITERIA_COUNTRY%>">
                        <%=cm.cmsPhrase("Country")%>
                      </option>
          <%
            }
          %>
                    </select>
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("site_name")%>
                    <%=cm.cmsInput("designation_name")%>
                    <%=cm.cmsInput("english_designation_name")%>
                    <%=cm.cmsInput("french_designation_name")%>

                    <select id="oper0" name="oper" title="<%=cm.cmsPhrase("Operator")%>">
                      <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cmsPhrase("is")%>
                      </option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>">
                        <%=cm.cmsPhrase("starts with")%>
                      </option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                        <%=cm.cmsPhrase("contains")%>
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
                  <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete")%>" border="0" style="vertical-align:middle" /></a>
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
                AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_SOURCE_DB);
                AbstractSortCriteria sortName = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_NAME);
                AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_COUNTRY);
                AbstractSortCriteria sortLat = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_LAT);
                AbstractSortCriteria sortLong = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_LONG);
                AbstractSortCriteria sortYear = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_YEAR);
                AbstractSortCriteria sortSize = formBean.lookupSortCriteria(DesignationSortCriteria.SORT_SIZE);
          %>
                <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
            if (showName)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            }
            if (showDesignType)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Designation name")%>
                      </th>
          <%
            }
            if (showCoord)
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
            if(showSize)
            {
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
            if (showYear)
            {
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                  <tbody>
          <%
            Iterator it = results.iterator();
            int i = 0;
            while (it.hasNext())
            {
              DesignationPersist site = (DesignationPersist)it.next();
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
              if (showCountry)
              {
          %>
                    <td>
                      <%=Utilities.formatString(site.getCountry(),"&nbsp;")%>
                    </td>
          <%
              }
              if (showName)
              {
          %>
                    <td>
                      <a href="sites/<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
                    </td>

          <%
              }
            if (showDesignType)
            {
          %>
                    <td>
                      <jsp:include page="sites-designations-detail.jsp">
                        <jsp:param name="idDesignation" value="<%=site.getIdDesign()%>"/>
                        <jsp:param name="idGeoscope" value="<%=site.getGeoscope()%>"/>
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
              if (showYear)
              {
          %>
                    <td style="text-align : right;">
                      <%=Utilities.formatString(SitesSearchUtility.parseDesignationYear(site.getDesignationDate(),site.getSourceDB()),"&nbsp;")%>
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
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                      </th>
          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
            if (showName)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            }
            if (showDesignType)
            {
          %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Designation name")%>
                      </th>
          <%
            }
            if (showCoord)
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
            if(showSize)
            {
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
            if (showYear)
            {
          %>
                      <th scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsPhrase("Designation year")%></a>
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

                <%=cm.cmsMsg("sites_designated-codes-result_title")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
