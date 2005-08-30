<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - Display in a popup sites which are related to selected habitat.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                 java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_sites-detail_title", false)%>
  </title>
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  <!--
   function setLine(val)
   {
     window.opener.document.eunis.scientificName.value=val;
     window.close();
   }
 // -->
  </script>
  <%
    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    Integer database = HabitatsSitesDomain.SEARCH_BOTH;
    Integer idNatureObject = Utilities.checkedStringToInt(request.getParameter("idNatureObject"), new Integer(-1));
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
    boolean[] source_db = {true, true, true, true, true, true, true, true};
    // List of sites names related to habitat.
    List results = new HabitatsSitesDomain().findSitesWithHabitats(new SitesSearchCriteria(searchAttribute,
      formBean.getScientificName(),
      relationOp),
      source_db,
      searchAttribute,
      idNatureObject,
      database);

  %>
</head>

<body>
<table width="275" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#EEEEEE">
    <td>
      <strong>
        <%=contentManagement.getContent("habitats_sites-detail_01")%>:
      </strong>
    </td>
  </tr>
  <tr>
    <td width="201">
      <%=contentManagement.getContent("habitats_sites-detail_02")%>:
      <strong>
        <%=results.size()%>
      </strong>
    </td>
  </tr>
  <%
    if (results == null || results.size() < 1) {
  %>
  <tr>
    <td>
      <strong>
        <%=contentManagement.getContent("habitats_sites-detail_03")%>.
      </strong>
    </td>
  </tr>
  <%
  } else {
  %>
  <tr>
    <td>
      <table width="275" border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse">
        <%
          // Display results.
          String rowBgColor = "";
          for (int i = 0; i < results.size(); i++) {
            rowBgColor = (0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE";
        %>
        <tr bgcolor="<%=rowBgColor%>">
          <td>
            <%=results.get(i)%>
          </td>
        </tr>
        <%
          }
        %>
      </table>
    </td>
  </tr>
  <%
    }
  %>
  <tr>
    <td>
      <br />
      <br />
      <label for="button2" class="noshow">Close window</label>
      <input type=button value="<%=contentManagement.getContent("habitats_sites-detail_04")%>" onclick="javascript:window.close()" name="button2" id="button2" class="inputTextField">
    </td>
  </tr>
</table>
</body>
</html>