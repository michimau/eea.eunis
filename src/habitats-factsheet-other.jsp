<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats other information' function - display links to all habitat searches.
--%>
<%--
This is the page which appears within 'Other info' parts of the factsheet
Parameters accepted for request:
  idHabitat - ID of the habitat for which information is retrieved
  infoID    - Which information. Possible values: ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet.OTHER_INFO_*
  embedded  - If this page is embedded within another page or standalone popup (if embedded some parts are discarded)
              Possible values: 3true' or 'false' strings

Notes:
- If embedded in another page an no results are available, then no output is entered (maybe some spaces)
- When embedded - only the table is generated (without any other HTML 'decorations')

--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.HabitatOtherInfo,
                 ro.finsiel.eunis.search.Utilities" %>
<%@ page import="java.util.List"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String idHabitat = request.getParameter("idHabitat");
  Integer infoID = Utilities.checkedStringToInt(request.getParameter("infoID"), new Integer(-1));
  HabitatsFactsheet factsheet = new HabitatsFactsheet(idHabitat);
  // List of other information about habitat.
  List results = null;
  try
  {
    results = factsheet.getOtherInfo(infoID);
  }
  catch(InitializationException e)
  {
    e.printStackTrace();
  }
  if( results != null && !results.isEmpty() )
  {
%>
  <table summary="<%=cm.cms("habitat_other_information")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th width="25%">
           <%=cm.cmsText("name")%>
        </th>
        <th width="75%">
          <%=cm.cmsText("description")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    // Display results.
    for(int i = 0; i < results.size(); i++)
    {
      HabitatOtherInfo obj = (HabitatOtherInfo) results.get(i);
      String name = (null == obj.getName()) ? "n/a" : obj.getName();
      String description = (null == obj.getDescription()) ? "n/a" : obj.getDescription();
      String _name = Utilities.formatString( name.replaceAll("<","&lt;").replaceAll(">","&gt;"), "&nbsp;" );
      String _description = Utilities.formatString( description.replaceAll("<","&lt;").replaceAll(">","&gt;"), "&nbsp;" );
%>
      <tr>
        <td>
          <%=_name%>
        </td>
        <td>
          <%=_description%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_other_information")%>
  <br />
<%
  }
%>