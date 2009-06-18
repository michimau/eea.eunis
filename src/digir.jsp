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
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Hashtable" %>
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
  String sDigirStatistics = "select DistinctSpecies, SpeciesWithCountry, SpeciesWithLatLong, SpeciesFromHabitats, SpeciesFromSites, DateLastModified from eunis_digir_stats";
  
  String sInstitutionCode = "EEA";
  String sCollectionCode = "EUNIS";
  String sDigirURL = application.getInitParameter( "DIGIR_URL" );
  String sEndpointURL = application.getInitParameter( "DIGIR_SERVICE" );
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,digir_location";
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("digir_title")%>
  </title>
</head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <img alt="<%=cm.cms("loading_data")%>" id="loading" src="images/loading.gif" />
                <%
                  out.flush();
                %>
                    <h1><%=cm.cmsPhrase("EUNIS Database DiGIR Provider Statistics")%></h1>
                    
                   <%=cm.cmsText("digir_02")%>

                    <h2><%=cm.cmsPhrase("Statistical data regarding the EUNIS DiGIR Provider:")%></h2>
                <%
                      int nTotalSpecies = Utilities.checkedStringToInt(sqlc.ExecuteSQL(sTotalSpecies),0);
                      
                      if(nTotalSpecies != 0) {
	                      
	                      String nDistinctSpecies = "0";
	                      String nSpeciesWithCountry = "0";
	                      String nSpeciesWithLatLong = "0";
	                      String nSpeciesFromHabitats = "0";
	                      String nSpeciesFromSites = "0";
	                      String DateLastModified = "";
                      
	                      Hashtable<String,String> h = sqlc.getHashtable(sDigirStatistics);
	                      if(h!= null && h.size() > 0){
		                      nDistinctSpecies = h.get("DistinctSpecies");
	                      	  nSpeciesWithCountry = h.get("SpeciesWithCountry");
	                      	  nSpeciesWithLatLong = h.get("SpeciesWithLatLong");
	                      	  nSpeciesFromHabitats = h.get("SpeciesFromHabitats");
	                      	  nSpeciesFromSites = h.get("SpeciesFromSites");
	                      	  DateLastModified = h.get("DateLastModified");
	                      }

                      
                %>
                    <table width="90%" class="datatable">
                      <col style="width:50%"/>
                      <col style="width:50%"/>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Total rows:")%>
                        </td>
                        <td>
                          <%=nTotalSpecies%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td>
                          <%=cm.cmsPhrase("Distinct Species:")%>
                        </td>
                        <td>
                          <%=nDistinctSpecies%>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Species with country:")%>
                        </td>
                        <td>
                          <%=nSpeciesWithCountry%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td>
                          <%=cm.cmsPhrase("Species with lat./long.:")%>
                        </td>
                        <td>
                          <%=nSpeciesWithLatLong%>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Species from habitat types:")%>
                        </td>
                        <td>
                          <%=nSpeciesFromHabitats%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td>
                          <%=cm.cmsPhrase("Species from sites:")%>
                        </td>
                        <td>
                          <%=nSpeciesFromSites%>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Last update:")%>
                        </td>
                        <td>
                          <%=DateLastModified%>
                        </td>
                      </tr>
                    </table>
                <%
                  } else {
                %>
                    <p>
                    <!--The DiGIR database is empty or the connection could not be established!-->
                    <!--<br />-->
                    <%=cm.cmsPhrase("The statistics are not available. Please try later.")%>
                    </p>
                <%
                  }
                %>
                    <h2><%=cm.cmsPhrase("Other information:")%></h2>
                    <table class="datatable">
                      <col style="width:50%"/>
                      <col style="width:50%"/>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Provider URL:")%>
                        </td>
                        <td>
                          <a href="<%=sEndpointURL%>"><%=sEndpointURL%></a>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td>
                          <%=cm.cmsPhrase("Provider endpoint:")%>
                        </td>
                        <td>
                          <a href="<%=sDigirURL%>"><%=sDigirURL%></a>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Institution code:")%>
                        </td>
                        <td>
                          <%=sInstitutionCode%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td>
                          <%=cm.cmsPhrase("Collection code:")%>
                        </td>
                        <td>
                          <%=sCollectionCode%>
                        </td>
                      </tr>
                    </table>
                    </td>
                  </tr>
                </table>
                <%=cm.br()%>
                <%=cm.cmsMsg("digir_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading_data")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("digir_location")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="digir.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
    <script language="JavaScript" type="text/javascript">
      var load = document.getElementById( "loading" );
      load.style.display="none";
    </script>
  </body>
</html>
