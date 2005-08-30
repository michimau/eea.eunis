<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports' function - search page.
--%>
<%@ page import="ro.finsiel.eunis.OSEnvironment,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.EunisRelatedReportsPersist,
                 ro.finsiel.eunis.jrfTables.users.UserPersist,
                 ro.finsiel.eunis.related_reports.RelatedReportsUtil,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.users.UsersUtility,
                 java.io.File,
                 java.text.SimpleDateFormat,
                 java.util.Date,
                 java.util.List,
                 java.util.Properties" %>
<%@ page contentType="text/html" %>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.admin.RelatedReportsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <title><%=application.getInitParameter("PAGE_TITLE")%>Additional reports related to biodiversity</title>
  <style type="text/css">
  <!--
  .tableBorder {
    border: 1px solid #000000;
  }

  -->
  </style>
  <script language="JavaScript" type="text/JavaScript">
  <!--
    function MM_callJS(jsStr) { //v2.0
      return eval(jsStr)
    }

    function ReloadPage() {
      self.location.href="related-reports.jsp";
    }

    function count_selFiles() {
      list=document.upload.filenames;
      if (!isArray(list)) {
        if (list.checked == true) {
          return 1;
        } else {
          return 0;
        }
      }
      nr=0;
      for (i = 0; i < list.length; i++) {
         if (list[i].checked == true) nr++;
      }
      return nr;
    }

    function isArray(obj) {
      var nr = parseInt(obj.length);
      if(isNaN(nr)) {
        return false;
      }
      return true;
    }

    function del_files() {
       nr=count_selFiles();
       if (!nr) {
          alert('Nothing selected');
          return false;
       } else {
          var ok = false;
          if (nr == 1) {
            return confirm('Are you sure you want to delete 1 file ?');
          } else {
            return confirm('Are you sure you want to delete ' + nr +' files ?');
          }
       }
    }

   function openUpload()
   {
      var width = 550, height = 400;
      var horizPos = centerHoriz(width);
      var vertPos = centerVert(height);
      window.open("related-reports-upload.jsp", "", "left=" + horizPos + ", top=" + vertPos + ", width=" + width + ", height=" + height + ", status=0, scrollbars=0, toolbar=0, resizable=1, location=0");
    }
  //-->
  </script>
</head>
  <body>
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Related reports"/>
  </jsp:include>
  <table summary="layout" width="100%" border="0">
    <tr>
      <td>
<%
  Properties osEnv = null;
  try {
    osEnv = OSEnvironment.getEnvVars();
  } catch(Exception e) {
    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
  }
  String uploadDir = osEnv.getProperty("TOMCAT_HOME") + "/" + application.getInitParameter("UPLOAD_DIR_FILES");
  String[] deleteFile = FormBean.getFilenames();
  String operation = FormBean.getOperation();

  // Delete the specified files from server
  if(null != operation && operation.equalsIgnoreCase("delete") && null != deleteFile) {
    RelatedReportsUtil.deleteFiles(deleteFile, uploadDir);
  }
%>
    <h5>Related reports</h5>

    <br />
    From this page you can download additional reports related to biodiversity.
<%
  // If there are documents pending, display this to the user who has such right, to know this.
  if(RelatedReportsUtil.listPendingReports().size() > 0 && SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT()) {
%>
    <br />
    Please note that some documents are uploaded and pending to be <a title="See documents waiting to be approved" href="related-reports-approval.jsp">approved</a>.
    <br />
<%
  }
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
    <br />
    <a title="Upload new document. This link will open a new page" href="javascript:openUpload();">Upload new document</a>
    <br />
<%
  }
  List approvedReportsList = RelatedReportsUtil.listApprovedReports();
  // Filter only approved documents.
  if(approvedReportsList.size() == 0)
  {
%>
    <br />
    <strong>
      No documents available for download at this time.
    </strong>
    <br />
<%
  }
  else
  {
%>
    <form name="upload" action="related-reports.jsp" method="post" onsubmit="javascript:return del_files();">
      <input type="hidden" name="operation" value="delete" />
      <div align="right" style="background-color : #EEEEEE; width : 740px;">
        <strong>
          <input type="button" name="Submit" value="Refresh list" title="Refresh document list" onclick="javascript:ReloadPage()" class="inputTextField" />
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
          <input type="submit" name="Submit" value="Delete selected" class="inputTextField" />
<%
  }
%>
        </strong>
      </div>
      <br />
      <table width="100%" border="0" cellspacing="0" cellpadding="4" class="tableBorder" summary="Uploaded files">
        <tr bgcolor="#CCCCCC">
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
          <th align="center">
            &nbsp;
          </th>
  <%
    }
  %>
          <th class="resultHeader" align="center">
            <strong>Valid</strong>
          </th>
          <th class="resultHeader">
            <strong>Description</strong>
          </th>
          <th class="resultHeader">
            <strong>File name</strong>
          </th>
          <th  class="resultHeader" style="text-align:right">
            <strong>Size(kB)</strong>
          </th>
          <th class="resultHeader" style="white-space:nowrap">
            <strong>Uploaded by</strong>
          </th>
          <th class="resultHeader">
            <strong>Date</strong>
          </th>
        </tr>
<%
  for(int i = 0; i < approvedReportsList.size(); i++)
  {
    EunisRelatedReportsPersist report = (EunisRelatedReportsPersist) approvedReportsList.get(i);
    if(null != report)
    {
      File file = new File(osEnv.getProperty("TOMCAT_HOME") + "/webapps/eunis/upload/" + report.getFileName());
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
<%
      if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
      {
 %>
          <td align="center">
            <label for="filename<%=i%>" class="noshow">Check this box to mark file for deletion</label>
            <input title="Check this box to mark file for deletion" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>" />
          </td>
  <%
      }
  %>
          <td align="center">
<%
      if(file.exists())
      {
%>
            <img src="images/mini/download.gif" title="File is downloadable" alt="File is downloadable" />
<%
      }
      else
      {
%>
            <img src="images/mini/downloadu.gif" title="Link is broken" alt="Link is broken" />
<%
      }
%>
          </td>
          <td>
            <%=report.getReportName()%>&nbsp;
          </td>
          <td>
            <a title="Link to document" href="upload/<%=report.getFileName()%>"><%=file.getName()%></a>
          </td>
          <td style="text-align:right">
<%
      long size = file.getAbsoluteFile().length();
      if(size > 0)
      {
%>
            <%=size / 1024%>
<%
      }
      else
      {
%>
            0/n.a.
<%
      }
%>
          </td>
          <td style="white-space:nowrap">
<%
      // Find the author's e-mail address in the EUNIS_USERS table.
      UserPersist user = UsersUtility.getUserByUserName(report.getRecordAuthor());
      String eMail = "";
      if(null != user) {
        eMail = Utilities.formatString(user.getEMail(), "");
        if(!eMail.equalsIgnoreCase("")) {
          eMail = " <a href=\"mailto:" + eMail.replaceAll("@", "&#64") + "\"><img src=\"images/mini/email.gif\" border=\"0\" valign=\"absmiddle\"></a>";
        }
      }
%>
            <%=report.getRecordAuthor() + eMail%>
          </td>
          <td>
<%
        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
        try {
          out.print(df.format(new Date(report.getRecordDate().getTime())));
        } catch(Exception ex) {
          out.print("<span color=\"red\">n/a</span>");
          ex.printStackTrace();
        }
%>
          </td>
        </tr>
<%
    }
  }
%>
        <tr bgcolor="#CCCCCC">
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
          <th align="center">
            &nbsp;
          </th>
<%
  }
%>
          <th  class="resultHeader" align="center">
            Valid
          </th>
          <th class="resultHeader">
            Description
          </th>
          <th class="resultHeader">
            File name
          </th>
          <th class="resultHeader" style="text-align:right">
            Size(kB)
          </th>
          <th class="resultHeader" style="white-space:nowrap">
            Uploaded by
          </th>
          <th class="resultHeader">
            Date
          </th>
        </tr>
      </table>
    </form>
<%
  }
%>
    </td>
    </tr>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="related-reports.jsp"/>
</jsp:include>
  </div>
</body>
</html>
