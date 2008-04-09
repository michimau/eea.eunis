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
                 java.net.URLEncoder,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String scientificName = URLEncoder.encode(request.getParameter("scientificName"),"UTF-8");
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <h2>
    <%=cm.cmsPhrase("GBIF observations")%>
  </h2>
  <div id="myMap">
    <p><%=cm.cmsPhrase("If GBIF has no information about this species, you will only see this text.")%></p>
    <p>
    	<noscript>
    		<%=cm.cmsPhrase("Webbrowsers without Javascript can go directly to <a href=\"http://data.gbif.org/species/{0}\">GBIF's page on {1}</a>.", scientificName, request.getParameter("scientificName"))%>
    	</noscript>
    </p>
  </div>
  <script type="text/javascript">
    function populateMap(obj) {
         document.getElementById('myMap').innerHTML = obj.Resultset.Result[0].mapHTML;
    }
  </script>
  <script type="text/javascript" src="http://data.gbif.org/species/nameSearch?rank=species&amp;view=json&amp;callback=populateMap&amp;returnType=nameIdMap&amp;query=<%=scientificName%>"></script>
<%=cm.br()%>
<%=cm.cmsMsg("gbif")%>
  <br />
  <br />
