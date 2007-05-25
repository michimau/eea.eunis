<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Feedback page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
  // Request parameters
  // operation - if operation is feedback then save the request form data to database.
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,feedback";
  String operation = Utilities.formatString( request.getParameter( "operation" ) );
  String referer = Utilities.formatString( request.getHeader( "referer" ) );
  String url = Utilities.formatString( request.getParameter( "url" ) );
  String feedbackType = Utilities.formatString( request.getParameter( "feedbackType" ) );
  String module = Utilities.formatString( request.getParameter( "module" ) );
  Boolean isResponseCorrect =Boolean.FALSE;
  if ( !url.equalsIgnoreCase( "" ) )
  {
    referer = url;
  }

  // If operation parameter is not null and is equals with 'feedback'
  String bodyHTML = "";
  if ( operation.equalsIgnoreCase( "feedback" ) )
  {
    // Parameter request
    String comment = Utilities.formatString( request.getParameter( "comment" ) );
    String name = Utilities.formatString( request.getParameter( "name" ) );
    String email = Utilities.formatString( request.getParameter( "email" ) );
    String organization = Utilities.formatString( request.getParameter( "organization" ) );
    String address = "";
    String telephone = Utilities.formatString( request.getParameter( "telephone" ) );
    String fax = Utilities.formatString( request.getParameter( "fax" ) );
    String cap = Utilities.formatString( request.getParameter( "j_captcha_response" ) );
    
    String captchaId = request.getSession().getId();
    
    isResponseCorrect = CaptchaServiceSingleton.getInstance().validateResponseForID(captchaId, cap);
    
    if(isResponseCorrect.booleanValue()){
	    try
	    {
	      // Set the database connection parameters
	      String SQL_DRV = application.getInitParameter( "JDBC_DRV" );
	      String SQL_URL = application.getInitParameter( "JDBC_URL" );
	      String SQL_USR = application.getInitParameter( "JDBC_USR" );
	      String SQL_PWD = application.getInitParameter( "JDBC_PWD" );
	
	      Class.forName( SQL_DRV );
	      Connection con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
	      Statement ps = con.createStatement();
	      String sql;
	      String idFeedback;
	      sql = "SELECT MAX(ID_FEEDBACK)+1 FROM EUNIS_FEEDBACK";// Find the last PK and increment it.
	      ResultSet rs = ps.executeQuery( sql );
	      rs.next();
	      idFeedback = rs.getString( 1 );
	      rs.close();
	      if ( idFeedback == null )
	      {
	        idFeedback = "1";
	      }
	      sql = "";
	      sql += " INSERT INTO EUNIS_FEEDBACK(ID_FEEDBACK,FEEDBACK_TYPE,MODULE,COMMENT,NAME,EMAIL,COMPANY,ADDRESS,PHONE,FAX,URL)";
	      sql += " VALUES(";
	      sql += idFeedback + ",";
	      sql += "'" + feedbackType.replaceAll( "'", "" ) + "',";
	      sql += "'" + module.replaceAll( "'", "" ) + "',";
	      sql += "'" + comment.replaceAll( "'", "" ) + "',";
	      sql += "'" + name.replaceAll( "'", "" ) + "',";
	      sql += "'" + email.replaceAll( "'", "" ) + "',";
	      sql += "'" + organization.replaceAll( "'", "" ) + "',";
	      sql += "'" + address.replaceAll( "'", "" ) + "',";
	      sql += "'" + telephone.replaceAll( "'", "" ) + "',";
	      sql += "'" + fax.replaceAll( "'", "" ) + "',";
	      sql += "'" + url.replaceAll( "'", "" ) + "'";
	      sql += ")";
	      ps.execute( sql );
	
	      ps.close();
	      con.close();
	      String recipient = application.getInitParameter( "EMAIL_FEEDBACK" );
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
	    }
	    catch ( Exception _ex )
	    {
	      _ex.printStackTrace( System.err );
	      throw new ServletException( _ex.getMessage() );
	    }
    } else {
	    bodyHTML += "Captcha verification failed!";
    }
  }

%>
<%@ page import="java.util.Date,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.Statement,
                 java.sql.ResultSet,
                 ro.finsiel.captcha.CaptchaServiceSingleton,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
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
      <%=cm.cms("feedback")%>
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
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
<%
  if ( operation.equalsIgnoreCase( "feedback" ) )
  {
	  if (isResponseCorrect) {
%>



                <h1>
                  <%=cm.cmsText("thank_you")%>
                </h1>
                <br />
                  <%=cm.cmsText("generic_feedback_02")%>
                <br />
                <br />
                <strong>
                  <%=cm.cmsText("generic_feedback_03")%>
                </strong>
                <br />
<% } %>
                <br />
                <%=bodyHTML%>
                <br />
                <br />
                <%=cm.cmsMsg("feedback")%>
<%
  }
  else
  {
%>
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
                        <select title="<%=cm.cms("feedback_type")%>" size="1" name="feedbackType" id="feedbackType">
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
                        <select title="<%=cm.cms("feedback_module")%>" name="module" id="select">
                          <option value="Not specified" <%=(module.equalsIgnoreCase("Not specified") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("generic_feedback_12")%>
                          </option>
                          <option value="EUNIS Species" <%=(module.equalsIgnoreCase("EUNIS Species") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("generic_feedback_13")%>
                          </option>
                          <option value="EUNIS Habitats" <%=(module.equalsIgnoreCase("EUNIS Habitats") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("eunis_habitat_types")%>
                          </option>
                          <option value="EUNIS Sites" <%=(module.equalsIgnoreCase("EUNIS Sites") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("generic_feedback_15")%>
                          </option>
                          <option value="Graphic Design" <%=(module.equalsIgnoreCase("Graphic Design") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("generic_feedback_16")%>
                          </option>
                          <option value="Database" <%=(module.equalsIgnoreCase("Database") ? "selected=\"selected\"" : "")%>>
                            <%=cm.cms("database")%>
                          </option>
                        </select>
                        <%=cm.cmsLabel("feedback_module")%>
                        <%=cm.cmsInput("generic_feedback_12")%>
                        <%=cm.cmsInput("generic_feedback_13")%>
                        <%=cm.cmsInput("eunis_habitat_types")%>
                        <%=cm.cmsInput("generic_feedback_15")%>
                        <%=cm.cmsInput("generic_feedback_16")%>
                        <%=cm.cmsInput("database")%>
                      </td>
                    </tr>
                    <tr>
                      <td width="99">
                        <strong>
                          <label for="url"><%=cm.cmsText("feedback_url")%></label>
                        </strong>
                      </td>
                      <td>
                        <input title="<%=cm.cms("feedback_url")%>" name="url" type="text" id="url" size="80" value="<%=referer%>" />
                      </td>
                    </tr>
                  </table>
                  <br />
                  <strong>
                    <label for="comment"><%=cm.cmsText("generic_feedback_18")%></label>
                  </strong>
                  <textarea title="<%=cm.cms("generic_feedback_18")%>" name="comment" id="comment" rows="8" cols="50">Enter your comments here... </textarea>
                  <br />
                  <br />
                  <%=cm.cmsText("generic_feedback_20")%>
                  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="99">
                        <label for="name"><%=cm.cmsText("generic_feedback_21")%></label>
                      </td>
                      <td width="635">
                        <input title="<%=cm.cms("generic_feedback_21")%>" name="name" type="text" id="name" size="40" />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label for="email"><%=cm.cmsText("generic_feedback_22")%></label>
                      </td>
                      <td>
                        <input title="<%=cm.cms("generic_feedback_22")%>" name="email" type="text" id="email" size="40" />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label for="organization"><%=cm.cmsText("generic_feedback_23")%></label>
                      </td>
                      <td>
                        <input title="<%=cm.cms("generic_feedback_23")%>" name="organization" type="text" id="organization" size="40" />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label for="telephone"><%=cm.cmsText("generic_feedback_25")%></label>
                      </td>
                      <td>
                        <input title="<%=cm.cms("generic_feedback_25")%>" name="telephone" type="text" id="telephone" size="40" />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <label for="fax"><%=cm.cmsText("generic_feedback_26")%></label>
                      </td>
                      <td>
                        <input title="Fax" name="fax" type="text" id="fax" size="40" />
                      </td>
                    </tr>
                    <tr>
                    	<td>
                    		<label for="j_captcha_response"><%=cm.cmsText("generic_feedback_28")%></label>
                    	</td>
                    	<td>
                    		<img src="/jcaptcha"><br/>
							<input type="text" name="j_captcha_response" value="">
                    	</td>
                    </tr>
                  </table>
                  <p>
                    <input title="<%=cm.cms("send_feedback")%>" type="submit" id="submit" value="<%=cm.cms("send_feedback")%>" name="ContactUs" class="searchButton" />
                    <%=cm.cmsInput("send_feedback")%>
                  </p>
                </form>
                <%=cm.cmsMsg("feedback")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("generic_feedback_27")%>
<%
  }
%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="feedback.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
