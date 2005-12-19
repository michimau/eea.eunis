<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : No results
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
        </td>
      </tr>
    </table>
    <br />
<%
  String fromRefine = (request.getParameter("fromRefine") != null ? request.getParameter("fromRefine") : "false");
  if("true".equalsIgnoreCase(fromRefine))
  {
%>
    <%=cm.cmsText("noresults_refine")%>.
<%
  }
  else
  {
%>
    <%=cm.cmsText("noresults_search")%>.
<%
  }
%>
    <%=cm.cmsText("noresults_explanation")%>
    <strong>
      <a href="javascript:history.go(-1)" title="Go to previous page"><%=cm.cmsText("noresults_back")%></a>
    </strong>
    <%=cm.cmsText("noresults_review_search_criteria")%>.
    <br />
    <br />
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="noresults.jsp" />
    </jsp:include>
  </body>
</html>