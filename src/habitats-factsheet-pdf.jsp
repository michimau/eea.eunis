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
      <%=cm.cms("habitats_factsheet-pdf_title")%>
    </title>
  </head>
  <body>
    <div id="imgtop">
      <img alt="" src="images/progress/top.jpg" width="400" height="178">
    </div>
    <img id="loading" src="<%=request.getContextPath()%>/images/loading_tsv.gif" width="200" height="10" alt="<%=cm.cms("loading_animation")%>" />
    <%=cm.cmsTitle("loading_animation")%>
    <div id="status">
      &nbsp;
    </div>
    <script language="JavaScript" type="text/javascript">
      <!--
        updateText( "<%=cm.cms("habitats_factsheet-pdf_01")%>" );
      //-->
    </script>
<%
  cm.cmsMsg("habitats_factsheet-pdf_04");
  cm.cmsMsg("habitats_factsheet-pdf_05");
  cm.cmsMsg("habitats_factsheet-pdf_06");

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
      f.add(new Phrase(cm.cms("habitats_factsheet-pdf_04"),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136))));
      f.add(new Phrase("                                                                                                                                     ",FontFactory.getFont(FontFactory.HELVETICA, 9)));
      f.add(new Phrase(cm.cms("habitats_factsheet-pdf_05") + ": " + application.getInitParameter("LAST_UPDATE"),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136))));
      f.add(new Phrase("                                                                                                                                                                                                                                                          ", FontFactory.getFont(FontFactory.HELVETICA, 9)));
      report.setFooter(f);
      report.init(linktopdf + filename);

      SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
      report.writeln(cm.cms("habitats_factsheet-pdf_06") + ": " + df.format(new Date()),FontFactory.getFont(FontFactory.HELVETICA, 8, Font.ITALIC, new Color(24, 40, 136)));

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
      updateText('<%=cm.cms("habitats_factsheet-pdf_54")%>');
<%
     }
      else
     {
%>
      showLoadingProgress( false );
      updateText('<%=cm.cms("habitats_factsheet-pdf_55")%>');
<%
     }
%>
      //-->
    </script>
<%
    out.flush();
%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_54")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_55")%>
    <%=cm.br()%>
<%
    if(!error)
    {
%>
  <a target="_blank" href="temp/<%=filename%>"><%=cm.cmsText("habitats_factsheet-pdf_56")%></a>
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
    <%=cm.cmsText("habitats_factsheet-pdf_57")%>
    <a href="javascript:feedback();"><%=cm.cmsText("habitats_factsheet-pdf_58")%></a>.
    <%=cm.cmsText("habitats_factsheet-pdf_59")%>
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
    <input type="button" onclick="javascript:window.close();" value="<%=cm.cms("habitats_factsheet-pdf_61")%>" name="button" class="inputTextField">
    <%=cm.cmsInput("habitats_factsheet-pdf_61")%>
<%
  }
%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_04")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_05")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_06")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("habitats_factsheet-pdf_01")%>
  </body>
</html>