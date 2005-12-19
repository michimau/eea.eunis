<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports approval' function - search page.
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
                 java.util.Date,
                 java.util.List" %>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.admin.RelatedReportsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String uploadDir = application.getInitParameter( "TOMCAT_HOME" ) + "/" + application.getInitParameter("UPLOAD_DIR_FILES");
  String operation = FormBean.getOperation();
  String[] files = FormBean.getFilenames();
  if(null != operation && operation.equalsIgnoreCase("delete")) // Delete the files
  {
    RelatedReportsUtil.deleteFiles(files, uploadDir);
  }
  if(null != operation && operation.equalsIgnoreCase("approve")) // Approve the files
  {
    RelatedReportsUtil.approveFiles(files);
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("related_reports_approval_page_title")%>
  </title>
  <script language="JavaScript" type="text/JavaScript">
  <!--
    function MM_callJS(jsStr) { //v2.0
      return eval(jsStr)
    }

    function count_selFiles() {
      list=document.approve.filenames;
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
            ok = confirm('<%=cm.cms("related_reports_approval_delete1file")%> ?');
          } else {
            ok = confirm('<%=cm.cms("related_reports_approval_deletefiles")%> ' + nr +' <%=cm.cms("related_reports_approval_files")%> ?');
          }
          if (ok) {
            document.approve.operation.value = "delete";
          }
          return ok;
       }
    }
  //-->
  </script>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,related_reports_location#related-reports.jsp,related_reports_approval_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("related_reports_approval_title")%>
      </h1>
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
    List pendingReportsList = RelatedReportsUtil.listPendingReports();
%>
      <br />
      <%=cm.cmsText("related_reports_approval_description")%>
      <br />
<%
    if(pendingReportsList.size() > 0)
    {
%>
      <form name="approve" action="related-reports-approval.jsp" method="post">
        <input type="hidden" name="operation" value="approve"/>
        <table summary="Files pending to be approved" width="100%" border="1" cellspacing="0" cellpadding="4" style="border-collapse : collapse;">
          <tr bgcolor="#CCCCCC">
            <th class="resultHeader" style="text-align : center;">
              <%=cm.cmsText("related_reports_approval_approve")%>
            </th>
            <th class="resultHeader" style="text-align : center;">
              <%=cm.cmsText("related_reports_approval_valid")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_docdescription")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_filename")%>
            </th>
            <th class="resultHeader" style="text-align : right;">
              <%=cm.cmsText("related_reports_approval_size")%>(kB)
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_author")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_date")%>
            </th>
          </tr>
<%
        for ( int i = 0; i < pendingReportsList.size(); i++ )
        {
          EunisRelatedReportsPersist report = ( EunisRelatedReportsPersist ) pendingReportsList.get( i );
          if ( null != report )
          {
            File file = new File( application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/upload/" + report.getFileName() );
            long size = file.getAbsoluteFile().length();
            if ( size > 0 ) size /= 1024;
            // Find the author's e-mail address in the EUNIS_USERS table.
            UserPersist user = UsersUtility.getUserByUserName( report.getRecordAuthor() );
            String eMail = "";
            if ( null != user )
            {
              eMail = Utilities.formatString( user.getEMail(), "" );
            }
            if(!eMail.equalsIgnoreCase(""))
            {
                eMail = " <a href=\"mailto:" + eMail.replaceAll("@", "&#64") + "\"><img src=\"images/mini/email.gif\" border=\"0\" valign=\"absmiddle\" /></a>";
            }
%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td align="center">
              <label for="filename<%=i%>" class="noshow"><%=cm.cms("related_reports_approval_check_label")%></label>
              <input title="<%=cm.cms("related_reports_approval_check_title")%>" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>"/>
              <%=cm.cmsLabel("related_reports_approval_check_label")%>
              <%=cm.cmsTitle("related_reports_approval_check_title")%>
            </td>
            <td align="center">
<%
            if(file.exists())
            {
%>
              <img src="images/mini/download.gif" alt="<%=cm.cms("related_reports_approval_download_alt")%>" title="<%=cm.cms("related_reports_approval_download_title")%>" />
              <%=cm.cmsAlt("related_reports_approval_download_alt")%>
              <%=cm.cmsTitle("related_reports_approval_download_title")%>
<%
            }
            else
            {
%>
              <img src="images/mini/downloadu.gif" alt="<%=cm.cms("related_reports_approval_downloadu_alt")%>" title="<%=cm.cms("related_reports_approval_downloadu_title")%>" />
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
              <a title="<%=cm.cms("related_reports_approval_downloadfile_title")%>" href="upload/<%=report.getFileName()%>"><%=file.getName()%></a>
              <%=cm.cmsTitle("related_reports_approval_downloadfile_title")%>
            </td>
            <td style="text-align : right;">
              <%=size%>
            </td>
            <td style="white-space:nowrap">
              <%=report.getRecordAuthor() + eMail%>
            </td>
            <td>
              <%=Utilities.formatDate( new Date(report.getRecordDate().getTime()), "yyyy/MM/dd" )%>
            </td>
          </tr>
<%
        }
      }
%>
          <tr bgcolor="#CCCCCC">
            <th class="resultHeader" style="text-align : center;">
              <%=cm.cmsText("related_reports_approval_approve")%>
            </th>
            <th class="resultHeader" style="text-align : center;">
              <%=cm.cmsText("related_reports_approval_valid")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_docdescription")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_filename")%>
            </th>
            <th class="resultHeader" style="text-align : right;">
              <%=cm.cmsText("related_reports_approval_size")%>(kB)
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_author")%>
            </th>
            <th class="resultHeader">
              <%=cm.cmsText("related_reports_approval_date")%>
            </th>
          </tr>
        </table>
        <br />
        <label for="submitApprove" class="noshow"><%=cm.cms("related_reports_approval_approve_label")%></label>
        <input  type="submit" id="submitApprove" name="Submit" title="<%=cm.cms("related_reports_approval_approve_title")%>" value="<%=cm.cms("related_reports_approval_approve_value")%>" class="inputTextField" />
        <%=cm.cmsLabel("related_reports_approval_approve_label")%>
        <%=cm.cmsTitle("related_reports_approval_approve_title")%>
        <%=cm.cmsInput("related_reports_approval_approve_value")%>
        <label for="submitDel" class="noshow"><%=cm.cms("related_reports_approval_delete_label")%></label>
        <input type="submit" id="submitDel" name="Submit" title="<%=cm.cms("related_reports_approval_delete_title")%>" value="<%=cm.cms("related_reports_approval_delete_value")%>" class="inputTextField" onclick="return del_files();" />
        <%=cm.cmsLabel("related_reports_approval_delete_label")%>
        <%=cm.cmsTitle("related_reports_approval_delete_title")%>
        <%=cm.cmsInput("related_reports_approval_delete_value")%>
      </form>
<%
    }
    else
    {
%>
      <br />
      <strong>
        <%=cm.cmsText("related_reports_approval_nonepending")%>.
      </strong>
      <br />
<%
    }
  }
  else
  {
    // User is not authorized to see this page
%>
      <br />
      <%=cm.cmsText("related_reports_approval_unauthorized")%>.
      <br />
<%
  }
%>

      <%=cm.cmsMsg("related_reports_approval_page_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_nothing")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_delete1file")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_deletefiles")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("related_reports_approval_files")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="related-reports-approval.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>