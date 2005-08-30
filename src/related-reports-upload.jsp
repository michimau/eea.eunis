<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports upload page' function - search page.
--%>
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    Upload manager
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
    function validateForm() {
      if (document.uploadFile.filename.value == "")
      {
        alert("File selection field is empty. Please select a file from your computer.");
        return false;
      }
      if (document.uploadFile.description.value == "" ||
          document.uploadFile.description.value == "Please enter a short document description here...") {
          alert("Please enter a short description of your document, default is not acceptable.");
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
  <input type="hidden" name="uploadType" value="file" />
  <br />
  <label for="filename">File to upload:</label>
  <br />
  <input title="Select file to upload from your computer" id="filename" name="filename" type="file" size="50" class="inputTextField" />
  <br />
  Press <strong>Browse</strong> to select a file from your computer or <strong>Close</strong> to finish.
  <br />
  Please notice that file size is limited to <strong>4 MB</strong>.
  <br />
  <p>
    <label for="description">Document description:</label>
    <br />
    <textarea title="Document description" id="description" name="description" cols="60" rows="5" class="inputTextField">Please enter a document description here...</textarea>
  </p>
  <p>
    <label for="Reset" class="noshow">Reset values</label>
    <input title="Reset values" type="reset" name="Reset" id="Reset" value="Reset" class="inputTextField" />
    <label for="Submit" class="noshow">Upload document</label>
    <input title="Upload document" type="submit" name="Submit" id="Submit" value="Upload" class="inputTextField" />
    <label for="Close" class="noshow">Close</label>
    <input title="Close window" type="button" name="Close" id="Close" value="Close" class="inputTextField" onclick="window.close();" />
  </p>
</form>
<%
  String message = request.getParameter("message");
  if(null != message) {
%>
<p>
  <strong><%=message%></strong>
</p>
<%
  }
%>
<strong>Uploaded documents are not made available for download, until they are approved by an EUNIS Database administrator.</strong>
<script language="JavaScript" type="text/javascript">
<!--
  window.opener.location.href='related-reports.jsp';
//-->
</script>
<%
} else {
%>
You must be logged in and have the proper rights in order to access this page.
<br />
  <form action="">
    <label for="Close1" class="noshow"></label>
    <input title="Close window" type="button" value="Close" id="Close1" onclick="javascript:window.close()" name="button" class="inputTextField" />
  </form>
<%
  }
%>
  </body>
</html>