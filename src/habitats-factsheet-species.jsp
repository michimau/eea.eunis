<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats species' function - display links to all habitat searches.
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
  try
  {
    // List of species related to habitat.
    List species = factsheet.getSpeciesForHabitats();
    if (!species.isEmpty())
    {
%>
  <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_37")%></div>
  <table summary="Habitat types species" width="100%" border="1" style="border-collapse: collapse;" cellspacing="1" cellpadding="0" id="species">
    <tr valign="middle">
      <th class="resultHeader" height="17" align="left">
        <a title="Sort table by this column" href="javascript:sortTable(6, 0, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_38")%></strong></a>
      </th>
      <th class="resultHeader" height="17" align="left">
        <a title="Sort table by this column" href="javascript:sortTable(6, 1, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_39")%></strong></a>
      </th>
      <th class="resultHeader" height="17" align="left">
        <a title="Sort table by this column" href="javascript:sortTable(6, 2, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_40")%></strong></a>
      </th>
      <th class="resultHeader" height="17" align="left">
        <a title="Sort table by this column" href="javascript:sortTable(6, 3, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_41")%></strong></a>
      </th>
      <th class="resultHeader" height="17" align="left">
        <a title="Sort table by this column" href="javascript:sortTable(6, 4, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_42")%></strong></a>
      </th>
<%--            <td height="17" align="left">--%>
<%--              <a href="javascript:sortTable(6, 5, species, false);"><strong><%=contentManagement.getContent("habitats_factsheet_43")%></strong></a>--%>
<%--            </td>--%>
      <th class="resultHeader" height="17" align="left">
        <a href="javascript:sortTable(6, 5, 'species', false);"><strong><%=contentManagement.getContent("habitats_factsheet_44")%></strong></a>
      </th>
    </tr>
<%
            for (int i = 0; i < species.size(); i++)
            {
              HabitatsSpeciesWrapper wrapper = (HabitatsSpeciesWrapper) species.get(i);
%>
              <tr bgcolor="<%=(0 == (i % 2) ?  "#EEEEEE" : "#FFFFFF")%>" valign="middle">
                <td>
                  <a title="Open species factsheet" href="species-factsheet.jsp?idSpecies=<%=wrapper.getIdSpecies()%>&amp;idSpeciesLink=<%=wrapper.getIdSpeciesLink()%>"><%=Utilities.formatString(wrapper.getSpeciesName())%>
                  </a>
                </td>
                <td><%=Utilities.formatString(wrapper.getGeoscope())%></td>
                <td><%=Utilities.formatString(wrapper.getAbundance())%></td>
                <td><%=Utilities.formatString(wrapper.getFrequencies())%></td>
                <td><%=Utilities.formatString(wrapper.getFaithfulness())%></td>
<%--                <td><%=Utilities.formatString(wrapper.getSpeciesStatus())%></td>--%>
                <td><%=Utilities.formatString(wrapper.getComment())%></td>
              </tr>
<%
            }
%>
        </table>
<%
      }
    }
    catch (Exception ex)
    {
          ex.printStackTrace();
    }
%>