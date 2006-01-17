 <%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - sites relations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility"%>
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  String idSpeciesLink = request.getParameter("idSpeciesLink");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(idSpecies, new Integer(0)),
          Utilities.checkedStringToInt(idSpeciesLink, new Integer(0)));
  boolean expand = Utilities.checkedStringToBoolean(request.getParameter("expand"), false);
  WebContentManagement cm = SessionManager.getWebContent();

  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );

  // List of sites related to species.
  List sites = factsheet.getSitesForSpecies();
  if (sites.size() > 0)
  {
    String ids = "";
    int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
    if ( sites.size() < maxSitesPerMap )
    {
      for (int i = 0; i < sites.size(); i++)
      {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites.get(i);
        ids += "'" + site.getIDSite() + "'";
        if ( i < sites.size() - 1 ) ids += ",";
      }
%>
        <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
          <input type="hidden" name="sites" value="<%=ids%>" />
          <input id="showMap" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="inputTextField" />
          <%=cm.cmsTitle("show_map")%>
          <%=cm.cmsInput("show_map")%>
        </form>
<%
    }
%>
        <br />
        <table summary="<%=cm.cms("species_factsheet_sites_01_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="sites" class="sortable">
          <tr>
            <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitescode")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitessource")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="20%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitescountry")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="50%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitesname")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
          </tr>
<%
          for (int i = 0; i < sites.size(); i++)
          {
            SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites.get(i);
%>
          <tr style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=Utilities.formatString(site.getIDSite())%></td>
            <td><strong><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></strong></td>
            <td>
        <%
            if(Utilities.isCountry(site.getAreaNameEn()))
            {
        %>
          <a href="javascript:goToSpeciesStatistics('<%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>')" title="<%=cm.cms("open_statistical_data")%> <%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></a>
          <%=cm.cmsTitle("open_statistical_data")%>
        <%
            } else {
        %>
             <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%>
        <%
             }
        %>
            </td>
            <td>
                <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a>
                <%=cm.cmsTitle("open_site_factsheet")%>
            </td>
          </tr>
<%
           if( i%10 == 0) {
            out.flush();
           }
         }
%>
        </table>
        <br />
        <br />
<%
      }

  // List of sites related to subspecies.
  List sites2 = factsheet.getSitesForSubpecies();
  if (sites2.size() > 0)
  {
    String ids = "";
    int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
    if ( sites2.size() < maxSitesPerMap )
    {
      for (int i = 0; i < sites2.size(); i++)
      {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites2.get(i);
        ids += "'" + site.getIDSite() + "'";
        if ( i < sites.size() - 1 ) ids += ",";
      }
%>
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet_sites_02")%></div>
        <br />
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="50%">
              <form name="gis2" action="sites-gis-tool.jsp" target="_blank" method="post">
                <input type="hidden" name="sites" value="<%=ids%>" />
                <input id="showMap2" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="inputTextField" />
                <%=cm.cmsTitle("show_map")%>
                <%=cm.cmsInput("show_map")%>
              </form>
            </td>
          </tr>
        </table>
        <br />
        <br />
<%
    }
%>
       <table summary="<%=cm.cms("species_factsheet_sites_02_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0"  id="sites2" class="sortable">
          <tr>
            <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sites_03")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>" >
              <strong>
                <%=cm.cmsText("species_factsheet_sitessource")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="20%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitescountry")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
            <th width="50%" title="<%=cm.cms("sort_results_on_this_column")%>">
              <strong>
                <%=cm.cmsText("species_factsheet_sitesname")%>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </strong>
            </th>
          </tr>
<%
          for (int i = 0; i < sites2.size(); i++)
          {
            SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites2.get(i);
%>
          <tr style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=Utilities.formatString(site.getIDSite())%></td>
            <td><strong><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></strong></td>
            <td>
        <%
            if(Utilities.isCountry(site.getAreaNameEn()))
            {
        %>
          <a href="javascript:goToSpeciesStatistics('<%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>')" title="<%=cm.cms("species_factsheet-geo_12_Title")%> <%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></a>
          <%=cm.cmsTitle("species_factsheet-geo_12_Title")%>
        <%
            } else {
        %>
             <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%>
        <%
             }
        %>
            </td>
            <td>
                <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a>
                <%=cm.cmsTitle("open_site_factsheet")%>
            </td>
          </tr>
<%
          }
%>
        </table>
<%
      }
%>

<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_sites_01_Sum")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_sites_02_Sum")%>
<%=cm.br()%>

<br />
<br />