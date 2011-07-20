<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - Popup for list of values in search page.
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
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
   function setLine(val) {
       window.opener.document.eunis.searchString.value=val;
       window.close();
  }
  //]]>
  </script>
</head>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.names.NameBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<% // Request parameters.
  boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);
  String searchString = formBean.getSearchString();
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  boolean useScientific = Utilities.checkedStringToBoolean(formBean.getUseScientific(), false);
  boolean useVernacular = Utilities.checkedStringToBoolean(formBean.getUseVernacular(), false);
  boolean useDescription = Utilities.checkedStringToBoolean(formBean.getUseDescription(), false);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), NamesDomain.SEARCH_EUNIS);
  List results = null;
  // List of habitats
  if(!expandFullNames) results = HabitatsSearchUtility.findHabitatsWithCriteriaWithLimit(searchString, relationOp, database, useScientific, useVernacular, useDescription, Utilities.MAX_POPUP_RESULTS);
  else results = HabitatsSearchUtility.findHabitatsWithCriteria(searchString, relationOp, database, useScientific, useVernacular, useDescription);
  Iterator it = results.iterator();
%>
<body>
<%
  if(results != null && results.size() > 0) {
    out.print(Utilities.getTextMaxLimitForPopup(cm, (results == null ? 0 : results.size())));
  }
%>
<%
  if(results != null && results.size() > 0) {
%>
<h2><%=cm.cmsPhrase("List of values for:")%></h2>
<u><%=cm.cmsPhrase("Habitat name or description")%></u>
<em><%=Utilities.ReturnStringRelatioOp(relationOp)%></em>
<strong><%=searchString%></strong>
<br />
<br />
<%
  }
  if(results.isEmpty()) {
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
  <table summary="<%=cm.cms("list_of_values_for")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <%  // Display results.
      int i = 0;
      while(it.hasNext()) {
        NamesPersist habitat = (NamesPersist) it.next();
    %>
    <tr>
      <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
        <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(habitat.getScientificName())%>');"><%=habitat.getScientificName()%></a>
        <%=cm.cmsTitle("click_link_to_select_value")%>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
<br />
  <%
    }
  %>
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" id="button" class="standardButton" />
  <%=cm.cmsInput("close_btn")%>
</form>
</body>
</html>
