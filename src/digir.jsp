<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'DIGIR statistics'.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

  String sTotalSpecies = "select count(*) from eunis_digir";
  String sDistinctSpecies = "select count(DISTINCT ScientificName) from eunis_digir";
  String sSpeciesWithCountry = "select count(*) from eunis_digir where Country is not null";
  String sSpeciesWithLatLong = "select count(*) from eunis_digir where DecimalLatitude is not null AND  DecimalLongitude is not null";
  String sSpeciesFromHabitats = "select count(*) from eunis_digir where GlobalUniqueIdentifier LIKE '%SPECHAB%'";
  String sSpeciesFromSites = "select count(*) from eunis_digir where GlobalUniqueIdentifier LIKE '%SPECSITE%'";
  String sDateLastModified = "select MAX(DateLastModified) from eunis_digir";
  String sInstitutionCode = "EEA";
  String sCollectionCode = "EUNIS";
  String sDigirURL = application.getInitParameter( "DIGIR_URL" );
  String sEndpointURL = application.getInitParameter( "DIGIR_SERVICE" );
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("digir_title")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
  <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,digir_location"/>
</jsp:include>
<img alt="<%=cm.cms("loading_data")%>" id="loading" src="images/loading.gif" />
<%
  out.flush();
%>
<table summary="layout" width="100%" border="0">
 <tr>
  <td>
    <h1><%=cm.cmsText("digir_01")%></h1>
    <br />
    <p><%=cm.cmsText("digir_02")%>
    </p>
    <span style="font-weight:bold"><%=cm.cmsText("digir_03")%></span>
<%
      int nTotalSpecies = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sTotalSpecies),0);
      int nDistinctSpecies = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sDistinctSpecies),0);
      int nSpeciesWithCountry = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesWithCountry),0);
      int nSpeciesWithLatLong = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesWithLatLong),0);
      int nSpeciesFromHabitats = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesFromHabitats),0);
      int nSpeciesFromSites = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesFromSites),0);
      String DateLastModified = sqlc.ExecuteSQL(sDateLastModified);

      if(nTotalSpecies != 0) {
%>
    <table summary="layout" width="100%" border="1" style="border-collapse:collapse">
      <tr bgcolor="#EEEEEE">
        <td width="50%">
          <%=cm.cmsText("digir_total_rows")%>
        </td>
        <td width="50%">
          <%=nTotalSpecies%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=cm.cmsText("digir_distinct_species")%>
        </td>
        <td>
          <%=nDistinctSpecies%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=cm.cmsText("digir_species_country")%>
        </td>
        <td>
          <%=nSpeciesWithCountry%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=cm.cmsText("digir_species_latlong")%>
        </td>
        <td>
          <%=nSpeciesWithLatLong%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=cm.cmsText("digir_species_habitats")%>
        </td>
        <td>
          <%=nSpeciesFromHabitats%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=cm.cmsText("digir_species_sites")%>
        </td>
        <td>
          <%=nSpeciesFromSites%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=cm.cmsText("digir_last_update")%>
        </td>
        <td>
          <%=DateLastModified%>
        </td>
      </tr>
    </table>
<%
  } else {
%>
    <br />
    <!--The DiGIR database is empty or the connection could not be established!-->
    <!--<br />-->
    <%=cm.cmsText("digir_statistics_are_not_available")%>
    <br />
    <br />
<%
  }
%>
    <br />
    <span style="font-weight:bold"><%=cm.cmsText("digir_other_information")%></span>
    <table summary="layout" width="100%" border="1" style="border-collapse:collapse">
      <tr bgcolor="#EEEEEE">
        <td width="50%">
          <%=cm.cmsText("digir_provider_url")%>
        </td>
        <td width="50%">
          <a href="<%=sEndpointURL%>"><%=sEndpointURL%></a>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=cm.cmsText("digir_provider_endpoint")%>
        </td>
        <td>
          <a href="<%=sDigirURL%>"><%=sDigirURL%></a>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=cm.cmsText("digir_institution_code")%>
        </td>
        <td>
          <%=sInstitutionCode%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=cm.cmsText("digir_collection_code")%>
        </td>
        <td>
          <%=sCollectionCode%>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
    <script language="JavaScript" type="text/javascript">
      var load = document.getElementById( "loading" );
      load.style.display="none";
    </script>
    <%=cm.br()%>
    <%=cm.cmsMsg("digir_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("loading_data")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("digir_location")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="digir.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
</body>
</html>
