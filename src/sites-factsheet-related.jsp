<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Sites related to a site' - part of site's factsheet
--%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
  WebContentManagement cm = SessionManager.getWebContent();
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
    <input type="submit" name="Show map" value="<%=cm.cms("show_map")%>" title="<%=cm.cms("show_map")%>" class="submitSearchButton" />
    <%=cm.cmsInput("show_map")%>
    <%=cm.cmsTitle("show_map")%>
  </form>
<%
      }
%>
  <h2>
    <%=cm.cmsPhrase("Relationships")%>
  </h2>
  <table summary="<%=cm.cms("sites_factsheet_123")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("ID Site")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Scientific name")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Within databases")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Type")%>
        </th>
        <th style="text-transform: capitalize; text-align: right;">
          <%=cm.cmsPhrase("Overlap(%)")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      String checkURL = "<img src=\"images/mini/check.gif\" alt=\"Check\" align=\"middle\" />";
      for (int i = 0; i < sites.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        SiteRelationsPersist site = (SiteRelationsPersist)sites.get(i);
        boolean withinProject = site.getWithinProject() != null && site.getWithinProject().intValue() == 1;
%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.formatString( site.getIdSiteLink(), "&nbsp;" )%>
        </td>
        <td>
<%
        if ( site.getIdSiteLink() != null )
        {
%>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>
          <%=cm.cmsTitle("open_site_factsheet")%>
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
    <tbody>
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
    <input type="submit" name="Show map" value="<%=cm.cms("show_map")%>" title="<%=cm.cms("show_map")%>" class="submitSearchButton" />
    <%=cm.cmsInput("show_map")%>
    <%=cm.cmsTitle("show_map")%>
  </form>
<%
      }
%>
  <br />
  <h2>
    <%=cm.cmsPhrase("Relation with other Natura 2000 sites")%>
  </h2>
  <table summary="<%=cm.cms("sites_factsheet_related_natura2000")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Type of relation")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Site code")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Site name")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < sitesNatura200.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        SiteRelationsPersist site = (SiteRelationsPersist)sitesNatura200.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <%=site.getRelationName()%>&nbsp;</td>
        <td>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getIdSiteLink()%></a>
          <%=cm.cmsTitle("open_site_factsheet")%>
        </td>
        <td>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>
        <%=cm.cmsTitle("open_site_factsheet")%>
        </td>
      </tr>
<%
      }
%>
    </tbody>
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
  <h2>
    <%=cm.cmsPhrase("Relation with Corine biotope sites")%>
  </h2>
  <table summary="<%=cm.cms("sites_factsheet_related_corinesites")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Site code")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Site name")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Overlap")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsPhrase("Overlap P")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < sitesCorine.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        SiteRelationsPersist site = (SiteRelationsPersist)sitesCorine.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getIdSiteLink()%></a>
          <%=cm.cmsTitle("open_site_factsheet")%>
        </td>
        <td>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSiteLink()%>"><%=site.getSiteName()%></a>
          <%=cm.cmsTitle("open_site_factsheet")%>
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
    </tbody>
  </table>
<%
    }
  }
%>
<%=cm.cmsMsg("sites_factsheet_123")%>
