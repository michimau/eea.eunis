<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
	request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist,ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain,ro.finsiel.eunis.jrfTables.habitats.code.CodePersist,ro.finsiel.eunis.search.Utilities,ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,java.util.List,java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
  	WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=cm.cms("list_of_values")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
   function setLine(val)
   {
       window.opener.document.eunis.searchString.value=val;
       window.close();
   }
 //]]>
  </script>
</head>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.code.CodeBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  List results = new Vector();
  // Request parameters
  int idClassification = Utilities.checkedStringToInt(formBean.getClassificationCode(), -1);
  int database = Utilities.checkedStringToInt(formBean.getDatabase(), CodeDomain.SEARCH_EUNIS.intValue());
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  String searchString = formBean.getSearchString();
  // '%' for all
  if(searchString == null || (searchString != null && searchString.trim().equalsIgnoreCase(""))) searchString = "%";
  StringBuffer codePartSQL = Utilities.prepareSQLOperator("", searchString, relationOp);
  int currentClassification = HabitatsSearchUtility.findCurrentClassificationID("eunis");
  if(idClassification == currentClassification) {
    // Search in current classification
    idClassification = -1;
  }
  results = HabitatsSearchUtility.findDatabaseClassificationsExamples(idClassification, codePartSQL.toString(), database);
%>
<body>
<%
  if(results != null && results.size() > 0) {
    out.print(cm.cms("only_first_100_values"));
  }
%>
<%
  if(results.isEmpty()) {
%>
<strong>
  <%=cm.cmsPhrase("No results were found.")%>
</strong>
<br />
<%
} else {
%>
<h2><%=cm.cmsPhrase("List of values")%></h2>

<div id="tab">
<table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
  // Search other classification
  if(idClassification != -1) {
    if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("EUNIS habitat type code")%>
  </th>
  <th>
    <%=cm.cmsPhrase("Code in other classifications")%>
  </th>
  <th>
    <%=cm.cms("habitat_type_name")%>
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("Habitat ANNEX I directive code")%>
  </th>
  <th>
    <%=cm.cmsPhrase("Code in other classifications")%>
  </th>
  <th>
    <%=cm.cms("Habitat type name")%>
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_BOTH.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("EUNIS habitat type code")%>
  </th>
  <th>
    <%=cm.cmsPhrase("Habitat ANNEX I directive code")%>
  </th>
  <th>
    <%=cm.cmsPhrase("Code in other classifications")%>
  </th>
  <th>
    <%=cm.cms("Habitat type name")%>
  </th>
</tr>
<%
  }
} else {  // Search in current classification
  if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("EUNIS habitat type code")%>
  </th>
  <th>
    <%=cm.cms("Habitat type name")%>
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("Habitat ANNEX I directive code")%>
  </th>
  <th>
    <%=cm.cms("Habitat type name")%>
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_BOTH.intValue()) {
%>
<tr>
  <th>
    <%=cm.cmsPhrase("EUNIS habitat type code")%>
  </th>
  <th>
    <%=cm.cmsPhrase("Habitat ANNEX I directive code")%>
  </th>
  <th>
    <%=cm.cms("Habitat type name")%>
  </th>
</tr>
<%
    }
  }

  // Display results
  for(int i = 0; i < results.size(); i++) {
    String code = "";
    String eunisOrAnnexcode = "";
    String eunisCode = "";
    String annexCode = "";
    String habitatName = "";
    // Search in current classification
    if(idClassification == -1) {
      Chm62edtHabitatPersist habitat = (Chm62edtHabitatPersist) results.get(i);
      if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
        eunisOrAnnexcode = habitat.getEunisHabitatCode();
        habitatName = habitat.getScientificName();
      }
      if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
        eunisOrAnnexcode = habitat.getCodeAnnex1();
        habitatName = habitat.getScientificName();
      }
      if(database == CodeDomain.SEARCH_BOTH.intValue()) {
        eunisCode = habitat.getEunisHabitatCode();
        annexCode = habitat.getCodeAnnex1();
        habitatName = habitat.getScientificName();
        if(null == eunisCode || (null != eunisCode && eunisCode.equalsIgnoreCase("0"))) eunisCode = "";
        if(null == annexCode || (null != annexCode && annexCode.equalsIgnoreCase("0"))) annexCode = "";
      }
    } else {
      // Search in other classification
      CodePersist habitat = (CodePersist) results.get(i);
      if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
        eunisOrAnnexcode = habitat.getEunisHabitatCode();
        code = habitat.getCode();
        habitatName = habitat.getScientificName();
      }
      if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
        eunisOrAnnexcode = habitat.getCodeAnnex1();
        code = habitat.getCode();
        habitatName = habitat.getScientificName();
      }
      if(database == CodeDomain.SEARCH_BOTH.intValue()) {
        eunisCode = habitat.getEunisHabitatCode();
        annexCode = habitat.getCodeAnnex1();
        code = habitat.getCode();
        habitatName = habitat.getScientificName();
        if(null == eunisCode || (null != eunisCode && eunisCode.equalsIgnoreCase("0"))) eunisCode = "";
        if(null == annexCode || (null != annexCode && annexCode.equalsIgnoreCase("0"))) annexCode = "";
      }
    }
    // Search in current classification
    if(idClassification == -1) {
%>
<tr>
  <%
    if(database == CodeDomain.SEARCH_EUNIS.intValue() || database == CodeDomain.SEARCH_ANNEX.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=eunisOrAnnexcode%>')"><%=eunisOrAnnexcode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
    if(database == CodeDomain.SEARCH_BOTH.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=eunisCode%>')"><%=eunisCode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=annexCode%>')"><%=annexCode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
  %>
</tr>
<%
} else {  // Search in other classification
%>
<tr>
  <%
    if(database == CodeDomain.SEARCH_EUNIS.intValue() || database == CodeDomain.SEARCH_ANNEX.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=eunisOrAnnexcode%>')"><%=eunisOrAnnexcode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=code%>')"><%=code%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
    if(database == CodeDomain.SEARCH_BOTH.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=eunisCode%>')"><%=eunisCode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td title="<%=cm.cms("click_link_to_select_value")%>" bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a href="javascript:setLine('<%=annexCode%>')"><%=annexCode%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td title="<%=cm.cms("click_link_to_select_value")%>" bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a href="javascript:setLine('<%=code%>')"><%=code%></a>&nbsp;
    <%=cm.cmsTitle("click_link_to_select_value")%>
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
  %>
</tr>
<% }
}
%>
</table>
</div>
<%
  }
%>
<br />
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" name="button" id="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" class="standardButton" />
  <%=cm.cmsInput("close_btn")%>
</form>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>
<%=cm.cmsMsg("only_first_100_values")%>
<%=cm.br()%>
<%=cm.cmsTitle("list_of_values")%>
<%=cm.br()%>
</body>
</html>
