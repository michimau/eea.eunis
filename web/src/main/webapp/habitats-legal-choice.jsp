<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 java.util.Iterator,
                 java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=cm.cmsPhrase("List of values")%>
  </title>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.legal.LegalBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
   function setLine(val)
   {
     window.opener.document.eunis.searchString.value=val;
     window.close();
   }
 //]]>
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
  if( results.size() > 0 )
  {
    out.print(Utilities.getTextMaxLimitForPopup(cm, results.size()));
  }
%>
<%
  if(!results.isEmpty()) {
%>
<h2>cm.<%=cm.cmsPhrase("List of values for:")%></h2>
<u><%=cm.cmsPhrase("Habitat type name")%></u>
<em><%=Utilities.ReturnStringRelatioOp(Utilities.OPERATOR_CONTAINS)%></em>
<strong><%=searchString%></strong>
<br />
<br />
<%
  }
  if(results.size() <= 0) {
%>
<strong>
  <%=cm.cmsPhrase("No results were found.")%>
</strong>
<br />
<br />
<%
} else {
%>
<div id="tab">
  <table summary="<%=cm.cmsPhrase("List of values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <%
      int i = 0;
      String bgColor;
      // Display results.
      while(it.hasNext()) {
        bgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
        NamesPersist habitat = (NamesPersist) it.next();
        String sciName = habitat.getScientificName();
    %>
    <tr bgcolor="<%=bgColor%>">
      <td>
        <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(sciName)%>');"><%=sciName%></a>
        <%=cm.cmsTitle("click_link_to_select_value")%>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
<%=Utilities.getTextWarningForPopup( results.size() )%>
<%
  }
%>
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" id="button2" name="button2" class="standardButton" />
  <%=cm.cmsInput("close_btn")%>
</form>
</body>
</html>
