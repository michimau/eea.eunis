<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Footer page - included in almost all other pages.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.net.URLEncoder,
                 java.util.Enumeration"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();

  String page_name = request.getParameter( "page_name" );
  String bookmarkURL = page_name + "?a=true";

  Enumeration en = request.getParameterNames();
  while ( en.hasMoreElements() )
  {
    String parameter = ( String )en.nextElement();
    String value = request.getParameter( parameter );
    if ( !parameter.equalsIgnoreCase( "page_name" ) )
    {
      bookmarkURL += "&amp;" + parameter + "=" + value;
    }
  }
  boolean isAuthenticated = SessionManager.isAuthenticated();
%>
<br class="brClear" />
<script language="javascript" type="text/javascript">
  function saveBookmark()
  {
    var URL = "users-bookmarks-save.jsp?bookmarkURL=<%=URLEncoder.encode( bookmarkURL, "UTF-8" )%>";
    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=420,height=230');");
  }
</script>
<div  class="footerprint">
<div class="horizontal_line"><img alt="" src="images/pixel.gif" width="100%" height="1" /></div>
<br />
  <%=cm.cmsText("footer_eunis_database")%>
  <br />
  <%=cm.cmsText("footer_eunis_content")%>
  <br />
<%
  if ( isAuthenticated )
  {
%>
  <a href="javascript:saveBookmark();" class="footerLink" title="<%=cm.cms("footer_bookmark_title")%>"><%=cm.cmsText("bookmark")%></a>
  <%=cm.cmsTitle("footer_bookmark_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
<%
  }
%>
  <a href="http://biodiversity-chm.eea.europa.eu/information/database/" title="<%=cm.cms("footer_related_databases_title")%>" class="footerLink"><%=cm.cmsText("footer_related_databases")%></a>
  <%=cm.cmsTitle("footer_related_databases_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="<%=cm.cms("footer_contact_title")%>" class="footerLink"><%=cm.cmsText("footer_contact")%></a>
  <%=cm.cmsTitle("footer_contact_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="news.jsp" class="footerLink" title="<%=cm.cms("footer_news_title")%>"><%=cm.cmsText("news")%></a>
  <%=cm.cmsTitle("footer_news_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="feedback.jsp" title="<%=cm.cms("footer_feedback_title")%>" class="footerLink"><%=cm.cmsText("feedback")%></a>
  <%=cm.cmsTitle("footer_feedback_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="copyright.jsp" title="<%=cm.cms("footer_copyright_title")%>" class="footerLink"><%=cm.cmsText("copyright_and_disclaimer_title")%></a>
  <%=cm.cmsTitle("footer_copyright_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="accessibility.jsp" title="<%=cm.cms("accessibility_statement")%>" class="footerLink" accesskey="0"><%=cm.cmsText("footer_accessibility")%></a>
  <%=cm.cmsTitle("accessibility_statement")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
</div>
<jsp:include page="digir_check.jsp" />
