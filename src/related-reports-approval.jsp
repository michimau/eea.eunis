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
  String uploadDir = application.getInitParameter( "TOMCAT_HOME" ) + "/" + application.getInitParameter("UPLOAD_DIR_FILES");
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("related_reports_approval_page_title")%>
  </title>
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
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
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
                <br />
                <strong>
                  <%=cm.cmsPhrase("No documents are pending for approval at this time")%>.
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
                <%=cm.cmsPhrase("You are not authorized to use the functionality of this page")%>.
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
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="related-reports-approval.jsp"/>
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
