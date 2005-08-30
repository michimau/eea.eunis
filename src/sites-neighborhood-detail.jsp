<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites neighborhood" function - Display sites which are in specified range of a selected site.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 java.util.List,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist,
                 java.util.ArrayList,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesDomain,
                 ro.finsiel.eunis.search.sites.neighborhood.NeighborhoodPaginator,
                 ro.finsiel.eunis.jrfTables.sites.neighborhood.NeighborhoodDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.names.NameDomain,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.sites.neighborhood.NeighborhoodDetailSortCriteria,
                 ro.finsiel.eunis.search.CountryUtil"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.neighborhood.NeighborhoodBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <jsp:include page="header-page.jsp" />
    <%
    // Web content manager used in this page.
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_neighborhood-detail_title", false )%></title>
  </head>
  <%
    String idSite = request.getParameter("idsite");
    String countryCode = request.getParameter("countryCode");
    countryCode = CountryUtil.areaNameEn2ISO2L(countryCode);// Translate it into CODE (ISO)
    float radius = Utilities.checkedStringToFloat(request.getParameter("radius"), 0.0F);
    int currentPage = Utilities.checkedStringToInt(request.getParameter("currentPage"), 0);
    if (currentPage < 0) currentPage = 0;
    int pageSize = Utilities.checkedStringToInt(request.getParameter("pageSize"), 10);
    List sites = new ArrayList();

    Vector hiddenParams = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
    hiddenParams.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
    hiddenParams.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
    hiddenParams.addElement("criteriaSearch");/*   to page "0" aka first page. */
    hiddenParams.addElement("pageSize");

    StringBuffer toFORMParam = Utilities.writeFormParameter("idsite", idSite);
    toFORMParam.append(Utilities.writeFormParameter("radius", radius));
    toFORMParam.append(Utilities.writeFormParameter("countryCode", countryCode));
    toFORMParam.append(formBean.toFORMParam(hiddenParams));

    // Initialize URL and FORM parameters, passed to links and forms from page.
    // Also add this page specific fields to the URL/FORM fields written on links/forms.
    String toURLParam = "idsite=" + idSite;
    toURLParam += Utilities.writeURLParameter("radius", radius);
    toURLParam += Utilities.writeURLParameter("pageSize", pageSize);
    toURLParam += Utilities.writeURLParameter("countryCode", countryCode);
    toURLParam += formBean.toURLParam(hiddenParams);

    // Try to find the site with ID passed on the request.
    Chm62edtSitesPersist mainSite = null;
    sites = new Chm62edtSitesDomain().findWhere("ID_SITE='" + idSite + "'");
    String pageName = "sites-neighborhood-detail.jsp";
    int guid = 0;
    // This is the paginator for the results.
    NeighborhoodPaginator paginator = null;
    float originX = 0;
    float originY = 0;
    int pagesCount = 0;
    mainSite = (Chm62edtSitesPersist)sites.get(0);
    // Compute circle's center
    originX = Utilities.checkedStringToFloat(mainSite.getLongitude(), 0);
    originY = Utilities.checkedStringToFloat(mainSite.getLatitude(), 0);
    paginator = new NeighborhoodPaginator(new NeighborhoodDomain(mainSite.getIdSite(), radius, originX, originY, formBean.toSortCriteriaDetailsPage()));
    paginator.setPageSize(pageSize);
    try
    {
      sites = paginator.getPage(currentPage);
    } catch (Exception e) {
      e.printStackTrace();
    }
    pagesCount = paginator.countPages();

    if (sites.size() > 0)
    {
      String ids = "";
      int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
      if ( sites.size() < maxSitesPerMap )
      {
        for (int i = 0; i < sites.size(); i++)
        {
          Chm62edtSitesPersist site = (Chm62edtSitesPersist)sites.get(i);
          ids += "'" + site.getIdSite() + "'";
          if ( i < sites.size() - 1 ) ids += ",";
        }
      }
  %>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Neighborhood#sites-neighborhood.jsp,Neighborhoods"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
<%
  if (sites.isEmpty())
  {
%>
      <br />
      <jsp:include page="noresults.jsp" />
<%
    return;
  }
%>
      <h5>
        Site neighborhood
      </h5>
      <br />
      <%=contentManagement.getContent("sites_neighborhood-detail_05")%>
      <strong>
        <%=paginator.countResults()%>
      </strong>
      <%=contentManagement.getContent("sites_neighborhood-detail_06")%>
      <strong>
        <%=radius%>
      </strong>
      <%=contentManagement.getContent("sites_neighborhood-detail_07")%>
      <strong>
        <%=mainSite.getName()%>
      </strong>
      <br />
<%
  if ( sites.size() < maxSitesPerMap )
  {
%>
      <br />
      <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
        <input type="hidden" name="sites" value="<%=ids%>" />
        <label for="showMapGIS" class="noshow">Show map</label>
        <input type="submit" id="showMapGIS" name="Show map" value="Show map" title="Show map" class="inputTextField" />
      </form>
<%
  }
%>
      <jsp:include page="pagesize.jsp">
        <jsp:param name="guid" value="<%=guid%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="pageSize" value="<%=pageSize%>"/>
        <jsp:param name="toFORMParam" value="<%=toFORMParam%>"/>
      </jsp:include>
      <br />
      <jsp:include page="navigator.jsp">
        <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="guid" value="<%=guid%>"/>
        <jsp:param name="currentPage" value="<%=currentPage%>"/>
        <jsp:param name="toURLParam" value="<%=toURLParam%>"/>
        <jsp:param name="toFORMParam" value="<%=toFORMParam%>"/>
      </jsp:include>
<%
  // Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  String urlSortString = formBean.toURLParam(sortURLFields);
  urlSortString += "&amp;idsite=" + idSite;
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(NeighborhoodDetailSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(NeighborhoodDetailSortCriteria.SORT_NAME);
  AbstractSortCriteria sortSize = formBean.lookupSortCriteria(NeighborhoodDetailSortCriteria.SORT_SIZE);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(NeighborhoodDetailSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(NeighborhoodDetailSortCriteria.SORT_LONG);
%>
      <a name="dataTable"></a>
      <table summary="Search results" width="100%" border="1" cellspacing="0" cellpadding="0" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader" nowrap="nowrap">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>#dataTable"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_neighborhood-detail_08")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>#dataTable"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_neighborhood-detail_09")%></a>
          </th>
          <th class="resultHeader" align="right" nowrap="nowrap" style="text-align : right;">
            <%=contentManagement.getContent("sites_neighborhood-detail_10")%>
          </th>
          <th class="resultHeader" align="center" nowrap="nowrap"  style="text-align : center;">
            <%=contentManagement.getContent("sites_neighborhood-detail_11")%>
          </th>
          <th class="resultHeader" align="center" nowrap="nowrap" style="text-align : center;">
            <%=contentManagement.getContent("sites_neighborhood-detail_12")%>
          </th>
          <th class="resultHeader" align="right" nowrap="nowrap" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>#dataTable"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_neighborhood-detail_13")%></a>
          </th>
        </tr>
<%
    String bgcolor = "";
    for (int i = 0; i < sites.size(); i++)
    {
      Chm62edtSitesPersist site = (Chm62edtSitesPersist)sites.get(i);
      bgcolor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF" ;
%>
        <tr bgcolor="<%=bgcolor%>">
          <td>
            <strong>
              <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
            </strong>
          </td>
          <td>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a>
          </td>
          <td align="right" nowrap="nowrap">
            <%=Utilities.formatArea("" + SitesSearchUtility.distanceBetweenSites(mainSite, site), 4, 3, "&nbsp;")%>
          </td>
          <td align="center" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
          </td>
          <td align="center" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
          </td>
          <td align="right" nowrap="nowrap">
            <%=Utilities.formatArea(site.getArea(), 5, 2, "&nbsp;")%>
          </td>
        </tr>
<%
    }
%>
        <tr>
          <th class="resultHeader" nowrap="nowrap">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>#dataTable"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_neighborhood-detail_08")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, sortName == null )%>#dataTable"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_neighborhood-detail_09")%></a>
          </th>
          <th class="resultHeader" align="right" nowrap="nowrap" style="text-align : right;">
            <%=contentManagement.getContent("sites_neighborhood-detail_10")%>
          </th>
          <th class="resultHeader" align="center" nowrap="nowrap"  style="text-align : center;">
            <%=contentManagement.getContent("sites_neighborhood-detail_11")%>
          </th>
          <th class="resultHeader" align="center" nowrap="nowrap" style="text-align : center;">
            <%=contentManagement.getContent("sites_neighborhood-detail_12")%>
          </th>
          <th class="resultHeader" align="right" nowrap="nowrap" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NeighborhoodDetailSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, sortSize == null )%>#dataTable"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_neighborhood-detail_13")%></a>
          </th>
        </tr>
      </table>
<%
  }
    %>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-neighborhood-detail.jsp" />
      </jsp:include>
    </div>
  </body>
</html>