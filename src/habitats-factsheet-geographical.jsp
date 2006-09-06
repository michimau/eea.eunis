<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats geographical distribution' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatCountryPersist,
                 ro.finsiel.eunis.search.UniqueVector" %>
<%@ page import="java.util.List, ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  // Geographical distribution
  List results = factsheet.getHabitatCountries();
  String url = "";
  String url2 = "";
  UniqueVector colorURL = new UniqueVector();
  UniqueVector colorURL2 = new UniqueVector();
  if(!results.isEmpty()) {
    for(int i = 0; i < results.size(); i++) {
      HabitatCountryPersist country = (HabitatCountryPersist) results.get(i);
      String countryColPair = country.getIso2L();
      if(colorURL.canBeAdded(countryColPair)) {
        colorURL.addElement(countryColPair);
        colorURL2.addElement(countryColPair + ":4");
      }
    }
    url = colorURL.getElementsSeparatedByComma();
    url2 = colorURL2.getElementsSeparatedByComma();
%>
  <h2>
    <%=cm.cmsText("geographical_distribution")%>
  </h2>
  <table summary="layout" width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <jsp:include page="habitats-factsheet-geo.jsp">
          <jsp:param name="url" value="<%=url%>" />
          <jsp:param name="url2" value="<%=url2%>" />
        </jsp:include>
      </td>
    </tr>
  </table>
  <table summary="<%=cm.cms("habitat_distribution")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("country")%>
        </th>
        <th>
          <%=cm.cmsText("biogeographic_region")%>
        </th>
        <th>
          <%=cm.cmsText("probability")%>
        </th>
        <th>
          <%=cm.cmsText("comment")%>
        </th>
      </tr>
    </thead>
    <tbody>
  <%
    for ( int i = 0; i < results.size(); i++ )
    {
      String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
      HabitatCountryPersist country = ( HabitatCountryPersist )results.get( i );
      String _comment = HabitatsFactsheet.getProbabilityAndCommentForHabitatGeoscope( country.getIdReportAttributes() ).get( 1 ).toString();
      _comment = Utilities.formatString( _comment.replaceAll( "<", "&lt;" ).replaceAll( ">", "&gt;" ), "&nbsp;" );
  %>
      <tr<%=cssClass%>>
        <td>
          <%=country.getAreaNameEn()%>
        </td>
        <td>
          <%=country.getBiogeoregionName()%>
        </td>
        <td>
          <%=HabitatsFactsheet.getProbabilityAndCommentForHabitatGeoscope(country.getIdReportAttributes()).get(0)%>
        </td>
        <td>
          <%=_comment%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_distribution")%>
  <%=cm.br()%>
<%
  }
%>
