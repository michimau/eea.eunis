<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'User preferences' function.
--%>
<%@page import="java.util.*,
                ro.finsiel.eunis.jrfTables.users.UserPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.session.ThemeManager,
                ro.finsiel.eunis.session.ThemeWrapper,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist"%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();

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
      <%=application.getInitParameter("PAGE_TITLE")%>Application Preferences
    </title>
  </head>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Preferences"/>
    </jsp:include>
    <h5>
      Preferences
    </h5>
    <%=contentManagement.getContent("generic_preferences_01")%>
    <br />
    <br />
    <form name="preferences" action="preferences.jsp" method="post">
      <input name="action" type="hidden" id="action" value="save" />
        <label for="themeIndex">Web page theme color</label>
        <select id="themeIndex" name="themeIndex" title="Web page theme color">
          <option value="<%=ThemeManager.THEME_SKY_BLUE%>"
            <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.SKY_BLUE ) ? "selected=\"selected\"" : ""%>>
            Sky blue
          </option>
          <option value="<%=ThemeManager.THEME_FRESH_ORANGE%>"
            <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.FRESH_ORANGE ) ? "selected=\"selected\"" : ""%>>
            Fresh orange
          </option>
          <option value="<%=ThemeManager.THEME_NATURE_GREEN%>"
            <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.NATURE_GREEN ) ? "selected=\"selected\"" : ""%>>
            Nature green
          </option>
          <option value="<%=ThemeManager.THEME_CHERRY%>"
            <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.CHERRY ) ? "selected=\"selected\"" : ""%>>
            Cherry
          </option>
          <option value="<%=ThemeManager.THEME_BLACKWHITE%>"
            <%=SessionManager.getThemeManager().getCurrentTheme().equals( ThemeManager.BLACKWHITE ) ? "selected=\"selected\"" : ""%>>
            High contrast
          </option>
        </select>
        <br />
        <br />
<%
        List translatedLanguages = contentManagement.getTranslatedLanguages();
%>
        <label for="language_international1">Language</label>
        <select id="language_international1" title="Language" name="language_international" class="inputTextField" disabled="disabled">
          <option value="en">English</option>
<%
        String selected;
        for ( int i = 0; i < translatedLanguages.size(); i++ )
        {
          Chm62edtLanguagePersist language = ( Chm62edtLanguagePersist )translatedLanguages.get( i );
          if ( language.getCode().equalsIgnoreCase( SessionManager.getCurrentLanguage() ) )
          {
            selected = "selected=\"selected\"";
          }
          else
          {
            selected = "";
          }
%>
          <option value="<%=language.getCode()%>" <%=selected%>>
            <%=language.getNameEn()%>
          </option>
<%
        }
%>
        </select>
        <br />
        <br />
        <label for="Submit" class="noshow">Save Preferences</label>
        <input type="submit" name="Submit" id="Submit" value="Save Preferences" title="Save Preferences" class="inputTextField" />
      </form>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="preferences.jsp" />
      </jsp:include>
    </div>
  </body>
</html>