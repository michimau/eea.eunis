<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
- Description : "Sites by designation types" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes.js"></script>
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

      String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-designated-codes.jsp?" + formBean.toURLParam(reportFields) + "')";
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_designated-codes-result_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,sites_designated_codes_location#sites-designated-codes.jsp,results"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("sites_designated-codes-result_01")%>
      </h1>
      <%=((DesignationSearchCriteria)formBean.getMainSearchCriteria()).toHumanStringMain()%>
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
      Results found: <strong><%=resultsCount%></strong><br />

<%
  Vector mapFields = new Vector();
  mapFields.addElement("criteriaSearch");
  mapFields.addElement("oper");
  mapFields.addElement("criteriaType");

  for (int i = 0; i < results.size(); i++)
  {
    DesignationPersist site = (DesignationPersist)results.get( i );
    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
    if ( longitude.lastIndexOf( "n/a" ) < 0 && latitude.lastIndexOf( "n/a" ) < 0 )
    {
%>
      <jsp:include page="sites-map.jsp">
        <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
        <jsp:param name="mapName" value="sites-designated-codes-map.jsp"/>
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
        <%=cm.cmsText("refine_your_search")%>
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
          <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType0" class="noshow"><%=cm.cms("criteria")%></label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField" title="<%=cm.cms("criteria")%>">
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
              <%=cm.cms("country")%>
            </option>
<%
  }
%>
          </select>
          <%=cm.cmsLabel("criteria")%>
          <%=cm.cmsTitle("criteria")%>
          <%=cm.cmsInput("database_source")%>
          <%=cm.cmsInput("site_name")%>
          <%=cm.cmsInput("designation_name")%>
          <%=cm.cmsInput("english_designation_name")%>
          <%=cm.cmsInput("french_designation_name")%>
          <%=cm.cmsInput("country")%>

          <label for="oper0" class="noshow"><%=cm.cms("operator")%></label>
          <select id="oper0" name="oper" class="inputTextField" title="<%=cm.cms("operator")%>">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
              <%=cm.cms("is")%>
            </option>
            <option value="<%=Utilities.OPERATOR_STARTS%>">
              <%=cm.cms("starts_with")%>
            </option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>">
              <%=cm.cms("contains")%>
            </option>
          </select>
          <%=cm.cmsLabel("operator")%>
          <%=cm.cmsTitle("operator")%>
          <%=cm.cmsInput("is")%>
          <%=cm.cmsInput("starts_with")%>
          <%=cm.cmsInput("contains")%>

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
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("designation_name")%>
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
  if(showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size_ha")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showYear)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("designation_year")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
        </tr>
<%
  Iterator it = results.iterator();
  int i = 0; String bgColor;
  while (it.hasNext())
  {
    bgColor = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
    DesignationPersist site = (DesignationPersist)it.next();
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
    if (showName)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
            <%=cm.cmsTitle("open_site_factsheet")%>
          </td>

<%
    }
  if (showDesignType)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <jsp:include page="sites-designations-detail.jsp">
              <jsp:param name="idDesignation" value="<%=site.getIdDesign()%>"/>
              <jsp:param name="idGeoscope" value="<%=site.getGeoscope()%>"/>
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
            &nbsp;
            <%=Utilities.formatArea(site.getArea(), 9, 2, "&nbsp;")%>
          </td>
<%
    }
    if (showYear)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=Utilities.formatString(SitesSearchUtility.parseDesignationYear(site.getDesignationDate(),site.getSourceDB()),"&nbsp;")%>
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
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("source_data_set")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCountry)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("country")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("site_name")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("designation_name")%>
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
  if(showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("size_ha")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showYear)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, sortYear == null )%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("designation_year")%></a>
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

      <%=cm.cmsMsg("sites_designated-codes-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("search_results")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designated-codes-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>