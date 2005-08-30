 <%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - sites relations.
--%>
<%@page contentType="text/html"%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();

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
          <label for="showMap" class="noshow">Show map</label>  
          <input id="showMap" type="submit" title="Show map" name="Show map" value="Show map" class="inputTextField" />
        </form>
<%
    }
%>
        <br />
        <table summary="List of sites" width="100%" border="1" cellspacing="1" cellpadding="0" id="sites" style="border-collapse:collapse">
          <tr style="background-color:#DDDDDD">
            <th class="resultHeaderForFactsheet" width="15%"><strong><a title="Sort by Site code" href="javascript:sortTable(4,0, 'sites', false);"><%=contentManagement.getContent("species_factsheet_sitescode")%></a></strong></th>
            <th class="resultHeaderForFactsheet" width="15%"><strong><a title="Sort by Site source" href="javascript:sortTable(4,1, 'sites', false);"><%=contentManagement.getContent("species_factsheet_sitessource")%></a></strong></th>
            <th class="resultHeaderForFactsheet" width="20%"><strong><a title="Sort by Site country" href="javascript:sortTable(4,2, 'sites', false);"><%=contentManagement.getContent("species_factsheet_sitescountry")%></a></strong></th>
            <th class="resultHeaderForFactsheet" width="50%"><strong><a title="Sort by Site name" href="javascript:sortTable(4,3, 'sites', false);"><%=contentManagement.getContent("species_factsheet_sitesname")%></a></strong></th>
          </tr>
<%
          for (int i = 0; i < sites.size(); i++)
          {
            SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites.get(i);
%>
          <tr style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=Utilities.formatString(site.getIDSite())%></td>
            <td><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></td>
            <td><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></td>
            <td><a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a></td>
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
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Sites for subtaxa of this taxon</div>
        <br />
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="50%">
              <form name="gis2" action="sites-gis-tool.jsp" target="_blank" method="post">
                <input type="hidden" name="sites" value="<%=ids%>" />
                <label for="showMap" class="noshow">Show map</label>
                <input id="showMap2" type="submit" title="Show map" name="Show map" value="Show map" class="inputTextField" />
              </form>
            </td>
          </tr>
        </table>
        <br />
        <br />
        <table summary="List of sites for subtaxa of this taxon" width="100%" border="1" cellspacing="1" cellpadding="0"  id="sites2" style="border-collapse:collapse">
<%
    }
%>
          <tr style="background-color:#DDDDDD">
            <th class="resultHeaderForFactsheet" width="15%"><strong><a title="Sort by Id site" href="javascript:sortTable(4,0, 'sites2', false);">Id site</a></strong></th>
            <th class="resultHeaderForFactsheet" width="15%"><strong><a title="Sort by Site source" href="javascript:sortTable(4,1, 'sites2', false);"><%=contentManagement.getContent("species_factsheet_sitessource")%></a></strong></th>
            <th class="resultHeaderForFactsheet" width="20%"><strong><a title="Sort by Site country" href="javascript:sortTable(4,2, 'sites2', false);"><%=contentManagement.getContent("species_factsheet_sitescountry")%></a></strong></th>
            <th class="resultHeaderForFactsheet" width="50%"><strong><a title="Sort by name" href="javascript:sortTable(4,3, 'sites2', false);"><%=contentManagement.getContent("species_factsheet_sitesname")%></a></strong></th>
          </tr>
<%
          for (int i = 0; i < sites2.size(); i++)
          {
            SitesByNatureObjectPersist site = (SitesByNatureObjectPersist)sites2.get(i);
%>
          <tr style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=Utilities.formatString(site.getIDSite())%></td>
            <td><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></td>
            <td><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()))%></td>
            <td><a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName()))%></a></td>
          </tr>
<%
          }
%>
        </table>
<%
      }
%>

<br />
<br />