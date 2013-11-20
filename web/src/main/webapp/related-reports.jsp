<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
                 eionet.eunis.util.Constants,
                 java.util.Properties" %>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.admin.RelatedReportsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String uploadDir = getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM) + application.getInitParameter("UPLOAD_DIR_FILES");
  String[] deleteFile = FormBean.getFilenames();
  String operation = FormBean.getOperation();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,related_reports";

  // Delete the specified files from server
  if(null != operation && operation.equalsIgnoreCase("delete") && null != deleteFile)
  {
    RelatedReportsUtil.deleteFiles(deleteFile, uploadDir);
  }
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("related_reports_page_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">

      <script language="JavaScript" type="text/JavaScript">
      //<![CDATA[
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
      //]]>
      </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
<!-- MAIN CONTENT -->
          <h1>
            <%=cm.cmsPhrase("Downloads and links")%>
          </h1>

		<p class="documentDescription">
              <%=cm.cmsPhrase("From this page you can download additional reports related to biodiversity")%>.
		</p>
          <%
            // If there are documents pending, display this to the user who has such right, to know this.
            if(RelatedReportsUtil.listPendingReports().size() > 0 && SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
            {
          %>
              <br />
              <%=cm.cmsPhrase("Please note that some documents are uploaded and pending to be")%> <a title="<%=cm.cms("related_reports_pendinglink_title")%>" href="related-reports-approval.jsp"><%=cm.cmsPhrase("approved")%></a>.
              <%=cm.cmsTitle("related_reports_pendinglink_title")%>
              <br />
          <%
            }
            if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
            {
          %>
              <br />

              <a title="<%=cm.cms("related_reports_uploadlink_title")%>" href="javascript:openUpload();"><%=cm.cmsPhrase("Upload new document")%></a>
              <%=cm.cmsTitle("related_reports_uploadlink_title")%>
              <br />
          <%
            }
            List approvedReportsList = RelatedReportsUtil.listApprovedReports();
            // Filter only approved documents.
            if(approvedReportsList.size() == 0)
            {
          %>
              <p>
              <strong>
                <%=cm.cmsPhrase("No documents available for download at this time")%>.
              </strong>
              </p>
          <%
            }
            else
            {
          %>
              <form name="upload" action="related-reports.jsp" method="post" onsubmit="javascript:return del_files();">
                <input type="hidden" name="operation" value="delete" />
                <div align="right" style="background-color : #EEEEEE; width : 100%;">
                  <strong>
                    <input type="button" id="refresh" name="Submit" value="<%=cm.cms("refresh_list")%>"
                           title="<%=cm.cms("related_reports_refresh_title")%>" onclick="javascript:ReloadPage()" class="standardButton" />
                    <%=cm.cmsInput("refresh_list")%>
                    <%=cm.cmsTitle("related_reports_refresh_title")%>



          <%
            if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
            {
          %>
                    <input type="submit" id="delete" name="Submit" value="<%=cm.cms("delete_selected")%>" class="submitSearchButton" title="<%=cm.cms("related_reports_delete_title")%>" />
                    <%=cm.cmsInput("delete_selected")%>
                    <%=cm.cmsTitle("related_reports_delete_title")%>
          <%
            }
          %>
                  </strong>
                </div>
                <br />
                <table width="100%" border="0" cellspacing="0" cellpadding="4" summary="Uploaded files" id="upload1" class="datatable">
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
                    <th>
                      <%=cm.cmsPhrase("Valid")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("File name")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Size")%>(kB)
                    </th>
                    <th style="white-space:nowrap">
                      <%=cm.cmsPhrase("Uploaded by")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Date")%>
                    </th>
                  </tr>
          <%
            for(int i = 0; i < approvedReportsList.size(); i++)
            {
              EunisRelatedReportsPersist report = (EunisRelatedReportsPersist) approvedReportsList.get(i);
              if(null != report)
              {
                File file = new File(getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM) + application.getInitParameter("UPLOAD_DIR_FILES") + report.getFileName());
          %>
                  <tr class="<%=(0 == (i % 2) ? "zebraodd" : "zebraeven")%>">
          <%
                if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
                {
           %>
                    <td align="center">
                      <label for="filename<%=i%>" class="noshow"><%=cm.cms("check_box_for_deletion")%></label>
                      <input title="<%=cm.cms("check_box_for_deletion")%>" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>" />
                      <%=cm.cmsLabel("check_box_for_deletion")%>
                      <%=cm.cmsTitle("check_box_for_deletion")%>
                    </td>
            <%
                }
            %>
                    <td align="center">
          <%
                if(file.exists())
                {
          %>
                      <img src="images/mini/download.gif" title="<%=cm.cms("file_is_downloadable")%>" alt="<%=cm.cms("file_is_downloadable")%>" />
                      <%=cm.cmsAlt("file_is_downloadable")%>
                      <%=cm.cmsTitle("file_is_downloadable")%>
          <%
                }
                else
                {
          %>
                      <img src="images/mini/downloadu.gif" title="<%=cm.cms("file_not_available")%>" alt="<%=cm.cms("file_not_available")%>" />
                      <%=cm.cmsAlt("file_not_available")%>
                      <%=cm.cmsTitle("file_not_available")%>
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
                    <td>
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
                <br />
                <%=cm.cmsText("related_reports_links")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>