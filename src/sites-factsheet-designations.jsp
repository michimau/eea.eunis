<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Designation for a site' - part of site's factsheet
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet, ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.jrfTables.DesignationsSitesRelatedDesignationsPersist"%>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String siteid = request.getParameter("idsite");
  ro.finsiel.eunis.factsheet.sites.SiteFactsheet factsheet = new SiteFactsheet( siteid );
  WebContentManagement cm = SessionManager.getWebContent();
  int type = factsheet.getType();
  if( type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD  || type == SiteFactsheet.TYPE_CORINE )
  {
    List sitesDesigc;
    if( type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD ) {
      sitesDesigc = factsheet.findSiteRelationsNatura2000Desigc();
    } else {
      //CORINE
      sitesDesigc = factsheet.findSiteRelationsCorine();
    }
    //2nd table should be called "National and/or International Designation of Natura 2000 site"
    // and should display information from desigc table decoded with desig-x table.
    //Columns should then be desigcode, descript with a link to Site module designation fact sheet (should always exist),
    // category and cover.
    if (sitesDesigc.size() > 0 )
    {
%>
  <h2>
    <%=cm.cmsPhrase("National and/or International Designation of Natura 2000 site")%>
  </h2>
  <table summary="<%=cm.cms("sites_factsheet_designations_national")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" style="text-align: left;">
          <%=cm.cmsPhrase("Designation code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" style="text-align: left;">
          <%=cm.cmsPhrase("Designation name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" style="text-align: left;">
          <%=cm.cmsPhrase("category")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align : right;" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsPhrase("Cover(%)")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
  for (int i = 0; i < sitesDesigc.size(); i++)
  {
    String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
    DesignationsSitesRelatedDesignationsPersist desig = (DesignationsSitesRelatedDesignationsPersist)sitesDesigc.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescription()%></a>&nbsp;
          <%=cm.cmsTitle("open_designation_factsheet")%>
        </td>
        <td>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescriptionEn()%></a>
          <%=cm.cmsTitle("open_designation_factsheet")%>
        </td>
        <td>
          <%=Utilities.formatString(desig.getNationalCategory())%>
          &nbsp;
        </td>
        <td style="text-align : right">
          <%=Utilities.formatDecimal(desig.getOverlap(), 2 )%>&nbsp;
        </td>
      </tr>
<%
      }
%>
    </tbody>
  </table>
  <br />
<%
  }
    //Third table should be called "Relation with designated areas" and should display information
    // from desigr table decoded with desig-x table.
    //Columns should then be des_site with link to "http://eunis.eea.europa.eu/sites-names.jsp" prefilled with site name
    // and data sets CDDA National, European Diploma, CDDA International and Biogenetic Reserve selected,
    // descript with a link to Site module designation fact sheet (should always exist),
    // category, overlap and overlap_p.
    List sitesDesigr = new Vector();
    if( type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD)
    {
        sitesDesigr = factsheet.findSiteRelationsNatura2000Desigr();
    }

     if (sitesDesigr.size() > 0 )
     {
%>
  <h2>
    <%=cm.cms("sites_factsheet_designations_areas")%>
  </h2>
  <table summary="<%=cm.cms("sites_factsheet_designations_areas")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Designated site")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Designation name")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("category")%>
        </th>
        <th style="text-align : right;">
          <%=cm.cmsPhrase("Overlap(%)")%>
        </th>
        <th style="text-align : right;">
          <%=cm.cmsPhrase("Overlap P(%)")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < sitesDesigr.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        DesignationsSitesRelatedDesignationsPersist desig = (DesignationsSitesRelatedDesignationsPersist)sitesDesigr.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <a title="<%=cm.cms("search_site_by_name")%>" href="sites-names.jsp?siteNameFromFactsheet=<%=desig.getDesignatedSite()%>"><%=Utilities.formatString(desig.getDesignatedSite())%></a>&nbsp;
          <%=cm.cmsTitle("search_site_by_name")%>
        </td>
        <td>
          <%=Utilities.formatString(desig.getDescriptionEn(),"&nbsp;")%>
        </td>
        <td>
          <%=Utilities.formatString(desig.getNationalCategory(), "&nbsp;")%>
        </td>
        <td style="text-align : right">
          <%=Utilities.formatString(Utilities.formatDecimal(desig.getOverlap(), 2), "&nbsp;")%>
        </td>
        <td style="text-align : right">
          <%=Utilities.formatString(desig.getOverlapType(), "&nbsp;")%>
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
