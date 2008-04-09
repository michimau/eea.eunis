<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - pdf.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="com.lowagie.text.Font, com.lowagie.text.*,
                com.lowagie.text.Image,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                ro.finsiel.eunis.search.Utilities,
                java.awt.*,
                java.text.SimpleDateFormat,
                java.util.Date,
                ro.finsiel.eunis.factsheet.PDFSpeciesFactsheet,
                ro.finsiel.eunis.reports.pdfReport,
                java.util.Properties"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp"/>
  <script language="JavaScript" type="text/javascript" src="script/timer.js"></script>
<%
  Integer idSpecies = Utilities.checkedStringToInt( request.getParameter( "idSpecies" ), new Integer( 0 ) );
  Integer idSpeciesLink = Utilities.checkedStringToInt( request.getParameter( "idSpeciesLink" ), new Integer( 0 ) );

  WebContentManagement cm = SessionManager.getWebContent();
  boolean error = false;
  // INPUT PARAMS: idSpecies, idSpeciesLink
  SpeciesFactsheet factsheet = new SpeciesFactsheet( idSpecies, idSpeciesLink );
  // Initializations
  if ( null != factsheet.getSpeciesObject() && null != factsheet.getSpeciesNatureObject() )
  {
  %>
  <title>
    <%=cm.cms("generating_pdf")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
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
  //]]>
  </script>
</head>

<body>
<div id="layout">
<table summary="layout" width="400" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td id="imgtop"><img alt="<%=cm.cms("species_factsheet-pdf_100_Alt")%>" src="images/progress/top.jpg" width="400" height="178"/><%=cm.cmsAlt("species_factsheet-pdf_100_Alt")%></td>
  </tr>
</table>
<img id="loading" src="<%=request.getContextPath()%>/images/loading_tsv.gif" width="200" height="10" alt="<%=cm.cms("loading_animation")%>" />
<%=cm.cmsAlt("loading_animation")%>
<table summary="layout" border="0">
  <tr>
    <td id="status">
      &nbsp;
    </td>
  </tr>
</table>
<% out.flush(); %>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
updateText('<%=cm.cms("generating_pdf_wait")%>');
//]]>
</script>
<%
  pdfReport report = new pdfReport();
  out.flush();
  String linktopdf = application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/temp/";
  String filename = "SpeciesFactsheet_" + request.getSession().getId() + ".pdf";

  Paragraph header = new Paragraph();
  String jpegPath = application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/images/headerpdf.jpg";

  try
  {
    Image jpeg = Image.getInstance( jpegPath );
    header.add( jpeg );
  }
  catch ( Exception e )
  {
    error = true;
    e.printStackTrace();
  }
  try
  {
    report.setHeader( header );
    Paragraph footer = new Paragraph();
    footer.add( new Phrase( cm.cmsPhrase( "Source: European Topic Centre on Biological Diversity" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
    report.setFooter( footer );
    report.init( linktopdf + filename );

    SimpleDateFormat df = new SimpleDateFormat( "yyyy-MM-dd" );
    report.writeln( cm.cmsPhrase( "Generated on" ) + ": " + df.format( new Date() ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) );

    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");

    PDFSpeciesFactsheet pdfFactsheet = new PDFSpeciesFactsheet( cm, report, idSpecies, idSpeciesLink, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
    pdfFactsheet.generateFactsheet();
  }
  catch ( Exception e )
  {
    error = true;
    e.printStackTrace();
  }
  // Close the PDF file and flush the output to client
  report.close();
  out.flush();
%>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
<%
   if ( error )
   {
%>
      showLoadingProgress( false );
      updateText('<%=cm.cms("species_factsheet-pdf_92")%>.');
<%
   }
    else
   {
%>
      showLoadingProgress( false );
      updateText('<%=cm.cms("species_factsheet-pdf_93")%>.');
<%
   }
%>
      //]]>
    </script>
<%
    out.flush();
    if ( !error )
    {
%>
    <a title="<%=cm.cms("species_factsheet-pdf_102_Title")%>" target="_blank" href="temp/<%=filename%>"><%=cm.cmsPhrase( "Open PDF report" )%></a>
    <%=cm.cmsTitle("species_factsheet-pdf_102_Title")%>
<%
    }
    else
    {
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      function feedback()
      {
        window.opener.location.href="feedback.jsp?feedbackType=Software%20bugs&module=EUNIS%20Species&url=Species%20PDF%20factsheet%20generation%20failed for species <%=Utilities.treatURLSpecialCharacters(Utilities.removeQuotes( factsheet.getSpeciesObject().getScientificName() ))%> with ID=<%=factsheet.getIdSpecies()%>, ID_link=<%=factsheet.getIdSpeciesLink()%>%>.";
        this.close();
      }
      //]]>
    </script>
    <%=cm.cmsPhrase( "Please let us know about this error by sending an" )%>
    <a title="<%=cm.cms("feedback")%>" href="javascript:feedback();"><%=cm.cmsPhrase( "EUNIS Feedback" )%></a>.
    <%=cm.cmsTitle("feedback")%>
    <%=cm.cmsPhrase( "Thank you!" )%>
    <%=cm.cmsPhrase( "Please let us know about this error by sending an" )%>
    <a title="Feedback" href="javascript:feedback();"><%=cm.cmsPhrase( "EUNIS Feedback" )%></a>.
    <%=cm.cmsPhrase( "Thank you!" )%>
<%
    }
    out.flush();
  }
  else
  {
%>
      <%=cm.cmsPhrase( "Sorry, no species matching has been found in database with ID:" )%> <%=factsheet.getIdSpecies()%>
      <br/>
      <br/>
      <input id="button2" title="<%=cm.cms("close_window")%>" type="button"
       onclick="javascript:window.close();"
       value="<%=cm.cms("close_btn")%>" name="button"
       class="standardButton"/>
      <%=cm.cmsTitle( "close_window")%>
      <%=cm.cmsInput( "close_btn")%>
<%
  }
%>
    </div>

<%=cm.br()%>
<%=cm.cmsMsg("generating_pdf")%>
<%=cm.br()%>
<%=cm.cmsMsg("generating_pdf_wait")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-pdf_92")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-pdf_93")%>
<%=cm.br()%>

  </body>
</html>
