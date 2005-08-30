<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : PDF of habitat factsheet.
--%>
<%@ page contentType="text/html" %>
<%@ page import="com.lowagie.text.*,
                com.lowagie.text.Font,
                com.lowagie.text.Image,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.factsheet.habitats.DescriptionWrapper,
                ro.finsiel.eunis.factsheet.habitats.HabitatFactsheetRelWrapper,
                ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                ro.finsiel.eunis.factsheet.habitats.SyntaxaWrapper,
                ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                ro.finsiel.eunis.jrfTables.Chm62edtHabitatInternationalNamePersist,
                ro.finsiel.eunis.jrfTables.HabitatOtherInfo,
                ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatCountryPersist,
                ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist,
                ro.finsiel.eunis.jrfTables.habitats.factsheet.OtherClassificationPersist,
                ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectDomain,
                ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.sites.SitesSearchUtility,
                ro.finsiel.eunis.search.species.factsheet.HabitatsSpeciesWrapper,
                java.awt.*,
                java.text.SimpleDateFormat,
                java.util.Date,
                java.util.List,
                java.util.Properties,
                ro.finsiel.eunis.factsheet.PDFHabitatsFactsheet,
                ro.finsiel.eunis.reports.pdfReport,
                java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
      <!--
      function updateText(txt)
      {
        document.getElementById("status").innerHTML=txt;
      }
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <title>
      <%=contentManagement.getContent("habitats_factsheet-pdf_title")%>
    </title>
  </head>
  <body>
    <div id="imgtop">
      <img alt="" src="images/progress/top.jpg" width="400" height="178">
    </div>
    <div id="status">
      &nbsp;
    </div>
    <script language="JavaScript" type="text/javascript">
      <!--
        updateText( "<%=contentManagement.getContent("habitats_factsheet-pdf_01")%>" );
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
  String idHabitat = request.getParameter("idHabitat");
  pdfReport report = new pdfReport();
  String linktopdf = application.getInitParameter("TOMCAT_HOME") + "/webapps/eunis/temp/";
  String filename = "HabitatFactsheet_" + request.getSession().getId() + ".pdf";
  out.flush();
  HabitatsFactsheet factsheet = new HabitatsFactsheet(idHabitat);
  if(null != factsheet.getHabitat())
  {
    boolean error = false;
    try
    {
      String typeString = "";
      // Headers and footers
      Paragraph h = new Paragraph();
      String jpegPath = application.getInitParameter("TOMCAT_HOME") + "/webapps/eunis/images/headerpdf.jpg";
      Image jpeg = Image.getInstance(jpegPath);
      h.add(jpeg);
      report.setHeader(h);
      // IMPORTANT: THESE LINKS SHOULD BE CHANGED TO THEIR ACTUAL SERVER VALUE!!!
      Paragraph f = new Paragraph();
      f.add(new Phrase(contentManagement.getContent("habitats_factsheet-pdf_04"),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136))));
      f.add(new Phrase("                                                                                                                                     ",FontFactory.getFont(FontFactory.HELVETICA, 9)));
      f.add(new Phrase(contentManagement.getContent("habitats_factsheet-pdf_05") + ": " + application.getInitParameter("LAST_UPDATE"),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136))));
      f.add(new Phrase("                                                                                                                                                                                                                                                          ", FontFactory.getFont(FontFactory.HELVETICA, 9)));
      report.setFooter(f);
      report.init(linktopdf + filename);

      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      report.writeln(contentManagement.getContent("habitats_factsheet-pdf_06") + ": " + df.format(new Date()),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136)));

      PDFHabitatsFactsheet pdfFactsheet = new PDFHabitatsFactsheet( idHabitat, report, contentManagement );
      pdfFactsheet.generateFactsheet();

      // Close the PDF file and flush the output to client
      report.close();
      out.flush();
    }
    catch(Exception _ex)
    {
      error = true;
      _ex.printStackTrace();
    }
%>
    <script language="JavaScript" type="text/javascript">
      <!--
<%
     if ( error )
     {
%>
      updateText('<%=contentManagement.getContent("habitats_factsheet-pdf_54")%>');
<%
     }
      else
     {
%>
      updateText('<%=contentManagement.getContent("habitats_factsheet-pdf_55")%>');
<%
     }
%>
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
    out.flush();
    if(!error)
    {
%>
  <a target="_blank" href="temp/<%=filename%>"><%=contentManagement.getContent("habitats_factsheet-pdf_56")%></a>
<%
    }
    else
    {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
      function feedback()
      {
        window.opener.location.href="feedback.jsp?feedbackType=Software%20bugs&module=EUNIS%20Habitats&url=Habitat%20PDF%20factsheet%20generation%20failed for habitat '<%=Utilities.removeQuotes(factsheet.getHabitatDescription())%>' with ID=<%=idHabitat%>.";
        this.close();
      }
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <%=contentManagement.getContent("habitats_factsheet-pdf_57")%>
    <a href="javascript:feedback();"><%=contentManagement.getContent("habitats_factsheet-pdf_58")%></a>.
    <%=contentManagement.getContent("habitats_factsheet-pdf_59")%>
<%
    }
    out.flush();
  }
  else
  {
%>
    <p>
      <%=contentManagement.getContent("habitats_factsheet-pdf_60")%> (ID=<strong><%=idHabitat%></strong>).
    </p>
    <br />
    <br />
    <input type="button" onclick="javascript:window.close();" value="<%=contentManagement.getContent("habitats_factsheet-pdf_61", false)%>" name="button" class="inputTextField">
    <%=contentManagement.writeEditTag("habitats_factsheet-pdf_61")%>
<%
  }
%>
  </body>
</html>