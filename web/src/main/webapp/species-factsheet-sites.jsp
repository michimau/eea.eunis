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
  //String idSpecies = request.getParameter("idSpecies");
  String mainIdSpecies = request.getParameter("mainIdSpecies");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)),
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)));
  WebContentManagement cm = SessionManager.getWebContent();
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
    <input id="showMap" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="standardButton" />
    <%=cm.cmsTitle("show_map")%>
    <%=cm.cmsInput("show_map")%>
  </form>
<%
    }
%>
  <br />
  <table summary="<%=cm.cms("species_factsheet_sites_01_Sum")%>" class="listing" style="table-layout:fixed">
    <col style="width: 8em"/>
    <col style="width: 12em"/>
    <col style="width: 12em"/>
    <col style="width: 40em"/>
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Site code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Source data set")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Country")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Site name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for (int i = 0; i < sites.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
          <%=Utilities.formatString(site.getIDSite())%>
        </td>
        <td>
            <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
        </td>
        <td>
        <%
            if(Utilities.isCountry(site.getAreaNameEn()))
            {
        %>
          <a href="species-statistics-module.jsp?countryName=<%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>" title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
        <%
            } else {
        %>
             <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%>
        <%
             }
        %>
        </td>
        <td>
          <a href="sites/<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a>
        </td>
      </tr>
<%
           if( i%10 == 0)
           {
            out.flush();
           }
         }
%>
    <tbody>
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
  <h2>
    <%=cm.cmsPhrase("Sites for subtaxa of this taxon")%>
  </h2>
  <br />
  <form name="gis2" action="sites-gis-tool.jsp" target="_blank" method="post">
    <input type="hidden" name="sites" value="<%=ids%>" />
    <input id="showMap2" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="standardButton" />
    <%=cm.cmsTitle("show_map")%>
    <%=cm.cmsInput("show_map")%>
  </form>
  <br />
  <br />
<%
    }
%>
  <table summary="<%=cm.cms("species_factsheet_sites_02_Sum")%>" class="listing fullwidth">
    <col style="width: 15%"/>
    <col style="width: 15%"/>
    <col style="width: 20%"/>
    <col style="width: 50%"/>
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Site code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Source data set")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Country")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Site name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
  for (int i = 0; i < sites2.size(); i++)
  {
    String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
    SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites2.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
          <%=Utilities.formatString(site.getIDSite())%>
        </td>
        <td>
          <strong>
            <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
          </strong>
        </td>
        <td>
        <%
            if(Utilities.isCountry(site.getAreaNameEn()))
            {
        %>
          <a href="species-statistics-module.jsp?countryName=<%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>" title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(site.getAreaNameEn())%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
        <%
            } else {
        %>
             <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%>
        <%
             }
        %>
        </td>
        <td>
          <a href="sites/<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a>
        </td>
      </tr>
<%
          }
%>
    </tbody>
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
