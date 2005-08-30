<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats related habitats' function - display links to all habitat searches.
--%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // Habitat syntaxa
  Vector syntaxaw = null;
  try {
    syntaxaw = factsheet.getHabitatSintaxa();
  } catch(InitializationException e) {
    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
  }
  if(!syntaxaw.isEmpty()) {
%>
<div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_72")%></div>
<table summary="Habitat type syntaxa" width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse;" id="syntaxa">
  <tr>
    <th class="resultHeader" width="25%" align="left">
      <a title="Sort table by this column" href="javascript:sortTable(5, 0, 'syntaxa', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_73")%></strong></a>
    </th>
    <th class="resultHeader" width="6%" align="left">
      <a title="Sort table by this column" href="javascript:sortTable(5, 1, 'syntaxa', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_74")%></strong></a>
    </th>
    <th class="resultHeader" width="30%" align="left">
      <a title="Sort table by this column" href="javascript:sortTable(5, 2, 'syntaxa', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_75")%></strong></a>
    </th>
    <th class="resultHeader" width="20%" align="left">
      <a title="Sort table by this column" href="javascript:sortTable(5, 3, 'syntaxa', false);">
        <strong><%=contentManagement.getContent("habitats_factsheet_76")%></strong></a>
    </th>
    <th class="resultHeader" width="14%" align="left">
      <%=contentManagement.getContent("habitats_factsheet_77")%>
    </th>
  </tr>
  <%
    String IdDc = "";
    for(int i = 0; i < syntaxaw.size(); i++) {
      SyntaxaWrapper syntaxa = (SyntaxaWrapper) syntaxaw.get(i);
  %>
  <tr bgcolor="<%=(0 == (i % 2) ?  "#EEEEEE" : "#FFFFFF")%>">
    <td><%=syntaxa.getName()%></td>
    <td><%=HabitatsFactsheet.mapHabitatsRelations(syntaxa.getRelation())%></td>
    <td><%=syntaxa.getSourceAbbrev()%></td>
    <td><%=syntaxa.getAuthor()%></td>
    <%
      if(syntaxa.getIdDc() != null) {
        IdDc = syntaxa.getIdDc().toString();
      }
      if(!Utilities.getAuthorAndUrlByIdDc(IdDc).get(1).toString().equalsIgnoreCase("")) {
        if(!IdDc.equalsIgnoreCase("0")) {
    %>
    <td onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(IdDc)%>')" onmouseout="hidetooltip()">
      <span class="boldUnderline">
        <a title="Author information" href="<%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(1)%>"><%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(0)%></a>
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
<%
  }
%>