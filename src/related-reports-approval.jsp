<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports approval' function - search page.
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
<%
  Properties osEnv = null;
  try
  {
    osEnv = OSEnvironment.getEnvVars();
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  String uploadDir = osEnv.getProperty("TOMCAT_HOME") + "/" + application.getInitParameter("UPLOAD_DIR_FILES");
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
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <title><%=application.getInitParameter("PAGE_TITLE")%>Reports approval page</title>
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
          alert('Nothing selected');
          return false;
       } else {
          var ok = false;
          if (nr == 1) {
            ok = confirm('Are you sure you want to delete 1 file ?');
          } else {
            ok = confirm('Are you sure you want to delete ' + nr +' files ?');
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
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Related reports#related-reports.jsp,Approval"/>
      </jsp:include>
      <h5>
        Related reports approval
      </h5>
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
  {
    List pendingReportsList = RelatedReportsUtil.listPendingReports();
%>
      <br />
      Please note that this files are not available for download until they are approved.
      <br />
      Below is the list of documents uploaded by users which are pending for approval.
      <br />
<%
    if(pendingReportsList.size() > 0)
    {
%>
      <form name="approve" action="related-reports-approval.jsp" method="post">
        <input type="hidden" name="operation" value="approve"/>
        <table summary="Files pending to be approved" width="100%" border="1" cellspacing="0" cellpadding="4" style="border-collapse : collapse;">
          <tr bgcolor="#CCCCCC">
            <th class="resultHeader" align="center">
              Approve
            </th>
            <th class="resultHeader" align="center">
              Valid
            </th>
            <th class="resultHeader">
              Document description
            </th>
            <th class="resultHeader">
              File name
            </th>
            <th class="resultHeader">
              Size(kB)
            </th>
            <th class="resultHeader">
              Author
            </th>
            <th class="resultHeader">
              Date
            </th>
          </tr>
<%
        for ( int i = 0; i < pendingReportsList.size(); i++ )
        {
          EunisRelatedReportsPersist report = ( EunisRelatedReportsPersist ) pendingReportsList.get( i );
          if ( null != report )
          {
            File file = new File( osEnv.getProperty( "TOMCAT_HOME" ) + "/webapps/eunis/upload/" + report.getFileName() );
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
              <label for="filename<%=i%>" class="noshow">Check this box to mark file for approval or deletion</label>
              <input title="Check this box to mark file for approval or deletion" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>"/>
            </td>
            <td align="center">
<%
            if(file.exists())
            {
%>
              <img src="images/mini/download.gif" alt="File is downloadable" title="File is downloadable" />
<%
            }
            else
            {
%>
              <img src="images/mini/downloadu.gif" alt="Link is broken" title="Link is broken" />
<%
            }
%>
            </td>
            <td>
              <%=report.getReportName()%>&nbsp;
            </td>
            <td>
              <a title="Download file to your computer" href="upload/<%=report.getFileName()%>"><%=file.getName()%></a>
            </td>
            <td>
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
        </table>
        <br />
        <label for="submitApprove" class="noshow">Approve checked files</label>
        <input  type="submit" id="submitApprove" name="Submit" title="Approve checked files" value="Approve selected" class="inputTextField" />
        <label for="submitDel" class="noshow">Delete checked files</label>
        <input type="submit" id="submitDel" name="Submit" title="Delete checked files" value="Delete selected" class="inputTextField" onclick="return del_files();" />
      </form>
<%
    }
    else
    {
%>
      <br />
      <strong>No documents are pending for approval at this time.</strong>
      <br />
<%
    }
  }
  else
  {
    // User is not authorized to see this page
%>
      <br />
      You are not authorized to use the functionality of this page.
      <br />
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="related-reports-approval.jsp"/>
      </jsp:include>
    </div>
  </body>
</html>