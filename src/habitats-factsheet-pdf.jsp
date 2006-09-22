<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : PDF of habitat factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="com.lowagie.text.*,
                com.lowagie.text.Font,
                com.lowagie.text.Image,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                ro.finsiel.eunis.search.Utilities,
                java.awt.*,
                java.text.SimpleDateFormat,
                java.util.Date,
                ro.finsiel.eunis.factsheet.PDFHabitatsFactsheet,
                ro.finsiel.eunis.reports.pdfReport" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
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
    <title>
      <%=cm.cms("generating_pdf")%>
    </title>
  </head>
  <body>
    <div id="imgtop">
      <img alt="" src="images/progress/top.jpg" width="400" height="178" />
    </div>
    <img id="loading" src="<%=request.getContextPath()%>/images/loading_tsv.gif" width="200" height="10" alt="<%=cm.cms("loading_animation")%>" />
    <%=cm.cmsTitle("loading_animation")%>
    <div id="status">
      &nbsp;
    </div>
    <script language="JavaScript" type="text/javascript">
      <!--
        updateText( "<%=cm.cms("generating_pdf_wait")%>" );
      //-->
    </script>
<%
  cm.cmsMsg("source_european_topic_centre");
  cm.cmsMsg("habitats_factsheet-pdf_05");
  cm.cmsMsg("generated_on");

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
      f.add(new Phrase(cm.cms("source_european_topic_centre"),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136))));
      report.setFooter(f);
      report.init(linktopdf + filename);

      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      report.writeln(cm.cms("generated_on") + ": " + df.format(new Date()),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136)));

      PDFHabitatsFactsheet pdfFactsheet = new PDFHabitatsFactsheet( idHabitat, report, cm );
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
      showLoadingProgress( false );
      updateText('<%=cm.cms("error_generating_pdf")%>');
<%
     }
      else
     {
%>
      showLoadingProgress( false );
      updateText('<%=cm.cms("pdf_document_ready")%>');
<%
     }
%>
      //-->
    </script>
<%
    out.flush();
%>
    <%=cm.cmsMsg("error_generating_pdf")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("pdf_document_ready")%>
    <%=cm.br()%>
<%
    if(!error)
    {
%>
  <a target="_blank" href="temp/<%=filename%>"><%=cm.cmsText("open_pdf_document")%></a>
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
    <%=cm.cmsText("please_let_us_know_about_error")%>
    <a href="javascript:feedback();"><%=cm.cmsText("feedback")%></a>.
    <%=cm.cmsText("thank_you")%>
<%
    }
    out.flush();
  }
  else
  {
%>
    <p>
      <%=cm.cmsText("habitats_factsheet-pdf_60")%> (ID=<strong><%=idHabitat%></strong>).
    </p>
    <br />
    <br />
    <input type="button" onclick="javascript:window.close();" value="<%=cm.cms("close_btn")%>" name="button" class="standardButton">
    <%=cm.cmsInput("close_btn")%>
<%
  }
%>
    <%=cm.br()%>
    <%=cm.cmsMsg("generating_pdf")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("source_european_topic_centre")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_05")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("generated_on")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("generating_pdf_wait")%>
  </body>
</html>
