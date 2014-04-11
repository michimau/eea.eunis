<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites advanced search results.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.advanced.DictionaryPaginator,
                 ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  AbstractPaginator paginator;
  //String searchedDatabase = formBean.getSearchedNatureObject();
  String searchedDatabase = "Sites";
//  System.out.println("searchedDatabase = " + searchedDatabase);
  paginator = new DictionaryPaginator(new DictionaryDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "sites-advanced-results.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showSourceDB = columnsDisplayed.contains( "showSourceDB" );
  boolean showCountry = columnsDisplayed.contains( "showCountry" );
  boolean showDesignationType = columnsDisplayed.contains( "showDesignationType" );
  boolean showName = columnsDisplayed.contains( "showName" );
  boolean showCoordinates = columnsDisplayed.contains( "showCoordinates" );
  boolean showSize = columnsDisplayed.contains( "showSize" );
  boolean showDesignationYear = columnsDisplayed.contains( "showDesignationYear" );
  boolean showLength = columnsDisplayed.contains( "showLength" );
  boolean showMinAltitude = columnsDisplayed.contains( "showMinAltitude" );
  boolean showMaxAltitude = columnsDisplayed.contains( "showMaxAltitude" );
  boolean showMeanAltitude = columnsDisplayed.contains( "showMeanAltitude" );
  //new fields added for advanced search
  boolean showRespondent = columnsDisplayed.contains( "showRespondent" );
  boolean showManager = columnsDisplayed.contains( "showManager" );
  boolean showOwnership = columnsDisplayed.contains( "showOwnership" );
  boolean showCharacter = columnsDisplayed.contains( "showCharacter" );
  boolean showCompilationDate = columnsDisplayed.contains( "showCompilationDate" );
  boolean showProposedDate = columnsDisplayed.contains( "showProposedDate" );

  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-advanced.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,advanced_search#sites-advanced.jsp,results";
  if (results.isEmpty())
  {
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
      </jsp:forward>
<%
  }
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("sites_advanced_results")%>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" downloadLink="<%=tsvLink%>" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-result.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
<!-- MAIN CONTENT -->
        <h1>
          <%=cm.cmsPhrase("Sites advanced search results")%>
        </h1>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("You searched sites using advanced search criteria")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Criteria combination used:")%> <%=SessionManager.getExplainedcriteria()%><%=cm.cmsPhrase(", where:")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=SessionManager.getListcriteria()%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Source data sets:")%> <%=SessionManager.getSourcedb()%>
                    </td>
                  </tr>
                </table>
                <br />
                <%=cm.cmsPhrase("Results found")%>&nbsp;<strong><%=resultsCount%></strong>
                <br />
          <%
            Vector mapFields = new Vector();
            mapFields.addElement("criteriaSearch");
            mapFields.addElement("oper");
            mapFields.addElement("criteriaType");

            Vector pageSizeFormFields = new Vector();
            pageSizeFormFields.addElement("sort");
            pageSizeFormFields.addElement("ascendency");
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
            filterSearch.addElement("pageSize");
          %>
                <br />
          <%
                Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                navigatorFormFields.addElement("ascendency");
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
            Vector sortURLFields = new Vector();
            sortURLFields.addElement("pageSize");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SOURCE_DB);
            AbstractSortCriteria sortSiteName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SITE_NAME);
            AbstractSortCriteria sortDesignationType = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_DESIGNATION_TYPE);
            AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_COUNTRY);
            AbstractSortCriteria sortSize = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SIZE);
            AbstractSortCriteria sortLength = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_LENGTH);
            AbstractSortCriteria sortDesignationYear = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_DESIGNATION_YEAR);
            AbstractSortCriteria sortMinAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MIN_ALTITUDE);
            AbstractSortCriteria sortMaxAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MAX_ALTITUDE);
            AbstractSortCriteria sortMeanAltitude = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MEAN_ALTITUDE);

            AbstractSortCriteria sortRespondent = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_RESPONDENT);
            AbstractSortCriteria sortManager = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_MANAGER);
            AbstractSortCriteria sortOwnership = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_OWNERSHIP);
            AbstractSortCriteria sortCharacter = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_CHARACTER);
            AbstractSortCriteria sortCompilationDate = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_COMPILATION_DATE);
            AbstractSortCriteria sortProposedDate = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_PROPOSED_DATE);

            // Expand/Collapse common names
            Vector expand = new Vector();
            expand.addElement("sort");
            expand.addElement("ascendency");
            expand.addElement("pageSize");
            expand.addElement("currentPage");
          %>
                <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
          <%
            if (showSourceDB)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set&nbsp;")%></a>
                      </th>
          <%
            }
            if (showName)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, null == sortSiteName)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            }
            if (showDesignationType)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, null == sortDesignationType)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=cm.cmsPhrase("Designation type")%></a>
                      </th>

          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
            if (showDesignationYear)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, null == sortDesignationYear)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=cm.cmsPhrase("Designation year")%></a>
                      </th>
          <%
            }
            if (showCoordinates)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : center;">
                        <%=cm.cmsPhrase("Longitude")%>
                      </th>
                      <th class="nosort" scope="col" style="text-align : center;">
                        <%=cm.cmsPhrase("Latitude")%>
                      </th>
          <%
            }
            if (showSize)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
            if (showLength)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=cm.cmsPhrase("Length(m)")%></a>
                      </th>
          <%
            }
            if (showMinAltitude)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, null == sortMinAltitude)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=cm.cmsPhrase("Min. altitude(m)")%></a>
                      </th>
          <%
            }
            if (showMaxAltitude)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, null == sortMaxAltitude)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=cm.cmsPhrase("Max. altitude(m)")%></a>
                      </th>
          <%
            }
            if (showMeanAltitude)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, null == sortMeanAltitude)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=cm.cmsPhrase("Mean altiude(m)")%></a>
                      </th>
          <%
            }
            if (showRespondent)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_RESPONDENT%>&amp;ascendency=<%=formBean.changeAscendency(sortRespondent, null == sortRespondent)%>"><%=Utilities.getSortImageTag(sortRespondent)%><%=cm.cmsPhrase("Respondent")%></a>
                      </th>
          <%
            }
            if (showManager)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MANAGER%>&amp;ascendency=<%=formBean.changeAscendency(sortManager, null == sortManager)%>"><%=Utilities.getSortImageTag(sortManager)%><%=cm.cms("manager")%></a>
                      </th>
          <%
            }
            if (showOwnership)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_OWNERSHIP%>&amp;ascendency=<%=formBean.changeAscendency(sortOwnership, null == sortOwnership)%>"><%=Utilities.getSortImageTag(sortOwnership)%><%=cm.cms("sites_advanced_results_ownership")%></a>
                      </th>
          <%
            }
            if (showCharacter)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_CHARACTER%>&amp;ascendency=<%=formBean.changeAscendency(sortCharacter, null == sortCharacter)%>"><%=Utilities.getSortImageTag(sortCharacter)%><%=cm.cms("sites_advanced_results_character")%></a>
                      </th>
          <%
            }
            if (showCompilationDate)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COMPILATION_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortCompilationDate, null == sortCompilationDate)%>"><%=Utilities.getSortImageTag(sortCompilationDate)%><%=cm.cms("sites_advanced_results_compilation")%></a>
                      </th>
          <%
            }
            if (showProposedDate)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PROPOSED_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortProposedDate, null == sortProposedDate)%>"><%=Utilities.getSortImageTag(sortProposedDate)%><%=cm.cms("sites_advanced_results_proposeddate")%></a>
                      </th>
          <%
            }
          %>
                    </tr>
                  </thead>
                  <tbody>
          <%
            int i = 0;
            while (it.hasNext())
            {
              String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
              ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryPersist site = (ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryPersist)it.next();
              String designationType = Utilities.formatString(site.getDesign());
              String designationYear = SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB());
              String longitude = SitesSearchUtility.formatLongitude(site.getLongitude());
              String latitude = SitesSearchUtility.formatLatitude(site.getLatitude());
              String size = Utilities.formatArea(site.getArea(), 5, 2, "&nbsp;");
              String length = Utilities.formatArea(site.getLength(), 5, 2, "&nbsp;");
          %>
                    <tr<%=cssClass%>>
          <%
              if (showSourceDB)
              {
          %>
                      <td>
                        <strong>
                          <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>&nbsp;
                        </strong>
                      </td>
          <%
              }
              if (showName)
              {
          %>
                      <td>
                        <a href="sites/<%=site.getIdSite()%>"><%=site.getName()%></a>
                      </td>
          <%
            }
              if(showDesignationType) {
                if(!site.getSourceDB().equalsIgnoreCase("NATURA2000") || !SitesSearchUtility.getSiteType(site.getIdSite()).equalsIgnoreCase("C"))
                {
            %>
                      <td>
                        <%=designationType%>
                      </td>
            <%
                } else {
                  List desigs = SitesSearchUtility.findDesignationsTypeC();
                  String des = "";
                  for(int ii=0;ii<desigs.size();ii++)
                  {
                    Chm62edtDesignationsPersist dp = (Chm62edtDesignationsPersist) desigs.get(ii);
                    des += dp.getDescriptionEn();
                    if(ii < desigs.size()-1)
                    {
                      des += "<hr />";
                    }
                  }
            %>
                      <td>
                        <%=des%>
                      </td>
            <%
                }
              }

              if (showCountry)
              {
          %>
                      <td>
                        <%=site.getAreaNameEn()%>
                      </td>
          <%
              }
              if (showDesignationYear)
              {
          %>
                      <td>
                        <%=designationYear%>
                      </td>
          <%
              }
              if (showCoordinates)
              {
          %>
                      <td style="text-align : center; white-space : nowrap;">
                        <%=longitude%>
                      </td>
                      <td style="text-align : center; white-space : nowrap;">
                        <%=latitude%>
                      </td>
          <%
              }
              if (showSize)
              {
          %>
                      <td style="text-align : right;">
                        <%=size%>
                      </td>
          <%
              }
              if (showLength)
              {
          %>
                      <td style="text-align : right;">
                        <%=length%>
                      </td>
          <%
              }
              if (showMinAltitude)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getAltMin())%>
                      </td>
          <%
              }
              if (showMaxAltitude)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getAltMax())%>
                      </td>
          <%
              }
              if (showMeanAltitude)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getAltMean())%>
                      </td>
          <%
              }
              if (showRespondent)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getRespondent())%>
                      </td>
          <%
              }
              if (showManager)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getManager())%>
                      </td>
          <%
              }
              if (showOwnership)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getOwnership())%>
                      </td>
          <%
              }
              if (showCharacter)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getCharacter())%>
                      </td>
          <%
              }
              if (showCompilationDate)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getCompilationDate())%>
                      </td>
          <%
              }
              if (showProposedDate)
              {
          %>
                      <td style="text-align : right;">
                        <%=Utilities.formatString(site.getProposedDate())%>
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
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsPhrase("Source data set&nbsp;")%></a>
                      </th>
          <%
            }
            if (showName)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SITE_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSiteName, null == sortSiteName)%>"><%=Utilities.getSortImageTag(sortSiteName)%><%=cm.cmsPhrase("Site name")%></a>
                      </th>
          <%
            }
            if (showDesignationType)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_TYPE%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationType, null == sortDesignationType)%>"><%=Utilities.getSortImageTag(sortDesignationType)%><%=cm.cmsPhrase("Designation type")%></a>
                      </th>

          <%
            }
            if (showCountry)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsPhrase("Country")%></a>
                      </th>
          <%
            }
            if (showDesignationYear)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESIGNATION_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignationYear, null == sortDesignationYear)%>"><%=Utilities.getSortImageTag(sortDesignationYear)%><%=cm.cmsPhrase("Designation year")%></a>
                      </th>
          <%
            }
            if (showCoordinates)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : center;">
                        <%=cm.cmsPhrase("Longitude")%>
                      </th>
                      <th class="nosort" scope="col" style="text-align : center;">
                        <%=cm.cmsPhrase("Latitude")%>
                      </th>
          <%
            }
            if (showSize)
            {
          %>
                      <th class="nosort" scope="col" style="text-align : right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsPhrase("Size(ha)")%></a>
                      </th>
          <%
            }
            if (showLength)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=cm.cmsPhrase("Length(m)")%></a>
                      </th>
          <%
            }
            if (showMinAltitude)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MIN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMinAltitude, null == sortMinAltitude)%>"><%=Utilities.getSortImageTag(sortMinAltitude)%><%=cm.cmsPhrase("Min. altitude(m)")%></a>
                      </th>
          <%
            }
            if (showMaxAltitude)
            {
          %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MAX_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMaxAltitude, null == sortMaxAltitude)%>"><%=Utilities.getSortImageTag(sortMaxAltitude)%><%=cm.cmsPhrase("Max. altitude(m)")%></a>
                      </th>
          <%
            }
            if (showMeanAltitude)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MEAN_ALTITUDE%>&amp;ascendency=<%=formBean.changeAscendency(sortMeanAltitude, null == sortMeanAltitude)%>"><%=Utilities.getSortImageTag(sortMeanAltitude)%><%=cm.cmsPhrase("Mean altiude(m)")%></a>
                      </th>
          <%
            }
            if (showRespondent)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_RESPONDENT%>&amp;ascendency=<%=formBean.changeAscendency(sortRespondent, null == sortRespondent)%>"><%=Utilities.getSortImageTag(sortRespondent)%><%=cm.cmsPhrase("Respondent")%></a>
                      </th>
          <%
            }
            if (showManager)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_MANAGER%>&amp;ascendency=<%=formBean.changeAscendency(sortManager, null == sortManager)%>"><%=Utilities.getSortImageTag(sortManager)%><%=cm.cms("manager")%></a>
                      </th>
          <%
            }
            if (showOwnership)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_OWNERSHIP%>&amp;ascendency=<%=formBean.changeAscendency(sortOwnership, null == sortOwnership)%>"><%=Utilities.getSortImageTag(sortOwnership)%><%=cm.cms("sites_advanced_results_ownership")%></a>
                      </th>
          <%
            }
            if (showCharacter)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_CHARACTER%>&amp;ascendency=<%=formBean.changeAscendency(sortCharacter, null == sortCharacter)%>"><%=Utilities.getSortImageTag(sortCharacter)%><%=cm.cms("sites_advanced_results_character")%></a>
                      </th>
          <%
            }
            if (showCompilationDate)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_COMPILATION_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortCompilationDate, null == sortCompilationDate)%>"><%=Utilities.getSortImageTag(sortCompilationDate)%><%=cm.cms("sites_advanced_results_compilation")%></a>
                      </th>
          <%
            }
            if (showProposedDate)
            {
          %>
                      <th class="nosort" scope="col" style="text-align: right;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PROPOSED_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortProposedDate, null == sortProposedDate)%>"><%=Utilities.getSortImageTag(sortProposedDate)%><%=cm.cms("sites_advanced_results_proposeddate")%></a>
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
                <%=cm.cmsMsg("sites_advanced_results")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>