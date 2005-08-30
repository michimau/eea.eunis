<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - habitat types relations.
--%>
<%@page contentType="text/html"%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // List of habitats related to species
  List habitats = factsheet.getHabitatsForSpecies();
  if ( habitats.size() > 0 )
  {
%>
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("species_factsheet_habitats")%></div>
        <table summary="List of habitats" width="100%" border="1" cellspacing="1" cellpadding="0"  id="habitats" style="border-collapse:collapse">
          <tr style="background-color:#DDDDDD;text-align:center">
            <th class="resultHeaderForFactsheet">
              <a title="Sort by EUNIS code" href="javascript:sortTable(9,0, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatsEUNISCode")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by Annex I code" href="javascript:sortTable(9,1, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatsANNEXCode")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by habitat type name" href="javascript:sortTable(9,2, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatsHabitatName")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by region" href="javascript:sortTable(9,3, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatRegion")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by abundance" href="javascript:sortTable(9,4, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatAbundance")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by frequencies" href="javascript:sortTable(9,5, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitaFrequencies")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by faithfulness" href="javascript:sortTable(9,6, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatFaithfulness")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by species status" href="javascript:sortTable(9,7, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatSpeciesStatus")%></a>
            </th>
            <th class="resultHeaderForFactsheet">
              <a title="Sort by comments" href="javascript:sortTable(9,8, 'habitats', false);"><%=contentManagement.getContent("species_factsheet_habitatComments")%></a>
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
              <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(habitat.getHabitatName()))%></a>
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
<br />
<br />