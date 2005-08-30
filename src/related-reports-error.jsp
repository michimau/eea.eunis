<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports error page' function - search page.
--%>
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String message = Utilities.formatString( request.getParameter("status"), "" );
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      Upload manager
    </title>
  </head>
  <body>
    <h5>
      Related reports
    </h5>
    <br />
    <br />
    <br />
    There was an error while trying to upload the document.
    <br />
    <strong>
      You may want to go <a href="javascript:history.go(-1);">back</a> and try again.
    </strong>
<%
  if( !message.equalsIgnoreCase( "" ) )
  {
%>
    Reason: <%=message%>
<%
  }
%>
    <form action="">
      <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>