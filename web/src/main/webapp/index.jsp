<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Home page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home";
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
<%
    WebContentManagement cm = SessionManager.getWebContent();

    // If operation is logout.
    if( operation.equalsIgnoreCase( "logout" ) ){
        SessionManager.logout();
        SessionManager.setUsername(null);
        SessionManager.setPassword(null);
    }
%>
<%
String title = application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase( "Welcome to EUNIS Database" );
%>
<c:set var="title" value="<%= title%>"></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}">
    <stripes:layout-component name="head">
        <link rel="alternate" type="application/rss+xml" title="EUNIS Database latest news" href="news.xml" />
        <script language="JavaScript" src="<%=request.getContextPath()%>/script/index.js" type="text/javascript"></script>
		<meta name="description" content="EUNIS provides access to: Information on Species, Habitat types and Sites taken into account in relevant international conventions or from International Red Lists; Specific data collected in the framework of the EEA's reporting activities, which also constitute a core set of data to be updated periodically."/>
  		<style type="text/css">
			#portal-column-content #content {
			    margin-right: 0 ! important;
			}
		</style>
    </stripes:layout-component>

    <stripes:layout-component name="contents">
		<jsp:include page="header-dynamic.jsp">
			<jsp:param name="location" value="<%=btrail%>"/>
		</jsp:include>
		<a name="documentContent"></a>
		<h1 class="documentFirstHeading">
			<%=cm.cmsPhrase( "Welcome to EUNIS, the European Nature Information System - find species, habitat types and sites across Europe" )%>
		</h1>
		<div class="visualClear"><!--&nbsp; --></div>
          <div style="position: relative;height: 380px;">
			<div class="figure-right" style="display:inline; position: absolute; right:0; top:0;">
				<div class="figure">
                     <img height="350" width="216" title="" alt="<%=cm.cmsPhrase("Image from EUNIS Database photo collection regarding Species, Habitat types and Sites")%>" src="<%=request.getContextPath()%>/images/intros/<%=Utilities.getIntroImage( application )%>" />
				</div>
			</div>
			<div style="float:left; position: absolute; left:0; top:0; padding-right: 250px;">
				<!-- MAIN CONTENT -->
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
                      <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_IS%>" />
					<input type="hidden" name="searchVernacular" value="true" />
					<input type="hidden" name="searchSynonyms" value="true" />
					<input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
					<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />

					<label for="scientificName">
						<%=cm.cmsPhrase( "Species" )%>
					</label>&nbsp;
					<input title="<%=cm.cmsPhrase("Species name")%>" id="scientificName" name="scientificName" size="24" />
					<input id="search_species" type="submit" name="submit" value="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" title="<%=cm.cmsPhrase("Search species")%>" />
					<br />
					<a title="<%=cm.cmsPhrase("Go to Species search tools")%>" href="species.jsp"><%=cm.cmsPhrase("Search tools")%></a>
					<div class="search_details">
						<%=cm.cmsPhrase( "Information about species and subspecies in Europe." )%>
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
					<input type="hidden" name="fuzzySearch" value="true" />
					<input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
					<label for="searchString">
						<%=cm.cmsPhrase( "Habitat types" )%>
					</label>&nbsp;
					<input title="<%=cm.cmsPhrase("Habitat type name")%>" id="searchString" name="searchString" size="24" />
					<input id="search_habitat_types" type="submit" name="submit" value="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" title="<%=cm.cmsPhrase("Search habitat types")%>" />
					<br />	
					<a title="<%=cm.cmsPhrase("Go to Habitat types search tools")%>" href="habitats.jsp"><%=cm.cmsPhrase("Search tools")%></a>
					<div class="search_details">
						<%=cm.cmsPhrase( "Information about the EUNIS habitat types classification and Habitats Directive Annex I habitats " )%>
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
					<input type="hidden" name="DB_DIPLOMA" value="ON" />
					<%--<input type="hidden" name="DB_EMERALD" value="ON" />--%>
					<input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_CONTAINS%>" />
					<input type="hidden" name="fuzzySearch" value="true" />
					<label for="englishName">
						<%=cm.cmsPhrase( "Sites" )%>
					</label>&nbsp;
					<input title="<%=cm.cmsPhrase("Site name")%>" id="englishName" name="englishName" size="24" />
					<input id="search_sites" type="submit" name="submit" value="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" title="<%=cm.cmsPhrase( "Search sites" )%>" />
					<br />
					<a title="<%=cm.cmsPhrase("Go to Sites search tools")%>" href="sites.jsp"><%=cm.cmsPhrase("Search tools")%></a>
					<div class="search_details" style="margin-bottom: 20px;">
						<%=cm.cmsPhrase( "Information collected from various databases regarding sites" )%>
					</div>
				</form>
				<a href="combined-search.jsp"><strong><%=cm.cmsPhrase( "Combined search" )%></strong></a>
				<div class="search_details" style="margin-bottom: 20px;">
					<%=cm.cmsPhrase( "Advanced cross-search tool, linking species, habitat types and sites" )%>
				</div>
                <!-- END MAIN CONTENT -->
              </div>
          </div>
    </stripes:layout-component>
</stripes:layout-render>
