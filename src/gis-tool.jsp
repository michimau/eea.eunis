<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : GIS Tool
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>Eunis Database Interactive Map Browser
    </title>
  </head>
  <body>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,GIS Tool"/>
      <jsp:param name="helpLink" value="gis-tool-help.jsp"/>
    </jsp:include>
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="740" height="552" id="fl_eunis" align="middle">
      <param name="allowScriptAccess" value="sameDomain" />
      <param name="movie" value="gis/fl_eunis.swf" />
      <param name="quality" value="high" />
      <param name="bgcolor" value="#FFFFFF" />
      <param name="FlashVars"  value="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_sh_sites=none&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>" />
      <embed src="gis/fl_eunis.swf" flashvars="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_sh_sites=none&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>" quality="high" bgcolor="#FFFFFF"  width="740" height="552" name="fl_eunis" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="gis-tool-help.jsp" />
    </jsp:include>
  </body>
</html>
<%
  out.flush();
%>