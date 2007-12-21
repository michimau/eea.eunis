<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - GBIF observations
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String scientificName = Utilities.treatSpacesInScientificName(request.getParameter("scientificName"));
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <h2>
    <%=cm.cmsText("gbif")%>
  </h2>
  <div id="myMap"></div>
        <script type="text/javascript">
            function populateMap(obj) {
                document.getElementById('myMap').innerHTML = obj.Resultset.Result[0].mapHTML;
            }
        </script>
  <script type="text/javascript" src="http://data.gbif.org/species/nameSearch?rank=species&view=json&callback=populateMap&returnType=nameIdMap&query=<%=scientificName%>"></script>
<%=cm.br()%>
<%=cm.cmsMsg("gbif")%>
  <br />
  <br />
