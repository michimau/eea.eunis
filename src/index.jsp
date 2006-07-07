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
    <%=cm.cms( "welcome_to_eunis_database" )%>
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
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value=""/>
                </jsp:include>
                <%=cm.cmsText("generic_index_07")%>
                <h1>
                  <%=cm.cmsText( "generic_index_06" )%>
                </h1>
                <br />
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

                  <label for="scientificName" class="noshow">
                    <%=cm.cms("species_name")%>
                  </label>
                  <strong>
                    <%=cm.cmsText( "species" )%>
                  </strong>&nbsp;
                  <input title="Species name" id="scientificName" name="scientificName" size="24" />
                  <input id="search_species" type="submit" name="submit" value="<%=cm.cms("search")%>" class="searchButton" />
                  <%=cm.cmsLabel("species_name")%>

                  <label for="search_species" class="noshow"><%=cm.cms("search_species")%></label>
                  <br />
                  <a title="<%=cm.cms("index_species_search_tools_title")%>" href="species.jsp"><%=cm.cmsText("search_tools")%></a><%=cm.cmsTitle("index_species_search_tools_title")%>
                  <div class="search_details">
                    <%=cm.cmsText( "generic_index_16" )%>
                  </div>
                </form>
                <br />
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
                  <label for="searchString" class="noshow">
                    <%=cm.cms("habitat_type_name")%>
                  </label>
                  <strong>
                    <%=cm.cmsText( "habitat_types" )%>
                  </strong>&nbsp;
                  <input title="<%=cm.cms("habitat_type_name")%>" id="searchString" name="searchString" size="24" />
                  <%=cm.cmsLabel("habitat_type_name")%>
                  <%=cm.cmsTitle("habitat_type_name")%>
                  <input id="search_habitat_types" type="submit" name="submit" value="<%=cm.cms("search")%>" class="searchButton" />

                  <label for="search_habitat_types" class="noshow"><%=cm.cms("search_habitat_type")%></label>
                  <br />
                  <a title="<%=cm.cms("index_habitats_search_tools_title")%>" href="habitats.jsp"><%=cm.cms("search_tools")%></a>
                  <%=cm.cmsTitle("index_habitats_search_tools_title")%>
                  <div class="search_details">
                    <%=cm.cmsText( "information_about_habitats" )%>
                  </div>
                </form>
                <br />
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
                  <label for="englishName" class="noshow">
                    <%=cm.cms("site_name")%>
                  </label>
                  <strong>
                    <%=cm.cmsText( "sites" )%>
                  </strong>&nbsp;
                  <input title="<%=cm.cms("site_name")%>" id="englishName" name="englishName" size="24" />
                  <%=cm.cmsLabel("site_name")%>
                  <%=cm.cmsTitle("site_name")%>
                  <input id="search_sites" type="submit" name="submit" value="<%=cm.cms("search")%>" class="searchButton" />
                  <br />
                  <a title="<%=cm.cms("index_sites_search_tools_title")%>" href="sites.jsp"><%=cm.cms("search_tools")%></a>
                  <%=cm.cmsTitle("index_sites_search_tools_title")%>
                  <div class="search_details" style="margin-bottom: 20px;">
                    <%=cm.cmsText( "information_collected_from_various_databases" )%>
                  </div>
                </form>
                <a href="combined-search.jsp" title="<%=cm.cms("generic_index_21_title")%>"><%=cm.cmsText( "generic_index_21" )%></a>
                <%=cm.cmsTitle("generic_index_21_title")%>
                <div class="search_details" style="margin-bottom: 20px;">
                  <%=cm.cmsText( "advanced_crosssearch_tool_linking_species_habitats_sites" )%>
                </div>
                <a href="gis-tool.jsp" title="<%=cm.cms("gis_tool_interactive_maps")%>"><%=cm.cmsText( "generic_index_27" )%></a>
                <%=cm.cmsTitle("gis_tool_interactive_maps")%>
                &nbsp;
                <a href="gis-tool.jsp" title="<%=cm.cms("gis_tool_interactive_maps")%>"><img src="images/<%=compassIMG%>" width="29" height="29" style="width : 29px; height : 29px; border : 0px; vertical-align : middle;" alt="<%=cm.cms("gis_tool_interactive_maps")%>" title="<%=cm.cms("gis_tool_interactive_maps")%>" /></a>
                <%=cm.cmsTitle("gis_tool_interactive_maps")%>
                <br />
                <%=cm.cms("generic_index_maps")%>
                <%=cm.cmsMsg("welcome_to_eunis_database")%>
                <br />
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="index.jsp" />
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
