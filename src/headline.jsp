<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Headline page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  /*
  System.out.println("==============================================");
  System.out.println("Input parameters:");
  */
  String insert = request.getParameter("insert");
  String delete = request.getParameter("delete");
  String deleteall = request.getParameter("deleteall");
  String headline = request.getParameter("generic_index_07");
  String start_date = request.getParameter("start_date");
  String end_date = request.getParameter("end_date");
  /*
  System.out.println("insert = " + insert);
  System.out.println("delete = " + delete);
  System.out.println("deleteall = " + deleteall);
  System.out.println("headline = " + headline);
  System.out.println("start_date = " + start_date);
  System.out.println("end_date = " + end_date);

  System.out.println("==============================================");
  */
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  if(headline == null) {headline=""; }
  if(start_date == null) {start_date=""; }
  if(end_date == null) {end_date=""; }

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

  if(insert == null && delete == null && deleteall == null) {
    String sContent = "select content from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    headline = sqlc.ExecuteSQL(sContent);
    //System.out.println("headline = " + headline);
    String sStartDate = "select start_date from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    start_date = sqlc.ExecuteSQL(sStartDate);
    //System.out.println("start_date = " + start_date);
    String sEndDate = "select end_date from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    end_date = sqlc.ExecuteSQL(sEndDate);
    //System.out.println("end_date = " + end_date);
  } else {
    if(null != insert && insert.equalsIgnoreCase(cm.cms( "headline_insert" ) )) {
      String sContent = "insert into eunis_headlines(content,start_date,end_date) values('" + headline + "','" + start_date + "','" + end_date + "')";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
        alert('<%=cm.cms( "headline_updated" )%>');
      //-->
      </script>
      <%
      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }

    if(null != delete && delete.equalsIgnoreCase("delete")) {
      String sContent = "delete from eunis_headlines where content='" + headline + "' and start_date='" + start_date + "' and end_date='" + end_date + "'";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);

      %>
      <script language="JavaScript" type="text/javascript">
      <!--
        alert('<%=cm.cms("headline_deleted")%>');
      //-->
      </script>
      <%

      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }

    if(null != deleteall && deleteall.equalsIgnoreCase("delete all")) {
      String sContent = "delete from eunis_headlines";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);

      %>
      <script language="JavaScript" type="text/javascript">
      <!--
        alert('<%=cm.cms("headlines_deleted_all")%>');
      //-->
      </script>
      <%

      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }
  }
  boolean authorised = SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("generic_index_07")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,services#services.jsp,headline"/>
      </jsp:include>
<%
  // If user is authentificated and has this right
  if(!authorised)
  {
%>
      <br />
      <strong>
        <%=cm.cmsText("not_authenticated_no_rights")%>
      </strong>
      <a href="login.jsp" title="Login"><%=cm.cmsText("login")%></a>
      <br />
<%
  }
  else
  {
%>
      <h1>
        <%=cm.cmsText("headline_title")%>
      </h1>
      <br />
      <form method="post" name="webcontent" action="headline.jsp">
        <label for="generic_index_07">
          <%=cm.cms("current_headline_label")%>:
        </label>
        <br />
        <textarea rows="10" cols="80" name="generic_index_07" id="generic_index_07" class="inputTextField"><%=headline%></textarea>
        <%=cm.cmsLabel("current_headline_label")%>
        <br />
        <br />
        <label for="start_date">
          <%=cm.cms("headline_start_date")%>:
        </label>
        <input type="text" name="start_date" id="start_date" size="12" value="<%=start_date%>" class="inputTextField" title="<%=cm.cms("headline_start_date")%>" />
        <%=cm.cmsLabel("headline_start_date")%>
        (yyyy-MM-dd)
        <br />
        <br />
        <label for="end_date">
          <%=cm.cms("headline_end_date")%>:
        </label>
        <input class="inputTextField" type="text" name="end_date" id="end_date" size="12" value="<%=end_date%>" title="<%=cm.cms("headline_end_date")%>" />
        <%=cm.cmsLabel("headline_end_date")%>
        (yyyy-MM-dd)
        <br />
        <br />
        <br />
        <input class="inputTextField" type="submit" value="<%=cm.cms("headline_insert")%>" id="insert" name="insert" title="<%=cm.cms("headline_insert_label")%>" />&nbsp;&nbsp;
        <%=cm.cmsInput("headline_insert")%>

        <input class="inputTextField" type="submit" value="<%=cm.cms("delete")%>" id="delete" name="delete" title="<%=cm.cms("delete")%>" />&nbsp;&nbsp;
        <%=cm.cmsInput("delete")%>

        <input class="inputTextField" type="submit" value="<%=cm.cms("delete_all")%>" id="deleteall" name="deleteall" title="<%=cm.cms("delete_all")%>" />
        <%=cm.cmsInput("delete_all")%>
      </form>
<%
  }
%>
      <%=cm.cmsMsg("generic_index_07")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("headline_updated")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("headline_deleted")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("headlines_deleted_all")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="template.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>