<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();

  String operation = Utilities.formatString( request.getParameter( "operation" ), "" );
  boolean result = false;
  if ( operation.equalsIgnoreCase( "add" ) )
  {
    String idPage = request.getParameter( "idpage" );
    String contentData = request.getParameter( "contentData" );
    if ( !idPage.equalsIgnoreCase( "" ) && !contentData.equalsIgnoreCase( "" ) )
    {
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");
      result = cm.insertContentJDBC( idPage, contentData, "", "en", SessionManager.getUsername(), false, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
    }
    else
    {
      System.out.println( "web-content-keys: invalid values: idpage=" + idPage );
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script type="text/javascript" language="javascript">
      <!--
      function validateForm()
      {
        var idpage = document.getElementById( "idpage" );
        var contentData = document.getElementById( "contentData" );
        if ( idpage.value == "" || contentData.value == "" )
        {
          alert( "<%=cm.cms("web_content_keys_01")%>");
          return false;
        }
        return true;
      }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,web_content_management_location"/>
        <jsp:param name="helpLink" value="help.jsp"/>
      </jsp:include>
<%
  if( SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
  {
%>    <h1>
        <%=cm.cmsText("web_content_keys_02")%>
      </h1>
      <br />
      <%=cm.cmsText("web_content_keys_03")%>
      <br />
      <br />
      <form name="contentManage" action="web-content-keys.jsp" method="POST" onsubmit="javascript: return validateForm();">
        <input type="hidden" name="operation" value="add">
        <label for="idpage"><%=cm.cmsText("web_content_keys_04")%>:</label>
        <br />
        <input title="<%=cm.cms("web_content_keys_04")%>" type="text" size="50" name="idpage" id="idpage" class="inputTextField" style="font-family:monospace,serif;" />
        <br />
        <label for="contentData"><%=cm.cmsText("web_content_keys_05")%>:</label>
        <br />
        <textarea title="<%=cm.cms("web_content_keys_05")%>" rows="5" cols="50" name="contentData" id="contentData" class="inputTextField" style="font-family:monospace,serif;"></textarea>
        <br />
        <br />
        <input title="<%=cm.cms("web_content_keys_06")%>" type="submit" name="submit" id="sub1" value="<%=cm.cms("web_content_keys_07")%>" class="inputTextField" />
        <%=cm.cmsTitle("web_content_keys_06")%>
        <%=cm.cmsInput("web_content_keys_07")%>
      </form>
      <br />
      <br />
<%
    if( operation.equalsIgnoreCase( "add" ) )
    {
      String message = cm.cms("web_content_keys_08");
      if ( !result )
      {
        message = cm.cms("web_content_keys_09");
      }
      out.print( message );
    }
  }
  else
  {
%>
        <br />
        <br />
        <%=cm.cmsText("web_content_keys_10")%>
        <br />
        <br />
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("web_content_keys_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("web_content_keys_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("web_content_keys_09")%>
<%=cm.br()%>

      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="template.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
<%
  out.flush();
%>
