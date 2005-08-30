<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@ page import="java.util.*,
                 java.sql.Timestamp,
                 ro.finsiel.eunis.search.species.sites.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesDomain,
                 ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>

<% // DB Record types we are going to use here%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtSpeciesPersist"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReportsPersist"%>

<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.sites.SitesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
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
      boolean[] source_db = { true, true, true, true, true, true, true, true };
      int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
      Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
      SitesPaginator paginator = null;
      // The main paginator
      paginator = new SitesPaginator(new SpeciesSitesDomain(formBean.toSearchCriteria(),
                                                            formBean.toSortCriteria(),
                                                            SessionManager.getShowEUNISInvalidatedSpecies(),
                                                            searchAttribute,
                                                            source_db));
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

      String tsvLink = "javascript:openlink('reports/species/tsv-species-sites.jsp?" + formBean.toURLParam(reportFields) + "')";
      WebContentManagement contentManagement = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_sites-result_title", false )%>
    </title>
  </head>
<body style="background-color:#ffffff">
<div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Species#species-sites.jsp,Results" />
    <jsp:param name="helpLink" value="sites-help.jsp" />
    <jsp:param name="downloadLink" value="<%=tsvLink%>" />
  </jsp:include>
<%--    <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>
  <h5>
   <%=contentManagement.getContent("species_sites-result_01")%>
  </h5>
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <%=contentManagement.getContent("species_sites-result_02")%>:
                <strong>
                    <%=Utilities.treatURLAmp(formBean.getMainSearchCriteria().toHumanString())%>.
                </strong>
            </td>
          </tr>
        </table>
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
          <%=contentManagement.getContent("species_sites-result_03")%>:
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
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="background-color:#EEEEEE">
                <%=contentManagement.getContent("species_sites-result_04")%>
            </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
              <form name="refineSearch" method="get" onsubmit="return( validateRefineForm(<%=noCriteria%>) );" action="" >
              <%=formBean.toFORMParam(filterSearch)%>
              <label for="select1" class="noshow">Criteria</label>
                   <%
                       if (!showGroup)
                       {
                   %>
                   <input type="hidden" name="criteriaType" value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                  <%
                       }
                  %>
              <select id="select1" title="Criteria" name="criteriaType" class="inputTextField" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
              <%
                  if (showGroup)
                  {
              %>
                    <option value="<%=SitesSearchCriteria.CRITERIA_GROUP%>">
                        <%=contentManagement.getContent("species_sites-result_05", false)%>
                    </option>
                  <%
                      }
                  %>
                  <option value="<%=SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                      <%=contentManagement.getContent("species_sites-result_08", false)%>
                  </option>
                </select>
                <label for="select2" class="noshow">Operator</label>
                <select id="select2" title="Operator" name="oper" class="inputTextField">
                  <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                      <%=contentManagement.getContent("species_sites-result_09", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_STARTS%>">
                      <%=contentManagement.getContent("species_sites-result_10", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=contentManagement.getContent("species_sites-result_11", false)%>
                  </option>
                </select>
                <label for="criteriaSearch" class="noshow">Criteria value</label>
                <input id="criteriaSearch" title="Criteria value" alt="Criteria value" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                <label for="refine" class="noshow">Search</label>
                <input id="refine" class="inputTextField" title="<%=contentManagement.getContent("species_sites-result_12", false)%>" type="submit" name="Submit" value="<%=contentManagement.getContent("species_sites-result_12", false)%>" />
                <%=contentManagement.writeEditTag( "species_sites-result_12" )%>
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
                <td style="background-color:#EEEEEE">
                    <%=contentManagement.getContent("species_sites-result_13")%>:
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
                  <td style="background-color:#CCCCCC;text-align:left">
                      <a title="Delete this search criteria" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="Delete" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
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
      <table summary="List of results" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;text-align:left">
        <%// Compute the sort criteria
          Vector sortURLFields = new Vector();      /* Used for sorting */
          sortURLFields.addElement("pageSize");
          sortURLFields.addElement("criteriaSearch");
          String urlSortString = formBean.toURLParam(sortURLFields);
          AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(SitesSortCriteria.SORT_GROUP);
          AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(SitesSortCriteria.SORT_ORDER);
          AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(SitesSortCriteria.SORT_FAMILY);
          AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(SitesSortCriteria.SORT_SCIENTIFIC_NAME);

          // Expand/Collapse vernacular names
          Vector expand = new Vector();
          expand.addElement("sort");
          expand.addElement("ascendency");
          expand.addElement("criteriaSearch");
          expand.addElement("oper");
          expand.addElement("criteriaType");
          expand.addElement("pageSize");
          expand.addElement("currentPage");
          String expandURL = formBean.toURLParam(expand);
          boolean isExpanded = (null == formBean.getExpand()) ? false : (formBean.getExpand().equalsIgnoreCase("true")) ? true : false;
        if (showVernacularNames && !isExpanded)
        {
        %>
         <tr>
           <td>
            <a title="Show vernacular names list" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=contentManagement.getContent("species_sites-result_14")%></a>
           </td>
         </tr>
        <%
        }
        %>
        <tr>
<%
            if (showGroup)
            {
%>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortGroup)%><%=contentManagement.getContent("species_sites-result_05")%></span></a>
              </th>
<%
            }
          if (showOrder)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=contentManagement.getContent("species_sites-result_06")%>
              </th>
<%
            }
            if (showFamily)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=contentManagement.getContent("species_sites-result_07")%>
              </th>
<%
            }
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortSciName)%><%=contentManagement.getContent("species_sites-result_08")%></span></a>
          </th>
          <%
            if (isExpanded)
            {
              if (showVernacularNames)
              {
%>
                <th style="text-align:center;vertical-align:top;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                  <span style="color:#FFFFFF">
                    <%=contentManagement.getContent("species_sites-result_14")%>
                    &nbsp;
                    [<a title="Hide vernacular names list" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><span style="color:#FFFFFF"><%=contentManagement.getContent("species_sites-result_15")%></span></a>]
                  </span>
                </th>
<%
              }
            }
  if ( showSites )
  {
%>
          <th style="text-align:left" class="resultHeader">
            <span style="color:#FFFFFF">
                <%=contentManagement.getContent("species_sites-result_16")%>
            </span>
          </th>
<%
  }
%>
        </tr>
        <%
          if (null!=results)
          {
          Iterator it = results.iterator();
          while (it.hasNext())
          {
              SpeciesSitesPersist specie = (SpeciesSitesPersist)it.next();
              Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
              // Sort this vernacular names in alphabetical order
              Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
        %>
              <tr>
                <%
                    if (showGroup)
                    {
                %>
                  <td style="text-align:left">
                      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
                  </td>
                  <%
                      }
                  %>
                <%
                    if (showOrder)
                    {
                %>
                  <td style="text-align:left">
                      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameOrder()),"&nbsp;")%>
                  </td>
                  <%
                      }
                  %>
                <%
                    if (showFamily)
                    {
                %>
                  <td style="text-align:left">
                      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily()),"&nbsp;")%>
                  </td>
                <%
                    }
                %>
                <td style="text-align:left">
                    &nbsp;
                    <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                </td>
                <%
                  if (isExpanded && showVernacularNames)
                  {
                %>
                  <td>
                    <!-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT -->
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
                    <%
                      for (int i = 0; i < sortVernList.size(); i++)
                      {
                      VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
                      String vernacularName = aVernName.getName();
                      String bgColor = (0 == i%2) ? "#EEEEEE" : "#FFFFFF";
                      %>
                      <tr>
                        <td style="background-color:<%=bgColor%>;text-align:left">
                            &nbsp;
                            <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                        </td>
                        <td style="background-color:<%=bgColor%>;text-align:left">
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
                <td style="text-align:left">
                  <%
                    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
                    Integer idNatureObject = specie.getIdNatureObject();
                    // List of habitats from the specified site
                    List resultsSites = new SpeciesSitesDomain().findSitesWithSpecies(
                        new SitesSearchCriteria(searchAttribute,
                                                formBean.getScientificName(),
                                                relationOp),
                                                source_db,
                                                searchAttribute,
                                                idNatureObject,
                                                SessionManager.getShowEUNISInvalidatedSpecies());

                    if (resultsSites!=null && resultsSites.size()>0)
                    {
                      String SQL_DRV = application.getInitParameter("JDBC_DRV");
                      String SQL_URL = application.getInitParameter("JDBC_URL");
                      String SQL_USR = application.getInitParameter("JDBC_USR");
                      String SQL_PWD = application.getInitParameter("JDBC_PWD");

                      SQLUtilities sqlc = new SQLUtilities();
                      sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                    %>
                      <table summary="List of species" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse">
                      <%
                        for(int ii=0;ii<resultsSites.size();ii++)
                        {
                          List l = (List) resultsSites.get(ii);
                          String siteName = Utilities.treatURLSpecialCharacters((String) l.get(0));
                          String siteSourceDb = (String) l.get(1);
                          String idSite = sqlc.ExecuteSQL("SELECT ID_SITE FROM chm62edt_sites WHERE NAME='"+siteName.replaceAll("'","''")+"'");
                        %>
                        <tr style="background-color:#FFFFFF">
                          <td style="text-align:left">
                            <a title="Species factsheet" href="sites-factsheet.jsp?idsite=<%=idSite%>"><%=siteName%></a>&nbsp;(<%=siteSourceDb%>)
                          </td>
                        </tr>
                        <%
                        }
                      %>
                      </table>
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
<tr>
<%
            if (showGroup)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortGroup)%><%=contentManagement.getContent("species_sites-result_05")%></span></a>
              </th>
<%
            }
          if (showOrder)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=contentManagement.getContent("species_sites-result_06")%>
              </th>
<%
            }
            if (showFamily)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=contentManagement.getContent("species_sites-result_07")%>
              </th>
<%
            }
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SitesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortSciName)%><%=contentManagement.getContent("species_sites-result_08")%></span></a>
          </th>
          <%
            if (isExpanded)
            {
              if (showVernacularNames)
              {
%>
                <th style="text-align:center;vertical-align:top;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                  <span style="color:#FFFFFF">
                    <%=contentManagement.getContent("species_sites-result_14")%>
                    &nbsp;
                    [<a title="Hide vernacular names list" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><span style="color:#FFFFFF"><%=contentManagement.getContent("species_sites-result_15")%></span></a>]
                  </span>
                </th>
<%
              }
            }
  if ( showSites )
  {
%>
          <th style="text-align:left" class="resultHeader">
            <span style="color:#FFFFFF">
                <%=contentManagement.getContent("species_sites-result_16")%>
            </span>
          </th>
<%
  }
%>
</tr>
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-sites-result.jsp" />
    </jsp:include>
</div>
  </body>
</html>