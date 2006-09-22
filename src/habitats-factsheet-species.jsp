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
    <%=cm.cmsText("species_characteristics_for_habitat_type")%>
  </h2>
  <table summary="<%=cm.cms("habitat_species")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("species_scientific_name")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("biogeographic_region")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("abundance")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("frequencies")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("faithfulness")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("comment")%>
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
          <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=wrapper.getIdSpecies()%>&amp;idSpeciesLink=<%=wrapper.getIdSpeciesLink()%>"><%=Utilities.formatString(wrapper.getSpeciesName())%></a>
          <%=cm.cmsTitle("open_species_factsheet")%>
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
