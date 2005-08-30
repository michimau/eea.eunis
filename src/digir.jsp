<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'DIGIR statistics'.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();

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
    String sDigirURL = "http://ns2.finsiel.ro:8081/digir/";
    String sEndpointURL = "http://ns2.finsiel.ro:8081/digir/DiGIR.php";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    EUNIS Database 2 - DiGIR Provider Statistics
  </title>
</head>

<body>
  <div id="content">
<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,DiGIR Provider"/>
</jsp:include>
<img alt="Loading data..." id="loading" src="images/loading.gif" />
<%
  out.flush();
%>
<table summary="layout" width="100%" border="0">
 <tr>
  <td>
    <h5>EUNIS Database DiGIR Provider Statistics</h5>
    <br />
    <p>DiGIR stands for <strong>Distributed Generic Information Retrieval</strong>.<br />
    Since 2005, EUNIS Database provides information about species, using the
    <a title="DiGIR" href="http://www.digir.net/">DiGIR protocol</a> protocol and the
    <a title="Darwin Core" href="http://tsadev.speciesanalyst.net/documentation/ow.asp?DarwinCoreV2">
    Darwin Core</a> XML schema. EUNIS DiGIR Provider is a registered member of the
    GBIF Data Network.<br />
    The provider was setup using the <a title="GBIF Tools" href="http://www.gbif.org/serv/gbif-tools">
    tools</a> provided by <a title="GBIF" href="http://www.gbif.net">GBIF</a>.
    </p>

<%
  out.flush();
%>
    <span style="font-weight:bold">Statistical data regarding the EUNIS DiGIR Provider:</span>
<%
      int nTotalSpecies = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sTotalSpecies),0);
      int nDistinctSpecies = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sDistinctSpecies),0);
      int nSpeciesWithCountry = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesWithCountry),0);
      int nSpeciesWithLatLong = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesWithLatLong),0);
      int nSpeciesFromHabitats = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesFromHabitats),0);
      int nSpeciesFromSites = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sSpeciesFromSites),0);
      String DateLastModified = sqlc.ExecuteSQL(sDateLastModified);
%>
    <table summary="layout" width="100%" border="1" style="border-collapse:collapse">
      <tr bgcolor="#EEEEEE">
        <td width="50%">
          Total rows:
        </td>
        <td width="50%">
          <%=nTotalSpecies%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          Distinct Species:
        </td>
        <td>
          <%=nDistinctSpecies%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          Species with country:
        </td>
        <td>
          <%=nSpeciesWithCountry%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          Species with lat./long.:
        </td>
        <td>
          <%=nSpeciesWithLatLong%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          Species from habitat types:
        </td>
        <td>
          <%=nSpeciesFromHabitats%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          Species from sites:
        </td>
        <td>
          <%=nSpeciesFromSites%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          Last update:
        </td>
        <td>
          <%=DateLastModified%>
        </td>
      </tr>
    </table>
    <br />
    <span style="font-weight:bold">Other information:</span>
    <table summary="layout" width="100%" border="1" style="border-collapse:collapse">
      <tr bgcolor="#EEEEEE">
        <td width="50%">
          Provider URL:
        </td>
        <td width="50%">
          <a href="<%=sEndpointURL%>"><%=sEndpointURL%></a>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          Provider endpoint:
        </td>
        <td>
          <a href="<%=sDigirURL%>"><%=sDigirURL%></a>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          Institution code:
        </td>
        <td>
          <%=sInstitutionCode%>
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          Collection code:
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="digir.jsp" />
    </jsp:include>
    </div>
  </body>
</html>
<%
  out.flush();
%>
