<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - pdf.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
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

  WebContentManagement contentManagement = SessionManager.getWebContent();
  boolean error = false;
  // INPUT PARAMS: idSpecies, idSpeciesLink
  SpeciesFactsheet factsheet = new SpeciesFactsheet( idSpecies, idSpeciesLink );
  // Initializations
  if ( null != factsheet.getSpeciesObject() && null != factsheet.getSpeciesNatureObject() )
  {
  %>
  <title>
    <%=contentManagement.getContent( "species_factsheet-pdf_title", false )%>
  </title>
  <jsp:include page="header-page.jsp"/>
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
<div id="layout">
<table summary="layout" width="400" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td id="imgtop"><img alt="In pogress" src="images/progress/top.jpg" width="400" height="178"/></td>
  </tr>
</table>
<% out.flush(); %>
<table summary="layout" border="0">
  <tr>
    <td id="status">
      &nbsp;
    </td>
  </tr>
</table>
<% out.flush(); %>
<script language="JavaScript" type="text/javascript">
<!--
updateText('<%=contentManagement.getContent("species_factsheet-pdf_01")%>');
  -->
</script>
<noscript>Your browser does not support JavaScript!</noscript>
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
    footer.add( new Phrase( contentManagement.getContent( "species_factsheet-pdf_03" ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
    footer.add( new Phrase( " ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
    footer.add( new Phrase( contentManagement.getContent( "species_factsheet-pdf_04" ) + ": " + application.getInitParameter( "LAST_UPDATE" ),
            FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) ) );
    footer.add( new Phrase( " ", FontFactory.getFont( FontFactory.HELVETICA, 9 ) ) );
    report.setFooter( footer );
    report.init( linktopdf + filename );

    SimpleDateFormat df = new SimpleDateFormat( "yyyy-MM-dd" );
    report.writeln( contentManagement.getContent( "species_factsheet-pdf_05" ) + ": " + df.format( new Date() ), FontFactory.getFont( FontFactory.HELVETICA, 8, Font.ITALIC, new Color( 24, 40, 136 ) ) );

    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");

    PDFSpeciesFactsheet pdfFactsheet = new PDFSpeciesFactsheet( contentManagement, report, idSpecies, idSpeciesLink, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
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
<!--
<%
   if ( error )
   {
%>
      updateText('<%=contentManagement.getContent("species_factsheet-pdf_92")%>.');
<%
   }
    else
   {
%>
      updateText('<%=contentManagement.getContent("species_factsheet-pdf_93")%>.');
<%
   }
%>
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
    out.flush();
    if ( !error )
    {
%>
    <a title="Open PDF report. Link will open a new window." target="_blank" href="temp/<%=filename%>"><%=contentManagement.getContent( "species_factsheet-pdf_94" )%></a>
<%
    }
    else
    {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
      function feedback()
      {
        window.opener.location.href="feedback.jsp?feedbackType=Software%20bugs&module=EUNIS%20Species&url=Species%20PDF%20factsheet%20generation%20failed for species <%=Utilities.treatURLSpecialCharacters(Utilities.removeQuotes( factsheet.getSpeciesObject().getScientificName() ))%> with ID=<%=factsheet.getIdSpecies()%>, ID_link=<%=factsheet.getIdSpeciesLink()%>%>.";
        this.close();
      }
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <%=contentManagement.getContent( "species_factsheet-pdf_95" )%>
    <a title="Feedback" href="javascript:feedback();"><%=contentManagement.getContent( "species_factsheet-pdf_96" )%></a>.
    <%=contentManagement.getContent( "species_factsheet-pdf_97" )%>
<%
    }
    out.flush();
  }
  else
  {
%>
      <%=contentManagement.getContent( "species_factsheet-pdf_98" )%> <%=factsheet.getIdSpecies()%>
      <br/>
      <br/>
      <label for="button2" class="noshow"><%=contentManagement.getContent( "species_factsheet-pdf_99", false )%></label>
      <input id="button2" title="<%=contentManagement.getContent("species_factsheet-pdf_99", false )%>" type="button"
       onclick="javascript:window.close();"
       value="<%=contentManagement.getContent("species_factsheet-pdf_99", false )%>" name="button"
       class="inputTextField"/>
      <%=contentManagement.writeEditTag( "species_factsheet-pdf_99" )%>
<%
  }
%>
    </div>
  </body>
</html>