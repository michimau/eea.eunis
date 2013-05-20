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
<!DOCTYPE html>
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
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
    <head>
        <base href="${actionBean.context.domainName}/${base}"/>
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
        %>
          <script language="JavaScript" src="<%=request.getContextPath()%>/script/index.js" type="text/javascript"></script>
          <title>
            <%=application.getInitParameter("PAGE_TITLE")%>
            <%=cm.cmsPhrase( "Welcome to EUNIS Database" )%>
          </title>
<meta name="description" content="EUNIS provides access to: Information on Species, Habitat types and Sites taken into account in relevant international conventions or from International Red Lists; Specific data collected in the framework of the EEA's reporting activities, which also constitute a core set of data to be updated periodically."/>
          <style type="text/css">
            #portal-column-content #content {
                margin-right: 0 ! important;
            }
        </style>
      </head>
      <body>
        <jsp:include page="header.jsp" />
        <div id="visual-portal-wrapper">
              <!-- The wrapper div. It contains the three columns. -->
              <div id="portal-columns">
                        <div id="content" class="column-area">
                                <jsp:include page="header-dynamic.jsp">
                                    <jsp:param name="location" value="<%=btrail%>"/>
                                </jsp:include>
                                  <a name="documentContent"></a>
                                      <h1 class="documentFirstHeading">
                                          <%=cm.cmsPhrase( "Welcome to EUNIS biodiversity database - find species, habitats and sites across Europe" )%>
                                      </h1>
                                      <div class="visualClear"><!--&nbsp; --></div>
                                      <div style="position: relative;height: 380px;">
                                          <div class="figure-right" style="display:inline; position: absolute; right:0; top:0;">
                                             <div class="figure">
                                                 <img height="350" width="216" title="" alt="<%=cm.cmsPhrase("Image from EUNIS Database photo collection regarding Species, Habitat types and Sites")%>" src="images/intros/<%=Utilities.getIntroImage( application )%>" />
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
                                                  <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
                                                  <input type="hidden" name="DB_DIPLOMA" value="ON" />
                                                  <input type="hidden" name="DB_CDDA_INTERNATIONAL" value="ON" />
                                                  <input type="hidden" name="DB_CORINE" value="ON" />
                                                  <input type="hidden" name="DB_BIOGENETIC" value="ON" />
                                                  <input type="hidden" name="DB_EMERALD" value="ON" />
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
<%--
                                            <a href="gis-tool.jsp"><strong><%=cm.cmsPhrase( "Interactive Maps" )%></strong></a>
                                            &nbsp;
                                            <a href="gis-tool.jsp" title="<%=cm.cmsPhrase("GIS Tool Interactive maps")%>"><img src="images/compass.jpg" width="29" height="29" style="width : 29px; height : 29px; border : 0px; vertical-align : middle;" alt="<%=cm.cmsPhrase("GIS Tool Interactive maps")%>" title="<%=cm.cmsPhrase("GIS Tool Interactive maps")%>" /></a>
                                            <br />
                                            <%=cm.cmsPhrase("Geographical information accessible within an interactive GIS tool allowing users to build maps or identify areas.")%>
                                            <br />
--%>
                                            <!-- END MAIN CONTENT -->
                                          </div>
                                      </div>
                                      <div class="visualClear"><!--&nbsp; --></div>
                                      <div class="documentActions">
                                        <h5 class="hiddenStructure">Document Actions</h5>
                                        <h2 class="share-title">Share with others</h2>

                                        <table class="table-document-actions">
                                            <tr>
                                                <td>
                                                    <div id="socialmedia-list">
                                                        <div id="delicious" class="social-box">
                                                            <a href="http://www.delicious.com/save" onclick="window.open('http://www.delicious.com/save?v=5&amp;noui&amp;jump=close&amp;url='+encodeURIComponent(location.href)+'&amp;title='+encodeURIComponent(document.title), 'delicious','toolbar=no,width=550,height=550'); return false;">
                                                                <img src="http://www.eea.europa.eu/delicious20x20.png" alt="Delicious">
                                                            </a>
                                                        </div>
                                                        <div id="twitter" class="social-box">
                                                            <a href="https://twitter.com/share" class="twitter-share-button"></a>
                                                            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
                                                        </div>
                                                        <div id="google" class="social-box">
                                                            <g:plusone size="medium"></g:plusone>
                                                            <script type="text/javascript">
                                                                (function() {
                                                                    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                                                                    po.src = 'https://apis.google.com/js/plusone.js';
                                                                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
                                                                })();
                                                            </script>
                                                        </div>
                                                        <div id="facebook" class="social-box">
                                                            <div id="fb-root"></div>
                                                            <script>
                                                                (function(d, s, id) {
                                                                    var js, fjs = d.getElementsByTagName(s)[0];
                                                                    if (d.getElementById(id)) return;
                                                                    js = d.createElement(s); js.id = id;
                                                                    js.src = '//connect.facebook.net/en_GB/all.js#xfbml=1';
                                                                    fjs.parentNode.insertBefore(js, fjs);
                                                                }(document, 'script', 'facebook-jssdk'));
                                                            </script>
                                                            <div class="fb-like" data-send="true" data-layout="button_count" data-show-faces="false"></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-right">
                                                    <ul>
                                                        <li>
                                                            <a href="javascript:this.print();"><img src="http://www.eea.europa.eu/templates/print_icon.gif"
                                                            alt="<%=cm.cmsPhrase("Print this page")%>"
                                                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                                                        </li>
                                                        <li>
                                                            <a href="javascript:toggleFullScreenMode();"><img src="http://www.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                                                            alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                                                            title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                                                        </li>
                                                    </ul>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                            </div>
                    </div>
                    <!-- end of the main column -->

                    <!-- start of right column -->
                    <div id="right-column" class="right-column-area">
                      <div class="visualPadding">
                        <jsp:include page="inc_column_left.jsp">
                          <jsp:param name="page_name" value="index.jsp" />
                        </jsp:include>
                      </div>
                    </div>
                  <!-- end of the right (by default at least) column -->
                </div>
                <!-- end of the main and left columns -->
                <div class="visualClear"><!-- --></div>
              </div>
              <!-- end column wrapper -->
              <jsp:include page="footer-static.jsp" />
        </div><!-- visual-portal-wrapper" -->
    </body>
</html>
