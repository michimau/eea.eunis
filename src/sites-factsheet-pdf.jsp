<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : PDF transform function for a site's factsheet
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.*,
                com.lowagie.text.*,
                java.awt.*,
                com.lowagie.text.Font,
                com.lowagie.text.Image,
                java.util.List,
                ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                ro.finsiel.eunis.search.Utilities,
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
  WebContentManagement cm = SessionManager.getWebContent();
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
      <%=cm.cms("sites_factsheet-pdf_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function showLoadingProgress( show )
      {
        var img = document.getElementById( "loading" );
        if ( show )
        {
          img.style.display = "block";
        }
        else
        {
          img.style.display = "none";
        }
      }

      function updateText(txt)
      {
        document.getElementById("status").innerHTML=txt;
      }
      //-->
    </script>
  </head>
<body>
  <div id="imgtop">
    <img src="images/progress/top.jpg" width="400" height="178" alt="" />
  </div>
  <img id="loading" src="<%=request.getContextPath()%>/images/loading_tsv.gif" width="200" height="10" alt="<%=cm.cms("loading")%>" />
  <div id="status">
    &nbsp;
  </div>
  <script language="JavaScript" type="text/javascript">
    <!--
    updateText('<%=cm.cms("sites_factsheet-pdf_01")%>');
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
      f.add( new Phrase( cm.cms( "sites_factsheet-pdf_02" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
      f.add( new Phrase( "                                                                                                                                     ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
      f.add( new Phrase( cm.cms( "sites_factsheet-pdf_03" ) + application.getInitParameter( "LAST_UPDATE" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
      f.add( new Phrase( "                                                                                                                                     ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
      report.setFooter( f );
      report.init( linktopdf + filename );

      SimpleDateFormat df = new SimpleDateFormat( "yyyy-MM-dd" );
      report.writeln( cm.cms( "sites_factsheet-pdf_04" ) + df.format( new Date() ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) );
      // Global data
      int type = factsheet.getType();
      String designationDescr = factsheet.getDesignation();

      String SQL_DRV = application.getInitParameter( "JDBC_DRV" );
      String SQL_URL = application.getInitParameter( "JDBC_URL" );
      String SQL_USR = application.getInitParameter( "JDBC_USR" );
      String SQL_PWD = application.getInitParameter( "JDBC_PWD" );

      PDFSitesFactsheet pdfFactsheet = new PDFSitesFactsheet( siteid, report, cm, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
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
      showLoadingProgress( false );
      updateText("<%=cm.cms("sites_factsheet-pdf_109")%>");
<%
   }
    else
   {
%>
      showLoadingProgress( false );
      updateText("<%=cm.cms("sites_factsheet-pdf_110")%>");
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
    <a target="_blank" href="temp/<%=filename%>" title="<%=cm.cms("download_pdf_file")%>"><%=cm.cmsText("sites_factsheet-pdf_111")%></a>
    <%=cm.cmsTitle("download_pdf_file")%>
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
    <%=cm.cmsText("sites_factsheet-pdf_112")%> <a href="javascript:feedback();"><%=cm.cmsText("feedback")%></a>.<%=cm.cmsText("sites_factsheet-pdf_113")%>
<%
  }
  }
  else
  {
%>
  <%=cm.cmsText("sites_factsheet-pdf_114")%> ID=<strong><%=siteid%></strong> <%=cm.cmsText("sites_factsheet-pdf_115")%>
  <br />
  <br />
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button2" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close_window_title")%>
      <%=cm.cmsInput("close_window_value")%>
    </form>
<%
  }
%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_title")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_01")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_02")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_03")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_04")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_109")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_factsheet-pdf_110")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("loading")%>
</body>
</html>
<%out.flush();%>