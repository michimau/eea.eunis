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
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  try
  {
    // List of species related to habitat.
    List species = factsheet.getSpeciesForHabitats();
    if (!species.isEmpty())
    {
%>
  <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_characteristics_for_habitat_type")%></div>
  <table summary="<%=cm.cms("habitat_species")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="species" class="sortable">
    <tr valign="middle">
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("species_scientific_name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("biogeographic_region")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("abundance")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("frequencies")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("faithfulness")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
      <th height="17" title="<%=cm.cms("sort_results_on_this_column")%>">
        <strong>
          <%=cm.cmsText("comment")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </strong>
      </th>
    </tr>
<%
            for (int i = 0; i < species.size(); i++)
            {
              HabitatsSpeciesWrapper wrapper = (HabitatsSpeciesWrapper) species.get(i);
%>
              <tr bgcolor="<%=(0 == (i % 2) ?  "#EEEEEE" : "#FFFFFF")%>" valign="middle">
                <td>
                  <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=wrapper.getIdSpecies()%>&amp;idSpeciesLink=<%=wrapper.getIdSpeciesLink()%>"><%=Utilities.formatString(wrapper.getSpeciesName())%></a>
                  <%=cm.cmsTitle("open_species_factsheet")%>
                </td>
                <td><%=Utilities.formatString(wrapper.getGeoscope())%></td>
                <td><%=Utilities.formatString(wrapper.getAbundance())%></td>
                <td><%=Utilities.formatString(wrapper.getFrequencies())%></td>
                <td><%=Utilities.formatString(wrapper.getFaithfulness())%></td>
                <td><%=Utilities.formatString(wrapper.getComment())%></td>
              </tr>
<%
            }
%>
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