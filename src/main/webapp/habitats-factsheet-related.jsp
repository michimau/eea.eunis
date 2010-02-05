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
  <table summary="<%=cm.cms("habitat_type_syntaxa")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th width="25%" style="text-align: left;">
          <%=cm.cmsPhrase("Name")%>
        </th>
        <th width="6%" style="text-align: left;">
          <%=cm.cmsPhrase("Relation")%>
        </th>
        <th width="30%" style="text-align: left;">
          <%=cm.cmsPhrase("Source (abbreviated)")%>
        </th>
        <th width="20%" style="text-align: left;">
          <%=cm.cmsPhrase("Author")%>
        </th>
        <th width="14%" style="text-align: left;">
          <%=cm.cmsPhrase("References")%>
        </th>
      </tr>
    </thead>
    <tbody>
  <%
    String IdDc = "";
    for(int i = 0; i < syntaxaw.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
      SyntaxaWrapper syntaxa = (SyntaxaWrapper) syntaxaw.get(i);
  %>
      <tr<%=cssClass%>>
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
      if(!Utilities.getAuthorAndUrlByIdDc(IdDc).get(1).toString().equalsIgnoreCase(""))
      {
        if(!IdDc.equalsIgnoreCase("0"))
        {
    %>
        <td>
          <span class="boldUnderline">
            <a title="<%=cm.cms("habitat_syntaxa_author")%>" href="<%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(1)%>"><%=Utilities.getAuthorAndUrlByIdDc(IdDc).get(0)%></a>
            <%=cm.cmsTitle("habitat_syntaxa_author")%>
          </span>
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
      }
      else
      {
        if(!IdDc.equalsIgnoreCase("0"))
        {
          String AuthorURL = Utilities.getAuthorAndUrlByIdDc(IdDc).get(0).toString();
          AuthorURL = AuthorURL.replaceAll("&","&amp;");
%>
        <td>
          <span class="boldUnderline">
            <a href="documents/<%=IdDc%>"><%=AuthorURL%></a>
          </span>
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
