<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Feedback page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Date,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.Statement,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("generic_feedback_title")%>
  </title>
  <script language="JavaScript" type="text/javascript">
    <!--
  function testform() {
    if (document.feed.comment.value=="" || document.feed.comment.value=="Enter your comments here... ") {
      alert('<%=cm.cms("generic_feedback_27")%>');
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
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");

      Class.forName(SQL_DRV);
      Connection con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      Statement ps = con.createStatement();
      String sql;
      String idFeedback;
      sql = "SELECT MAX(ID_FEEDBACK)+1 FROM EUNIS_FEEDBACK";// Find the last PK and increment it.
      ResultSet rs = ps.executeQuery(sql);
      rs.next();
      idFeedback = rs.getString(1);
      rs.close();
      if(idFeedback == null) {
        idFeedback = "1";
      }
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
      ro.finsiel.eunis.SendMail.sendMail(
        recipient,
        feedbackType,
        body,
        application.getInitParameter( "SMTP_SERVER" ),
        application.getInitParameter( "SMTP_USERNAME" ),
        application.getInitParameter( "SMTP_PASSWORD" ),
        application.getInitParameter( "SMTP_SENDER" ),
        null // no attachments
        );
%>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,feedback_location" />
      </jsp:include>
      <h1>
        <%=cm.cmsText("generic_feedback_01")%>
      </h1>
      <br />
        <%=cm.cmsText("generic_feedback_02")%>
      <br />
      <br />
      <strong>
        <%=cm.cmsText("generic_feedback_03")%>
      </strong>
      <br />
      <br />
      <%=bodyHTML%>
      <br />
      <br />
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="feedback.jsp" />
      </jsp:include>
      <%=cm.cmsMsg("generic_feedback_title")%>
    </div>
    </div>
    </div>
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
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,feedback_location" />
      </jsp:include>
      <h1>
        <%=cm.cmsText("generic_feedback_04")%>
      </h1>
      <br />
      <%=cm.cmsText("generic_feedback_05")%>
      <br />
      <br />
      <form name="feed" action="feedback.jsp" method="post" onsubmit="javascript: return testform();">
        <input type="hidden" name="operation" value="feedback" />
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="40%">
              <strong>
                <%=cm.cmsText("generic_feedback_06")%>
              </strong>
            </td>
            <td>
              <label for="feedbackType" class="noshow"><%=cm.cms("feedback_type")%></label>
              <select title="<%=cm.cms("feedback_type")%>" size="1" name="feedbackType" id="feedbackType" class="inputTextField">
                <option value="Proposal to add value" <%=(feedbackType.equalsIgnoreCase("Proposal to add value") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_07")%>
                </option>
                <option value="Contribute with data" <%=(feedbackType.equalsIgnoreCase("Contribute with data") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_08")%>
                </option>
                <option value="Software bugs" <%=(feedbackType.equalsIgnoreCase("Software bugs") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_09")%>
                </option>
                <option value="Application tools" <%=(feedbackType.equalsIgnoreCase("Application tools") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_10")%>
                </option>
                <option value="Other comments" <%=(feedbackType.equalsIgnoreCase("Other comments") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_11")%>
                </option>
              </select>
              <%=cm.cmsLabel("feedback_type")%>
              <%=cm.cmsInput("generic_feedback_07")%>
              <%=cm.cmsInput("generic_feedback_08")%>
              <%=cm.cmsInput("generic_feedback_09")%>
              <%=cm.cmsInput("generic_feedback_10")%>
              <%=cm.cmsInput("generic_feedback_11")%>
            </td>
          </tr>
          <tr>
            <td width="40%"><strong><%=cm.cmsText("feedback_module")%></strong></td>
            <td>
              <label for="select" class="noshow"><%=cm.cms("feedback_module")%></label>
              <select title="<%=cm.cms("feedback_module")%>" name="module" id="select" class="inputTextField">
                <option value="Not specified" <%=(module.equalsIgnoreCase("Not specified") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_12")%>
                </option>
                <option value="EUNIS Species" <%=(module.equalsIgnoreCase("EUNIS Species") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_13")%>
                </option>
                <option value="EUNIS Habitats" <%=(module.equalsIgnoreCase("EUNIS Habitats") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_14")%>
                </option>
                <option value="EUNIS Sites" <%=(module.equalsIgnoreCase("EUNIS Sites") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_15")%>
                </option>
                <option value="Graphic Design" <%=(module.equalsIgnoreCase("Graphic Design") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_16")%>
                </option>
                <option value="Database" <%=(module.equalsIgnoreCase("Database") ? "selected=\"selected\"" : "")%>>
                  <%=cm.cms("generic_feedback_17")%>
                </option>
              </select>
              <%=cm.cmsLabel("feedback_module")%>
              <%=cm.cmsInput("generic_feedback_12")%>
              <%=cm.cmsInput("generic_feedback_13")%>
              <%=cm.cmsInput("generic_feedback_14")%>
              <%=cm.cmsInput("generic_feedback_15")%>
              <%=cm.cmsInput("generic_feedback_16")%>
              <%=cm.cmsInput("generic_feedback_17")%>
            </td>
          </tr>
          <tr>
            <td width="99">
              <strong>
                <label for="url"><%=cm.cmsText("feedback_url")%></label>
              </strong>
            </td>
            <td>
              <input title="<%=cm.cms("feedback_url")%>" name="url" type="text" id="url" size="80" class="inputTextField" value="<%=referer%>" />
            </td>
          </tr>
        </table>
        <br />
        <strong>
          <label for="comment"><%=cm.cmsText("generic_feedback_18")%></label>
        </strong>
        <textarea title="<%=cm.cms("generic_feedback_18")%>" name="comment" id="comment" rows="8" cols="50" class="inputTextField">Enter your comments here... </textarea>
        <br />
        <br />
        <%=cm.cmsText("generic_feedback_20")%>
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="99">
              <label for="name"><%=cm.cmsText("generic_feedback_21")%></label>
            </td>
            <td width="635">
              <input title="<%=cm.cms("generic_feedback_21")%>" name="name" type="text" id="name" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="email"><%=cm.cmsText("generic_feedback_22")%></label>
            </td>
            <td>
              <input title="<%=cm.cms("generic_feedback_22")%>" name="email" type="text" id="email" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="organization"><%=cm.cmsText("generic_feedback_23")%></label>
            </td>
            <td>
              <input title="<%=cm.cms("generic_feedback_23")%>" name="organization" type="text" id="organization" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="telephone"><%=cm.cmsText("generic_feedback_25")%></label>
            </td>
            <td>
              <input title="<%=cm.cms("generic_feedback_25")%>" name="telephone" type="text" id="telephone" size="40" class="inputTextField" />
            </td>
          </tr>
          <tr>
            <td>
              <label for="fax"><%=cm.cmsText("generic_feedback_26")%></label>
            </td>
            <td>
              <input title="Fax" name="fax" type="text" id="fax" size="40" class="inputTextField" />
            </td>
          </tr>
        </table>
        <p>
          <label for="submit" class="noshow"><%=cm.cms("feedback_send")%></label>
          <input title="<%=cm.cms("feedback_send")%>" type="submit" id="submit" value="<%=cm.cms("feedback_send")%>" name="ContactUs" class="inputTextField" />
          <%=cm.cmsInput("feedback_send")%>
        </p>
      </form>
      <%=cm.cmsMsg("generic_feedback_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("generic_feedback_27")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="feedback.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
<%
  }
%>