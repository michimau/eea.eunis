<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports upload page' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  int maxSize = Utilities.checkedStringToInt( application.getInitParameter( "UPLOAD_FILE_MAX_SIZE" ), 10485760 ) / 1048576;
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("upload_manager")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
    function validateForm() {
      if (document.uploadFile.filename.value == "")
      {
        alert("<%=cm.cms("related_reports_upload_empty")%>.");
        return false;
      }
      if (document.uploadFile.description.value == "" ||
          document.uploadFile.description.value == "<%=cm.cms("related_reports_upload_description_value")%>") {
          alert("<%=cm.cms("related_reports_upload_validate_description")%>.");
          return false;
      }
      return true;
    }
  //-->
  </script>
</head>

<body bgcolor="#ffffff">
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT()) {
%>
<form action="<%=application.getInitParameter("DOMAIN_NAME")%>/fileupload" method="post" enctype="multipart/form-data" name="uploadFile" onsubmit="return validateForm();">
  <input type="hidden" name="uploadType" value="file" /><br />

  <label for="filename"><%=cm.cmsText("related_reports_upload_filetoupload_label")%>:</label><br />
  <input title="<%=cm.cms("related_reports_upload_filetoupload_title")%>" id="filename" name="filename" type="file" size="50" /><br />
  <%=cm.cmsTitle("related_reports_upload_filetoupload_title")%>
  <%=cm.cmsText("related_reports_upload_filetoupload_description")%>
  <br />
  <%=cm.cmsText("related_reports_upload_filetoupload_notice")%> <strong><%=maxSize%> MB</strong>.
  <br />
  <p>
    <label for="description"><%=cm.cmsText("document_description")%>:</label>
    <br />
    <textarea title="<%=cm.cms("document_description")%>" id="description" name="description" cols="60" rows="5"><%=cm.cms("related_reports_upload_description_value")%></textarea>
    <%=cm.cmsTitle("document_description")%>
    <%=cm.cmsInput("related_reports_upload_description_value")%>
  </p>
  <p>
    <input title="<%=cm.cms("reset_values")%>" type="reset" name="Reset" id="Reset" value="<%=cm.cms("reset")%>" class="standardButton" />
    <%=cm.cmsTitle("reset_values")%>
    <%=cm.cmsInput("reset")%>

    <input title="<%=cm.cms("upload_document")%>" type="submit" name="Submit" id="Submit" value="<%=cm.cms("upload")%>" class="searchButton" />
    <%=cm.cmsTitle("upload_document")%>
    <%=cm.cmsInput("upload")%>

    <input type="button" onclick="javascript:window.close();" value="<%=cm.cms("close_window")%>" title="<%=cm.cms("close_window")%>" id="button2" name="button" class="standardButton" />
    <%=cm.cmsTitle("close_window")%>
    <%=cm.cmsInput("close_window")%>
  </p>
</form>
<%
  String message = request.getParameter("message");
  if(null != message)
  {
%>
<p>
  <strong><%=message%></strong>
</p>
<%
  }
%>
  <strong>
    <%=cm.cmsText("related_reports_upload_pending")%>.
  </strong>
<script language="JavaScript" type="text/javascript">
<!--
  window.opener.location.href='related-reports.jsp';
//-->
</script>
<%
}
else
{
%>
  <%=cm.cmsText("related_reports_upload_unauthorized")%>.
  <br />
  <form action="">
    <input type="button" onclick="javascript:window.close();" value="<%=cm.cms("close_window")%>" title="<%=cm.cms("close_window")%>" id="button1" name="button" class="standardButton" />
    <%=cm.cmsTitle("close_window")%>
    <%=cm.cmsInput("close_window")%>
  </form>
<%
  }
%>
    <%=cm.cmsMsg("upload_manager")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_empty")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_validate_description")%>
  </body>
</html>
