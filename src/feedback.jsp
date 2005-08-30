<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Feedback page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.Date,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.Statement,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement" %>
<%@ page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("generic_feedback_title", false)%>
  </title>
  <script language="JavaScript" type="text/javascript">
    <!--
  function testform(x) {
    if (x.content.value=="") {
      alert('<%=contentManagement.getContent( "generic_feedback_27",false )%>');
      return false;
    }
    return true;
    }
  //-->
  </script>
</head>
<%
  // Request parameters
  // operation - if operation is feedback then save the request form data to database.
  String operation = request.getParameter("operation");
  String referer = request.getHeader("referer");
  String url = request.getParameter("url");
  String feedbackType = request.getParameter("feedbackType");
  String module = request.getParameter("module");

  if(null == referer) referer = "";
  if(url != null) referer = url;
  // If operation parameter is not null and is equals with 'feedback'
  if(null != operation && operation.equalsIgnoreCase("feedback")) {
    // Parameter request
    String comment = request.getParameter("comment");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String organization = request.getParameter("organization");
    String address = "";
    String telephone = request.getParameter("telephone");
    String fax = request.getParameter("fax");

    try {
      // Set the database connection parameters
      String SQL_DRV = "";
      String SQL_URL = "";
      String SQL_USR = "";
      String SQL_PWD = "";

      SQL_DRV = application.getInitParameter("JDBC_DRV");
      SQL_URL = application.getInitParameter("JDBC_URL");
      SQL_USR = application.getInitParameter("JDBC_USR");
      SQL_PWD = application.getInitParameter("JDBC_PWD");

      Class.forName(SQL_DRV);
      Connection con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      Statement ps = con.createStatement();
      String sql = "";
      String idFeedback = "";
      sql = "SELECT MAX(ID_FEEDBACK)+1 FROM EUNIS_FEEDBACK";// Find the last PK and increment it.
      ResultSet rs = ps.executeQuery(sql);
      rs.next();
      idFeedback = rs.getString(1);
      rs.close();
      // Insert the new feedback
      if(idFeedback != null) {
        sql = "";
        sql += " INSERT INTO EUNIS_FEEDBACK(ID_FEEDBACK,FEEDBACK_TYPE,MODULE,COMMENT,NAME,EMAIL,COMPANY,ADDRESS,PHONE,FAX,URL)";
        sql += " VALUES(";
        sql += idFeedback + ",";
        sql += "'" + feedbackType.replaceAll("'", "") + "',";
        sql += "'" + module.replaceAll("'", "") + "',";
        sql += "'" + comment.replaceAll("'", "") + "',";
        sql += "'" + name.replaceAll("'", "") + "',";
        sql += "'" + email.replaceAll("'", "") + "',";
        sql += "'" + organization.replaceAll("'", "") + "',";
        sql += "'" + address.replaceAll("'", "") + "',";
        sql += "'" + telephone.replaceAll("'", "") + "',";
        sql += "'" + fax.replaceAll("'", "") + "',";
        sql += "'" + url.replaceAll("'", "") + "'";
        sql += ")";
        ps.execute(sql);
      }
      ps.close();
      con.close();
      String recipient = application.getInitParameter("EMAIL_FEEDBACK");
      // Set body string
      String body = "";
      body += "\n";
      body += "Module: " + module;
      body += "\n";
      body += "Page URL: " + url;
      body += "\n\n";
      body += "Content: " + comment;
      body += "\n\n";
      body += "Author: " + name;
      body += "\n";
      body += "Organization: " + organization;
      body += "\n";
      body += "Address: " + address;
      body += "\n";
      body += "Email: " + email;
      body += "\n";
      body += "Telephone: " + telephone;
      body += "\n";
      body += "Fax: " + fax;
      body += "\n";
      body += "\n\n";
      body += "Date: " + new Date().toString();
      //Set bodyHTML string
      String bodyHTML = "";
      bodyHTML += "<br />";
      bodyHTML += "Module: " + module;
      bodyHTML += "<br />";
      bodyHTML += "Page URL: " + url;
      bodyHTML += "<br /><br />";
      bodyHTML += "Content: " + comment;
      bodyHTML += "<br /><br />";
      bodyHTML += "Author: " + name;
      bodyHTML += "<br />";
      bodyHTML += "Organization: " + organization;
      bodyHTML += "<br />";
      bodyHTML += "Address: " + address;
      bodyHTML += "<br />";
      bodyHTML += "Email: " + email;
      bodyHTML += "<br />";
      bodyHTML += "Telephone: " + telephone;
      bodyHTML += "<br />";
      bodyHTML += "Fax: " + fax;
      bodyHTML += "<br />";
      bodyHTML += "<br />";
      bodyHTML += "Date: " + new Date().toString();
      bodyHTML += "<br />";
      // Send feddback
      ro.finsiel.eunis.SendMail.sendEUNISFeedback(recipient, feedbackType, body);
%>
<body>
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Feedback#feedback.jsp" />
</jsp:include>
<h5><%=contentManagement.getContent("generic_feedback_01")%></h5>
<br />
  <%=contentManagement.getContent("generic_feedback_02")%>
<br />
<br />
<strong>
  <%=contentManagement.getContent("generic_feedback_03")%>
</strong>
<br />
<br />
<%=bodyHTML%>
<br />
<br />
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="feedback.jsp" />
</jsp:include>
</body>
</html>
<%
  } catch(Exception _ex) {
    _ex.printStackTrace(System.err);
    throw new ServletException(_ex.getMessage());
  }
}
  else
  {
  if(module == null) module = "";
  if(feedbackType == null) feedbackType = "";
%>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Feedback" />
      </jsp:include>
      <h5>
        <%=contentManagement.getContent("generic_feedback_04")%>
      </h5>
      <br />
      <%=contentManagement.getContent("generic_feedback_05")%>
      <br />
      <br />
      <form name="feed" action="feedback.jsp" method="post">
        <input type="hidden" name="operation" value="feedback" />
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="40%">
              <strong>
                <%=contentManagement.getContent("generic_feedback_06")%>
              </strong>
            </td>
            <td>
              <label for="feedbackType" class="noshow">Feedback type</label>
              <select title="Feedback type" size="1" name="feedbackType" id="feedbackType" class="inputTextField">
                <option value="Proposal to add value" <%=(feedbackType.equalsIgnoreCase("Proposal to add value") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_07", false)%>
                </option>
                <option value="Contribute with data" <%=(feedbackType.equalsIgnoreCase("Contribute with data") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_08", false)%>
                </option>
                <option value="Software bugs" <%=(feedbackType.equalsIgnoreCase("Software bugs") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_09", false)%>
                </option>
                <option value="Application tools" <%=(feedbackType.equalsIgnoreCase("Application tools") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_10", false)%>
                </option>
                <option value="Other comments" <%=(feedbackType.equalsIgnoreCase("Other comments") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_11", false)%>
                </option>
              </select>
            </td>
          </tr>
          <tr>
            <td width="40%"><strong>EUNIS Database module:</strong></td>
            <td>
              <label for="select" class="noshow">EUNIS Database module</label>
              <select title="EUNIS Database module" name="module" id="select" class="inputTextField">
                <option value="Not specified" <%=(module.equalsIgnoreCase("Not specified") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_12", false)%>
                </option>
                <option value="EUNIS Species" <%=(module.equalsIgnoreCase("EUNIS Species") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_13", false)%>
                </option>
                <option value="EUNIS Habitats" <%=(module.equalsIgnoreCase("EUNIS Habitats") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_14", false)%>
                </option>
                <option value="EUNIS Sites" <%=(module.equalsIgnoreCase("EUNIS Sites") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_15", false)%>
                </option>
                <option value="Graphic Design" <%=(module.equalsIgnoreCase("Graphic Design") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_16", false)%>
                </option>
                <option value="Database" <%=(module.equalsIgnoreCase("Database") ? "selected=\"selected\"" : "")%>>
                  <%=contentManagement.getContent("generic_feedback_17", false)%>
                </option>
              </select>
            </td>
          </tr>
          <tr>
            <td width="99">
              <strong>
                <label for="url">URL:</label>
              </strong>
            </td>
            <td>
              <input title="URL" name="url" type="text" id="url" size="80" class="inputTextField" value="<%=referer%>" />
            </td>
          </tr>
        </table>
        <br />
        <strong>
          <label for="comment"><%=contentManagement.getContent("generic_feedback_18")%></label>
        </strong>
        <textarea title="Comment" name="comment" id="comment" rows="8" cols="50" class="inputTextField">Enter your comments here... </textarea>
        <br />
        <br />
        <%=contentManagement.getContent("generic_feedback_20")%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="99">
              <label for="name"><%=contentManagement.getContent("generic_feedback_21")%></label>
            </td>
            <td width="635">
              <input title="Name" name="name" type="text" id="name" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="email"><%=contentManagement.getContent("generic_feedback_22")%></label>
            </td>
            <td>
              <input title="Email" name="email" type="text" id="email" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="organization"><%=contentManagement.getContent("generic_feedback_23")%></label>
            </td>
            <td>
              <input title="Organization" name="organization" type="text" id="organization" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="telephone"><%=contentManagement.getContent("generic_feedback_25")%></label>
            </td>
            <td>
              <input title="Phone" name="telephone" type="text" id="telephone" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="fax"><%=contentManagement.getContent("generic_feedback_26")%></label>
            </td>
            <td>
              <input title="Fax" name="fax" type="text" id="fax" size="40" class="inputTextField" />
            </td>
          </tr>
        </table>
        <p>
          <label for="submit" class="noshow">Send feedback</label>
          <input title="Send feedback" type="submit" id="submit" value="Send feedback" name="ContactUs" class="inputTextField" />
        </p>
      </form>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="feedback.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
<%
  }
%>