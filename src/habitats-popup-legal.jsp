<%--
This is the popup displaying information about the legal instruments of a habitat.
The following request parameters are available as input:
  idHabitat - ID of the habitat for which we are displaying Legal status information.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalPersist,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 java.util.List"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
   <head>
     <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
  <title>
    <%=cm.cms("habitats_popup-legal_title")%>
    <%=HabitatsSearchUtility.findHabitatNameById(request.getParameter("idHabitat"))%>
  </title>
  </head>
  <body>
    <%
      String idHabitat = request.getParameter("idHabitat");
      // List of habitat legal instruments.
      List results = HabitatsSearchUtility.findHabitatLegalInstrument(idHabitat);
    %>
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <%if (!results.isEmpty()) {%>
          <tr bgcolor="#DDDDDD">
          <td>
            <strong>
              <%=cm.cmsText("legal_instrument")%>
            </strong>
          </td>
          </tr>
          <%
            // Display results.
            for (int i = 0; i < results.size(); i++)
            {
            EUNISLegalPersist legal = (EUNISLegalPersist) results.get(i);
            String bgColor = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
          %>
            <tr bgcolor="<%=bgColor%>">
              <td>
                <%=legal.getLegalName()%>&nbsp;
              </td>
            </tr>
<%
          }
        }
        else
        {
%>
          <%=cm.cmsText("habitats_popup-legal_02")%>
<%
        }
%>
    </table>
    <form action="">
      <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" id="button" name="button" class="standardButton" />
      <%=cm.cmsInput("close_btn")%>
    </form>
    <%=cm.cms("habitats_popup-legal_title")%>
  </body>
</html>