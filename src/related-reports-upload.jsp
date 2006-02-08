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
    <%=cm.cms("related_reports_upload_page_title")%>
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
  <input title="<%=cm.cms("related_reports_upload_filetoupload_title")%>" id="filename" name="filename" type="file" size="50" class="inputTextField" /><br />
  <%=cm.cmsTitle("related_reports_upload_filetoupload_title")%>
  <%=cm.cmsText("related_reports_upload_filetoupload_description")%>
  <br />
  <%=cm.cmsText("related_reports_upload_filetoupload_notice")%> <strong><%=maxSize%> MB</strong>.
  <br />
  <p>
    <label for="description"><%=cm.cmsText("related_reports_upload_description_label")%>:</label>
    <br />
    <textarea title="<%=cm.cms("related_reports_upload_description_title")%>" id="description" name="description" cols="60" rows="5" class="inputTextField"><%=cm.cms("related_reports_upload_description_value")%></textarea>
    <%=cm.cmsTitle("related_reports_upload_description_title")%>
    <%=cm.cmsInput("related_reports_upload_description_value")%>
  </p>
  <p>
    <input title="<%=cm.cms("reset_btn_title")%>" type="reset" name="Reset" id="Reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" />
    <%=cm.cmsTitle("reset_btn_title")%>
    <%=cm.cmsInput("reset_btn_value")%>

    <input title="<%=cm.cms("related_reports_upload_uploadbtn_title")%>" type="submit" name="Submit" id="Submit" value="<%=cm.cms("related_reports_upload_uploadbtn_value")%>" class="inputTextField" />
    <%=cm.cmsTitle("related_reports_upload_uploadbtn_title")%>
    <%=cm.cmsInput("related_reports_upload_uploadbtn_value")%>

    <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_label")%>" title="<%=cm.cms("close_window_label")%>" id="button2" name="button" class="inputTextField" />
    <%=cm.cmsTitle("close_window_label")%>
    <%=cm.cmsInput("close_window_label")%>
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
    <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_label")%>" title="<%=cm.cms("close_window_label")%>" id="button1" name="button" class="inputTextField" />
    <%=cm.cmsTitle("close_window_label")%>
    <%=cm.cmsInput("close_window_label")%>
  </form>
<%
  }
%>
    <%=cm.cmsMsg("related_reports_upload_page_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_empty")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_validate_description")%>
  </body>
</html>