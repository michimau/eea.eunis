<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Home page
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                ro.finsiel.eunis.search.AbstractSortCriteria,
                ro.finsiel.eunis.search.Utilities, ro.finsiel.eunis.search.species.names.NameSortCriteria,
                ro.finsiel.eunis.utilities.SQLUtilities" %>
<%@ page import="java.sql.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  Connection con;
  PreparedStatement ps;
  ResultSet rs;

  try
  {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      String SQL="SELECT COUNT(*) from eunis_web_content";
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      if (rs.next())
      {
        rs.close();
        ps.close();
        con.close();
      }

  } catch (Exception e) {
    e.printStackTrace();
%>
    <jsp:include page="database-error.jsp" />
<%
    return;
  }
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <link rel="alternate" type="application/rss+xml" title="EUNIS Database latest news" href="news.xml" />
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  String operation = Utilities.formatString( request.getParameter("operation"), "" );
  // If operation is logout.
  if( operation.equalsIgnoreCase( "logout" ) )
  {
    SessionManager.logout();
    SessionManager.setUsername(null);
    SessionManager.setPassword(null);
  }
  if( operation.equalsIgnoreCase( "changeLanguage" ) )
  {
    String language = Utilities.formatString( request.getParameter( "language_international" ), "en" );
    SessionManager.setCurrentLanguage( language );
  }
  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
  String sqlHeadline = "select content from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
  String headline = sqlc.ExecuteSQL(sqlHeadline);
%>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/index.js" type="text/javascript"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent( "generic_index_title", false )%>
  </title>
  </head>
  <body>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home"/>
    </jsp:include>
    <%=headline%>
    <br />
    <div id="container">
      <div id="leftnav">
        <div class="mainlabel180_1">
          <strong>
          <%=contentManagement.getContent( "generic_index_01" )%>
          </strong>
        </div>
        <ul>
          <li>
            <a title="Introduction to EUNIS Database" href="introduction.jsp"><%=contentManagement.getContent( "generic_index_02" )%></a>
          </li>
          <li>
            <a title="Information on EUNIS Database" href="about.jsp"><%=contentManagement.getContent( "generic_index_03" )%></a>
          </li>
          <li>
            <a title="Help on using EUNIS database" href="howto.jsp"><%=contentManagement.getContent( "generic_index_04" )%></a>
          </li>
          <li>
            <a title="Web site map" href="eunis-map.jsp"><%=contentManagement.getContent( "generic_index_05" )%></a>
          </li>
          <li>
            <img src="images/mini/help.jpg" border="0" width="13" height="16" align="middle" alt="Tutorials"/>&nbsp;<a title="EUNIS Database animated tutorials" href="tutorials.jsp"><%=contentManagement.getContent( "generic_index_tutorials" )%></a>
          </li>
          <li>
            <a title="EUNIS Database latest news" href="news.jsp"><%=contentManagement.getContent( "generic_index_news" )%></a>
          </li>
        </ul>
        <div class="between"></div>
        <div class="mainlabel180_1">
          <strong>
            User preferences
          </strong>
        </div>
       <ul>
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
          <li>
            <a href="index.jsp?operation=logout" title="Logout"><%=contentManagement.getContent( "generic_index_08" )%></a>
            <%--<%=contentManagement.getContent( "generic_index_07" )%>--%>
            (<strong><%=SessionManager.getUsername()%></strong>)
          </li>
<%
  }
  else
  {
%>
          <li>
            <a href="login.jsp" title="Login"><%=contentManagement.getContent( "generic_index_11" )%></a>
          </li>
<%
  }
%>
          <li>
            <a title="EUNIS Database special features" href="services.jsp"><%=contentManagement.getContent( "generic_index_09" )%></a>
            <br />
            <%=contentManagement.getContent( "generic_index_10" )%>
          </li>
          <li>
            <a title="User preferences" href="preferences.jsp"><%=contentManagement.getContent("generic_index_13")%></a>
            <br />
            <%=contentManagement.getContent("generic_index_14")%>
          </li>
        </ul>
        <div class="between"></div>
      </div>
      <div id="content_index">
        <div id="mainlabel250">
          <strong>
            <%=contentManagement.getContent( "generic_index_06" )%>
          </strong>
        </div>
        <form name="species_qs" action="species-names-result.jsp" method="post" onsubmit="return validateQS( 'species' ); ">
          <input type="hidden" name="showGroup" value="true" />
          <input type="hidden" name="showOrder" value="true" />
          <input type="hidden" name="showFamily" value="true" />
          <input type="hidden" name="showScientificName" value="true" />
          <input type="hidden" name="showVernacularNames" value="true" />
          <input type="hidden" name="showValidName" value="true" />
          <input type="hidden" name="showOtherInfo" value="true" />
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
          <input type="hidden" name="searchVernacular" value="true" />
          <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
          <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
          <div class="search_style">
            <label for="scientificName" class="noshow">Species name</label>
            <input title="Species name" id="scientificName" name="scientificName" class="textInputColorMain" size="24" />

            <label for="search_species" class="noshow">Search species</label>
            <input id="search_species" name="search_species" type="image" title="Search species" src="images/magnify.gif" alt="Search species" align="top" style="margin-top:1px;"  />
          </div>
          <a title="Go to Species module" href="species.jsp"><%=contentManagement.getContent( "generic_index_15" )%></a>&nbsp;
          <div class="search_details">
            <%=contentManagement.getContent( "generic_index_16" )%>
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
            <label for="searchString" class="noshow">Habitat type name</label>
            <input title="Habitat type name" id="searchString" name="searchString" class="textInputColorMain" size="24" />

            <label for="search_habitat_types" class="noshow">Search habitat types</label>
            <input type="image" src="images/magnify.gif" id="search_habitat_types" name="search_habitat_types" alt="Search habitat types" title="Search habitat types" align="top" style="margin-top:1px;" />
          </div>
          <a href="habitats.jsp" title="Go to Habitat types module"><%=contentManagement.getContent( "generic_index_17" )%></a>&nbsp;
          <div class="search_details">
            <%=contentManagement.getContent( "generic_index_18" )%>
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
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
          <div class="search_style">
            <label for="englishName" class="noshow">Site name</label>
            <input title="Site name" id="englishName" name="englishName" class="textInputColorMain" size="24" />
            <label for="search_sites" class="noshow">Search sites</label>
            <input type="image" id="search_sites" name="search_sites" alt="Search sites" title="Search sites" src="images/magnify.gif" align="top" style="margin-top:1px;" />
          </div>
          <a href="sites.jsp" title="Go to Sites module"><%=contentManagement.getContent( "generic_index_19" )%></a>&nbsp;
          <div class="search_details" style="margin-bottom: 40px;">
            <%=contentManagement.getContent( "generic_index_20" )%>
          </div>
        </form>
        <a href="combined-search.jsp" title="Go to Combined search"><%=contentManagement.getContent( "generic_index_21" )%></a>
        <div class="search_details" style="margin-bottom: 40px;">
          <%=contentManagement.getContent( "generic_index_22" )%>
        </div>
        <a href="gis-tool.jsp" title="GIS Tool - Interactive maps"><%=contentManagement.getContent( "generic_index_27" )%></a>
        &nbsp;
        <a href="gis-tool.jsp" title="GIS Tool - Interactive maps"><img src="images/compass.jpg" style="width : 29px; height : 29px; border : 0px; vertical-align : middle;" alt="" title="GIS Tool - Interactive maps" /></a>
      </div>
      <div id="rightnav">
        <img height="350" width="216" title="" alt="Image from EUNIS Database photo collection regarding Species, Habitat types and Sites" src="images/intros/<%=Utilities.getIntroImage( application )%>" align="middle" />
      </div>
    </div>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="index.jsp" />
    </jsp:include>
  </body>
</html>