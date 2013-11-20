<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports approval' function - search page.
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
                 java.util.Date,
                 eionet.eunis.util.Constants,
                 java.util.List" %>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.admin.RelatedReportsBean" scope="request">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String uploadDir = getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM) + application.getInitParameter("UPLOAD_DIR_FILES");
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,related_reports#related-reports.jsp,related_reports_approval_location";
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
<%
    WebContentManagement cm = SessionManager.getWebContent();
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("related_reports_approval_page_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">

  <script language="JavaScript" type="text/JavaScript">
  //<![CDATA[
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
  //]]>
  </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
<!-- MAIN CONTENT -->
        <h1>
          <%=cm.cmsPhrase("Related reports approval")%>
        </h1>

          <%
            if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT())
            {
              List pendingReportsList = RelatedReportsUtil.listPendingReports();
          %>
                <br />
                <%=cm.cmsPhrase("Please note that this files are not available for download until they are approved.<br />Below is the list of documents uploaded by users which are pending for approval.")%>
                <br />
          <%
              if(pendingReportsList.size() > 0)
              {
          %>
                <form name="approve" action="related-reports-approval.jsp" method="post">
                  <input type="hidden" name="operation" value="approve"/>
                  <table summary="Files pending to be approved" class="datatable" width="100%">
                    <thead>
                      <tr>
                        <th>
                          <%=cm.cmsPhrase("Approve")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Valid")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Description")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("File name")%>
                        </th>
                        <th style="text-align : right;">
                          <%=cm.cmsPhrase("Size")%>(kB)
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Author")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Date")%>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
          <%
                  for ( int i = 0; i < pendingReportsList.size(); i++ )
                  {
                    EunisRelatedReportsPersist report = ( EunisRelatedReportsPersist ) pendingReportsList.get( i );
                    if ( null != report )
                    {
                      String cssClass = i % 2 == 0 ? " class=\"zebraeven\"" : "";
                      File file = new File( getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM) + application.getInitParameter("UPLOAD_DIR_FILES") + report.getFileName() );
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
                    <tr<%=cssClass%>>
                      <td>
                        <label for="filename<%=i%>" class="noshow"><%=cm.cms("check_box_for_approval")%></label>
                        <input title="<%=cm.cms("check_box_for_approval")%>" type="checkbox" id="filename<%=i%>" name="filenames" value="<%=report.getFileName()%>"/>
                        <%=cm.cmsLabel("check_box_for_approval")%>
                        <%=cm.cmsTitle("check_box_for_approval")%>
                      </td>
                      <td>
          <%
                      if(file.exists())
                      {
          %>
                        <img src="images/mini/download.gif" alt="<%=cm.cms("file_is_downloadable")%>" title="<%=cm.cms("file_is_downloadable")%>" />
                        <%=cm.cmsAlt("file_is_downloadable")%>
                        <%=cm.cmsTitle("file_is_downloadable")%>
          <%
                      }
                      else
                      {
          %>
                        <img src="images/mini/downloadu.gif" alt="<%=cm.cms("file_not_available")%>" title="<%=cm.cms("file_not_available")%>" />
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
                        <a title="<%=cm.cms("related_reports_approval_downloadfile_title")%>" href="upload/<%=report.getFileName()%>"><%=file.getName()%></a>
                        <%=cm.cmsTitle("related_reports_approval_downloadfile_title")%>
                      </td>
                      <td style="text-align : right;">
                        <%=size%>
                      </td>
                      <td>
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
                    </tbody>
                    <thead>
                      <tr>
                        <th>
                          <%=cm.cmsPhrase("Approve")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Valid")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Description")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("File name")%>
                        </th>
                        <th style="text-align : right;">
                          <%=cm.cmsPhrase("Size")%>(kB)
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Author")%>
                        </th>
                        <th>
                          <%=cm.cmsPhrase("Date")%>
                        </th>
                      </tr>
                    </thead>
                  </table>
                  <br />
                  <input  type="submit" id="submitApprove" name="Submit" title="<%=cm.cms("approve_checked_files")%>"
                          value="<%=cm.cms("related_reports_approval_approve_value")%>" class="submitSearchButton" />
                  <%=cm.cmsTitle("approve_checked_files")%>
                  <%=cm.cmsInput("related_reports_approval_approve_value")%>
                  <input type="submit" id="submitDel" name="Submit" title="<%=cm.cms("delete_checked_files")%>"
                         value="<%=cm.cms("delete_selected")%>" class="submitSearchButton" onclick="return del_files();" />
                  <%=cm.cmsTitle("delete_checked_files")%>
                  <%=cm.cmsInput("delete_selected")%>
                </form>
          <%
              }
              else
              {
          %>
                <div class="error-msg">
                  <%=cm.cmsPhrase("No documents are pending for approval at this time")%>.
                </div>
          <%
              }
            }
            else
            {
              // User is not authorised to see this page
          %>
                <div class="error-msg">
                <%=cm.cmsPhrase("You are not authorised to use the functionality of this page")%>.
                </div>
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
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
