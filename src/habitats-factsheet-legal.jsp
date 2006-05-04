<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
  WebContentManagement cm = SessionManager.getWebContent();
  Vector legals = null;
  try {
    legals = factsheet.getHabitatLegalInfo();
  } catch(InitializationException e) {
    e.printStackTrace();
  }
  // Habitat legal information.
  if((factsheet.isEunis() && !legals.isEmpty())) {
%>
<div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("habitats_factsheet_27")%></div>
<table summary="<%=cm.cms("habitat_type_legal_instruments")%>" width="100%" border="0" cellspacing="0" cellpadding="0" id="legal" class="sortable">
  <tr>
    <th width="30%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("legal_instrument")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="50%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("habitats_factsheet_29")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="20%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("habitats_factsheet_30")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
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
<%=cm.br()%>
<%=cm.cmsMsg("habitat_type_legal_instruments")%>
<br />
<%
  }
%>