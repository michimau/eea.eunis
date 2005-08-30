<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Headline page
--%>
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  /*
  System.out.println("==============================================");
  System.out.println("Input parameters:");
  */
  String insert = request.getParameter("insert");
  String delete = request.getParameter("delete");
  String deleteall = request.getParameter("deleteall");
  String headline = request.getParameter("headline");
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
    if(null != insert && insert.equalsIgnoreCase("insert/update")) {
      String sContent = "insert into eunis_headlines(content,start_date,end_date) values('" + headline + "','" + start_date + "','" + end_date + "')";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
        alert('The headline was updated.');
      -->
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
        alert('The headline was deleted.');
      -->
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
        alert('All headlines were deleted.');
      -->
      </script>
      <%

      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }
  }
  WebContentManagement contentManagement = SessionManager.getWebContent();
  boolean authorised = SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT();
%>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,Headline"/>
      </jsp:include>
<%
  // If user is authentificated and has this right
  if(!authorised)
  {
%>
      <br />
      <strong>
        You can't do this because you are not authentificated or you don't haven enough rights!
      </strong>
      <br />
      Please <a href="login.jsp" title="Login">login</a>
      <br />
<%
  }
  else
  {
%>
      <h5>
        Edit Headlines
      </h5>
      <br />
      <form method="post" name="webcontent" action="headline.jsp">
        <label for="headline">Current headline:</label>
        <br />
        <textarea rows="10" cols="80" name="headline" id="headline" class="inputTextField"><%=headline%></textarea>
        <br />
        <br />
        <label for="start_date">Start date:</label>
        <input type="text" name="start_date" id="start_date" size="12" value="<%=start_date%>" class="inputTextField" title="Start date" />
        (yyyy-MM-dd)
        <br />
        <br />
        <label for="end_date">End date:</label>
        <input class="inputTextField" type="text" name="end_date" id="end_date" size="12" value="<%=end_date%>" title="End date" />
        (yyyy-MM-dd)
        <br />
        <br />
        <br />
        <label for="insert" class="noshow">Insert</label>
        <input class="inputTextField" type="submit" value="Insert/Update" id="insert" name="insert" title="Insert/Update" />&nbsp;&nbsp;

        <label for="delete" class="noshow">Delete</label>
        <input class="inputTextField" type="submit" value="Delete" id="delete" name="delete" title="Delete" />&nbsp;&nbsp;

        <label for="deleteall" class="noshow">Delete all</label>
        <input class="inputTextField" type="submit" value="Delete all" id="deleteall" name="deleteall" title="Delete all" />
      </form>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="template.jsp"/>
      </jsp:include>
    </div>
  </body>
</html>
