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
<br clear="all" />
<script language="javascript" type="text/javascript">
  function saveBookmark()
  {
    var URL = "users-bookmarks-save.jsp?bookmarkURL=<%=URLEncoder.encode( bookmarkURL, "UTF-8" )%>";
    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=420,height=230');");
  }
</script>
<div  class="footerprint">
  <hr class="horizontal_line" />
  <br />
  <%=cm.cmsText("footer_eunis_database")%>
  <br />
  <%=cm.cmsText("footer_eunis_content")%>
  <br />
<%
  if ( isAuthenticated )
  {
%>
  <a href="javascript:saveBookmark();" title="<%=cm.cms("footer_bookmark_title")%>"><%=cm.cmsPhrase("Bookmark")%></a>
  <%=cm.cmsTitle("Bookmark this page")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
<%
  }
%>
  <a href="http://biodiversity-chm.eea.europa.eu/information/database/" title="<%=cm.cms("footer_related_databases_title")%>"><%=cm.cmsPhrase("Related databases")%></a>
  <%=cm.cmsTitle("footer_related_databases_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="<%=cm.cms("footer_contact_title")%>"><%=cm.cmsPhrase("Contact EUNIS")%></a>
  <%=cm.cmsTitle("footer_contact_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="news.jsp" title="<%=cm.cms("footer_news_title")%>"><%=cm.cmsPhrase("EUNIS News")%></a>
  <%=cm.cmsTitle("footer_news_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="feedback.jsp" title="<%=cm.cms("footer_feedback_title")%>"><%=cm.cmsPhrase("EUNIS Feedback")%></a>
  <%=cm.cmsTitle("footer_feedback_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="copyright.jsp" title="<%=cm.cms("footer_copyright_title")%>"><%=cm.cmsPhrase("EUNIS Copyright and Disclaimer")%></a>
  <%=cm.cmsTitle("footer_copyright_title")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="accessibility.jsp" title="<%=cm.cms("accessibility_statement")%>" accesskey="0"><%=cm.cmsPhrase("Eunis Accessibility statement")%></a>
  <%=cm.cmsTitle("accessibility_statement")%>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
</div>
<%--<jsp:include page="digir_check.jsp" />--%>
