<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - Display in a popup sites related to selected species.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesDomain,
                 ro.finsiel.eunis.search.species.sites.SitesSearchCriteria,
                 java.util.List,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("species_sites-detail_title", false )%>
    </title>
    <%// Get form parameters here%>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <script language="JavaScript" type="text/javascript">
      <!--
        function setLine(val) {
          window.opener.document.eunis.scientificName.value=val;
          window.close();
        }
      // -->
    </script>
  <%
    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    Integer idNatureObject = Utilities.checkedStringToInt(request.getParameter("idNatureObject"), new Integer(-1));
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
    boolean[] source_db = { true, true, true, true, true, true, true, true };
    // List of habitats from the specified site
    List results = new SpeciesSitesDomain().findSitesWithSpecies(new SitesSearchCriteria(searchAttribute,
                                                                                formBean.getScientificName(),
                                                                                relationOp),
                                                                         source_db,
                                                                         searchAttribute,
                                                                         idNatureObject,
                                                                         SessionManager.getShowEUNISInvalidatedSpecies());

   %>
  </head>
<body style="background-color:#ffffff">
      <span style="background-color:#EEEEEE">
          <strong>
            <%=contentManagement.getContent("species_sites-detail_01")%>:
          </strong>
          <br />
       </span>
      <%=contentManagement.getContent("species_sites-detail_02")%>:
      <strong> <%=results.size()%> </strong>
      <br />
      <%
        if (results==null || results.size() < 1)
        {
      %>
              <strong>
                <%=contentManagement.getContent("species_sites-detail_03")%>.
              </strong>
      <%} else { %>
          <h6>List of values :</h6>
          <div id="tab">
          <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
          <%
            String rowBgColor = "";
            // Display results.
            for(int i =0;i<results.size();i++)
            {
              rowBgColor = (0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE";
          %>
              <tr style="background-color:<%=rowBgColor%>">
                <td><%=results.get(i)%></td>
              </tr>
          <%
            }
          %>
          </table>
          </div>
       <%
        }
       %>
          <br />
          <br />
          <form action="">
            <label for="button" class="noshow"><%=contentManagement.getContent("species_sites-detail_04", false )%></label>  
            <input id="button" title="Close window" type=button value="<%=contentManagement.getContent("species_sites-detail_04")%>" onclick="javascript:window.close()" name="button2" class="inputTextField" />
          </form>
  </body>
</html>