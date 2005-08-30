<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Diagrams images for habitats.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatDomain,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.List" %>

<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_diagram_title", false)%>
  </title>
  <%
    String eunisCode = request.getParameter("habCode");
    //System.out.println("eunisCode = " + eunisCode);
    boolean isEUNIS = false;
    int level = 0;
    Chm62edtHabitatPersist habitat = null;
    // If eunisCode is a valid code
    if (eunisCode != null && !eunisCode.equalsIgnoreCase("null") && !eunisCode.trim().equalsIgnoreCase("")) {
      //System.out.println("OK");
      // Find habitat with this code (eunisCode)
      List list = new Chm62edtHabitatDomain().findWhere("EUNIS_HABITAT_CODE='" + eunisCode + "'");
      //System.out.println("list.size() = " + list.size());
      if (list.size() > 0) {
        habitat = (Chm62edtHabitatPersist) list.get(0);
      }
      if (null != habitat) {
        //isEunis = (0 == Utilities.EUNIS_HABITAT.compareTo(Utilities.getHabitatType(habitat.getCode2000()))) ? true : false;
        int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
        //System.out.println("idHabitat = " + idHabitat);
        isEUNIS = (idHabitat > 10000) ? false : true;
        level = habitat.getHabLevel().intValue();
        //System.out.println("level = " + level);
      }
    } else {
      //System.out.println("This is level 1 or error...");
    }
  %>
</head>

<body>
<%
  if (isEUNIS) {
%>
<%
  if (level > 0 && level < 3) {
%>
<img alt="Habitat type diagram of relation" border="0" src="images/diagrams/level<%=habitat.getEunisHabitatCode()%>.gif" />
<br />
<%
} else {
%>
<br />
<br />
<%=contentManagement.getContent("habitats_diagram_02")%>: <%=habitat.getScientificName()%>(
<strong><%=eunisCode%></strong>)
-
<%=contentManagement.getContent("habitats_diagram_04")%>:<strong><%=habitat.getHabLevel()%></strong>
<br />
<%=contentManagement.getContent("habitats_diagram_03")%>.
<br />
<table summary="layout" width="500" border="0" cellpadding="0" cellspacing="0" bgcolor="#EEEEEE">
  <%
    if (habitat.getEunisHabitatCode().length() > 2) {
  %>
  <tr>
    <td width="417">
      &nbsp;<%=contentManagement.getContent("habitats_diagram_05")%>:
    </td>
    <td width="40">
      &nbsp;<%=habitat.getEunisHabitatCode().substring(0, 1)%>
    </td>
    <td width="43">
      &nbsp;
      <a title="Open diagram" href="habitats-diagram.jsp?habCode=<%=habitat.getEunisHabitatCode().substring(0, 1)%>">
        <img alt="Diagram" src="images/mini/diagram_in.png" align="middle" width="20" height="20" border="0" />
      </a>
      <br />
    </td>
  </tr>
  <%
    }
  %>
  <%    if (habitat.getEunisHabitatCode().length() > 3) {
  %>
  <tr>
    <td width="417">
      &nbsp;<%=contentManagement.getContent("habitats_diagram_06")%>:
    </td>
    <td width="40">
      &nbsp;<%=habitat.getEunisHabitatCode().substring(0, 2)%>
    </td>
    <td width="43">
      &nbsp;
      <a title="Open diagram" href="habitats-diagram.jsp?habCode=<%=habitat.getEunisHabitatCode().substring(0, 2)%>">
        <img alt="Diagram" src="images/mini/diagram_in.png" align="middle" width="20" height="20" border="0" />
      </a>
      <br />
    </td>
  </tr>
  <%
    }
  %>
</table>
<%
  }
%>
<%
} else {
%>
<img alt="First level diagram of habitat types relation" border="0" src="images/diagrams/level1.gif" />
<br />
<%
  }
%>
</body>
</html>