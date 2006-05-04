<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Tutorials page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,user_tutorials_location"/>
    </jsp:include>
    <h1><%=cm.cmsText("tutorials_01")%></h1>
    <br />
    <%=cm.cmsText("tutorials_main")%>
    <br />
    <br />
    <table width="100%" border="0">
      <tr>
        <td>
          <strong><%=cm.cmsText("species")%></strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_name&amp;title=Search%20Species%20by%20name"><%=cm.cmsText("tutorials_03")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_country_biogeographic_region&amp;title=Search%20species%20by%20country/biogeoregion"><%=cm.cmsText("tutorials_04")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_groups&amp;title=Search%20species%20by%20group"><%=cm.cmsText("tutorials_05")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_species_by_synonyms&amp;title=Search%20Species%20by%20synonyms"><%=cm.cmsText("tutorials_06")%></a>
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
          <strong><%=cm.cmsText("habitat_types")%></strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_name&amp;title=Search%20habitat%20types%20by%20name"><%=cm.cmsText("tutorials_08")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_code_classification&amp;title=Search%20habitat%20types%20by%20code%20classification"><%=cm.cmsText("tutorials_09")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_country_region&amp;title=Search%20habitat%20types%20by%20country/biogeoregion"><%=cm.cmsText("tutorials_10")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_habitat_types_by_legal_instruments&amp;title=Search%20habitat%20types%20by%20legal%20instruments"><%=cm.cmsText("tutorials_11")%></a>
            </li>
          </ul>
          <br />
          <strong><%=cm.cmsText("sites")%></strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_name&amp;title=Search%20sites%20by%20name"><%=cm.cmsText("tutorials_13")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_coordinates&amp;title=Search%20sites%20by%20geographical%20coordinates"><%=cm.cmsText("search_by_coordinates")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_country&amp;title=Search%20sites%20by%20country"><%=cm.cmsText("tutorials_15")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_size&amp;title=Search%20sites%20by%20size"><%=cm.cmsText("search_by_size")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_designation_year&amp;title=Search%20sites%20by%20designation"><%=cm.cmsText("tutorials_17")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Search_sites_by_altitude&amp;title=Search%20sites%20by%20altitude"><%=cm.cmsText("tutorials_18")%></a>
            </li>
          </ul>
          <br />
          <strong><%=cm.cmsText("tutorials_19")%></strong>
          <br />
          <ul>
            <li>
              <a href="flash-movie.jsp?tutorial=General_Usage&amp;title=EUNIS%20Database%20general%20usage"><%=cm.cmsText("tutorials_20")%></a>
            </li>
          </ul>
          <br />
          <strong><%=cm.cmsText("tutorials_21")%></strong>
          <br />
          <ul>
            <li>
              <a href="gis-tool-help.jsp" title="GIS Tool help"><%=cm.cmsText("gis_help")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Advanced_Search&amp;title=EUNIS%20Database%20Advanced%20search"><%=cm.cmsText("tutorials_23")%></a>
            </li>
            <li>
              <a href="flash-movie.jsp?tutorial=Combined_Search&amp;title=EUNIS%20Database%20Combined%20search"><%=cm.cmsText("tutorials_24")%></a>
            </li>
          </ul>
        </td>
      </tr>
    </table>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="tutorials.jsp" />
    </jsp:include>
      </div>
      </div>
      </div>
  </body>
</html>
