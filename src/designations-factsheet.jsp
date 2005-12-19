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
    <!--
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
    //-->
    </script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
<%
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
    <div id="outline">
    <div id="alignment">
    <div id="content">
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,designation_factsheet_location"/>
    </jsp:include>
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
%>
    <table width="100%" border="0" summary="layout">
      <tr>
        <td>
          <!--General information-->
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
            <tr align="center">
              <td>
                <h1>
                  <%=cm.cmsText( "sites_designations-factsheet_01" )%> : <%=fromWho%>
                </h1>
              </td>
            </tr>
          </table>
          <br />
          <table summary="layout" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
            <tr bgcolor="#CCCCCC">
              <td colspan="2">
                <strong>
                  <%=cm.cmsText( "sites_designations-factsheet_03" )%>
                </strong>
              </td>
            </tr>
            <%--Code--%>
            <tr bgcolor="#EEEEEE">
              <td width="30%">
                <%=cm.cmsText( "sites_designations-factsheet_04" )%>
              </td>
              <td width="70%">
                &nbsp;
                <strong>
                  <%=Utilities.formatString(factsheet.getIdDesignation(), "&nbsp")%>
                </strong>
              </td>
            </tr>
            <!--Source data set-->
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_05" )%>
              </td>
              <td>
                &nbsp;
                <strong>
                  <%=factsheet.getOriginalDataSource()%>
                </strong>
              </td>
            </tr>
<%
            String country = Utilities.formatString(Utilities.findCountryByIdGeoscope(factsheet.getIdGeoscope()), "");
            if( country.equalsIgnoreCase( "Europe" ) )
            {
              country = "European Community";
            }
%>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_06" )%>
              </td>
              <td>
                &nbsp;
                <%
                   if(Utilities.isCountry(country))
                   {
                %>
                <a href="javascript:goToCountryStatistics('<%=country%>')" title="<%=cm.cms("open_statistical_data_for")%> <%=country%>"><strong><%=country%></strong></a><%=cm.cmsTitle("open_statistical_data_for")%>&nbsp;
                <%
                   } else {
                %>
                    <strong><%=country%></strong>
                <%
                    }
                %>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_07" )%>
              </td>
              <td>
                &nbsp;
                <%=(fromWhere.equalsIgnoreCase("original")?"<strong>":"")%>
                <%=Utilities.formatString(factsheet.getDescription())%>
                <%=(fromWhere.equalsIgnoreCase("original")?"</strong>":"")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_08" )%>
              </td>
              <td>
                &nbsp;
                <%=(fromWhere.equalsIgnoreCase("en")?"<strong>":"")%>
                <%=Utilities.formatString(factsheet.getDescriptionEn())%>
                <%=(fromWhere.equalsIgnoreCase("en")?"</strong>":"")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_09" )%>
              </td>
              <td>
                &nbsp;
                <%=(fromWhere.equalsIgnoreCase("fr")?"<strong>":"")%>
                <%=Utilities.formatString(factsheet.getDescriptionFr())%>
                <%=(fromWhere.equalsIgnoreCase("fr")?"</strong>":"")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_10" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getIdDesignation(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_11" )%>
              </td>
<%
                // Is CDDA sites or not
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
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_12" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString( Utilities.formatDecimal( factsheet.getReferenceArea(), 5 ), "" )%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_13" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString( Utilities.formatDecimal( factsheet.getTotalArea(), 5 ), "" )%>
              </td>
            </tr>
          </table>
          <br />
<%
    if( !Utilities.formatString(factsheet.getNationalLaw()).equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getNationalCategory(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getNationalLawReference(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getNationalLawAgency(), "").equalsIgnoreCase(""))
    {
%>
          <table summary="layout" border="1" cellpadding="0" cellspacing="1" width="100%" style="border-collapse: collapse">
            <tr bgcolor="#CCCCCC">
              <td colspan="2">
                <strong>
                  <%=cm.cmsText( "sites_designations-factsheet_14" )%>
                </strong>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td width="161">
                <%=cm.cmsText( "sites_designations-factsheet_15" )%>
              </td>
              <td width="579">
                &nbsp;
                <%=Utilities.formatString(factsheet.getNationalLaw(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_16" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getNationalCategory(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_17" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getNationalLawReference(), "")%>
              </td>
            </tr>
             <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_18" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getNationalLawAgency())%>
              </td>
            </tr>
          </table>
<%
    }
%>
          <br />
<%
    if( !Utilities.formatString(factsheet.getDataSource(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getReferenceNumber(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getReferenceDate(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getRemark(), "").equalsIgnoreCase("") ||
        !Utilities.formatString(factsheet.getRemarkSource(), "").equalsIgnoreCase(""))
    {
%>
          <table summary="layout" border="1" cellpadding="0" cellspacing="1" width="100%" style="border-collapse: collapse">
            <tr bgcolor="#CCCCCC">
              <td colspan="2">
                <strong>
                  <%=cm.cmsText( "sites_designations-factsheet_19" )%>
                </strong>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td width="161">
                <%=cm.cmsText( "sites_designations-factsheet_20" )%>
              </td>
              <td width="579">
                &nbsp;
                <%=Utilities.formatString(factsheet.getDataSource(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_21" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getReferenceNumber(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_22" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getReferenceDate(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_23" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getRemark(), "")%>
              </td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td>
                <%=cm.cmsText( "sites_designations-factsheet_24" )%>
              </td>
              <td>
                &nbsp;
                <%=Utilities.formatString(factsheet.getRemarkSource(), "")%>
              </td>
            </tr>
          </table>
<%
    }
%>
          <br />
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
          <table summary="layout" width="100%" border="1" cellspacing="1" cellpadding="0" id="references" style="border-collapse:collapse; background-color:#EEEEEE;">
            <tr bgcolor="#CCCCCC">
              <td colspan="2">
                <strong>
                  <%=cm.cmsText("designation_factsheet_references")%>
                </strong>
              </td>
            </tr>
            <tr>
              <td width="20%">
                <%=cm.cmsText("designation_factsheet_author")%>
              </td>
              <td width="80%">
                <%=author%>
              </td>
            </tr>
            <tr>
              <td width="20%">
                <%=cm.cmsText("designation_factsheet_editor")%>
              </td>
              <td width="80%">
                <%=editor%>
              </td>
            </tr>
            <tr>
              <td width="20%">
                <%=cm.cmsText("designation_factsheet_date")%>
              </td>
              <td width="80%">
                <%=date%>
              </td>
            </tr>
            <tr>
              <td width="20%">
                <%=cm.cmsText("designation_factsheet_title")%>
              </td>
              <td width="80%">
                <%=title%>
              </td>
            </tr>
            <tr>
              <td width="20%">
                <%=cm.cmsText("designation_factsheet_publisher")%>
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
       <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;">
          <%=cm.cmsText( "sites_designations-factsheet_25" )%>
       </div>
<%
    String ids = "";
    int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
    if ( sites.size() < maxSitesPerMap )
    {
%>
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<%
      for (int i = 0; i < sites.size(); i++)
      {
        DesignationPersist site = (DesignationPersist)sites.get(i);
        ids += "'" + site.getIdSite() + "'";
        if ( i < sites.size() - 1 ) ids += ",";
      }
%>
                  <tr>
                    <td width="50%">
                      <br />
                      <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
                        <input type="hidden" name="sites" value="<%=ids%>" />
                        <label for="showMap" class="noshow"><%=cm.cms("show_map")%></label>
                        <input id="showMap" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="inputTextField" />
                        <%=cm.cmsLabel("show_map")%>
                      </form>
                    </td>
                  </tr>
                </table>
              <br />
<%
  }
%>
                <table summary="<%=cm.cms("designation_factsheet_sites")%>" width="100%" border="0" cellspacing="0" cellpadding="0" id="sitesx" class="sortable">
                  <tr>
                    <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
                      <strong>
                        <%=cm.cmsText( "sites_designations-factsheet_28" )%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                    <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
                      <strong>
                        <%=cm.cmsText( "sites_designations-factsheet_05" )%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                    <th class="resultHeader" width="20%">
                      <strong>
                        <%=cm.cmsText( "sites_designations-factsheet_06" )%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                    <th class="resultHeader" width="50%">
                      <strong>
                        <%=cm.cmsText( "sites_designations-factsheet_29" )%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                  </tr>
<%
        // List of sites for this designation
        for (int i = 0; i < sites.size(); i++)
        {
          DesignationPersist site = (DesignationPersist)sites.get(i);
%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=Utilities.formatString(site.getIdSite())%></td>
            <td><%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%></td>
            <td><%=Utilities.formatString(site.getCountry())%></td>
            <td>
              <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
              <%=cm.cmsTitle("open_site_factsheet")%>
            </td>
          </tr>
<%
        }
%>
       </table>
<%
      }
      else
      {
%>
          <br />
          <strong>
            <%=cm.cmsText( "sites_designations-factsheet_30" )%>
          </strong>
<%
      }
%>

<%
    }
    else
    {
%>
      <a title="<%=cm.cms("show_sites_in_page")%>" href="designations-factsheet.jsp?showSites=true&amp;fromWhere=<%=fromWhere%>&amp;idDesign=<%=id%>&amp;geoscope=<%=geoscope%>"><%=cm.cmsText( "sites_designations-factsheet_31" )%></a>
      <%=cm.cmsTitle("show_sites_in_page")%>
      <br />
      <br />
      <strong>
        <%=cm.cmsText( "sites_designations-factsheet_32" )%>
      </strong>
<%
    }
%>
      </td>
    </tr>
<%
  }
  else
  {
%>
        <tr>
          <td>
            <br />
            <br />
            <strong>
              <%=cm.cmsText( "sites_designations-factsheet_33")%>
            </strong>
            <br />
            <br />
          </td>
        </tr>
<%
  }
%>
    </table>
    <%=cm.cmsMsg("sites_designations-factsheet_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("loading_data")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("designation_factsheet_sites")%>
    <%=cm.br()%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="designations-factsheet.jsp" />
    </jsp:include>
    <script language="javascript" type="text/javascript">
    <!--
    try {
    var ctrl_loading = document.getElementById( "loading" );
    ctrl_loading.style.display = "none"; }
    catch ( e ) { }
    //-->
    </script>
    </div>
    </div>
    </div>
  </body>
</html>
<%
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
%>