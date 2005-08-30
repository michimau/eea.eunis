<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display pictures in factsheet
--%>
<%@page contentType="text/html"%>
<%@ page import="java.util.Enumeration,
                 java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.admin.EUNISUploadServlet,
                 ro.finsiel.eunis.factsheet.PicturesHelper"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
<%
  String IdObject = request.getParameter("idobject");
  if(IdObject == null || IdObject.length()==0)
  {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
        window.close();
      //-->
    </script>
<%
  }
  String NatureObjectType = request.getParameter("natureobjecttype");
  if(NatureObjectType == null || NatureObjectType.length()==0)
  {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
        window.close();
      //-->
    </script>
<%
  }
  // Test the error parameter to see if an error was encountered during the redirect from upload page.
  String message = request.getParameter("message");
  if (null != message)
  {
%>
    <script language="JavaScript" type="text/javascript">
      <!--
          alert("<%=message%>");
      //-->
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
  String firstimage="";
  String firstdescription="";
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
      <!--
        var image_dir = ""
        var ImageNum = 0;
        imageArray = new Array();
        nameArray = new Array();
        descriptionArray = new Array();
<%
    while (it.hasNext())
    {
      Chm62edtNatureObjectPicturePersist picture = (Chm62edtNatureObjectPicturePersist)it.next();
      filename = picture.getFileName();
      name=picture.getName();
      description=picture.getDescription();
      if(firstimage.equalsIgnoreCase(""))
      {
        firstimage = filename;
        firstdescription = description;
      }
%>
        imageArray[ImageNum] = new imageItem("<%=dirBase + filename%>");
        nameArray[ImageNum] = "<%=name%>";
        descriptionArray[ImageNum] = "<%=description%>";
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
          document.all.picture_name.innerText=nameArray[ImageNum];
          document.all.picture_description.innerText=descriptionArray[ImageNum];
        }

        function getNextImage() {
          ImageNum = (ImageNum+1) % number_of_image;
          var new_image = get_ImageItemLocation(imageArray[ImageNum]);
          return(new_image);
        }

        function prevImage(place) {
          var new_image = getPrevImage();
          document[place].src = new_image;
          document.all.picture_name.innerText=nameArray[ImageNum];
          document.all.picture_description.innerText=descriptionArray[ImageNum];
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
      //-->
    </script>
    <title>
      Images of <%=scientificName%>
    </title>
  </head>
  <body>
    <div id="content">
      <div id="picture_name" style="width : 740px; text-align:center; font-weight:bold;">
        <%=scientificName%>
      </div>
      <div id="picture_description" style="width : 740px; text-align:center; font-weight:bold;">
        <%=firstdescription%>
      </div>
      <div id="navRow" style="width : 740px; text-align : center;">
        <a href="javascript:prevImage('rImage')">« Previous</a>
        &nbsp;&nbsp;
        <a href="javascript:nextImage('rImage')">Next »</a>
      </div>
      <div style="width : 740px; text-align : center;">
        <img alt="<%=firstdescription%>" id="image" name="rImage" src="<%=dirBase + firstimage%>" border="1" />
      </div>
      <script language="JavaScript" type="text/javascript">
        <!--
          // Hide the Next and Previous links if there is only one picture
          if (imageArray.length < 2) {
            if(document.getElementById) {
              document.getElementById("navRow").style.visibility = "hidden";
            }
          }
        //-->
      </script>
<%
  }
  else
  {
%>
    <title>
      Images of <%=scientificName%>
    </title>
  </head>
  <body>
    <div id="content">
    We are sorry, but no pictures are available for <strong>
      <%=scientificName%>
    </strong>
<%
  }
%>
  <a href="javascript:window.close()">Close</a>
  <br />
<%
  if (SessionManager.isAuthenticated())
  {
%>
  <a href="pictures-upload.jsp?idobject=<%=IdObject%>&amp;natureobjecttype=<%=NatureObjectType%>&amp;operation=upload">Upload new picture</a><br />
  <a href="javascript:deletePicture();">Delete picture</a><br />
  <script type="text/javascript" language="javascript">
    <!--
    function deletePicture() {
      if (confirm('Are you sure you want to delete this picture?')) {
        var imgURI = document.getElementById("image").src;
        var uriElements = imgURI.split("/");
        var scientificName = uriElements[uriElements.length - 1];
        document.deletePicture.filename.value = scientificName;
        document.deletePicture.submit();
      }
    }
    //-->
  </script>
  <form name="deletePicture" method="post" action="pictures-upload.jsp">
    <input type="hidden" name="idobject" value="<%=IdObject%>" />
    <input type="hidden" name="natureobjecttype" value="<%=NatureObjectType%>" />
    <input type="hidden" name="filename" value="" />
    <input type="hidden" name="operation" value="delete" />
  </form>
<%
  }
  else
  {
%>
  If you were logged in, you could also add / delete pictures.
<%
  }
%>
    </div>
  </body>
</html>