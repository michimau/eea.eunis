<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Footer page - included in almost all other pages.
--%>
<%@ page import="java.net.URLEncoder,
                 java.util.Enumeration"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
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
    var URL = "users-bookmarks-save.jsp?bookmarkURL=<%=URLEncoder.encode( bookmarkURL, "UTF-8")%>";
    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=420,height=230');");
  }
</script>
<noscript>Your browser does not support JavaScript!</noscript>
<div class="horizontal_line"><img alt="" src="images/pixel.gif" width="740" height="1" /></div>
<div style="width : 740px; text-align : center;">
  The <a href="about.jsp" class="footerLink">EUNIS Database application</a> is developed
  under <a href="http://biodiversity-chm.eea.eu.int/" class="footerLink">IDA EC CHM project</a>
  <br />
  Content maintained by the <a href="http://nature.eionet.eu.int/" class="footerLink">European Topic Centre on Biological Diversity</a>
  <br />
<%
  if ( isAuthenticated )
  {
%>
  <a href="javascript:saveBookmark();" class="footerLink" title="Bookmark this page">Bookmark</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
<%
  }
%>
  <a href="http://biodiversity-chm.eea.eu.int/information/database/" title="Other nature information sources" class="footerLink">Related databases</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="Contact site administrator" class="footerLink">Contact</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="news.jsp" class="footerLink" title="Latest news on EUNIS development">News</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="feedback.jsp" title="Send feedback on EUNIS Database" class="footerLink">Feedback</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="copyright.jsp" title="Copyright and Disclaimer information" class="footerLink">Copyright and Disclaimer</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />

  <a href="accessibility.jsp" title="Accessibility statement" class="footerLink" accesskey="0">Accessibility</a>
  <img src="images/pixel.gif" width="10" height="1" alt="" />
</div>
<jsp:include page="digir_check.jsp" />