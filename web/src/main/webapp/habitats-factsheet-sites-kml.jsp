<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.0">
<Document>
<%@ page contentType="application/vnd.google-earth.kml+xml; charset=UTF-8" %>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
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
  String scientificName = factsheet.getHabitat().getScientificName();
  String description = factsheet.getHabitat().getDescription();
  
  response.setHeader("Content-Disposition", "attachment; filename="+scientificName+"_sites.kml");
  
  try
  {
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

    %>
	<name><%=scientificName%></name>
	<description><%=description%></description>
	<Style id="presence">
		<IconStyle>
			<scale>1.0</scale>
			<Icon>
				<href>http://eunis.eea.europa.eu/images/ge_icon.png</href>
				<x>32</x>
				<y>128</y>
				<w>32</w>
				<h>32</h>
			</Icon>
		</IconStyle>
		<LabelStyle>
			<scale>1.0</scale>
			<color>00ffffff</color>
		</LabelStyle>
	</Style>
    <%
      
    if( ( null != sites && !sites.isEmpty() ) )
    {
      // List of sites for which this habitat is recorded.
      for(int i = 0; i < sites.size(); i++)
      {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sites.get(i);
        String SiteName = Utilities.formatString(site.getName());
        String areaName = site.getAreaNameEn();
        String latitude = site.getLatitude();
        String longitude = site.getLongitude();
        SiteName = SiteName.replaceAll("&","&amp;");
%>
<Placemark>
	<name><%=SiteName%></name>
	<description>
		<%=areaName%>
	</description>
	<open>0</open>
	<styleUrl>#presence</styleUrl>
	<Point>
		<coordinates><%=longitude%>,<%=latitude%></coordinates>
	</Point>
</Placemark>
<%
      }
    }
  }
  catch(Exception _ex) {
    _ex.printStackTrace();
  }
%>
</Document>
</kml>
