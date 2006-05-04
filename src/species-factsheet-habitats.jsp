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
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("habitat_type_populated_by_species")%></div>
        <table summary="<%=cm.cms("open_the_statistical_data_for")%>" width="100%" border="1" cellspacing="1" cellpadding="0"  id="habitats" class="sortable">
          <tr style="background-color:#DDDDDD;text-align:center">
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("eunis_code")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("annex_code")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("habitat_type_name")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("biogeographic_region")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("abundance")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("frequencies")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("faithfulness")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("species_status")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("comment")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
          </tr>
<%
          for (int i = 0; i < habitats.size(); i++)
          {
            SpeciesHabitatWrapper habitat = (SpeciesHabitatWrapper)habitats.get(i);
%>
          <tr style="background-color:#EEEEEE">
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
        </table>
<%
      }
%>

<%=cm.br()%>
<%=cm.cmsMsg("open_the_statistical_data_for")%>

<br />
<br />