<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
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
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.admin.RelatedReportsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String uploadDir = application.getInitParameter("TOMCAT_HOME") + "/" + application.getInitParameter("UPLOAD_DIR_FILES");
  String[] deleteFile = FormBean.getFilenames();
  String operation = FormBean.getOperation();

  // Delete the specified files from server
  if(null != operation && operation.equalsIgnoreCase("delete") && null != deleteFile)
  {
    RelatedReportsUtil.deleteFiles(deleteFile, uploadDir);
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("related_reports_page_title")%>
  </title>
  <style type="text/css">
    .tableBorder
    {
      border: 1px solid #000000;
    }
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
          alert('<%=cm.cms("related_reports_approval_nothing")%>!');
          return false;
       } else {
          var ok = false;
          if (nr == 1) {
            return confirm('<%=cm.cms("related_reports_approval_delete1file")%> ?');
          } else {
            return confirm('<%=cm.cms("related_reports_approval_deletefiles")%> ' + nr +' <%=cm.cms("related_reports_approval_files")%> ?');
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
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,related_reports_location"/>
      </jsp:include>
    <h1>
      <%=cm.cmsText("related_reports_title")%>
    </h1>
    <br />
    <%=cm.cmsText("related_reports_description")%>.
<%
  // If there are documents pending, display this to the user who has such right, to know this.
  if(RelatedReportsUtil.listPendingReports().size() > 0 && SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
    <br />
    <%=cm.cmsText("related_reports_pendingnotice")%> <a title="<%=cm.cms("related_reports_pendinglink_title")%>" href="related-reports-approval.jsp"><%=cm.cmsText("related_reports_pendinglink")%></a>.
    <%=cm.cmsTitle("related_reports_pendinglink_title")%>
    <br />
<%
  }
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
    <br />

    <a title="<%=cm.cms("related_reports_uploadlink_title")%>" href="javascript:openUpload();"><%=cm.cmsText("related_reports_uploadlink")%></a>
    <%=cm.cmsTitle("related_reports_uploadlink_title")%>
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
      <%=cm.cmsText("related_reports_nodocs")%>.
    </strong>
    <br />
<%
  }
  else
  {
%>
    <form name="upload" action="related-reports.jsp" method="post" onsubmit="javascript:return del_files();">
      <input type="hidden" name="operation" value="delete" />
      <div align="right" style="background-color : #EEEEEE; width : 100%;">
        <strong>
          <label for="refresh" class="noshow"><%=cm.cms("related_reports_refresh_label")%></label>
          <input type="button" id="refresh" name="Submit" value="<%=cm.cms("related_reports_refresh_value")%>" title="<%=cm.cms("related_reports_refresh_title")%>" onclick="javascript:ReloadPage()" class="inputTextField" />
          <%=cm.cmsLabel("related_reports_refresh_label")%>
          <%=cm.cmsInput("related_reports_refresh_value")%>
          <%=cm.cmsTitle("related_reports_refresh_title")%>



<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
          <label for="delete" class="noshow"><%=cm.cms("related_reports_delete_label")%></label>
          <input type="submit" id="delete" name="Submit" value="<%=cm.cms("related_reports_delete_value")%>" class="inputTextField" title="<%=cm.cms("related_reports_delete_title")%>" />
          <%=cm.cmsLabel("related_reports_delete_label")%>
          <%=cm.cmsInput("related_reports_delete_value")%>
          <%=cm.cmsTitle("related_reports_delete_title")%>
<%
  }
%>
        </strong>
      </div>
      <br />
      <table width="100%" border="0" cellspacing="0" cellpadding="4" class="tableBorder" summary="Uploaded files">
        <tr>
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
%>
          <th style="text-align : center;">
            &nbsp;
          </th>
  <%
    }
  %>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("related_reports_valid")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_description_column")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_filename")%>
          </th>
          <th  class="resultHeader" style="text-align:right">
            <%=cm.cmsText("related_reports_size")%>(kB)
          </th>
          <th class="resultHeader" style="white-space:nowrap">
            <%=cm.cmsText("related_reports_author")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_date")%>
          </th>
        </tr>
<%
  for(int i = 0; i < approvedReportsList.size(); i++)
  {
    EunisRelatedReportsPersist report = (EunisRelatedReportsPersist) approvedReportsList.get(i);
    if(null != report)
    {
      File file = new File(application.getInitParameter("TOMCAT_HOME") + "/webapps/eunis/upload/" + report.getFileName());
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
<%
      if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
      {
 %>
          <td align="center">
            <label for="filename<%=i%>" class="noshow"><%=cm.cms("related_reports_file_label")%></label>
            <input title="<%=cm.cms("related_reports_file_title")%>" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>" />
            <%=cm.cmsLabel("related_reports_file_label")%>
            <%=cm.cmsTitle("related_reports_file_title")%>
          </td>
  <%
      }
  %>
          <td align="center">
<%
      if(file.exists())
      {
%>
            <img src="images/mini/download.gif" title="<%=cm.cms("related_reports_approval_download_title")%>" alt="<%=cm.cms("related_reports_approval_download_alt")%>" />
            <%=cm.cmsAlt("related_reports_approval_download_alt")%>
            <%=cm.cmsTitle("related_reports_approval_download_title")%>
<%
      }
      else
      {
%>
            <img src="images/mini/downloadu.gif" title="<%=cm.cms("related_reports_approval_downloadu_title")%>" alt="<%=cm.cms("related_reports_approval_downloadu_alt")%>" />
            <%=cm.cmsAlt("related_reports_approval_downloadu_alt")%>
            <%=cm.cmsTitle("related_reports_approval_downloadu_title")%>
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
          <th style="text-align : center;">
            &nbsp;
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("related_reports_valid")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_description_column")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_filename")%>
          </th>
          <th  class="resultHeader" style="text-align:right">
            <%=cm.cmsText("related_reports_size")%>(kB)
          </th>
          <th class="resultHeader" style="white-space:nowrap">
            <%=cm.cmsText("related_reports_author")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("related_reports_date")%>
          </th>
        </tr>
      </table>
    </form>
<%
  }
%>
      <%=cm.cmsMsg("related_reports_page_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_delete1file")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_deletefiles")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_files")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="related-reports.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
