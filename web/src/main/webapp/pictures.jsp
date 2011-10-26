<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display pictures in factsheet
--%>
<%@page import="ro.finsiel.eunis.utilities.EunisUtil"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.*,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.factsheet.PicturesHelper"%><%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String IdObject = request.getParameter("idobject");
  if(IdObject == null || IdObject.length()==0)
  {
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        window.close();
      //]]>
    </script>
<%
  }
  String NatureObjectType = request.getParameter("natureobjecttype");
  if(NatureObjectType == null || NatureObjectType.length()==0)
  {
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        window.close();
      //]]>
    </script>
<%
  }
  // Test the error parameter to see if an error was encountered during the redirect from upload page.
  String message = request.getParameter("message");
  if (null != message)
  {
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
          alert("<%=message%>");
      //]]>
    </script>
<%
  }
  // The dir base where each set of pictures are located (for species, sites)
  String dirBase = "";
  if (NatureObjectType.equalsIgnoreCase("Species")) { dirBase = "images/species/"; }
  if (NatureObjectType.equalsIgnoreCase("Sites")) { dirBase = "images/sites/"; }
  if (NatureObjectType.equalsIgnoreCase("Habitats")) { dirBase = "images/habitats/"; }
  String filename;
  String name;
  String description;
  String license="";
  String source;
  String sourceUrl;
  String firstimage="";
  String firstdescription="";
  String firstsource="";
  // List of pictures.
  List pictures = PicturesHelper.findPicturesForSpecies(IdObject, NatureObjectType);
  String scientificName = "";
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Species")) {
    scientificName = PicturesHelper.findSpeciesByIDObject(IdObject);
  }
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Sites")) {
    scientificName = PicturesHelper.findSitesByIDObject(IdObject);
  }
  if (null != NatureObjectType && NatureObjectType.equalsIgnoreCase("Habitats")) {
    scientificName = PicturesHelper.findHabitatsByIDObject(IdObject);
  }
  if(null != pictures && pictures.size() > 0)
  {
    Iterator it = pictures.iterator();
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        var image_dir = ""
        var ImageNum = 0;
        imageArray = new Array();
        nameArray = new Array();
        descriptionArray = new Array();
        sourceArray = new Array();
<%
    while (it.hasNext())
    {
      Chm62edtNatureObjectPicturePersist picture = (Chm62edtNatureObjectPicturePersist)it.next();
      filename = picture.getFileName();
      name=picture.getName();
      description=picture.getDescription();
      license=picture.getLicense();
      source=picture.getSource();
      sourceUrl=picture.getSourceUrl();
      if (sourceUrl != null && !sourceUrl.equals("")) {
          source = "<a href=\"" + EunisUtil.replaceTags(sourceUrl, true, true) + "\">" + source + "</a>";
      }
      if(firstimage.equalsIgnoreCase(""))
      {
        firstimage = filename;
        firstdescription = description;
        firstsource = source;
      }
%>
        imageArray[ImageNum] = new imageItem("<%=dirBase + filename%>");
        nameArray[ImageNum] = "<%=name%>";
        descriptionArray[ImageNum] = "<%=description%>";
        sourceArray[ImageNum] = "<%=cm.cmsPhrase("Source")%>: <%=source%>";
        licenseArray[ImageNum] = "<%=cm.cmsPhrase("License")%>: <%=license%>";
        ImageNum++;
<%
    }
%>
        var number_of_image = imageArray.length;

        function imageItem(image_location) {
          this.image_item = new Image();
          this.image_item.src = image_location;
        }

        function get_ImageItemLocation(imageObj) {
          return(imageObj.image_item.src)
        }

        function nextImage(place) {
          var new_image = getNextImage();
          document[place].src = new_image;
          document.getElementById('picture_name').innerHTML=nameArray[ImageNum];
          document.getElementById('picture_description').innerHTML=descriptionArray[ImageNum];
          document.getElementById('picture_source').innerHTML=sourceArray[ImageNum];
          document.getElementById('picture_license').innerHTML=licenseArray[ImageNum];
        }

        function getNextImage() {
          ImageNum = (ImageNum+1) % number_of_image;
          var new_image = get_ImageItemLocation(imageArray[ImageNum]);
          return(new_image);
        }

        function prevImage(place) {
          var new_image = getPrevImage();
          document[place].src = new_image;
          document.getElementById('picture_name').innerHTML=nameArray[ImageNum];
          document.getElementById('picture_description').innerHTML=descriptionArray[ImageNum];
          document.getElementById('picture_source').innerHTML=sourceArray[ImageNum];
          document.getElementById('license_source').innerHTML=licenseArray[ImageNum];
        }

        function getPrevImage()
        {
          ImageNum = ImageNum-1;
          if(ImageNum < 0) {
            ImageNum = number_of_image-1;
          }
          var new_image = get_ImageItemLocation(imageArray[ImageNum]);
          return(new_image);
        }
      //]]>
    </script>
<%
  }
%>
    <title>
      <%=cm.cmsPhrase("Pictures of")%> <%=scientificName%>
    </title>
  </head>
  <body class="popup">
<%
  if(null != pictures && pictures.size() > 0)
  {
%>
    <h1 id="picture_name" style="text-align:center; font-weight:bold;">
      <%=scientificName%>
    </h1>
    <div id="picture_description" style="width : 100%; text-align:center; font-weight:bold;">
      <%=firstdescription%>
    </div>
    <div id="navRow" style="width : 100%; text-align : center;">
      <a href="javascript:prevImage('rImage')"><%=cm.cmsPhrase("&lt; Previous")%></a>
      &nbsp;&nbsp;
      <a href="javascript:nextImage('rImage')"><%=cm.cmsPhrase("Next &gt;")%></a>
    </div>
    <div style="width : 100%; text-align : center;">
      <img alt="<%=firstdescription%>" id="image" name="rImage" src="<%=dirBase + firstimage%>" border="1" style="max-width:95%; max-height:500px"/>
    </div>
    <div id="picture_source" style="text-align:right; font-weight:bold;">
      <%=cm.cmsPhrase("Source")%>: <%=firstsource%>
    </div>
    <div id="picture_license" style="text-align:right; font-weight:bold;">
      <%=cm.cmsPhrase("License")%>: <%=license%>
    </div>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        // Hide the Next and Previous links if there is only one picture
        if (imageArray.length < 2) {
          if(document.getElementById) {
            document.getElementById("navRow").style.visibility = "hidden";
          }
        }
      //]]>
    </script>
<%
  }
  else
  {
%>
  <div class="note-msg"><strong><%=cm.cmsPhrase("Sorry")%></strong>
   <p>
    <%=cm.cmsPhrase("We are sorry, but no pictures are available for")%>
    <em>
      <%=scientificName%>
    </em>
   </p>
  </div>
<%
  }
%>
    <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    <br />
<%
  if (SessionManager.isAuthenticated())
  {
%>
   <p style="text-align:right">
    [<a href="pictures-upload.jsp?idobject=<%=IdObject%>&amp;natureobjecttype=<%=NatureObjectType%>&amp;operation=upload"><%=cm.cmsPhrase("Upload new picture")%></a>]
    [<a href="javascript:deletePicture();"><%=cm.cmsPhrase("Delete picture")%></a>]
    <script type="text/javascript" language="javascript">
      //<![CDATA[
      function deletePicture() {
        if (confirm('<%=cm.cms("pictures_confirm")%>')) {
          var imgURI = document.getElementById("image").src;
          var uriElements = imgURI.split("/");
          var scientificName = uriElements[uriElements.length - 1];
          document.deletePicture.filename.value = scientificName;
          document.deletePicture.submit();
        }
      }
      //]]>
    </script>
    <form name="deletePicture" method="post" action="pictures-upload.jsp">
      <input type="hidden" name="idobject" value="<%=IdObject%>" />
      <input type="hidden" name="natureobjecttype" value="<%=NatureObjectType%>" />
      <input type="hidden" name="filename" value="" />
      <input type="hidden" name="operation" value="delete" />
    </form>
  </p>
<%
  }
  else
  {
%>
    <%=cm.cmsPhrase("If you were logged in, you could also add / delete pictures.")%>
<%
  }
%>
    <%=cm.cmsMsg("pictures_page_title")%>
    <%=cm.cmsMsg("pictures_confirm")%>
  </body>
</html>
