<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 java.util.Iterator,
                 java.util.List" %>
<%@ page import="ro.finsiel.eunis.session.SessionManager"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
  <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
  %>

<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <title>
    <%=contentManagement.getContent("habitats_legal-choice_title", false)%>
  </title>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.legal.LegalBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  <!--
   function setLine(val)
   {
     window.opener.document.eunis.searchString.value=val;
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
    String searchString = formBean.getSearchString();
    // List of habitats names.
    List results = HabitatsSearchUtility.findHabitatsWithCriteria(searchString, Utilities.OPERATOR_CONTAINS, NamesDomain.SEARCH_EUNIS, true, false, false);
    Iterator it = results.iterator();
  %>
</head>

<body>
<%
  if(results != null && results.size() > 0) {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement, (results == null ? 0 : results.size())));
  }
%>
<%
  if(!results.isEmpty()) {
%>
<h6>List of values for:</h6>
<u>Habitat name</u>
<em><%=Utilities.ReturnStringRelatioOp(Utilities.OPERATOR_CONTAINS)%></em>
<strong><%=searchString%></strong>
<br />
<br />
<%
  }
  if(results.size() <= 0) {
%>
<strong>
  <%=contentManagement.getContent("habitats_legal-choice_01")%>
</strong>
<br />
<br />
<%
} else {
%>
<div id="tab">
  <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <%
      int i = 0;
      String bgColor = "#EEEEEE";
      // Display results.
      while(it.hasNext()) {
        bgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
        NamesPersist habitat = (NamesPersist) it.next();
        String sciName = habitat.getScientificName();
    %>
    <tr bgcolor="<%=bgColor%>">
      <td align="left">
        <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(sciName)%>');"><%=sciName%></a>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
<%=Utilities.getTextWarningForPopup((results == null ? 0 : results.size()))%>
<%
  }
%>
<form action="">
  <label for="button2" class="noshow">Close window</label>
  <input title="Close window" type="button" value="<%=contentManagement.getContent("habitats_legal-choice_02", false)%>" onclick="javascript:window.close()" id="button2" name="button2" class="inputTextField" />
</form>
</body>
</html>