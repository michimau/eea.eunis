<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.designations.DesignationsPaginator,
                 ro.finsiel.eunis.jrfTables.sites.designations.DesignationsDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.designations.DesignationsPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.designations.DesignationsBean,
                 ro.finsiel.eunis.search.sites.designations.DesignationsSearchCriteria,
                 ro.finsiel.eunis.search.sites.designations.DesignationsSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.designations.DesignationsBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), DesignationsBean.HIDE);
  boolean showDesignation = Utilities.checkedStringToBoolean(formBean.getShowDesignation(), true);
  boolean showDesignEn = Utilities.checkedStringToBoolean(formBean.getShowDesignationEn(), true);
  boolean showDesignFr = Utilities.checkedStringToBoolean(formBean.getShowDesignationFr(), DesignationsBean.HIDE);
  boolean showIso = Utilities.checkedStringToBoolean(formBean.getShowIso(), DesignationsBean.HIDE);
  boolean showAbreviation = Utilities.checkedStringToBoolean(formBean.getShowAbreviation(), DesignationsBean.HIDE);
  //boolean showSource = Utilities.checkedStringToBoolean(formBean.getShowSource(), DesignationsBean.HIDE);
  // Contains true values if proper sourceDB checkbox was check
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
  DesignationsPaginator paginator = new DesignationsPaginator(new DesignationsDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-designations-result.jsp";
  int resultsCount = 0;
  int pagesCount = 0;// This is used in @page include...
  int guid = 0;// This is used in @page include...
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
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String downloadLink = null;
  if( results.size() > 0 )
  {
    downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-designations.jsp?" + formBean.toURLParam(reportFields) + "')";
  }
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_types#sites-designations.jsp,results";
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
    <script language="JavaScript" type="text/javascript" src="script/sites-designations.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_designations-result_title")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
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
          <%--      <jsp:param name="printLink" value="<%=printLink%>"/>--%>
                <h1>
                  <%=cm.cmsPhrase("Sites designations types")%>
                </h1>
                <%=((DesignationsSearchCriteria)formBean.getMainSearchCriteria()).toHumanStringMain()%>
                <br />
                <%=cm.cmsPhrase("Results found")%> <strong><%=resultsCount%></strong><br />
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
                  <strong>
                    <%=cm.cmsPhrase("Refine your search")%>
                  </strong>
                  <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
                    <%=formBean.toFORMParam(filterSearch)%>
                    <label for="criteriaType0" class="noshow"><%=cm.cms("criteria")%></label>
                    <select id="criteriaType0" name="criteriaType" title="<%=cm.cms("criteria")%>">
          <%
            if (showSourceDB)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_SOURCE_DB%>">
                        <%=cm.cms("database_source")%>
                      </option>
          <%
            }
            if (showDesignation)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN%>">
                        <%=cm.cms("designation_name")%>
                      </option>
          <%
            }
            if (showDesignEn)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN_EN%>">
                        <%=cm.cms("english_designation_name")%>
                      </option>
          <%
            }
            if (showDesignFr)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN_FR%>">
                        <%=cm.cms("french_designation_name")%>
                      </option>
          <%
            }
            if (showAbreviation)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_ABREVIATION%>">
                        <%=cm.cms("abbreviation")%>
                      </option>
          <%
            }
            if (showIso)
            {
          %>
                      <option value="<%=DesignationsSearchCriteria.CRITERIA_COUNTRY%>">
                        <%=cm.cms("country")%>
                      </option>
          <%
            }
          %>
                    </select>
                    <%=cm.cmsLabel("criteria")%>
                    <%=cm.cmsTitle("criteria")%>
                    <%=cm.cmsInput("database_source")%>
                    <%=cm.cmsInput("designation_name")%>
                    <%=cm.cmsInput("english_designation_name")%>
                    <%=cm.cmsInput("french_designation_name")%>
                    <%=cm.cmsInput("abbreviation")%>
                    <%=cm.cmsInput("country")%>

                    <select id="oper0" name="oper" title="<%=cm.cms("operator")%>">
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
                    <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" title="<%=cm.cms("filter_value")%>" />
                    <%=cm.cmsLabel("filter_value")%>
                    <%=cm.cmsTitle("filter_value")%>

                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" border="0" width="11" height="18" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("list_of_values")%>
                    <%=cm.cmsAlt("list_of_values")%>

                    <input id="submit" name="Submit" type="submit" value="<%=cm.cms("search")%>" class="searchButton" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
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
            AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_SOURCE_DB);
            //AbstractSortCriteria sortSource = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_SOURCE);
            //AbstractSortCriteria sortIso = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_ISO);
            AbstractSortCriteria sortAbreviation = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_ABREVIATION);
            AbstractSortCriteria sortDesignation = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION);
            AbstractSortCriteria sortDesignEn = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION_EN);
            AbstractSortCriteria sortDesignFr = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION_FR);
            AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_COUNTRY);
          %>
                <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showIso)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignation)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignation, sortDesignation == null )%>"><%=Utilities.getSortImageTag(sortDesignation)%><%=cm.cmsPhrase("Designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignEn)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_EN%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignEn, sortDesignEn == null )%>"><%=Utilities.getSortImageTag(sortDesignEn)%><%=cm.cmsPhrase("English designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignFr)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_FR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignFr, sortDesignFr == null )%>"><%=Utilities.getSortImageTag(sortDesignFr)%><%=cm.cmsPhrase("French designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showAbreviation)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_ABREVIATION%>&amp;ascendency=<%=formBean.changeAscendency(sortAbreviation, sortAbreviation == null )%>"><%=Utilities.getSortImageTag(sortAbreviation)%><%=cm.cmsPhrase("Abbreviation")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                  <tbody>
          <%
            for (int i = 0; i < results.size(); i++)
            {
              String cssClass = i % 2 == 0 ? " class=\"zebraeven\"" : "";
              DesignationsPersist designation = (DesignationsPersist)results.get(i);
          %>
                  <tr<%=cssClass%>>
          <%
              if (showSourceDB)
              {
          %>
                    <td>
                      <strong>
                        <%=SitesSearchUtility.translateSourceDB(designation.getDataSet())%>
                      </strong>
                    </td>
          <%
              }
              if (showIso)
              {
          %>
                    <td>
                      <%=Utilities.formatString(designation.getCountry(), "&nbsp;")%>
                    </td>
          <%
              }
              if (showDesignation)
              {
          %>
                    <td>
          <%
                if (null != designation.getDescription() && !designation.getDescription().equalsIgnoreCase(""))
                {
                  String factsheetURL = "designations-factsheet.jsp?fromWhere=original&amp;idDesign=" + designation.getIdDesignation();
                  factsheetURL += "&amp;geoscope=" + designation.getIdGeoscope();
          %>
                      <a title="<%=cm.cms("open_designation_factsheet")%>" href="<%=factsheetURL%>"><%=Utilities.formatString(designation.getDescription(), "&nbsp;")%></a>
                      <%=cm.cmsTitle("open_designation_factsheet")%>
          <%
                }
                else
                {
          %>
                      &nbsp;
          <%
                }
          %>
                    </td>
          <%
              }
              if (showDesignEn)
              {
          %>
                    <td>
          <%
                if (null != designation.getDescriptionEn() && !designation.getDescriptionEn().equalsIgnoreCase(""))
                {
          %>
                      <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=Utilities.formatString(designation.getDescriptionEn(), "&nbsp;")%></a>
                      <%=cm.cmsTitle("open_designation_factsheet")%>
          <%
                }
                else
                {
          %>
                      &nbsp;
          <%
                }
          %>
                    </td>
          <%
              }
              if (showDesignFr)
              {
          %>
                    <td>
          <%
                if (null != designation.getDescriptionFr() && !designation.getDescriptionFr().equalsIgnoreCase(""))
                {
          %>
                        <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=fr&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=Utilities.formatString(designation.getDescriptionFr(), "&nbsp;")%></a>
                        <%=cm.cmsTitle("open_designation_factsheet")%>
          <%
                }
                else
                {
          %>
                        &nbsp;
          <%
                }
          %>
                      </td>
          <%
              }
              if (showAbreviation)
              {
          %>
                      <td>
                        <%=Utilities.formatString(designation.getAbbreviation(), "&nbsp;")%>
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
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showIso)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignation)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignation, sortDesignation == null )%>"><%=Utilities.getSortImageTag(sortDesignation)%><%=cm.cmsPhrase("Designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignEn)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_EN%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignEn, sortDesignEn == null )%>"><%=Utilities.getSortImageTag(sortDesignEn)%><%=cm.cmsPhrase("English designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showDesignFr)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_FR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignFr, sortDesignFr == null )%>"><%=Utilities.getSortImageTag(sortDesignFr)%><%=cm.cmsPhrase("French designation name")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </th>
          <%
            }
            if (showAbreviation)
            {
          %>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_ABREVIATION%>&amp;ascendency=<%=formBean.changeAscendency(sortAbreviation, sortAbreviation == null )%>"><%=Utilities.getSortImageTag(sortAbreviation)%><%=cm.cmsPhrase("Abbreviation")%></a>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
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

                <%=cm.cmsMsg("sites_designations-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_results")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-designations-result.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
