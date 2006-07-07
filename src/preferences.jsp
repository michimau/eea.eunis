<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'User preferences' function.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.session.ThemeManager,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.UserPrefsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<%
  /// REQUEST PARAMETERS
  /// * action - What to do. Possible values: 'save' (save preferences) or nothing and shows the page...
  /// * textsize - Text size. Size of the text
  /// * themeIndex - Which theme to use
  String action = FormBean.getAction();
  int themeIndex = Utilities.checkedStringToInt(FormBean.getThemeIndex(), 0);

  if ( action.equals( "save" ) )
  {
    SessionManager.setThemeIndex( themeIndex );
    SessionManager.saveUserPreferences();
    String language = Utilities.formatString( request.getParameter( "language_international" ), "en" );
    SessionManager.setCurrentLanguage( language );
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("preferences_page_title")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getHeader?site=eunis" )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,preferences"/>
                </jsp:include>
                <h1>
                  <%=cm.cmsText("preferences")%>
                </h1>
                <%=cm.cmsText("generic_preferences_01")%>
                <br />
                <br />
                <form name="preferences" action="preferences.jsp" method="post">
                  <input name="action" type="hidden" id="action" value="save" />
                  <label for="themeIndex"><%=cm.cmsText("web_page_theme_color")%></label>
                  <select id="themeIndex" name="themeIndex" title="<%=cm.cms("web_page_theme_color")%>">
                    <option value="<%=ThemeManager.THEME_SKY_BLUE%>"
                      <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.SKY_BLUE ) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("preferences_theme_sky_blue")%>
                    </option>
                    <option value="<%=ThemeManager.THEME_FRESH_ORANGE%>"
                      <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.FRESH_ORANGE ) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("preferences_theme_fresh_orange")%>
                    </option>
                    <option value="<%=ThemeManager.THEME_NATURE_GREEN%>"
                      <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.NATURE_GREEN ) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("preferences_theme_nature_green")%>
                    </option>
                    <option value="<%=ThemeManager.THEME_CHERRY%>"
                      <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.CHERRY ) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("preferences_theme_cherry")%>
                    </option>
                    <option value="<%=ThemeManager.THEME_BLACKWHITE%>"
                      <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.BLACKWHITE ) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("preferences_theme_bw")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("web_page_theme_color")%>
                  <%=cm.cmsTitle("web_page_theme_color")%>
                  <%=cm.cmsInput("preferences_theme_sky_blue")%>
                  <%=cm.cmsInput("preferences_theme_fresh_orange")%>
                  <%=cm.cmsInput("preferences_theme_nature_green")%>
                  <%=cm.cmsInput("preferences_theme_cherry")%>
                  <%=cm.cmsInput("preferences_theme_bw")%>
                  <br />
                  <input id="submit1" type="submit" name="Submit" value="<%=cm.cms("save_preferences")%>" title="<%=cm.cms("save_preferences")%>" class="searchButton" />
                  <%=cm.cmsTitle("save_preferences")%>
                  <%=cm.cmsInput("save_preferences")%>
                </form>

                <%=cm.cmsMsg("preferences_page_title")%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="preferences.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getFooter?site=eunis" )%>
    </div>
  </body>
</html>
