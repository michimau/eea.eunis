<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Static part of the header
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist,
                 ro.finsiel.eunis.search.Utilities" %>
<%@ page import="ro.finsiel.eunis.session.ThemeManager" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  ThemeManager themeManager = SessionManager.getThemeManager();
  //String lightColor = (null != themeManager) ? themeManager.getLightColor() : "#669ACC";
  String mediumColor = (null != themeManager) ? themeManager.getMediumColor() : "#4478AA";
  String darkColor = (null != themeManager) ? themeManager.getDarkColor() : "#3759A3";
  String imageName = (null != themeManager) ? themeManager.getHeaderImageName() : "banner.jpg";
  String digir_url = Utilities.formatString(application.getInitParameter("DIGIR_URL"));
%>
<script type="text/javascript" language="JavaScript" src="script/utils.js"></script>
<noscript>Your browser does not support JavaScript!</noscript>
<script type="text/javascript" language="JavaScript" src="script/header.js"></script>
<noscript>Your browser does not support JavaScript!</noscript>
<a href="#main_content" style="display:none" title="Skip to main content">Skip to main content</a>
<div id="header">
<%
  List translatedLanguages = contentManagement.getTranslatedLanguages();
%>
  <form action="">
    <label for="language_international" class="noshow">Language</label>
    <select title="Select site language" id="language_international" name="language_international" onchange="changeLanguage();" class="languageTextField" disabled="disabled">
        <option value="en" selected="selected">English</option>
<%
  String selected = "";
  for(int i = 0; i < translatedLanguages.size(); i++)
  {
    Chm62edtLanguagePersist language = (Chm62edtLanguagePersist) translatedLanguages.get(i);
    if(language.getCode().equalsIgnoreCase( SessionManager.getCurrentLanguage() ) )
    {
      selected = " selected=\"selected\"";
    }
    else
    {
      selected = "";
    }
%>
        <option value="<%=language.getCode()%>"<%=selected%>>
          <%=language.getNameEn()%>
        </option>
<%
  }
%>
    </select>
  </form>
</div>
<div class="noshow">Begin main menu</div>
<div style="width : 740px;">
  <table summary="layout" border="1" cellpadding="0" cellspacing="0" class="main_menu" width="100%">
    <tr>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="index.jsp" accesskey="1" title="Home page"><%=contentManagement.getContent("generic_header-static_home")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="login.jsp" accesskey="l" title="User login"><%=contentManagement.getContent("generic_header-static_login")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a id="digir_url_link" class="menu_link" title="View DiGIR application provider information" href="<%=digir_url%>"><%=contentManagement.getContent("generic_header-static_digir")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a href="references.jsp" class="menu_link" accesskey="r" title="View references used in EUNIS"><%=contentManagement.getContent("generic_header-static_references")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="related-reports.jsp" accesskey="p" title="View and download reports on biodiversity"><%=contentManagement.getContent("generic_header-static_reports")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td colspan="3" style="padding-left : 5px; text-align : right;">
        <form action="" name="searchGoogle" id="searchGoogle" method="get" onsubmit="popSearch(); return false;">
        <label class="menu_text" for="qq"><%=contentManagement.getContent("generic_header-static_google")%></label>
        <input type="text"
               name="q"
               id="qq"
               size="15"
               class="textInputColorMain"
               title="Type the string you are searching for and press 'Enter'"
               alt="Type the string you are searching for and press 'Enter'"
               value="Search on Google"
               onfocus="javascript:document.searchGoogle.qq.select();" />
        </form>
      </td>
    </tr>
    <tr>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="species.jsp" accesskey="s" title="Species module"><%=contentManagement.getContent("generic_header-static_species")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="habitats.jsp" accesskey="h" title="Habitat types module"><%=contentManagement.getContent("generic_header-static_habitats")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="sites.jsp" accesskey="t" title="Sites module"><%=contentManagement.getContent("generic_header-static_sites")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="combined-search.jsp" accesskey="c" title="Combined search tool"><%=contentManagement.getContent("generic_header-static_combined")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="glossary.jsp" accesskey="g" title="Glossary of terms"><%=contentManagement.getContent("generic_header-static_glossary")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="eunis-map.jsp" accesskey="3" title="EUNIS navigation map"><%=contentManagement.getContent("generic_header-static_sitemap")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="gis-tool.jsp" accesskey="u" title="Interactive map server"><%=contentManagement.getContent("generic_header-static_gistool")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="about.jsp" accesskey="b" title="Information about EUNIS"><%=contentManagement.getContent("generic_header-static_about")%></a>
        <img src="images/pixel.gif" width="1" height="1" alt="" />
      </td>
    </tr>
  </table>
</div>  
<div class="noshow">End main menu</div>