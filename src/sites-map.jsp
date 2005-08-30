<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Page displaying "Show Map" button within results of search pages in sites module
--%>
<%--
  Defined fields (you must define them where you include this page
    - mapPopupName - Name of the popup search file (for example 'sites-names-map.jsp')
    - paginator - AbstractPaginator - The paginator to retrieve results count (common on all pages with result of searches)
    - formBean  - AbstractFormBean - The form bean to retrieve query (common on all pages with result of searches)
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  int resultsCount = Utilities.checkedStringToInt( request.getParameter( "resultsCount" ), 0 );
  int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
  if ( resultsCount > 0 && resultsCount < maxSitesPerMap )
  {
    String mapName = request.getParameter("mapName");
    String toURLParam = request.getParameter("toURLParam");
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<script language="JavaScript" type="text/javascript">
  <!--
  function openMap(searchCriteria)
  {
    URL = "<%=mapName%>?" + searchCriteria ;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes,location=0,width=740,height=552,left=30,top=20');");
  }
  //-->
</script>
<br />        
<div style="width : 740px;">
  <label for="showMap" class="noshow">Show map</label>
  <input id="showMap" name="showMap" type="button" value="<%=contentManagement.getContent("sites_map_01", false)%>"
         onclick="javascript:openMap('<%=toURLParam%>');"
         title="<%=contentManagement.getContent("sites_map_02", false)%>" class="inputTextField" />
  <%=contentManagement.writeEditTag("sites_map_01")%>
</div>
<%
  }
%>