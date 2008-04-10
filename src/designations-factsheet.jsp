<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Designation factsheet for a country - display information about a specified country.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List, ro.finsiel.eunis.search.sites.designations.FactsheetDesignations,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist,
                 ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationPersist,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Statement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
    function MM_openBrWindow(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }
    function openLink(URL)
    {
      eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
    }

   function goToCountryStatistics(countryName) {

      var frm = document.createElement( "FORM" );
      document.appendChild( frm );
      frm.method = "post";
      frm.action="sites-statistical-result.jsp";

      var c = document.createElement("input");
      c.type= "hidden";
      c.name = "country";
      c.value = countryName;
      frm.appendChild( c );

     var db1 = document.createElement("input");
     db1.type= "hidden";
     db1.name = "DB_NATURA2000";
     db1.value = true;
     frm.appendChild( db1 );

    var db2 = document.createElement("input");
    db2.type= "hidden";
    db2.name = "DB_CDDA_NATIONAL";
    db2.value = true;
    frm.appendChild( db2 );

    var db3 = document.createElement("input");
    db3.type= "hidden";
    db3.name = "DB_NATURE_NET";
    db3.value = false;
    frm.appendChild( db3 );

    var db4 = document.createElement("input");
    db4.type= "hidden";
    db4.name = "DB_CORINE";
    db4.value = true;
    frm.appendChild( db4 );

    var db5 = document.createElement("input");
    db5.type= "hidden";
    db5.name = "DB_CDDA_INTERNATIONAL";
    db5.value = true;
    frm.appendChild( db5 );

    var db6 = document.createElement("input");
    db6.type= "hidden";
    db6.name = "DB_DIPLOMA";
    db6.value = true;
    frm.appendChild( db6 );

    var db7 = document.createElement("input");
    db7.type= "hidden";
    db7.name = "DB_BIOGENETIC";
    db7.value = true;
    frm.appendChild( db7 );

    var db8 = document.createElement("input");
    db8.type= "hidden";
    db8.name = "DB_EMERALD";
    db8.value = true;
    frm.appendChild( db8 );

    frm.submit();
}
    //]]>
    </script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_factsheet_location";
  try
  {
  // Request parameters
  String id = (request.getParameter("idDesign") == null ? null : request.getParameter("idDesign"));
  String geoscope = (request.getParameter("geoscope") == null ? null : request.getParameter("geoscope"));
  boolean showSites = Utilities.checkedStringToBoolean( request.getParameter( "showSites" ), false );

  WebContentManagement cm = SessionManager.getWebContent();

  // The designation for witch the factsheet is made is identified by id, iso, description and sourceDb parameters,
  // so they must be not null
  Chm62edtDesignationsPersist factsheet = null;
  if(id != null && geoscope != null)
  {
    FactsheetDesignations design = new FactsheetDesignations(id,geoscope);
    // Get the DesignationPersist object
    factsheet = design.FindDesignationPersist();
  }
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_designations-factsheet_title")%>
    </title>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <img alt="<%=cm.cms("loading_data")%>" id="loading" src="images/loading.gif" />
                <br />
<%
  if (factsheet != null)
  {
    String fromWhere = (request.getParameter("fromWhere") == null ? "" : request.getParameter("fromWhere"));
    // Name of designation
    String fromWho=(factsheet.getDescription() != null && !factsheet.getDescription().equalsIgnoreCase("") ? factsheet.getDescription() : "");
    if (fromWho.equalsIgnoreCase("")) fromWho=(factsheet.getDescriptionEn() != null && !factsheet.getDescriptionEn().equalsIgnoreCase("") ? factsheet.getDescriptionEn() : "");
    if (fromWho.equalsIgnoreCase("")) fromWho=(factsheet.getDescriptionFr() != null && !factsheet.getDescriptionFr().equalsIgnoreCase("") ? factsheet.getDescriptionFr() : "");
    String country = Utilities.formatString(Utilities.findCountryByIdGeoscope(factsheet.getIdGeoscope()), "");
    if( country.equalsIgnoreCase( "Europe" ) )
    {
      country = "European Community";
    }
%>
                <!--General information-->
                  <h1>
                    <%=cm.cmsPhrase( "Designation type" )%> : <%=fromWho%>
                  </h1>
                <h2>
                  <%=cm.cmsPhrase( "General information" )%>
                </h2>
                <table class="datatable" width="90%">
                  <%--Code--%>
                  <tr>
                    <td width="30%">
                      <%=cm.cmsPhrase( "Code" )%>
                    </td>
                    <td width="70%">
                      <strong>
                        <%=Utilities.formatString(factsheet.getIdDesignation(), "&nbsp")%>
                      </strong>
                    </td>
                  </tr>
                  <!--Source data set-->
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Source data set" )%>
                    </td>
                    <td>
                      <strong>
                        <%=factsheet.getOriginalDataSource()%>
                      </strong>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Geographical coverage" )%>
                    </td>
                    <td>
<%
    if(Utilities.isCountry(country))
    {
%>
                      <a href="javascript:goToCountryStatistics('<%=country%>')" title="<%=cm.cms("open_the_statistical_data_for")%> <%=country%>"><strong><%=country%></strong></a>
                      <%=cm.cmsTitle("open_the_statistical_data_for")%>&nbsp;
<%
     }
     else
     {
%>
                      <strong>
                        <%=country%>
                      </strong>
<%
      }
%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Designation name in original language" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=(fromWhere.equalsIgnoreCase("original")?"<strong>":"")%>
                      <%=Utilities.formatString(factsheet.getDescription())%>
                      <%=(fromWhere.equalsIgnoreCase("original")?"</strong>":"")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Designation name in English" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=(fromWhere.equalsIgnoreCase("en")?"<strong>":"")%>
                      <%=Utilities.formatString(factsheet.getDescriptionEn())%>
                      <%=(fromWhere.equalsIgnoreCase("en")?"</strong>":"")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Designation name in French" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=(fromWhere.equalsIgnoreCase("fr")?"<strong>":"")%>
                      <%=Utilities.formatString(factsheet.getDescriptionFr())%>
                      <%=(fromWhere.equalsIgnoreCase("fr")?"</strong>":"")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Designation abbreviation" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString(factsheet.getIdDesignation(), "")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "CDDA sites" )%>
                    </td>
<%
        // Are CDDA sites or not
        String cddacount = "&nbsp;";
        if(factsheet.getCddaSites()!=null)
        {
          cddacount = factsheet.getCddaSites();
          if(!cddacount.equalsIgnoreCase("Y"))
          {
             cddacount="Yes";
          }
          else
          {
             cddacount="No";
          }
        }
%>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString( cddacount, "&nbsp;" )%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Area reference (ha)" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString( Utilities.formatDecimal( factsheet.getReferenceArea(), 5 ), "" )%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Total area(ha)" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString( Utilities.formatDecimal( factsheet.getTotalArea(), 5 ), "" )%>
                    </td>
                  </tr>
                </table>
<%
        if( !Utilities.formatString(factsheet.getNationalLaw()).equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getNationalCategory(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getNationalLawReference(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getNationalLawAgency(), "").equalsIgnoreCase(""))
        {
%>
                <h2>
                  <%=cm.cmsPhrase( "National information" )%>
                </h2>
                <table summary="layout" class="datatable" width="90%">
                  <tr>
                    <td width="30%">
                      <%=cm.cmsPhrase( "National Law" )%>
                    </td>
                    <td width="70%">
                      <%=Utilities.formatString(factsheet.getNationalLaw(), "&nbsp;")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "National Category" )%>
                    </td>
                    <td>
                      <%=Utilities.formatString(factsheet.getNationalCategory(), "&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Reference for National Law" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString(factsheet.getNationalLawReference(), "")%>
                    </td>
                  </tr>
                   <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "National Law Agency" )%>
                    </td>
                    <td>
                      <%=Utilities.formatString(factsheet.getNationalLawAgency(), "&nbsp;")%>
                    </td>
                  </tr>
                </table>
<%
        }
%>
<%
        if( !Utilities.formatString(factsheet.getDataSource(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getReferenceNumber(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getReferenceDate(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getRemark(), "").equalsIgnoreCase("") ||
            !Utilities.formatString(factsheet.getRemarkSource(), "").equalsIgnoreCase(""))
        {
%>
                <h2>
                  <%=cm.cmsPhrase( "References" )%>
                </h2>
                <table summary="layout" class="datatable" width="90%">
                  <tr>
                    <td width="30%">
                      <%=cm.cmsPhrase( "Source" )%>
                    </td>
                    <td width="70%">
                      <%=Utilities.formatString(factsheet.getDataSource(), "&nbsp;")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Number of reference" )%>
                    </td>
                    <td>
                      <%=Utilities.formatString(factsheet.getReferenceNumber(), "&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Reference date" )%>
                    </td>
                    <td>
                      &nbsp;
                      <%=Utilities.formatString(factsheet.getReferenceDate(), "")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase( "Remark" )%>
                    </td>
                    <td>
                      <%=Utilities.formatString(factsheet.getRemark(), "&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase( "Source remark" )%>
                    </td>
                    <td>
                      <%=Utilities.formatString(factsheet.getRemarkSource(), "&nbsp;")%>
                    </td>
                  </tr>
                </table>
<%
        }
%>
<%
        Connection con = null;
        Statement ps = null;
        ResultSet rs = null;
        try
        {
          String sql="";
          sql+="    SELECT";
          sql+="      `DC_SOURCE`.`SOURCE`,";
          sql+="      `DC_SOURCE`.`EDITOR`,";
          sql+="      `DC_DATE`.`CREATED`,";
          sql+="      `DC_TITLE`.`TITLE`,";
          sql+="      `DC_PUBLISHER`.`PUBLISHER`";
          sql+="    FROM";
          sql+="      `CHM62EDT_DESIGNATIONS`";
          sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_DESIGNATIONS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
          sql+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
          sql+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
          sql+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
          sql+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
          sql+="    WHERE";
          sql+="      `CHM62EDT_DESIGNATIONS`.ID_DESIGNATION = '"+ factsheet.getIdDesignation() + "'";
          sql+="    AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = " + factsheet.getIdGeoscope();
          // Set the database connection parameters
          String SQL_DRV = application.getInitParameter("JDBC_DRV");
          String SQL_URL = application.getInitParameter("JDBC_URL");
          String SQL_USR = application.getInitParameter("JDBC_USR");
          String SQL_PWD = application.getInitParameter("JDBC_PWD");

          Class.forName(SQL_DRV);
          con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
          ps = con.createStatement();
          rs = ps.executeQuery(sql);

          String author;
          String editor;
          String date;
          String title;
          String publisher;

          rs.beforeFirst();

          if(rs.next())
          {

            author = Utilities.formatString( Utilities.FormatDatabaseFieldName( rs.getString( 1 ) ), "&nbsp;" );
            editor = Utilities.formatString( Utilities.FormatDatabaseFieldName( rs.getString( 2 ) ), "&nbsp;" );
            date = Utilities.formatString( Utilities.formatReferencesDate( rs.getDate( 3 ) ), "&nbsp;" );
            title = Utilities.formatString( Utilities.FormatDatabaseFieldName( rs.getString( 4 ) ), "&nbsp;" );
            publisher = Utilities.formatString( Utilities.FormatDatabaseFieldName( rs.getString( 5 ) ), "&nbsp;" );
%>
                <h2>
                  <%=cm.cmsPhrase("Designation references")%>
                </h2>
                <table summary="layout" class="datatable" width="90%">
                  <tr>
                    <td width="30%">
                      <%=cm.cmsPhrase("Author:")%>
                    </td>
                    <td width="70%">
                      <%=author%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Editor:")%>
                    </td>
                    <td>
                      <%=editor%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Date:")%>
                    </td>
                    <td>
                      <%=date%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Title:")%>
                    </td>
                    <td>
                      <%=title%>
                    </td>
                  </tr>
                  <tr>
                    <td width="20%">
                      <%=cm.cmsPhrase("Publisher:")%>
                    </td>
                    <td width="80%">
                      <%=publisher%>
                    </td>
                  </tr>
                </table>
                <br />
<%
          }
        }
        catch( Exception ex )
        {
          ex.printStackTrace();
        }
        finally
        {
          if ( ps != null ) ps.close();
          if ( rs != null ) rs.close();
          if ( con != null ) con.close();
        }
        // If show sites for this designation
        if( showSites )
        {
          List sites = SitesSearchUtility.findSitesForDesignation(id, geoscope);
          if (sites != null && sites.size() > 0)
          {
%>
                <h2>
                  <%=cm.cmsPhrase( "Related sites for this designation" )%>
                </h2>
<%
            String ids = "";
            int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
            if ( sites.size() < maxSitesPerMap )
            {
              for (int i = 0; i < sites.size(); i++)
              {
                DesignationPersist site = (DesignationPersist)sites.get(i);
                ids += "'" + site.getIdSite() + "'";
                if ( i < sites.size() - 1 ) ids += ",";
              }
%>
                <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
                  <input type="hidden" name="sites" value="<%=ids%>" />
                  <input id="showMap" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="searchButton" />
                </form>
<%
              }
%>
                <table summary="<%=cm.cms("sites")%>" class="listing" width="90%">
                  <thead>
                    <tr>
                      <th scope="col">
                        <%=cm.cmsPhrase( "Site code (in source data set)" )%>
                      </th>
                      <th scope="col">
                        <%=cm.cmsPhrase( "Source data set" )%>
                      </th>
                      <th scope="col">
                        <%=cm.cmsPhrase( "Geographical coverage" )%>
                      </th>
                      <th scope="col">
                        <%=cm.cmsPhrase( "Site name" )%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
<%
              // List of sites for this designation
              for (int i = 0; i < sites.size(); i++)
              {
                String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
                DesignationPersist site = (DesignationPersist)sites.get(i);
%>
                  <tr<%=cssClass%>>
                    <td>
                      <%=Utilities.formatString(site.getIdSite(), "&nbsp;")%>
                    </td>
                    <td>
                      <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()), "&nbsp;")%>
                    </td>
                    <td>
                      <%=Utilities.formatString(site.getCountry(), "&nbsp;")%>
                    </td>
                    <td>
                      <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
                      <%=cm.cmsTitle("open_site_factsheet")%>
                    </td>
                  </tr>
<%
              }
%>
                  </tbody>
                </table>
<%
            }
            else
            {
%>
                <br />
                <strong>
                  <%=cm.cmsPhrase( "This designation has not related sites." )%>
                </strong>
<%
            }
          }
          else
          {
%>
                <a title="<%=cm.cms("show_sites_in_page")%>" href="designations-factsheet.jsp?showSites=true&amp;fromWhere=<%=fromWhere%>&amp;idDesign=<%=id%>&amp;geoscope=<%=geoscope%>"><%=cm.cmsPhrase( "Show sites for this designation type" )%></a>
                <%=cm.cmsTitle("show_sites_in_page")%>
                <br />
                <br />
                <strong>
                  <%=cm.cmsPhrase( "Warning: This might take a long time." )%>
                </strong>
<%
          }
        }
        else
        {
%>
                <br />
                <br />
                <strong>
                  <%=cm.cmsPhrase( "The requested designation does not exists. ")%>
                </strong>
                <br />
                <br />
<%
        }
%>
                <%=cm.cmsMsg("sites_designations-factsheet_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading_data")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="designations-factsheet.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
    <script language="javascript" type="text/javascript">
    //<![CDATA[
    try {
    var ctrl_loading = document.getElementById( "loading" );
    ctrl_loading.style.display = "none"; }
    catch ( e ) { }
    //]]>
    </script>
  </body>
</html>
<%
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
%>
