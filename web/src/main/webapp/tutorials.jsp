<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Tutorials page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
      String eeaHome = application.getInitParameter( "EEA_HOME" );
      String btrail = "eea#" + eeaHome + ",home#index.jsp,user_tutorials_location";
    %>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Tutorials") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1><%=cm.cmsPhrase("EUNIS Database Learning tutorials")%></h1>
<!-- MAIN CONTENT -->
                <%=cm.cmsText("tutorials_main")%>
                  <h2><%=cm.cmsPhrase("Species")%></h2>
                  <ul>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_name&amp;title=Search%20Species%20by%20name"><%=cm.cmsPhrase("Search species by name")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_country_biogeographic_region&amp;title=Search%20species%20by%20country/biogeoregion"><%=cm.cmsPhrase("Search species by country/biogeoregion")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_groups&amp;title=Search%20species%20by%20group"><%=cm.cmsPhrase("Search species by group")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_synonyms&amp;title=Search%20Species%20by%20synonyms"><%=cm.cmsPhrase("Search species by synonyms")%></a>
                    </li>
                    <!--
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_threat_status&amp;title=Search%20species%20by%20threat%20status">Search species by threat status</a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_species_by_legal_instruments&amp;title=Search%20species%20by%20legal%20instruments">Search species by legal instruments</a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Pick_species_show_habitats&amp;title=Find%20habitat%20types%20characterised%20by%20a%20particular%20species">Find habitat types characterised by a particular species</a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Pick_species_show_sites&amp;title=Find%20sites%20characterised%20by%20a%20particular%20species">Find sites characterised by a particular species</a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Taxonomic_classification&amp;title=Taxonomic%20classification%20for%20species">Taxonomic classification for species</a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Advanced_species_search&amp;title=Search%20species%20using%20advanced%20search%20function">Search species using advanced search function</a>
                    </li>
                    !-->
                  </ul>

                  <h2><%=cm.cmsPhrase("Habitat types")%></h2>
                  <ul>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_name&amp;title=Search%20habitat%20types%20by%20name"><%=cm.cmsPhrase("Search habitat types by name")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_code_classification&amp;title=Search%20habitat%20types%20by%20code%20classification"><%=cm.cmsPhrase("Search habitat types by code classification")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_country_region&amp;title=Search%20habitat%20types%20by%20country/biogeoregion"><%=cm.cmsPhrase("Search habitat types by country/biogeoregion")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_legal_instruments&amp;title=Search%20habitat%20types%20by%20legal%20instruments"><%=cm.cmsPhrase("Search habitat types by legal instruments")%></a>
                    </li>
                  </ul>

                  <h2><%=cm.cmsPhrase("Sites")%></h2>
                  <ul>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_name&amp;title=Search%20sites%20by%20name"><%=cm.cmsPhrase("Search sites by name")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_coordinates&amp;title=Search%20sites%20by%20geographical%20coordinates"><%=cm.cmsPhrase("Search sites by geographical coordinates")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_country&amp;title=Search%20sites%20by%20country"><%=cm.cmsPhrase("Search sites by country")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_size&amp;title=Search%20sites%20by%20size"><%=cm.cmsPhrase("Search sites by size")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_designation_year&amp;title=Search%20sites%20by%20designation"><%=cm.cmsPhrase("Search sites by designation")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Search_sites_by_altitude&amp;title=Search%20sites%20by%20altitude"><%=cm.cmsPhrase("Search sites by altitude")%></a>
                    </li>
                  </ul>

                  <h2><%=cm.cmsPhrase("General usage")%></h2>
                  <ul>
                    <li>
                      <a href="flash-movie.jsp?tutorial=General_Usage&amp;title=EUNIS%20Database%20general%20usage"><%=cm.cmsPhrase("EUNIS Database general usage")%></a>
                    </li>
                  </ul>

                  <h2><%=cm.cmsPhrase("Advanced usage")%></h2>
                  <ul>
                    <li>
                      <a href="gis-tool-help.jsp" title="GIS Tool help"><%=cm.cmsPhrase("GIS Tool Help")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Advanced_Search&amp;title=EUNIS%20Database%20Advanced%20search"><%=cm.cmsPhrase("EUNIS Database Advanced search")%></a>
                    </li>
                    <li>
                      <a href="flash-movie.jsp?tutorial=Combined_Search&amp;title=EUNIS%20Database%20Combined%20search"><%=cm.cmsPhrase("EUNIS Database Combined search")%></a>
                    </li>
                  </ul>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
