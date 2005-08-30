<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Sites related to a site' - part of site's factsheet
--%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteRelationsPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%-- Relation with other sites --%>
<%
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // Relation with other sites
  int type = factsheet.getType();
  if( type != SiteFactsheet.TYPE_NATURA2000 )
  {
    //not a NATURA2000 site - everything remains as it is
    List sites = factsheet.findSiteRelations();
    if (sites.size() > 0 )
    {
      String ids = "";
      int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
      if ( sites.size() < maxSitesPerMap )
      {
        for (int i = 0; i < sites.size(); i++)
        {
          SiteRelationsPersist site = (SiteRelationsPersist)sites.get(i);
          ids += "'" + site.getIdSite() + "'";
          if ( i < sites.size() - 1 ) ids += ",";
        }
%>
      <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
        <input type="hidden" name="sites" value="<%=ids%>" />
        <input type="submit" name="Show map" value="Show map" title="Show map" class="inputTextField" />
      </form>
<%
      }
%>
      <br />
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">
        <%=contentManagement.getContent("sites_factsheet_123")%>
      </div>
      <table summary="<%=contentManagement.getContent("sites_factsheet_123", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="relations" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 0, 'relations', false);"><%=contentManagement.getContent("sites_factsheet_124")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 1, 'relations', false);"><%=contentManagement.getContent("sites_factsheet_125")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 2, 'relations', false);"><%=contentManagement.getContent("sites_factsheet_126")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 3, 'relations', false);"><%=contentManagement.getContent("sites_factsheet_127")%></a>
          </th>
          <th class="resultHeader" align="right">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 4, 'relations', false);"><%=contentManagement.getContent("sites_factsheet_128")%></a>
          </th>
        </tr>
<%
      String checkURL = "<img src=\"images/mini/check.gif\" alt=\"Check\" align=\"middle\" />";
      for (int i = 0; i < sites.size(); i++)
      {
        SiteRelationsPersist site = (SiteRelationsPersist)sites.get(i);
        boolean withinProject = site.getWithinProject() != null && site.getWithinProject().intValue() == 1;
%>
        <tr bgcolor="<%=0 == i % 2 ? "#EEEEEE" : "#FFFFFF"%>">
          <td>
            <%=Utilities.formatString( site.getIdSiteLink(), "&nbsp;" )%>
          </td>
          <td>
<%
        if ( site.getIdSiteLink() != null )
        {
%>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>


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
          <td>
            <%=withinProject ? checkURL : "&nbsp;"%>
          </td>
          <td>
            <%=Utilities.formatString( site.getRelationType(), "&nbsp;" )%>
          </td>
          <td align="right">
            <%=Utilities.formatString( site.getOverlap(), "&nbsp;" )%>
          </td>
        </tr>
<%
      }
%>
      </table>
<%
    }
  }
  else
  {
    //we have a Natura 2000 factsheet type
    //First render the relations between Natura 2000 sites - sitrel
    List sitesNatura200 = factsheet.findSiteRelationsNatura2000Natura2000();
    if (sitesNatura200.size() > 0 )
    {
      String ids = "";
      int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
      if ( sitesNatura200.size() < maxSitesPerMap )
      {
        for (int i = 0; i < sitesNatura200.size(); i++)
        {
          SiteRelationsPersist site = (SiteRelationsPersist)sitesNatura200.get(i);
          ids += "'" + site.getIdSite() + "'";
          if ( i < sitesNatura200.size() - 1 ) ids += ",";
        }
%>
      <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
        <input type="hidden" name="sites" value="<%=ids%>" />
        <input type="submit" name="Show map" value="Show map" title="Show map" class="inputTextField" />
      </form>
<%
      }
%>
      <br />
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">
        Relation with other Natura 2000 sites
      </div>
      <table summary="Relation with other Natura 2000 sites" border="1" cellpadding="1" cellspacing="1" width="100%" id="relationsNatura2000Natura2000" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 3, 0, 'relationsNatura2000Natura2000', false);">Type of relation</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 3, 1, 'relationsNatura2000Natura2000', false);">Site code</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 3, 2, 'relationsNatura2000Natura2000', false);">Site name</a>
          </th>
        </tr>
<%
      for (int i = 0; i < sitesNatura200.size(); i++)
      {
        SiteRelationsPersist site = (SiteRelationsPersist)sitesNatura200.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%=site.getRelationName()%>&nbsp;</td>
          <td>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getIdSiteLink()%></a>
          </td>
          <td>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>
          </td>
        </tr>
<%
      }
%>
      </table>
<%
    }
    //Fourth table should be called "Relation with Corine biotope sites"
    // and should display information stored in corine table joined to corine database
    // on corine field = site.name.
    //Columns should then be corine, site.name with a link to corine site fact sheet,
    // overlap and overlap_p.
    List sitesCorine = factsheet.findSiteRelationsNatura2000Corine();
    if (sitesCorine.size() > 0 )
    {
%>
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">
        Relation with Corine biotope sites
      </div>
      <table summary="Relation with Corine biotope sites" border="1" cellpadding="1" cellspacing="1" width="100%" id="relationsNatura2000sitesCorine" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 0, 'relationsNatura2000sitesCorine', false);">Site code</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 1, 'relationsNatura2000sitesCorine', false);">Site name</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 2, 'relationsNatura2000sitesCorine', false);">Overlap</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 3, 'relationsNatura2000sitesCorine', false);">Overlap P</a>
          </th>
        </tr>
<%
      for (int i = 0; i < sitesCorine.size(); i++)
      {
        SiteRelationsPersist site = (SiteRelationsPersist)sitesCorine.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getIdSiteLink()%></a>
          </td>
          <td>
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>
          </td>
          <td>
            <%=site.getRelationType()%>
          </td>
          <td>
            <%=Utilities.formatDecimal( site.getOverlap(), 2 )%>
          </td>
        </tr>
<%
      }
%>
      </table>
<%
    }
  }
%>