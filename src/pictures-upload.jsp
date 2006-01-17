<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Upload pictures for sites, species and habitats
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.PicturesHelper,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.admin.EUNISUploadServlet"%><%@ page import="java.io.File"%><%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  // Request parameters
  // idobject - ID object (eg. ID_SPECIES / ID_HABITAT / ID_SITE)
  // natureobjecttype - Type of nature object to upload (eg. Species, Habitats, Sites)
  String operation = request.getParameter("operation");
  String IDObject = request.getParameter("idobject");
  String NatureObjectType = request.getParameter("natureobjecttype");
  String filename = request.getParameter("filename");// Used only for deletion
  String message = request.getParameter("message");
  String scientificName = "";
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("species"))
  {
    scientificName = PicturesHelper.findSpeciesByIDObject(IDObject);
  }
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Sites"))
  {
    scientificName = PicturesHelper.findSitesByIDObject(IDObject);
  }
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Habitats"))
  {
    scientificName = PicturesHelper.findHabitatsByIDObject(IDObject);
  }
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
      <!--
        function validateForm() {
          if (document.uploadPicture.filename.value == "") {
            alert("<%=cm.cms("pictures_upload_click_browse")%>");
            return false;
          }
          if (document.uploadPicture.description.value.length > 255) {
            alert("<%=cm.cms("pictures_upload_limit_description")%>");
            return false;
          }
          return true;
        }
      //-->
    </script>
      <title>
        <%=cm.cms("pictures_upload_page_title")%>
        <%=scientificName%>
      </title>
  </head>
  <body>
<%
  if (SessionManager.isAuthenticated() && SessionManager.isUpload_pictures_RIGHT())
  {
    if (null != IDObject && null != NatureObjectType && null != operation && operation.equalsIgnoreCase("upload"))
    {
%>
    <p>
      <%=cm.cmsText("pictures_upload_description")%> <strong><%=scientificName%></strong>.
    </p>
    <p>
      <%=cm.cmsText("pictures_upload_browse")%>.
      <br />
    </p>
    <%
      String contextPath = request.getContextPath();
      if( contextPath.endsWith( "/" ) )
      {
        contextPath += "fileupload";
      }
      else
      {
        contextPath += "/fileupload";
      }
    %>
    <form action="<%=contextPath%>" method="post" enctype="multipart/form-data" name="uploadPicture" onsubmit="return validateForm();">
      <input type="hidden" name="uploadType" value="picture" />
      <input type="hidden" name="natureobjecttype" value="<%=NatureObjectType%>" />
      <input type="hidden" name="idobject" value="<%=IDObject%>" />
      <p>
        <label for="filename" class="noshow"><%=cm.cms("pictures_upload_filename_label")%></label>
        <input id="filename" name="filename" type="file" size="50" class="inputTextField" title="<%=cm.cms("pictures_upload_filename_label")%>" />
        <%=cm.cmsLabel("pictures_upload_filename_label")%>
      </p>
      <p>
        <%=cm.cmsText("pictures_upload_pictures_description")%>
        <br />
        <label for="description" class="noshow"><%=cm.cms("pictures_upload_description_label")%></label>
        <textarea id="description" name="description" cols="60" rows="5" class="inputTextField" title="<%=cm.cms("pictures_upload_description_label")%>"></textarea>
        <%=cm.cmsLabel("pictures_upload_description_label")%>
      </p>
      <p>
        <input type="reset" id="reset" title="<%=cm.cms("pictures_upload_reset_title")%>" name="Reset" value="<%=cm.cms("pictures_upload_reset_value")%>" class="inputTextField" />
        <%=cm.cmsTitle("pictures_upload_reset_title")%>
        <%=cm.cmsInput("pictures_upload_reset_value")%>

        <input type="submit" id="submit" title="<%=cm.cms("pictures_upload_upload_title")%>" name="Submit" value="<%=cm.cms("pictures_upload_upload_value")%>" class="inputTextField" />
        <%=cm.cmsTitle("pictures_upload_upload_title")%>
        <%=cm.cmsInput("pictures_upload_upload_value")%>

        <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button0" name="button" class="inputTextField" />
        <%=cm.cmsTitle("close_window_title")%>
        <%=cm.cmsInput("close_window_value")%>
      </p>
    </form>
<%
      if (null != message)
      {
%>
    <p>
      <%=message%>
    </p>
<%
      }
    }
    else if (null != IDObject && null != NatureObjectType && null != operation && operation.equalsIgnoreCase("delete"))
    {
      boolean ret = PicturesHelper.deletePicture(IDObject, NatureObjectType, scientificName, filename);
      // Delete picture physically from disk
      String tomcatHome = application.getInitParameter( "TOMCAT_HOME" );
      String baseDir = "";
      if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("species"))
      {
        baseDir = application.getInitParameter( "UPLOAD_DIR_PICTURES_SPECIES" );
      }
      if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Sites"))
      {
        baseDir = application.getInitParameter( "UPLOAD_DIR_PICTURES_SITES");
      }
      if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Habitats"))
      {
        baseDir = application.getInitParameter( "UPLOAD_DIR_PICTURES_HABITATS");
      }
      String absoluteFilename = tomcatHome + "/" + baseDir + filename;
      File absolutFile = new File( absoluteFilename );
      if ( absolutFile.exists() )
      {
        System.out.println( "removing file:" + absoluteFilename );
        absolutFile.delete();
      }
%>
    <%-- Delete the picture --%>
    <script language="JavaScript" type="text/javascript">
      <!--
<%
      if (ret)
      {
%>
      alert("<%=cm.cms("pictures_upload_success")%>.");
<%
      }
      else
      {
%>
      alert("<%=cm.cms("pictures_upload_error")%>!");
<%
      }
%>
      this.location.href="pictures.jsp?idobject=<%=IDObject%>&natureobjecttype=<%=NatureObjectType%>";
      //-->
    </script>
<%
    }
    else
    {
%>
    <%=cm.cms("pictures_upload_denied")%>.
    <br />
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button1" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close_window_title")%>
      <%=cm.cmsInput("close_window_value")%>
    </form>
<%
    }
  }
  else
  {
%>
    <%=cm.cms("pictures_upload_login")%>.
    <br />
    <div style="width : 100%; text-align:left;">
      <form action="">
        <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button2" name="button" class="inputTextField" />
        <%=cm.cmsTitle("close_window_title")%>
        <%=cm.cmsInput("close_window_value")%>
      </form>
    </div>
<%
  }
%>
    <%=cm.cmsMsg("pictures_upload_click_browse")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("pictures_upload_limit_description")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("pictures_upload_page_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("pictures_upload_success")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("pictures_upload_error")%>
  </body>
</html>