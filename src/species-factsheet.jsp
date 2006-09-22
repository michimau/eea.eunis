<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.utilities.SQLUtilities,
                ro.finsiel.eunis.factsheet.species.*,
                ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  String idSpeciesLink = request.getParameter("idSpeciesLink");

  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(idSpecies, new Integer(0)),
                                                    Utilities.checkedStringToInt(idSpeciesLink, new Integer(0)));
  String eeaHome = application.getInitParameter( "EEA_HOME" );
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" src="script/species.js" type="text/javascript"></script>
    <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
<%
  String metaDescription = "";
  if ( factsheet.exists() )
  {
    SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
    String scientificName = specie.getScientificName();
    metaDescription = factsheet.getSpeciesDescription();
%>
    <title>
      <%=cm.cms("species_factsheet_title")%>
      <%=Utilities.treatURLSpecialCharacters(scientificName)%>
    </title>
<%
  }
  else
  {
%>
    <title>
      <%=cm.cmsText("species_factsheet_nodata")%>.
    </title>
<%
  }
%>
    <jsp:include page="header-page.jsp">
      <jsp:param name="metaDescription" value="<%=metaDescription%>" />
    </jsp:include>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
<%
  if ( factsheet.exists() )
  {
                  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
                  SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
                  String scientificName = specie.getScientificName();

                  String []tabs = {
                          cm.cms("general_information"),
                          cm.cms("vernacular_names"),
                          cm.cms("geographical_distribution"),
                          cm.cms("population"),
                          cm.cms("trends"),
                          cm.cms("references"),
                          cm.cms("grid_distribution"),
                          cm.cms("threat_status"),
                          cm.cms("legal_instruments"),
                          cm.cms("habitat_types"),
                          cm.cms("sites")
                  };

                  String []dbtabs = {
                          "GENERAL_INFORMATION",
                          "VERNACULAR_NAMES",
                          "GEOGRAPHICAL_DISTRIBUTION",
                          "POPULATION",
                          "TRENDS",
                          "REFERENCES",
                          "GRID_DISTRIBUTION",
                          "THREAT_STATUS",
                          "LEGAL_INSTRUMENTS",
                          "HABITATS",
                          "SITES"
                  };

                  String SQL_DRV = application.getInitParameter("JDBC_DRV");
                  String SQL_URL = application.getInitParameter("JDBC_URL");
                  String SQL_USR = application.getInitParameter("JDBC_USR");
                  String SQL_PWD = application.getInitParameter("JDBC_PWD");
                  String PdfUrl = "javascript:openLink('species-factsheet-pdf.jsp?idSpecies="+factsheet.getIdSpecies()+"&amp;idSpeciesLink="+factsheet.getIdSpeciesLink()+"')";
%>
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="eea#<%=eeaHome%>,home#index.jsp,species#species.jsp,factsheet" />
                  <jsp:param name="printLink" value="<%=PdfUrl%>" />
                </jsp:include>
                <img alt="<%=cm.cms("loading_data")%>" id="loading" src="images/loading.gif" />
                <div style="width: 100%; text-align: center;">
                  <h1>
                    <%=Utilities.treatURLSpecialCharacters(scientificName)%>
                  </h1>
                </div>
                <br />
                <%=cm.cmsText("scientific_name")%>: <%=Utilities.treatURLSpecialCharacters(scientificName)%>
                <br />
                <%=cm.cmsText("author")%>:<strong><%=Utilities.treatURLSpecialCharacters(factsheet.getSpeciesNatureObject().getAuthor())%></strong>
                <br />
                <br />
                <div id="tabbedmenu">
                  <ul>
              <%
                SQLUtilities sqlUtilities = new SQLUtilities();
                sqlUtilities.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

                String currentTab;
                for(int i = 0; i < tabs.length; i++) {
                  currentTab = "";
                  if(tab == i) currentTab = " id=\"currenttab\"";

                  //System.out.println("factsheet.getSpeciesNatureObject().getIdNatureObject().toString() = " + factsheet.getSpeciesNatureObject().getIdSpecies().toString());

                  if(!sqlUtilities.TabPageIsEmpy(factsheet.getSpeciesNatureObject().getIdNatureObject().toString(),"SPECIES",dbtabs[i]))
                  {
                    %>
                    <li<%=currentTab%>>
                      <!--<a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="species-factsheet.jsp?tab=<%=i%>&amp;idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"><%=tabs[ i ]%></a><div style="background-color:#F0F0EB;"><%=cm.cmsTitle("show")%></div>-->
                      <a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="species-factsheet.jsp?tab=<%=i%>&amp;idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"><%=tabs[ i ]%></a>
                    </li>
                    <%
                  }
                }
              %>
                  </ul>
                </div>
                <br style="clear:both;" clear="all" />
                <br />
              <%
                  if ( tab == 0 )
                  {
              %>
                <%-- General information--%>
                <jsp:include page="species-factsheet-general.jsp">
                  <jsp:param name="idSpecies" value="<%=idSpecies%>" />
                  <jsp:param name="idSpeciesLink" value="<%=idSpeciesLink%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 1 )
                  {
              %>
                <%-- Vernacular names tab --%>
                <jsp:include page="species-factsheet-vern.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idSpecies" value="<%=factsheet.getIdSpecies()%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 2 )
                  {
              %>
                <%-- Geographical distribution --%>
                <jsp:include page="species-factsheet-geo.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idSpecies" value="<%=factsheet.getIdSpecies()%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 3 )
                  {
              %>
                <%-- Population --%>
                <jsp:include page="species-factsheet-pop.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 4 )
                  {
              %>
                <%-- Trends --%>
                <jsp:include page="species-factsheet-trends.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                  <jsp:param name="idSpecies" value="<%=specie.getIdSpecies()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 5 )
                  {
              %>
                <%-- References --%>
                <jsp:include page="species-factsheet-references.jsp">
                  <jsp:param name="idSpecies" value="<%=factsheet.getIdSpecies()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 6 )
                  {
              %>
                <%-- Grid distribution --%>
                <jsp:include page="species-factsheet-distribution.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 7 )
                  {
              %>
                <%-- Threat statis --%>
                <jsp:include page="species-factsheet-threat.jsp">
                  <jsp:param name="idSpecies" value="<%=idSpecies%>" />
                  <jsp:param name="scName" value="<%=scientificName%>" />
                  <jsp:param name="expand" value="true" />
                </jsp:include>
              <%
                  }
                  if ( tab == 8 )
                  {
              %>
                <%-- Legal instruments --%>
                <jsp:include page="species-factsheet-legal.jsp">
                  <jsp:param name="idSpecies" value="<%=idSpecies%>" />
                  <jsp:param name="idSpeciesLink" value="<%=idSpeciesLink%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 9 )
                  {
              %>
                <%-- Related habitats --%>
                <jsp:include page="species-factsheet-habitats.jsp">
                  <jsp:param name="idSpecies" value="<%=idSpecies%>" />
                  <jsp:param name="idSpeciesLink" value="<%=idSpeciesLink%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 10 )
                  {
              %>
                <%-- Related sites --%>
                <jsp:include page="species-factsheet-sites.jsp">
                  <jsp:param name="idSpecies" value="<%=idSpecies%>" />
                  <jsp:param name="idSpeciesLink" value="<%=idSpeciesLink%>" />
                </jsp:include>
<%
                  }
  }
  else
  {
%>
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="eea#<%=eeaHome%>,home#index.jsp,species#species.jsp,factsheet" />
                </jsp:include>
                <br />
                <strong>
                  <%=cm.cmsText("species_factsheet_nodata")%>.
                </strong>
                <br />
<%
  }
%>
                <%=cm.br()%>
                <%=cm.cmsMsg("general_information")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("vernacular_names")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("geographical_distribution")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("population")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("trends")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("references")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("grid_distribution")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("threat_status")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("legal_instruments")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitat_types")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_factsheet_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("show")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading_data")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-factsheet.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
    <script language="JavaScript" type="text/javascript">
    <!--
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
      //-->
    </script>
  </body>
</html>
