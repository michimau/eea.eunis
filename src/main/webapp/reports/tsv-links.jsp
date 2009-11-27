<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String tsvfilename = Utilities.formatString( request.getParameter( "tsvfilename" ), "" );
  String xmlfilename = Utilities.formatString( request.getParameter( "xmlfilename" ), "" );
  String emailSuggested = Utilities.formatString( SessionManager.getCacheReportEmailAddress(), "" );
  if( emailSuggested.equalsIgnoreCase( "" ) && SessionManager.isAuthenticated() )
  {
    emailSuggested = SessionManager.getUserPrefs().getEMail();
  }
%>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
   updateText('The reports are ready.');
   showLoadingProgress( false );
//]]>
</script>
<a target="_blank"
   href="<%=request.getContextPath()%>/temp/<%=tsvfilename%>">Open TSV(Tab Separated Values) file</a>
<%
  if ( !xmlfilename.equalsIgnoreCase( "") )
  {
%>
<br />
<a target="_blank"
   href="<%=request.getContextPath()%>/temp/<%=xmlfilename%>">Open XML file</a>
<%
  }
%>
<br />
<a href="javascript:emailresults('<%=emailSuggested%>');">Send reports via e-mail</a>
<form id="emailresults" name="emailresults" action="<%=request.getContextPath()%>/reports/tsv-email.jsp">
  <input type="hidden" name="operation" value="email" />
  <input type="hidden" name="tsvfilename" value="<%=tsvfilename%>" />
  <input type="hidden" name="xmlfilename" value="<%=xmlfilename%>" />
  <input type="hidden" name="email" value="" />
</form>
