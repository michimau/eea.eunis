<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.species.sites.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesDomain,
                 ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.sites.SitesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
//      Utilities.dumpRequestParams(request);
  // Check columns to be displayed
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), SitesBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), SitesBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), SitesBean.HIDE);
  //boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), SitesBean.HIDE);
  boolean showVernacularNames = false;//Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), SitesBean.HIDE);
  boolean showSites = Utilities.checkedStringToBoolean(formBean.getShowSites(), SitesBean.HIDE);

  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
  SitesPaginator paginator;
  // The main paginator
  paginator = new SitesPaginator(new SpeciesSitesDomain(formBean.toSearchCriteria(),
                                                        formBean.toSortCriteria(),
                                                        SessionManager.getShowEUNISInvalidatedSpecies(),
                                                        searchAttribute,
                                                        SourceDb.allDatabases()));
  // Initialisation
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "species-sites-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);

  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-sites.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,pick_sites_show_species_location#species-sites.jsp,results";
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
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_sites-result_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="sites-help.jsp" pageTitle="${title}" downloadLink="<%= tsvLink%>" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-result.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
         <%=cm.cmsPhrase("Pick sites, show species")%>
        </h1>

<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("You searched species from sites with the following characteristic(s)")%>:
                              <strong>
                                  <%=Utilities.treatURLAmp(formBean.getMainSearchCriteria().toHumanString())%>.
                              </strong>
                          </td>
                        </tr>
                      </table>
                        <%=cm.cmsPhrase("Results found")%>
                        <strong>
                           <%=resultsCount%>
                        </strong>
                      <%// Prepare parameters for pagesize.jsp
                        Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                        pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                        pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                        pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
                      %>
                      <jsp:include page="pagesize.jsp">
                        <jsp:param name="guid" value="<%=guid%>" />
                        <jsp:param name="pageName" value="<%=pageName%>" />
                        <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
                        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
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
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                        <tr>
                          <td>
                              <%=cm.cmsPhrase("Refine your search")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <form name="refineSearch" method="get" onsubmit="return( validateRefineForm(<%=noCriteria%>) );" action="" >
                            <%=formBean.toFORMParam(filterSearch)%>
                            <label for="select1" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                                 <%
                                     if (!showGroup)
                                     {
                                 %>
                                 <input type="hidden" name="criteriaType" value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                                <%
                                     }
                                %>
                            <select id="select1" title="<%=cm.cmsPhrase("Criteria")%>" name="criteriaType" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
                            <%
                                if (showGroup)
                                {
                            %>
                                  <option value="<%=SitesSearchCriteria.CRITERIA_GROUP%>">
                                      <%=cm.cmsPhrase("Group")%>
                                  </option>
                                <%
                                    }
                                %>
                                <option value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                    <%=cm.cms("species_scientific_name")%>
                                </option>
                              </select>
                              <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="oper">
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
                              <label for="criteriaSearch" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                              <input id="criteriaSearch" title="<%=cm.cmsPhrase("Filter value")%>" alt="<%=cm.cmsPhrase("Filter value")%>" name="criteriaSearch" type="text" size="30" />
                              <input id="refine" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" type="submit" name="Submit" value="<%=cm.cmsPhrase("Search")%>" />
                            </form>
                          </td>
                        </tr>
                        <%-- This is the code which shows the search filters --%>
                        <%
                            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
                        %>
                        <%
                            if (criterias.length > 1)
                            {
                        %>
                          <tr>
                              <td>
                                  <%=cm.cmsPhrase("Applied filters to the results")%>:
                              </td>
                          </tr>
                          <%
                              }
                            for (int i = criterias.length - 1; i > 0; i--)
                            {
                              AbstractSearchCriteria criteria = criterias[i];
                              if (null != criteria && null != formBean.getCriteriaSearch())
                              {
                          %>
                            <tr>
                                <td>
                                    <a title="<%=cm.cms("delete_criteria")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_criteria")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
                                    <%=cm.cmsTitle("delete_criteria")%>
                                    &nbsp;&nbsp;
                                    <strong class="linkDarkBg">
                                        <%= i + ". " + criteria.toHumanString()%>
                                    </strong>
                                </td>
                            </tr>
                          <%
                              }
                            }
                        %>
                    </table>
                    <%
                      // Prepare parameters for navigator.jsp
                      Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                      navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                      navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                      navigatorFormFields.addElement("ascendency");
                      navigatorFormFields.addElement("criteriaSearch");
                    %>
                    <jsp:include page="navigator.jsp">
                      <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="guid" value="<%=guid%>" />
                      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                    </jsp:include>
                      <%// Compute the sort criteria
                        Vector sortURLFields = new Vector();      /* Used for sorting */
                        sortURLFields.addElement( "pageSize" );
                        sortURLFields.addElement( "criteriaSearch" );
                        String urlSortString = formBean.toURLParam( sortURLFields );
                        AbstractSortCriteria sortGroup = formBean.lookupSortCriteria( SitesSortCriteria.SORT_GROUP );
                        AbstractSortCriteria sortOrder = formBean.lookupSortCriteria( SitesSortCriteria.SORT_ORDER );
                        AbstractSortCriteria sortFamily = formBean.lookupSortCriteria( SitesSortCriteria.SORT_FAMILY );
                        AbstractSortCriteria sortSciName = formBean.lookupSortCriteria( SitesSortCriteria.SORT_SCIENTIFIC_NAME );

                        // Expand/Collapse common names
                        Vector expand = new Vector();
                        expand.addElement( "sort" );
                        expand.addElement( "ascendency" );
                        expand.addElement( "criteriaSearch" );
                        expand.addElement( "oper" );
                        expand.addElement( "criteriaType" );
                        expand.addElement( "pageSize" );
                        expand.addElement( "currentPage" );
                        String expandURL = formBean.toURLParam( expand );
                        boolean isExpanded = null == formBean.getExpand() ? false : formBean.getExpand().equalsIgnoreCase( "true" );
                        if ( showVernacularNames && !isExpanded )
                        {
                      %>
                          <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display common names")%></a>
                          <%=cm.cmsTitle("show_vernacular_list")%>
                      <%
                      }
                      %>
                      <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                        <thead>
                          <tr>
              <%
                          if (showGroup)
                          {
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                            </th>
              <%
                          }
                        if (showOrder)
                          {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Order")%>
                            </th>
              <%
                          }
                          if (showFamily)
                          {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Family")%>
                            </th>
              <%
                          }
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Species scientific name")%></a>
                            </th>
                        <%
                          if (isExpanded)
                          {
                            if (showVernacularNames)
                            {
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display common names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                            </th>
              <%
                            }
                          }
                if ( showSites )
                {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Site(s) name(s)")%>
                            </th>
              <%
                }
              %>
                          </tr>
                        </thead>
                        <tbody>
                      <%
                        if (null!=results)
                        {
                        for( int i = 0; i < results.size(); i++ )
                        {
                            SpeciesSitesPersist specie = (SpeciesSitesPersist)results.get( i );
                            Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                            // Sort this common names in alphabetical order
                            Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
                      %>
                          <tr>
                              <%
                                  if (showGroup)
                                  {
                              %>
                            <td>
                              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
                            </td>
                                <%
                                    }
                                %>
                              <%
                                  if (showOrder)
                                  {
                              %>
                            <td>
                              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameOrder()),"&nbsp;")%>
                            </td>
                                <%
                                    }
                                %>
                              <%
                                  if (showFamily)
                                  {
                              %>
                            <td>
                              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily()),"&nbsp;")%>
                            </td>
                              <%
                                  }
                              %>
                            <td>
                              <a href="species/<%=specie.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                            </td>
                              <%
                                if (isExpanded && showVernacularNames)
                                {
                              %>
                            <td>
                              <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <%
                                    for (int ii = 0; ii < sortVernList.size(); ii++)
                                    {
                                    VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(ii);
                                    String vernacularName = aVernName.getName();
                                    %>
                                    <tr>
                                      <td>
                                        &nbsp;
                                        <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                                      </td>
                                      <td>
                                        &nbsp;
                                        <%=Utilities.treatURLSpecialCharacters(vernacularName)%>
                                      </td>
                                    </tr>
                                  <%
                                      }
                                  %>
                              </table>
                            </td>
                              <%
                                  }
                              %>
              <%
                if( showSites )
                {
              %>
                            <td>
              <%
                                  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
                                  Integer idNatureObject = specie.getIdNatureObject();
                                  // List of habitats from the specified site
                                  List resultsSites = new SpeciesSitesDomain().findSitesWithSpecies(
                                      new SitesSearchCriteria(searchAttribute,
                                                              formBean.getScientificName(),
                                                              relationOp),
                                                              SourceDb.allDatabases(),
                                                              searchAttribute,
                                                              idNatureObject,
                                                              SessionManager.getShowEUNISInvalidatedSpecies());

                                  if (resultsSites!=null && resultsSites.size()>0)
                                  {
                                    SQLUtilities sqlc = new SQLUtilities();
                                    sqlc.Init();
              %>
                              <%--<ul>--%>
              <%
                                      for(int ii=0;ii<resultsSites.size();ii++)
                                      {
                                        List l = (List) resultsSites.get(ii);
                                        String siteName = Utilities.treatURLSpecialCharacters((String) l.get(0));
                                        String siteSourceDb = (String) l.get(1);
                                        String idSite = sqlc.ExecuteSQL("SELECT ID_SITE FROM chm62edt_sites WHERE NAME='"+siteName.replaceAll("'","''")+"'");
              %>
                                      <p>
                                          <a href="sites/<%=idSite%>"><%=siteName%></a>&nbsp;(<%=siteSourceDb%>)
                                        </p>
                                      <%
                                      }
                                    %>
                              <%--</ul>--%>
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
                        }
                          %>
                        </tbody>
                        <thead>
                          <tr>
              <%
                          if (showGroup)
                          {
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                            </th>
              <%
                          }
                        if (showOrder)
                          {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Order")%>
                            </th>
              <%
                          }
                          if (showFamily)
                          {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Family")%>
                            </th>
              <%
                          }
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Species scientific name")%></a>
                            </th>
                        <%
                          if (isExpanded)
                          {
                            if (showVernacularNames)
                            {
              %>
                            <th class="nosort" scope="col">
                              <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display common names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                            </th>
              <%
                            }
                          }
                if ( showSites )
                {
              %>
                            <th class="nosort" scope="col">
                              <%=cm.cmsPhrase("Site(s) name(s)")%>
                            </th>
              <%
                }
              %>
                          </tr>
                        </thead>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <jsp:include page="navigator.jsp">
                        <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                        <jsp:param name="pageName" value="<%=pageName%>" />
                        <jsp:param name="guid" value="<%=guid + 1%>" />
                        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                      </jsp:include>
                    </td>
                  </tr>
                </table>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_sites-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_scientific_name")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("list_species")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>