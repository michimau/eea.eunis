<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain, ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                java.util.List,
                java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_sites-choice_title", false)%>
  </title>
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.sites.SitesBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  <!--
    function setLine(val)
    {
      window.opener.document.criteria.scientificName.value=val;
      window.close();
    }

   function editContent( idPage )
  {
    var url = "web-content-inline-editor.jsp?idPage=" + idPage;
    window.open( url ,'', "width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0");
  }
  // -->
  </script>
  <%
    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
    List results = new Vector();
    boolean[] source_db = {true, true, true, true, true, true, true, true};
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatsSitesDomain.SEARCH_EUNIS);
    // List of values (in accordance with searchAttribute)
    results = new HabitatsSitesDomain().findPopupLOV(new SitesSearchCriteria(searchAttribute,
                                                                             formBean.getScientificName(),
                                                                             relationOp),
                                                     source_db,
                                                     searchAttribute,
                                                     database);
  %>
</head>

<body bgcolor="#FFFFFF">
<%
  if(results != null && results.size() > 0) {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement, (results == null ? 0 : results.size())));
  }
%>
<%
  if(!results.isEmpty()) {
    SitesSearchCriteria sitesSearch = new SitesSearchCriteria(searchAttribute, formBean.getScientificName(), relationOp);
%>
<h6>List of values for:</h6>
<u><%=sitesSearch.getHumanMappings().get(searchAttribute)%></u>
<%
  if(null != formBean.getScientificName() && null != relationOp) {
%>
<em><%=Utilities.ReturnStringRelatioOp(relationOp)%></em>
<strong><%=formBean.getScientificName()%></strong>
<%
  }
%>
<br />
<br />

<div id="tab">
  <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <%
      // Display results.
      String rowBgColor = "";
      String value = "";
      for(int i = 0; i < results.size(); i++) {
        rowBgColor = (0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE";
        value = (String) results.get(i);
    %>
    <tr bgcolor="<%=rowBgColor%>">
      <td>
        <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(value)%>');"><%=value%></a>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
  <%--   <%=Utilities.getTextMaxLimitForPopup((results == null ? 0 : results.size()))%>--%>
  <%
  } else {
  %>
  <strong>
    <%=contentManagement.getContent("habitats_sites-choice_01")%>
  </strong>
  <br />
  <%
    }
  %>
  <br />

  <form action="">
    <label for="button" class="noshow">Close window</label>
    <input title="Close window" type="button" value="<%=contentManagement.getContent("habitats_sites-choice_02", false )%>" onclick="javascript:window.close()" id="button" name="button" class="inputTextField" />
  </form>
  <%=contentManagement.writeEditTag("habitats_sites-choice_02")%>
</body>
</html>