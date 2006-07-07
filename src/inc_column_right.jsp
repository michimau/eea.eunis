<%@ page import="ro.finsiel.eunis.search.Utilities, ro.finsiel.eunis.WebContentManagement" %>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<div class="thumbnail-right">
  <img height="350" width="216" title="" alt="<%=cm.cms("index_photo_alt")%>" src="images/intros/<%=Utilities.getIntroImage( application )%>" />
</div>
