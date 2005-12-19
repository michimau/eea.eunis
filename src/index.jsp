<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Home page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                ro.finsiel.eunis.search.AbstractSortCriteria,
                ro.finsiel.eunis.search.Utilities, ro.finsiel.eunis.search.species.names.NameSortCriteria,
                ro.finsiel.eunis.utilities.SQLUtilities" %>
<%@ page import="java.sql.*"%>
<%@ page import="ro.finsiel.eunis.session.ThemeWrapper"%>
<%@ page import="ro.finsiel.eunis.session.ThemeManager"%>
<%@ page import="ro.finsiel.eunis.jrfTables.users.UserPersist"%>
<%@ page import="ro.finsiel.eunis.jrfTables.users.UserDomain"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  String operation = Utilities.formatString( request.getParameter("operation"), "" );
  if( operation.equalsIgnoreCase( "changeLanguage" ) )
  {
    String language = Utilities.formatString( request.getParameter( "language_international" ), "en" );
    SessionManager.setCurrentLanguage( language );

    // If user is authenticated then save it's preferences within the database.
    if ( SessionManager.isAuthenticated() )
    {
      UserPersist usr = SessionManager.getUserPrefs();
      usr.setLang( language );
      usr.markModifiedPersistentState();
      try
      {
        new UserDomain().save( usr );
      }
      catch( Exception ex )
      {
        System.out.println( "Could not save user language preference." + ex.getLocalizedMessage() );
      }
    }
  }

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  try
  {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      String SQL="SELECT COUNT(*) from eunis_web_content";
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      rs.next();
      if (rs.getInt(1) == 0)
      {
        throw new Exception("Warning! Table eunis_web_content has 0 rows.");
      }

  } catch (Exception e)
  {
    e.printStackTrace();
%>
    <jsp:include page="database-error.jsp" />
<%
    return;
  } finally
    {
       try
       {
         if(rs != null)
           rs.close();
         if(ps != null)
         ps.close();
         if(con != null)
         con.close();
       } catch (Exception e) {}
     }
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <link rel="alternate" type="application/rss+xml" title="EUNIS Database latest news" href="news.xml" />
<%
  WebContentManagement cm = SessionManager.getWebContent();

  // If operation is logout.
  if( operation.equalsIgnoreCase( "logout" ) )
  {
    SessionManager.logout();
    SessionManager.setUsername(null);
    SessionManager.setPassword(null);
  }
  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
  String sqlHeadline = "select content from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
  String headline = sqlc.ExecuteSQL(sqlHeadline);

  String magnifyIMG;
  String compassIMG;
  ThemeWrapper currentTheme = SessionManager.getThemeManager().getCurrentTheme();
  if ( currentTheme.equals( ThemeManager.FRESH_ORANGE ) )
  {
    magnifyIMG = "magnify_orange.gif";
    compassIMG = "compass_orange.jpg";
  }
  else if ( currentTheme.equals( ThemeManager.NATURE_GREEN ) )
  {
    magnifyIMG = "magnify_green.gif";
    compassIMG = "compass_green.jpg";
  }
  else if ( currentTheme.equals( ThemeManager.CHERRY ) )
  {
    magnifyIMG = "magnify_cherry.gif";
    compassIMG = "compass_cherry.jpg";
  }
  else if ( currentTheme.equals( ThemeManager.BLACKWHITE ) )
  {
    magnifyIMG = "magnify_bw.gif";
    compassIMG = "compass_bw.jpg";
  }
  else
  {
    magnifyIMG = "magnify.gif";
    compassIMG = "compass.jpg";
  }
%>
  <script language="JavaScript" src="script/index.js" type="text/javascript"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms( "generic_index_title" )%>
  </title>
  </head>
  <body>
    <center>
    <div id="bodydiv2">
      <div id="container">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location"/>
    </jsp:include>
    <%=cm.cmsText("headline")%>
      <div id="leftnav">
        <div class="mainlabel180_1">
          <strong>
          <%=cm.cmsText( "generic_index_01" )%>
          </strong>
        </div>
        <ul>
          <li>
            <a title="<%=cm.cms("generic_index_02_title")%>" href="introduction.jsp"><%=cm.cmsText( "generic_index_02" )%></a><%=cm.cmsTitle("generic_index_02")%>
          </li>
          <li>
            <a title="<%=cm.cms("generic_index_03_title")%>" href="about.jsp"><%=cm.cmsText( "generic_index_03" )%></a><%=cm.cmsTitle("generic_index_03_title")%>
          </li>
          <li>
            <a title="<%=cm.cms("generic_index_04_title")%>" href="howto.jsp"><%=cm.cmsText( "generic_index_04" )%></a><%=cm.cmsTitle("generic_index_04_title")%>
          </li>
          <li>
            <a title="<%=cm.cms("generic_index_05_title")%>" href="eunis-map.jsp"><%=cm.cmsText( "generic_index_05" )%></a><%=cm.cmsTitle("generic_index_05_title")%>
          </li>
          <li>
            <img src="images/mini/help.jpg" border="0" width="13" height="16" align="middle" alt="<%=cm.cms("generic_index_tutorials_alt")%>" /><%=cm.cmsAlt("generic_index_tutorials_alt")%>
            <a title="<%=cm.cms("generic_index_tutorials_title")%>" href="tutorials.jsp"><%=cm.cmsText( "generic_index_tutorials" )%></a><%=cm.cmsTitle("generic_index_tutorials_title")%>
          </li>
          <li>
            <a title="<%=cm.cms("generic_index_news_title")%>" href="news.jsp"><%=cm.cmsText( "generic_index_news" )%></a><%=cm.cmsTitle("generic_index_news_title")%>
          </li>
        </ul>
        <div class="between"></div>
        <div class="mainlabel180_1">
          <strong>
            <%=cm.cmsText("user_preferences")%>
          </strong>
        </div>
       <ul>
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
          <li>
            <a href="index.jsp?operation=logout" title="<%=cm.cms("generic_index_08_title")%>"><%=cm.cmsText( "generic_index_08" )%></a><%=cm.cmsTitle("generic_index_08_title")%>
            (<strong><%=SessionManager.getUsername()%></strong>)
          </li>
<%
  }
  else
  {
%>
          <li>
            <a href="login.jsp" title="<%=cm.cms("generic_index_11_title")%>"><%=cm.cmsText( "generic_index_11" )%></a><%=cm.cmsTitle("generic_index_11_title")%>
          </li>
<%
  }
%>
          <li>
            <a title="<%=cm.cms("generic_index_09_title")%>" href="services.jsp"><%=cm.cmsText( "generic_index_09" )%></a><%=cm.cmsTitle("generic_index_09_title")%>
            <br />
            <%=cm.cmsText( "generic_index_10" )%>
          </li>
          <li>
            <a title="<%=cm.cms("generic_index_13_title")%>" href="preferences.jsp"><%=cm.cmsText("generic_index_13")%></a><%=cm.cmsTitle("generic_index_13_title")%>
            <br />
            <%=cm.cmsText("generic_index_14")%>
          </li>
        </ul>
        <div class="between"></div>
      </div>
      <div id="content_index">
        <div id="mainlabel250">
          <strong>
            <%=cm.cmsText( "generic_index_06" )%>
          </strong>
          <br />
        </div>
        <form name="species_qs" action="species-names-result.jsp" method="post" onsubmit="return validateQS( 'species' ); ">
          <input type="hidden" name="comeFromQuickSearch" value="true" />
          <input type="hidden" name="showGroup" value="true" />
          <input type="hidden" name="showOrder" value="true" />
          <input type="hidden" name="showFamily" value="true" />
          <input type="hidden" name="showScientificName" value="true" />
          <input type="hidden" name="showVernacularNames" value="true" />
          <input type="hidden" name="showValidName" value="true" />
          <input type="hidden" name="showOtherInfo" value="true" />
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
          <input type="hidden" name="searchVernacular" value="true" />
          <input type="hidden" name="searchSynonyms" value="true" />
          <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
          <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
          <div class="search_style">
            <label for="scientificName" class="noshow"><%=cm.cms("index_species_name_label")%></label>
            <input title="Species name" id="scientificName" name="scientificName" class="textInputColorMain" size="24" />
            <%=cm.cmsLabel("index_species_name_label")%>
            <label for="search_species" class="noshow"><%=cm.cms("index_search_species_label")%></label>
            <input id="search_species" name="search_species" type="image" title="<%=cm.cms("index_search_species_title")%>" src="images/<%=magnifyIMG%>" alt="<%=cm.cms("index_search_species_alt")%>" align="top" style="margin-top:1px;" />
            <%=cm.cmsLabel("index_search_species_label")%>
            <%=cm.cmsTitle("index_search_species_title")%>
            <%=cm.cmsAlt("index_search_species_alt")%>
          </div>
          <!--<a title="Go to Species module" href="species.jsp"><%=cm.cmsText( "generic_index_15" )%></a>&nbsp;-->
          <strong><%=cm.cmsText( "generic_index_15" )%></strong>&nbsp;
          <br /><br />
          <a title="<%=cm.cms("index_species_search_tools_title")%>" href="species.jsp"><%=cm.cmsText("index_species_search_tools")%></a><%=cm.cmsTitle("index_species_search_tools_title")%>
          <div class="search_details">
            <%=cm.cmsText( "generic_index_16" )%>
          </div>
        </form>
        <span class="separator"></span>
        <form name="habitats_qs" action="habitats-names-result.jsp" method="post" onsubmit="return validateQS( 'habitats' );">
          <input type="hidden" name="showLevel" value="true" />
          <input type="hidden" name="showCode" value="true" />
          <input type="hidden" name="showScientificName" value="true" />
          <input type="hidden" name="showVernacularName" value="true" />
          <input type="hidden" name="showOtherInfo" value="true" />
          <input type="hidden" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
          <input type="hidden" name="useScientific" value="true" />
          <input type="hidden" name="useVernacular" value="true" />
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
          <div class="search_style">
            <label for="searchString" class="noshow"><%=cm.cms("index_habitat_type_name_label")%></label>
            <input title="<%=cm.cms("index_habitat_type_name_title")%>" id="searchString" name="searchString" class="textInputColorMain" size="24" />
            <%=cm.cmsLabel("index_habitat_type_name_label")%>
            <%=cm.cmsTitle("index_habitat_type_name_title")%>

            <label for="search_habitat_types" class="noshow"><%=cm.cms("index_search_habitats_label")%></label>
            <input type="image" src="images/<%=magnifyIMG%>" id="search_habitat_types" name="search_habitat_types" alt="<%=cm.cms("index_search_habitats_alt")%>" title="<%=cm.cms("index_search_habitats_title")%>" align="top" style="margin-top:1px;" />
            <%=cm.cmsLabel("index_search_habitats_label")%>
            <%=cm.cmsAlt("index_search_habitats_alt")%>
            <%=cm.cmsTitle("index_search_habitats_title")%>
          </div>
          <!--<a href="habitats.jsp" title="Go to Habitat types module"><%=cm.cmsText( "generic_index_17" )%></a>&nbsp;-->
          <strong><%=cm.cmsText( "generic_index_17" )%></strong>&nbsp;
          <br /><br />
          <a title="<%=cm.cms("index_habitats_search_tools_title")%>" href="habitats.jsp"><%=cm.cms("index_habitats_search_tools")%></a>
          <%=cm.cmsTitle("index_habitats_search_tools_title")%>
          <div class="search_details">
            <%=cm.cmsText( "generic_index_18" )%>
          </div>
        </form>
        <span class="separator"></span>
        <form name="sites_qs" action="sites-names-result.jsp" method="post" onsubmit="return validateQS( 'sites' );">
          <input type="hidden" name="showSourceDB" value="true" />
          <input type="hidden" name="showCountry" value="true" />
          <input type="hidden" name="showDesignationTypes" value="true" />
          <input type="hidden" name="showName" value="true" />
          <input type="hidden" name="showCoordinates" value="true" />
          <input type="hidden" name="showSize" value="true" />
          <input type="hidden" name="showDesignationYear" value="true" />
          <input type="hidden" name="sort" value="<%=ro.finsiel.eunis.search.sites.names.NameSortCriteria.SORT_NAME%>" />
          <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
          <input type="hidden" name="DB_NATURA2000" value="ON" />
          <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
          <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
          <input type="hidden" name="DB_DIPLOMA" value="ON" />
          <input type="hidden" name="DB_CDDA_INTERNATIONAL" value="ON" />
          <input type="hidden" name="DB_CORINE" value="ON" />
          <input type="hidden" name="DB_BIOGENETIC" value="ON" />
          <input type="hidden" name="DB_EMERALD" value="ON" />
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
          <div class="search_style">
            <label for="englishName" class="noshow"><%=cm.cms("index_site_name_label")%></label>
            <input title="<%=cm.cms("index_site_name_title")%>" id="englishName" name="englishName" class="textInputColorMain" size="24" />
            <%=cm.cmsLabel("index_site_name_label")%>
            <%=cm.cmsTitle("index_site_name_title")%>
            <label for="search_sites" class="noshow"><%=cm.cms("index_search_sites_label")%></label>
            <input type="image" id="search_sites" name="search_sites" alt="Search sites" title="Search sites" src="images/<%=magnifyIMG%>" align="top" style="margin-top:1px;" />
            <%=cm.cmsLabel("index_search_sites_label")%>
          </div>
          <!--<a href="sites.jsp" title="Go to Sites module"><%=cm.cmsText( "generic_index_19" )%></a>&nbsp;-->
          <strong><%=cm.cmsText( "generic_index_19" )%></strong>&nbsp;
          <br /><br />
          <a title="<%=cm.cms("index_sites_search_tools_title")%>" href="sites.jsp"><%=cm.cms("index_sites_search_tools")%></a>
          <%=cm.cmsTitle("index_sites_search_tools_title")%>
          <div class="search_details" style="margin-bottom: 40px;">
            <%=cm.cmsText( "generic_index_20" )%>
          </div>
        </form>
        <a href="combined-search.jsp" title="<%=cm.cms("generic_index_21_title")%>"><%=cm.cmsText( "generic_index_21" )%></a>
        <%=cm.cmsTitle("generic_index_21_title")%>
        <div class="search_details" style="margin-bottom: 40px;">
          <%=cm.cmsText( "generic_index_22" )%>
        </div>
        <a href="gis-tool.jsp" title="<%=cm.cms("generic_index_27_title")%>"><%=cm.cmsText( "generic_index_27" )%></a>
        <%=cm.cmsTitle("generic_index_27_title")%>
        &nbsp;
        <a href="gis-tool.jsp" title="<%=cm.cms("index_gis_tool_title")%>"><img src="images/<%=compassIMG%>" width="29" height="29" style="width : 29px; height : 29px; border : 0px; vertical-align : middle;" alt="<%=cm.cms("index_gis_tool_title")%>" title="<%=cm.cms("index_gis_tool_title")%>" /></a>
        <%=cm.cmsTitle("index_gis_tool_title")%>
        <br />
        <%=cm.cms("generic_index_maps")%>
      </div>
      <div id="rightnav">
        <div class="imageprint">
          <img height="350" width="216" title="" alt="<%=cm.cms("index_photo_alt")%>" src="images/intros/<%=Utilities.getIntroImage( application )%>" align="middle" />
        </div>
      </div>
      <%=cm.cmsMsg("generic_index_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="index.jsp" />
      </jsp:include>
        </div>
      </div>
    </center>
  </body>
</html>