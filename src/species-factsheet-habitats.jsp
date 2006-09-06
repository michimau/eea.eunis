<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - habitat types relations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.factsheet.species.SpeciesHabitatWrapper"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  String idSpeciesLink = request.getParameter("idSpeciesLink");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(idSpecies, new Integer(0)),
          Utilities.checkedStringToInt(idSpeciesLink, new Integer(0)));
  WebContentManagement cm = SessionManager.getWebContent();
  // List of habitats related to species
  List habitats = factsheet.getHabitatsForSpecies();
  if ( habitats.size() > 0 )
  {
%>
  <h2>
    <%=cm.cmsText("habitat_type_populated_by_species")%>
  </h2>
  <table summary="<%=cm.cms("open_the_statistical_data_for")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("eunis_code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("annex_code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("habitat_type_name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("biogeographic_region")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("abundance")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("frequencies")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("faithfulness")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("species_status")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("comment")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for (int i = 0; i < habitats.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
      SpeciesHabitatWrapper habitat = (SpeciesHabitatWrapper)habitats.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.formatString(habitat.getEunisHabitatcode())%>
        </td>
        <td>
          <%=Utilities.formatString(habitat.getAnnexICode())%>
        </td>
        <td>
          <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getHabitatName()))%></a>
          <%=cm.cmsTitle("open_habitat_factsheet")%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getGeoscope()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getAbundance()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getFrequencies()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getFaithfulness()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getSpeciesStatus()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getComment()))%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
<%
  }
%>
  <%=cm.br()%>
  <%=cm.cmsMsg("open_the_statistical_data_for")%>
  <br />
  <br />
