<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : GIS Tool
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,gis_tool";
  %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("gis_title")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper-gis-tool">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase("Interactive map")%></h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                    <li>
                      <a href="gis-tool-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                    codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0"
                    width="740" height="552" id="fl_eunis">
                  <param name="allowScriptAccess" value="sameDomain" />
                  <param name="movie" value="gis/fl_eunis.swf" />
                  <param name="wmode" value="opaque" />
                  <param name="quality" value="high" />
                  <param name="bgcolor" value="#FFFFFF" />
                  <param name="FlashVars"  value="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_sh_sites=none&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>" />
                  <!--[if !IE]> <-->
                  <object name="fl_eunis" data="gis/fl_eunis.swf"
                          width="740" height="552" type="application/x-shockwave-flash">
                    <param name="quality" value="high" />
                    <param name="bgcolor" value="#FFFFFF" />
                    <param name="FlashVars"  value="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_sh_sites=none&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>" />
                    <param name="pluginurl" value="http://www.macromedia.com/go/getflashplayer" />
                    <!--> <![endif]-->
                    <div style="width:740px; height:552px; overflow:auto">
                     <h3>Adobe Flash Player needed</h3>
                     <p>
                     The interactive GIS tool is built with Adobe Flash Player. If you don't have 
                     this in your browser, then this tool can't launch.
                     </p>
                     <p>
                     We encourage you to visit all the other pages of the EUNIS website.
                     </p>
                    </div>
                    <!--[if !IE]> <-->
                  </object>
                  <!--> <![endif]-->
                </object>
                <%=cm.cmsMsg("gis_title")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="gis-tool.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
