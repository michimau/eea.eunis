<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : PDF transform function for a site's factsheet
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.*,
                com.lowagie.text.*,
                java.awt.*,
                com.lowagie.text.Font,
                com.lowagie.text.Image,
                ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                ro.finsiel.eunis.factsheet.habitats.HabitatFactsheetRelWrapper,
                java.util.List,
                ro.finsiel.eunis.jrfTables.habitats.factsheet.OtherClassificationPersist,
                ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist,
                ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                ro.finsiel.eunis.jrfTables.*,
                ro.finsiel.eunis.search.sites.SitesSearchUtility,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.jrfTables.sites.factsheet.*,
                java.text.SimpleDateFormat,
                com.lowagie.text.FontFactory,
                ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.factsheet.PDFSitesFactsheet"%><%@ page import="ro.finsiel.eunis.reports.pdfReport"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/timer.js"></script>
<%
  pdfReport report = new pdfReport();
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  String linktopdf = application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/temp/";
  String filename = "SiteFactsheet_" + request.getSession().getId() + ".pdf";
  /// INPUT PARAMS: idHabitat
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  List results = null;
  if (factsheet.exists())
  {
%>
    <title>
      <%=contentManagement.getContent("sites_factsheet-pdf_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function updateText(txt)
      {
        document.getElementById("status").innerHTML=txt;
      }
      //-->
    </script>
  </head>
<body>
  <div id="imgtop">
    <img src="images/progress/top.jpg" width="400" height="178" />
  </div>
  <div id="status">
    &nbsp;
  </div>
  <script language="JavaScript" type="text/javascript">
    <!--
    updateText('<%=contentManagement.getContent("sites_factsheet-pdf_01")%>');
    //-->
  </script>
<%
  out.flush();
  boolean error = false;
  if ( factsheet.exists() )
  {
    try
    {
      // Headers and footers
      Paragraph header = new Paragraph();
      String jpegPath = application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/images/headerpdf.jpg";
      Image jpeg = Image.getInstance( jpegPath );
      header.add( jpeg );
      header.add( new Phrase( " ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
      report.setHeader( header );
      // IMPORTANT: THESE LINKS SHOULD BE CHANGED TO THEIR ACTUAL SERVER VALUE!!!
      Paragraph f = new Paragraph();
      f.add( new Phrase( contentManagement.getContent( "sites_factsheet-pdf_02" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
      f.add( new Phrase( "                                                                                                                                     ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
      f.add( new Phrase( contentManagement.getContent( "sites_factsheet-pdf_03" ) + application.getInitParameter( "LAST_UPDATE" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
      f.add( new Phrase( "                                                                                                                                     ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
      report.setFooter( f );
      report.init( linktopdf + filename );

      SimpleDateFormat df = new SimpleDateFormat( "yyyy-MM-dd" );
      report.writeln( contentManagement.getContent( "sites_factsheet-pdf_04" ) + df.format( new Date() ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) );
      // Global data
      int type = factsheet.getType();
      String designationDescr = factsheet.getDesignation();

      String SQL_DRV = application.getInitParameter( "JDBC_DRV" );
      String SQL_URL = application.getInitParameter( "JDBC_URL" );
      String SQL_USR = application.getInitParameter( "JDBC_USR" );
      String SQL_PWD = application.getInitParameter( "JDBC_PWD" );

      PDFSitesFactsheet pdfFactsheet = new PDFSitesFactsheet( siteid, report, contentManagement, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
      pdfFactsheet.generateFactsheet();

      report.close();
    }
    catch ( Exception ex )
    {
      error = true;
      ex.printStackTrace();
    }
  }
  out.flush();
%>
<script language="JavaScript" type="text/javascript">
<!--
<%
   if ( error )
   {
%>
      updateText("<%=contentManagement.getContent("sites_factsheet-pdf_109")%>");
<%
   }
    else
   {
%>
      updateText("<%=contentManagement.getContent("sites_factsheet-pdf_110")%>");
<%
   }
%>
//-->
</script>
<%
  out.flush();
  if ( !error )
  {
%>
    <a target="_blank" href="temp/<%=filename%>"><%=contentManagement.getContent("sites_factsheet-pdf_111")%></a>
<%
  }
  else
  {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
        function feedback()
        {
          window.opener.location.href="feedback.jsp?feedbackType=Software%20bugs&module=EUNIS%20Sites&url=Site%20PDF%20factsheet%20generation%20failed for site '<%=Utilities.removeQuotes(factsheet.getSiteObject().getName())%>' with ID=<%=siteid%>%>.";
          this.close();
        }
      //-->
    </script>
    <%=contentManagement.getContent("sites_factsheet-pdf_112")%> <a href="javascript:feedback();">feedback</a>.<%=contentManagement.getContent("sites_factsheet-pdf_113")%>
<%
  }
  }
  else
  {
%>
  <%=contentManagement.getContent("sites_factsheet-pdf_114")%> ID=<strong><%=siteid%></strong> <%=contentManagement.getContent("sites_factsheet-pdf_115")%>
  <br />
  <br />
  <input type="button" onclick="javascript:window.close();" value="<%=contentManagement.getContent("sites_factsheet-pdf_116", false )%>" name="button" class="inputTextField" title="Close window" />
  <%=contentManagement.writeEditTag( "sites_factsheet-pdf_116" )%>
<%
  }
%>
</body>
</html>
<%out.flush();%>