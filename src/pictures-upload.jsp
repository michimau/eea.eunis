<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Upload pictures for sites, species and habitats
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.factsheet.PicturesHelper,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.admin.EUNISUploadServlet"%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
      <!--
        function validateForm() {
          if (document.uploadPicture.filename.value == "") {
            alert("Please click 'Browse' and select the appropriate file from your computer.");
            return false;
          }
          if (document.uploadPicture.description.value.length > 255) {
            alert("The description text exceeds the limit of 255 characters. Cannot upload picture.");
            return false;
          }
          return true;
        }
      //-->
    </script>
      <title>Upload images for <%=scientificName%></title>
  </head>
  <body>
<%
  if (SessionManager.isAuthenticated() && SessionManager.isUpload_pictures_RIGHT())
  {
    if (null != IDObject && null != NatureObjectType && null != operation && operation.equalsIgnoreCase("upload"))
    {
%>
    <p>
      This page allows to upload new pictures for <strong><%=scientificName%></strong>.
    </p>
    <p>
      Please click browse and select the picture from your computer.
      <br />
    </p>
    <form action="/eunis/fileupload" method="post" enctype="multipart/form-data" name="uploadPicture" onsubmit="return validateForm();">
      <input type="hidden" name="uploadType" value="picture" />
      <input type="hidden" name="natureobjecttype" value="<%=NatureObjectType%>" />
      <input type="hidden" name="idobject" value="<%=IDObject%>" />
      <p>
        <label for="filename" class="noshow">Filename</label>
        <input id="filename" name="filename" type="file" size="50" class="inputTextField" />
      </p>
      <p>
        Picture description (max 255 characters)
        <br />
        <label for="description" class="noshow">Picture description</label>
        <textarea id="description" name="description" cols="60" rows="5"></textarea>
      </p>
      <p>
        <label for="reset" class="noshow">Reset values</label>
        <input type="reset" id="reset" title="Reset values" name="Reset" value="Reset" class="inputTextField" />
        <label for="submit" class="noshow">Upload</label>
        <input type="submit" id="submit" title="Submit" name="Submit" value="Upload" class="inputTextField" />
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
%>
    <%-- Delete the picture --%>
    <script language="JavaScript" type="text/javascript">
      <!--
<%
      if (ret)
      {
%>
      alert("Picture was successfully deleted from the server! Please refresh the parent page to refresh status.");
<%
      }
      else
      {
%>
      alert("Picture could not be deleted from the server!");
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
    This page was accessed in a wrong way.
    <br />
    <a title="Close Window" href="javascript:this.window.close()">Close</a>
<%
    }
  }
  else
  {
%>
    You must be logged in and have the 'upload pictures' right in order to access this page.
    <br />
    <div style="width : 740px; text-align:left;">
      <input type="button" onClick="javascript:window.close();" value="Close" title="Close window" name="button" class="inputTextField" />
    </div>
<%
  }
%>
  </body>
</html>