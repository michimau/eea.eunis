<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - display links to all habitat searches.
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist" %>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// INPUT PARAMS: idHabitat
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement contentManagement = SessionManager.getWebContent();
  Vector legals = null;
  try {
    legals = factsheet.getHabitatLegalInfo();
  } catch(InitializationException e) {
    e.printStackTrace();
  }
  // Habitat legal information.
  if((factsheet.isEunis() && !legals.isEmpty())) {
%>
<div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_27")%></div>
<table summary="Habitat type legal instruments" width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse; " id="legal">
  <tr bgcolor="#DDDDDD">
    <th class="resultHeader" width="30%">
      <a title="Sort table by this column" href="javascript:sortTable(3, 0, 'legal', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_28")%></strong></a>
    </th>
    <th class="resultHeader" width="50%">
      <a title="Sort table by this column" href="javascript:sortTable(3, 1, 'legal', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_29")%></strong></a>
    </th>
    <th class="resultHeader" width="20%">
      <a title="Sort table by this column" href="javascript:sortTable(3, 2, 'legal', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_30")%></strong></a>
    </th>
  </tr>
  <%
    for(int i = 0; i < legals.size(); i++) {
      HabitatLegalPersist legal = (HabitatLegalPersist) legals.get(i);
  %>
  <tr>
    <td bgcolor="#EEEEEE" width="30%"><%=legal.getLegalName()%></td>
    <td bgcolor="#EEEEEE" width="50%"><%=legal.getTitle()%></td>
    <td bgcolor="#EEEEEE" width="20%"><%=legal.getCode()%></td>
  </tr>
  <%
    }
  %>
</table>
<br />
<%
  }
%>