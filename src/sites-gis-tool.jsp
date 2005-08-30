<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Page displaying the GIS tool
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String sites = Utilities.formatString( request.getParameter( "sites" ), "" );
  if ( sites.equalsIgnoreCase( "") )
  {
    sites = "none";
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  </head>
  <body style="margin : 0px; padding : 0px;" >
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="740" height="552" id="fl_eunis" align="middle">
      <param name="allowScriptAccess" value="sameDomain" />
      <param name="movie" value="gis/fl_eunis.swf" />
      <param name="quality" value="high" />
      <param name="bgcolor" value="#FFFFFF" />
      <param name="FlashVars"  value="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>&amp;v_sh_sites=<%=sites%>" />
      <embed src="gis/fl_eunis.swf" FLASHVARS="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>&amp;v_sh_sites=<%=sites%>" quality="high" bgcolor="#FFFFFF"  width="740" height="552" name="fl_eunis" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>
  </body>
</html>