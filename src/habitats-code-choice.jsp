<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist,
                 ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain,
                 ro.finsiel.eunis.jrfTables.habitats.code.CodePersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
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
    <%=contentManagement.getContent("habitats_code-choice_title", false)%>
  </title>
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
    out.print("<strong>Note: Only the first 100 values are listed below.</strong><br /><br />");
  }
%>
<%
  if(results.isEmpty()) {
%>
<strong>
  <%=contentManagement.getContent("habitats_code-choice_01")%>
</strong>
<br />
<%
} else {
%>
<h6>List of values</h6>

<div id="tab">
<table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
  // Search other classification
  if(idClassification != -1) {
    if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_02")%>
  </th>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_03")%>
  </th>
  <th>
    Habitat type name
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_04")%>
  </th>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_05")%>
  </th>
  <th>
    Habitat type name
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_BOTH.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_02")%>
  </th>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_04")%>
  </th>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_05")%>
  </th>
  <th>
    Habitat type name
  </th>
</tr>
<%
  }
} else {  // Search in current classification
  if(database == CodeDomain.SEARCH_EUNIS.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_02")%>
  </th>
  <th>
    Habitat type name
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_ANNEX.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_04")%>
  </th>
  <th>
    Habitat type name
  </th>
</tr>
<%
  }
  if(database == CodeDomain.SEARCH_BOTH.intValue()) {
%>
<tr>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_02")%>
  </th>
  <th>
    <%=contentManagement.getContent("habitats_code-choice_04")%>
  </th>
  <th>
    Habitat type name
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
    <a title="Click link to select the value" href="javascript:setLine('<%=eunisOrAnnexcode%>')"><%=eunisOrAnnexcode%></a>&nbsp;
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
    if(database == CodeDomain.SEARCH_BOTH.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="Click link to select the value" href="javascript:setLine('<%=eunisCode%>')"><%=eunisCode%></a>&nbsp;
  </td>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="Click link to select the value" href="javascript:setLine('<%=annexCode%>')"><%=annexCode%></a>&nbsp;
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
    <a title="Click link to select the value" href="javascript:setLine('<%=eunisOrAnnexcode%>')"><%=eunisOrAnnexcode%></a>&nbsp;
  </td>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="Click link to select the value" href="javascript:setLine('<%=code%>')"><%=code%></a>&nbsp;
  </td>
  <td>
    <%=habitatName%>
  </td>
  <%
    }
    if(database == CodeDomain.SEARCH_BOTH.intValue()) {
  %>
  <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a title="Click link to select the value" href="javascript:setLine('<%=eunisCode%>')"><%=eunisCode%></a>&nbsp;
  </td>
  <td title="Click link to select the value" bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a href="javascript:setLine('<%=annexCode%>')"><%=annexCode%></a>&nbsp;
  </td>
  <td title="Click link to select the value" bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
    <a href="javascript:setLine('<%=code%>')"><%=code%></a>&nbsp;
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
  <label for="button" class="noshow">Close window</label>
  <input title="Close window" type="button" name="button" id="button" value="<%=contentManagement.getContent("habitats_code-choice_06",false)%>" onclick="javascript:window.close()" class="inputTextField" />
</form>
</body>
</html>