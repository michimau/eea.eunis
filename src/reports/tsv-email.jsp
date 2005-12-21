<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.SendMail"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.File"%>
<%--
  Created by IntelliJ IDEA.
  User: cromanescu
  Date: Oct 13, 2005
  Time: 2:42:45 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%
  //Utilities.dumpRequestParams( request );
  String op = Utilities.formatString( request.getParameter( "operation"), "" );
  String email = Utilities.formatString( request.getParameter( "email"), "" );
  String csvfilename = Utilities.formatString( request.getParameter( "tsvfilename"), "" );
  String xmlfilename = Utilities.formatString( request.getParameter( "xmlfilename"), "" );

  String TOMCAT_HOME = application.getInitParameter( "TOMCAT_HOME" );
  String TEMP_DIR = application.getInitParameter( "TEMP_DIR" );

  File csvfile;
  File xmlfile;
  ArrayList attachments = new ArrayList();
  System.out.println( "csvfilename = " + csvfilename );
  System.out.println( "xmlfilename = " + xmlfilename );
  if ( !csvfilename.equalsIgnoreCase( "" ) )
  {
    csvfile = new File( TOMCAT_HOME + "/" + TEMP_DIR + csvfilename );
    attachments.add( csvfile.getAbsolutePath() );
  }
  if ( !xmlfilename.equalsIgnoreCase( "" ) )
  {
    xmlfile = new File( TOMCAT_HOME + "/" + TEMP_DIR + xmlfilename );
    attachments.add( xmlfile.getAbsolutePath() );
  }
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>E-Mail report</title>
    <jsp:include page="../header-page.jsp" />
  </head>
  <body>
    <img alt="In progress" src="../images/progress/top.jpg" width="400" height="178" />
<%
  if ( op.equalsIgnoreCase( "email" ) )
  {
    SessionManager.setCacheReportEmailAddress( email );
    System.out.println( "attachments.size() = " + attachments.size() );
    SendMail.sendMail(
      email,
      "EUNIS Database generated reports",
      "Generated reports are attached below",
      application.getInitParameter( "SMTP_SERVER" ),
      application.getInitParameter( "SMTP_USERNAME" ),
      application.getInitParameter( "SMTP_PASSWORD" ),
      application.getInitParameter( "SMTP_SENDER" ),
      attachments
    );
%>
    The files in report has been sent to the supplied e-mail address.

<%
  }
  else
  {
%>
    This page was accessed in a wrong way.
<%
  }
%>
  <br />
  <a href="javascript:history.go(-1);">Back</a>
  </body>
</html>