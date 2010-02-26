<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats species' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.factsheet.HabitatsSpeciesWrapper" %>
<%@ page import="java.util.List"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  //boolean isMini = Utilities.checkedStringToBoolean( request.getParameter( "mini" ), false );
  HabitatsFactsheet factsheet;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  try
  {
    // List of species related to habitat.
    List species = factsheet.getSpeciesForHabitats();
    if (!species.isEmpty())
    {
%>
  <h2>
    <%=cm.cmsPhrase("Species characteristics for habitat type")%>
  </h2>
  <table summary="<%=cm.cms("habitat_species")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Species scientific name")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Biogeographic region")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Abundance")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Frequencies")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Faithfulness")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Comment")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < species.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        HabitatsSpeciesWrapper wrapper = (HabitatsSpeciesWrapper) species.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <a href="species/<%=wrapper.getIdSpecies()%>"><%=Utilities.formatString(wrapper.getSpeciesName())%></a>
        </td>
        <td>
          <%=Utilities.formatString(wrapper.getGeoscope())%>
        </td>
        <td>
          <%=Utilities.formatString(wrapper.getAbundance())%>
        </td>
        <td>
          <%=Utilities.formatString(wrapper.getFrequencies())%>
        </td>
        <td>
          <%=Utilities.formatString(wrapper.getFaithfulness())%>
        </td>
        <td>
          <%=Utilities.formatString(wrapper.getComment())%>
        </td>
      </tr>
<%
      }
%>
    </tbody>
  </table>
        <%=cm.br()%>
        <%=cm.cmsMsg("habitat_species")%>
        <%=cm.br()%>
<%
    }
  }
  catch (Exception ex)
  {
          ex.printStackTrace();
  }
%>
