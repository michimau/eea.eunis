<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Tutorials page
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,User tutorials"/>
    </jsp:include>
    <h5>EUNIS Database Learning tutorials</h5>
    <br />
    <%=cm.getContent("tutorials_main")%>
    <br />
    <br />
    <table width="100%" border="0">
      <tr>
        <td>
          <strong>Species</strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_name&amp;title=Search%20Species%20by%20name">Search species by name</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_country_biogeographic_region&amp;title=Search%20species%20by%20country/biogeoregion">Search species by country/biogeoregion</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_groups&amp;title=Search%20species%20by%20group">Search species by group</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_synonyms&amp;title=Search%20Species%20by%20synonyms">Search species by synonyms</a>
            </li>
            <!--
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_threat_status&amp;title=Search%20species%20by%20threat%20status">Search species by threat status</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_legal_instruments&amp;title=Search%20species%20by%20legal%20instruments">Search species by legal instruments</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Pick_species_show_habitats&amp;title=Find%20habitat%20types%20characterized%20by%20a%20particular%20species">Find habitat types characterized by a particular species</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Pick_species_show_sites&amp;title=Find%20sites%20characterized%20by%20a%20particular%20species">Find sites characterized by a particular species</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Taxonomic_classification&amp;title=Taxonomic%20classification%20for%20species">Taxonomic classification for species</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Advanced_species_search&amp;title=Search%20species%20using%20advanced%20search%20function">Search species using advanced search function</a>
            </li>
            !-->
          </ul>
          <br />
          <strong>Habitat types</strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_name&amp;title=Search%20habitat%20types%20by%20name">Search habitat types by name</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_code_classification&amp;title=Search%20habitat%20types%20by%20code%20classification">Search habitat types by code classification</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_country_region&amp;title=Search%20habitat%20types%20by%20country/biogeoregion">Search habitat types by country/biogeoregion</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_legal_instruments&amp;title=Search%20habitat%20types%20by%20legal%20instruments">Search habitat types by legal instruments</a>
            </li>
          </ul>
          <br />
          <strong>Sites</strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_name&amp;title=Search%20sites%20by%20name">Search sites by name</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_coordinates&amp;title=Search%20sites%20by%20geographical%20coordinates">Search sites by geographical coordinates</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_country&amp;title=Search%20sites%20by%20country">Search sites by country</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_size&amp;title=Search%20sites%20by%20size">Search sites by size</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_designation_year&amp;title=Search%20sites%20by%20designation">Search sites by designation</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_altitude&amp;title=Search%20sites%20by%20altitude">Search sites by altitude</a>
            </li>
          </ul>
          <br />
          <strong>General usage</strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=General_Usage&amp;title=EUNIS%20Database%20general%20usage">EUNIS Database general usage</a>
            </li>
          </ul>
          <br />
          <strong>Advanced usage</strong>
          <br />
          <ul>
            <li>
              <a href="gis-tool-help.jsp" title="GIS Tool help">GIS Tool help</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Advanced_Search&amp;title=EUNIS%20Database%20Advanced%20search">EUNIS Database Advanced search</a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Combined_Search&amp;title=EUNIS%20Database%20Combined%20search">EUNIS Database Combined search</a>
            </li>
          </ul>
        </td>
      </tr>
    </table>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="tutorials.jsp" />
    </jsp:include>
      </div>
  </body>
</html>
