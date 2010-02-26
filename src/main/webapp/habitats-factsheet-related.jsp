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
  <h2>
  <%=cm.cmsPhrase("Habitat type syntaxa")%>
  </h2>
  <table summary="<%=cm.cms("habitat_type_syntaxa")%>" class="listing fullwidth">
    <col style="width:25%"/>
    <col style="width:6%"/>
    <col style="width:30%"/>
    <col style="width:20%"/>
    <col style="width:14%"/>
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Name")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Relation")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Source (abbreviated)")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Author")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("References")%>
        </th>
      </tr>
    </thead>
    <tbody>
  <%
    String IdDc = "";
    for(int i = 0; i < syntaxaw.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      SyntaxaWrapper syntaxa = (SyntaxaWrapper) syntaxaw.get(i);
  %>
      <tr class="<%=cssClass%>">
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
          <%=syntaxa.getAuthor()%>
        </td>
<%
      if(syntaxa.getIdDc() != null)
      {
        IdDc = syntaxa.getIdDc().toString();
      }
      if(!IdDc.equalsIgnoreCase("0"))
      {
	String AuthorURL = Utilities.getAuthorAndUrlByIdDc(IdDc).get(0).toString();
	AuthorURL = AuthorURL.replaceAll("&","&amp;");
%>
      <td>
	  <a href="documents/<%=IdDc%>"><%=AuthorURL%></a>
      </td>
<%
      }
      else
      {
%>
      <td>
	&nbsp;
      </td>
<%
      }
%>
      </tr>
<%
    }
%>
    </tbody>
  </table>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_type_syntaxa")%>
  <%=cm.br()%>
<%
  }
%>
