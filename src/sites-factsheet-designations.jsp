<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Designation for a site' - part of site's factsheet
--%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet, ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.jrfTables.DesignationsSitesRelatedDesignationsPersist"%>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String siteid = request.getParameter("idsite");
  ro.finsiel.eunis.factsheet.sites.SiteFactsheet factsheet = new SiteFactsheet( siteid );
  //WebContentManagement contentManagement = SessionManager.getWebContent();
  int type = factsheet.getType();
  if( type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD  || type == SiteFactsheet.TYPE_CORINE )
  {
    List sitesDesigc = null;
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
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">National and/or International Designation of Natura 2000 site</div>
      <table border="1" cellpadding="1" cellspacing="1" width="100%" id="relationsNatura2000Natura20002" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 0, 'relationsNatura2000Natura20002', false);">Designation code</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 1, 'relationsNatura2000Natura20002', false);">Designation name</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 2, 'relationsNatura2000Natura20002', false);">Category</a>
          </th>
          <th class="resultHeader" style="text-align : right">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 3, 'relationsNatura2000Natura20002', false);">Cover(%)</a>
          </th>
        </tr>
<%
      for (int i = 0; i < sitesDesigc.size(); i++)
      {
        DesignationsSitesRelatedDesignationsPersist desig = (DesignationsSitesRelatedDesignationsPersist)sitesDesigc.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <a title="Designation factsheet" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescription()%></a>&nbsp;
          </td>
          <td>
            <a title="Designation factsheet" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescriptionEn()%></a>
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
      </table>
      <br />
<%
    }
    //Third table should be called "Relation with designated areas" and should display information
    // from desigr table decoded with desig-x table.
    //Columns should then be des_site with link to "http://eunis.eea.eu.int/sites-names.jsp" prefilled with site name
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
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Relation with designated areas</div>
      <table border="1" cellpadding="1" cellspacing="1" width="100%" id="relationsNatura2000Natura20003" style="border-collapse:collapse">
        <tr bgcolor="#DDDDDD">
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 0, 'relationsNatura2000Natura20003', false);">Designated site</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 1, 'relationsNatura2000Natura20003', false);">Designation name</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 2, 'relationsNatura2000Natura20003', false);">Category</a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 3, 'relationsNatura2000Natura20003', false);">Overlap</a>
          </th>
          <th class="resultHeader" style="text-align : right">
            <a title="Sort results by this column" href="javascript:sortTable( 5, 4, 'relationsNatura2000Natura20003', false);">Overlap P</a>
          </th>
        </tr>
<%
        for (int i = 0; i < sitesDesigr.size(); i++)
        {
          DesignationsSitesRelatedDesignationsPersist desig = (DesignationsSitesRelatedDesignationsPersist)sitesDesigr.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <a title="Search site by name" href="sites-names.jsp?siteNameFromFactsheet=<%=desig.getDesignatedSite()%>"><%=Utilities.formatString(desig.getDesignatedSite())%></a>&nbsp;
          </td>
          <td><%=Utilities.formatString(desig.getDescriptionEn(),"")%>&nbsp;</td>
          <td><%=Utilities.formatString(desig.getNationalCategory())%>&nbsp;</td>
          <td style="text-align : right">
            <%=Utilities.formatDecimal(desig.getOverlap(), 2 )%>&nbsp;
          </td>
          <td style="text-align : right">
            <%=Utilities.formatString(desig.getOverlapType())%>&nbsp;
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
