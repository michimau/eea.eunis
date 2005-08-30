<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats sites' function - display links to all habitat searches.
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectDomain,
                 ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility" %>
<%@ page import="java.util.List"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  //int tab = Utilities.checkedStringToInt(request.getParameter("tab"), 0);
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement contentManagement = SessionManager.getWebContent();
  try {

    String isGoodHabitat = " IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ";
    // Sites for which this habitat is recorded.
    List sites = new SitesByNatureObjectDomain().findCustom("SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_HABITAT AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE   " + isGoodHabitat + " AND A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT");

    // Sites for habitat subtypes.
    List sitesForSubtypes = new SitesByNatureObjectDomain().findCustom("SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_HABITAT AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() +
      (factsheet.isAnnexI() ? " and right(A.code_2000,2) <> '00' and length(A.code_2000) = 4 AND if(right(A.code_2000,1) = '0',left(A.code_2000,3),A.code_2000) like '" + factsheet.getCode2000() + "%' and A.code_2000 <> '" + factsheet.getCode2000() + "'" : " AND A.EUNIS_HABITAT_CODE like '" + factsheet.getEunisHabitatCode() + "%' and A.EUNIS_HABITAT_CODE<> '" + factsheet.getEunisHabitatCode() + "'") +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT");

    if( ( null != sites && !sites.isEmpty() ) || ( null != sitesForSubtypes && !sitesForSubtypes.isEmpty() ) )
    {
      String ids = "";
      int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
      if ( sites.size() < maxSitesPerMap )
      {
        for(int i = 0; i < sites.size(); i++) {
          SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sites.get(i);
          ids += "'" + site.getIDSite() + "'";
          if(i < sites.size() - 1) ids += ",";
        }
%>

<form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
  <input type="hidden" name="sites" value="<%=ids%>" />
  <label for="ShowMap" class="noshow">Show map</label>
  <input type="submit" name="Show map" id="ShowMap" value="Show map" title="Show map" class="inputTextField" />
</form>
<%
      }
%>
<br />
<div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_sitesForHabitatRecorded")%></div>
<table summary="Habitat types sites" width="100%" border="0" cellspacing="0" cellpadding="0" id="sites" style="border-collapse : collapse;">
  <tr bgcolor="#DDDDDD" valign="middle">
    <th class="resultHeader" width="15%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 0, 'sites', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_68")%></strong></a>
    </th>
    <th class="resultHeader" width="15%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 1, 'sites', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_69")%></strong></a>
    </th>
    <th class="resultHeader" width="20%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 2, 'sites', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_70")%></strong></a>
    </th>
    <th class="resultHeader" width="50%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 3, 'sites', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_71")%></strong></a>
    </th>
  </tr>
  <%
    // List of sites for which this habitat is recorded.
    for(int i = 0; i < sites.size(); i++) {
      SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sites.get(i);
  %>
  <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
    <td><%=Utilities.formatString(site.getIDSite())%></td>
    <td><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></td>
    <td><%=Utilities.formatString(site.getAreaNameEn())%></td>
    <%
    String SiteName = Utilities.formatString(site.getName());
    SiteName = SiteName.replaceAll("&","&amp;");
    %>
    <td><a title="Open site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=SiteName%></a></td>
  </tr>
  <%
    }
  %>
</table>
<%
  if(null != sitesForSubtypes && !sitesForSubtypes.isEmpty()) {
%>
<br />
<div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_sitesForSubtypes")%></div>
<table summary="Habitat types related sites" width="100%" border="0" cellspacing="0" cellpadding="0" id="sites2" style="border-collapse : collapse;">
  <tr bgcolor="#DDDDDD" valign="middle">
    <th class="resultHeader" width="15%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 0, 'sites2', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_68")%></strong></a>
    </th>
    <th class="resultHeader" width="15%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 1, 'sites2', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_69")%></strong></a>
    </th>
    <th class="resultHeader" width="20%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 2, 'sites2', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_70")%></strong></a>
    </th>
    <th class="resultHeader" width="50%">
      <a title="Sort table by this column" href="javascript:sortTable(4, 3, 'sites2', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_71")%></strong></a>
    </th>
  </tr>
  <%
    // List of sites for habitat subtypes
    for(int i = 0; i < sitesForSubtypes.size(); i++) {
      SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sitesForSubtypes.get(i);
  %>
  <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
    <td><%=Utilities.formatString(site.getIDSite())%></td>
    <td><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></td>
    <td><%=Utilities.formatString(site.getAreaNameEn())%></td>
    <%
    String SiteName = Utilities.formatString(site.getName());
    SiteName = SiteName.replaceAll("&","&amp;");
    %>
    <td><a title="Open site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIDSite()%>"><%=SiteName%></a></td>
  </tr>
  <%
    }
  %>
</table>


<%
      }
    }
  }
  catch(Exception _ex) {
    _ex.printStackTrace();
  }
%>