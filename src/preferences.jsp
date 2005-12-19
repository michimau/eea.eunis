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
  WebContentManagement cm = SessionManager.getWebContent();

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
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("preferences_page_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,preferences_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("preferences_title")%>
      </h1>
      <%=cm.cmsText("generic_preferences_01")%>
      <br />
      <br />
      <form name="preferences" action="preferences.jsp" method="post">
        <input name="action" type="hidden" id="action" value="save" />
        <label for="themeIndex"><%=cm.cmsText("preferences_theme_label")%></label>
        <select id="themeIndex" name="themeIndex" title="<%=cm.cms("preferences_theme_title")%>">
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
        <%=cm.cmsLabel("preferences_theme_label")%>
        <%=cm.cmsTitle("preferences_theme_title")%>
        <%=cm.cmsInput("preferences_theme_sky_blue")%>
        <%=cm.cmsInput("preferences_theme_fresh_orange")%>
        <%=cm.cmsInput("preferences_theme_nature_green")%>
        <%=cm.cmsInput("preferences_theme_cherry")%>
        <%=cm.cmsInput("preferences_theme_bw")%>
        <br />
        <label for="submit1" class="noshow"><%=cm.cms("preferences_save_label")%></label>
        <input id="submit1" type="submit" name="Submit" value="<%=cm.cms("preferences_save_value")%>" title="<%=cm.cms("preferences_save_title")%>" class="inputTextField" />
        <%=cm.cmsLabel("preferences_save_label")%>
        <%=cm.cmsTitle("preferences_save_title")%>
        <%=cm.cmsInput("preferences_save_value")%>
      </form>

      <%=cm.cmsMsg("preferences_page_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="preferences.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>