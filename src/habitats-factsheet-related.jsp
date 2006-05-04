<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats related habitats' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.factsheet.habitats.SyntaxaWrapper,
                 ro.finsiel.eunis.search.Utilities" %>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// INPUT PARAMS: idHabitat
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  boolean isMini = Utilities.checkedStringToBoolean(request.getParameter("mini"), false);
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  // Habitat syntaxa
  Vector syntaxaw = null;
  try {
    syntaxaw = factsheet.getHabitatSintaxa();
  } catch(InitializationException e) {
    e.printStackTrace();
  }
  if(null != syntaxaw && !syntaxaw.isEmpty())
  {
%>
<div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("habitat_type_syntaxa")%></div>
<table summary="<%=cm.cms("habitat_type_syntaxa")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="syntaxa" class="sortable">
  <tr>
    <th width="25%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("name")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="6%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("relation")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="30%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("habitats_factsheet_75")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="20%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <strong>
        <%=cm.cmsText("author")%>
        <%=cm.cmsTitle("sort_results_on_this_column")%>
      </strong>
    </th>
    <th width="14%" title="<%=cm.cms("sort_results_on_this_column")%>">
      <%=cm.cmsText("references")%>
      <%=cm.cmsTitle("sort_results_on_this_column")%>
    </th>
  </tr>
  <%
    String IdDc = "";
    for(int i = 0; i < syntaxaw.size(); i++) {
      SyntaxaWrapper syntaxa = (SyntaxaWrapper) syntaxaw.get(i);
  %>
  <tr bgcolor="<%=(0 == (i % 2) ?  "#EEEEEE" : "#FFFFFF")%>">
    <td>
      <%=syntaxa.getName()%>
    </td>
    <td>
      <%=HabitatsFactsheet.mapHabitatsRelations(syntaxa.getRelation())%>
    </td>
    <td>
      <%=syntaxa.getSourceAbbrev()%>
    </td>
    <td>
      <%=syntaxa.getAuthor()%></td>
    <%
      if(syntaxa.getIdDc() != null) {
        IdDc = syntaxa.getIdDc().toString();
      }
      if(!Utilities.getAuthorAndUrlByIdDc(IdDc).get(1).toString().equalsIgnoreCase("")) {
        if(!IdDc.equalsIgnoreCase("0")) {
    %>
    <td onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(IdDc)%>')" onmouseout="hidetooltip()">
      <span class="boldUnderline">
        <a title="<%=cm.cms("habitat_syntaxa_author")%>" href="<%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(1)%>"><%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(0)%></a>
        <%=cm.cmsTitle("habitat_syntaxa_author")%>
      </span>
    </td>
    <%
    } else {
    %>
    <td>
      &nbsp;
    </td>
    <%
      }
    } else {
      if(!IdDc.equalsIgnoreCase("0")) {
    %>
    <td onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(IdDc)%>')" onmouseout="hidetooltip()">
      <%
         String AuthorURL = Utilities.getAuthorAndUrlByIdDc(IdDc).get(0).toString();
         AuthorURL = AuthorURL.replaceAll("&","&amp;");
      %>
      <span class="boldUnderline">
      <%=AuthorURL%>
      </span>    
    </td>
    <%
    } else {
    %>
    <td>
      &nbsp;
    </td>
    <%
        }
      }
    %>
  </tr>
  <%
    }
  %>
</table>
<%=cm.br()%>
<%=cm.cmsMsg("habitat_type_syntaxa")%>
<%=cm.br()%>
<%
  }
%>