<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
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

  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(request.getParameter("idSpecies"), new Integer(0)),
          Utilities.checkedStringToInt(request.getParameter("idSpeciesLink"), new Integer(0)));
  String PdfUrl = "javascript:openLink('species-factsheet-pdf.jsp?idSpecies="+factsheet.getIdSpecies()+"&amp;idSpeciesLink="+factsheet.getIdSpeciesLink()+"')";
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
      <%=cm.cmsPhrase("We are sorry, the requested species does not exist")%>.
    </title>
<%
  }
%>
 <jsp:include page="/header-page.jsp">
     <jsp:param name="metaDescription" value="<%=metaDescription%>" />
   </jsp:include>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <jsp:include page="/header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <jsp:include page="/header-dynamic.jsp">
                  <jsp:param name="location" value="${actionBean.btrail}" />
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
<%
  if ( factsheet.exists() )
  {
                  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
                  SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
                  String scientificName = specie.getScientificName();

                %>
                <img alt="<%=cm.cms("loading_data")%>" id="loading" src="images/loading.gif" />
                  <c:if test="${actionBean.referedFromName != null}">
	                  redirected from <strong>${actionBean.referedFromName }</strong>
                  </c:if>
                  <h1 class="documentFirstHeading">
                    <%=Utilities.treatURLSpecialCharacters(scientificName)%>
                  </h1>
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
                    <li>
                      <a href="<%=PdfUrl%>"><img src="images/pdf.png"
                             alt="<%=cm.cms( "header_download_pdf_title" )%>"
                             title="<%=cm.cms( "header_download_pdf_title" )%>" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
                <%=cm.cmsPhrase("Scientific name")%>: <%=Utilities.treatURLSpecialCharacters(scientificName)%>
                <br />
                <%=cm.cmsPhrase("Author")%>:<strong><%=Utilities.treatURLSpecialCharacters(factsheet.getSpeciesNatureObject().getAuthor())%></strong>
                <br />
                <br />
                <div id="tabbedmenu">
                  <ul>
	              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
              		<c:choose>
              			<c:when test="${dataTab.id eq actionBean.tab}">
	              			<li id="currenttab">
	              				<a title="<%=cm.cms("show")%> ${dataTab.value}" href="species-factsheet.jsp?tab=${dataTab.id}&amp;idSpecies=${actionBean.idSpecies}&amp;idSpeciesLink=${idSpeciesLink}">${dataTab.value}</a>
	              			</li>
              			</c:when>
              			<c:otherwise>
              				<li id="currenttab">
	              				<a title="<%=cm.cms("show")%> ${dataTab.value}" href="species-factsheet.jsp?tab=${dataTab.id}&amp;idSpecies=${actionBean.idSpecies}&amp;idSpeciesLink=${idSpeciesLink}">${dataTab.value}</a>
	              			</li>
              			</c:otherwise>
              		</c:choose>
              		</c:forEach>
                  </ul>
                </div>
                <br style="clear:both;" clear="all" />
                <br />
              <%
                  if ( tab == 0 )
                  {
              %>
                <%-- General information--%>
                <jsp:include page="/species-factsheet-general.jsp">
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                </jsp:include>
              <%
                  }
                  if ( tab == 1 )
                  {
              %>
                <%-- Vernacular names tab --%>
                <jsp:include page="/species-factsheet-vern.jsp">
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
                <jsp:include page="/species-factsheet-geo.jsp">
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
                <jsp:include page="/species-factsheet-pop.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 4 )
                  {
              %>
                <%-- Trends --%>
                <jsp:include page="/species-factsheet-trends.jsp">
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
                <jsp:include page="/species-factsheet-references.jsp">
                  <jsp:param name="idSpecies" value="<%=factsheet.getIdSpecies()%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 6 )
                  {
	                  String kmlUrl = "species-factsheet-distribution-kml.jsp?idSpecies="+factsheet.getIdSpecies()+"&amp;idSpeciesLink="+factsheet.getIdSpeciesLink();
              %>
                <%-- Grid distribution --%>
                <jsp:include page="/species-factsheet-distribution.jsp">
                  <jsp:param name="name" value="<%=scientificName%>" />
                  <jsp:param name="idNatureObject" value="<%=specie.getIdNatureObject()%>" />
                  <jsp:param name="kmlUrl" value="<%=kmlUrl%>" />
                </jsp:include>
              <%
                  }
                  if ( tab == 7 )
                  {
              %>
                <%-- Threat statis --%>
                <jsp:include page="/species-factsheet-threat.jsp">
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                  <jsp:param name="scName" value="<%=scientificName%>" />
                  <jsp:param name="expand" value="true" />
                </jsp:include>
              <%
                  }
                  if ( tab == 8 )
                  {
              %>
                <%-- Legal instruments --%>
                <jsp:include page="/species-factsheet-legal.jsp">
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                </jsp:include>
              <%
                  }
                  if ( tab == 9 )
                  {
              %>
                <%-- Related habitats --%>
                <jsp:include page="/species-factsheet-habitats.jsp">
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                </jsp:include>
              <%
                  }
                  if ( tab == 10 )
                  {
              %>
                <%-- Related sites --%>
                <jsp:include page="/species-factsheet-sites.jsp">
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                </jsp:include>
<%
                  }
                  if ( tab == 11 )
                  {
              %>
                <%-- GBIF observations --%>
                <jsp:include page="/species-factsheet-gbif.jsp">
                  <jsp:param name="scientificName" value="<%=scientificName%>" />
                  <jsp:param name="idSpecies" value="${actionBean.idSpecies}" />
                </jsp:include>
<%
                  }
  }
  else
  {
%>
                <div class="error-msg">
                  <%=cm.cmsPhrase("We are sorry, the requested species does not exist")%>.
                </div>
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
                <%=cm.cmsMsg("gbif")%>
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
              <jsp:include page="/inc_column_left.jsp">
                <jsp:param name="page_name" value="species-factsheet.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="/footer-static.jsp" />
    </div>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
      //]]>
    </script>
  </body>
</html>
