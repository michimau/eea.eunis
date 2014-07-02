<%@ include file="/stripes/common/taglibs.jsp"%>
<%@page import="eionet.eunis.stripes.actions.UpdateTemplateActionBean" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%= SessionManager.getWebContent().getText(UpdateTemplateActionBean.FOOTER)%>
<% if(! SessionManager.isAuthenticated()) { %>
<script type="text/javascript">
	jQuery(document).ready(function($){
		jQuery("#portal-colophon").find(".colophon-middle .colophon-links").last().find("a").first().after(' <a href="login.jsp" title="EUNIS login"><strong>EUNIS login</strong></a> ');
	});
</script>
<% } %>
