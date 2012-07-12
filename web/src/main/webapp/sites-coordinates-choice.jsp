 <%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites coordinates" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
  String callback = request.getParameter("callback");
  String type = request.getParameter("type");
  if (null == type) type = "world";
  String imgPath = "script/map_selector/w.jpg";
  if (type.equalsIgnoreCase("world"))
  {
    imgPath = "script/map_selector/w.jpg";
  }
  if (type.equalsIgnoreCase("europe"))
  {
    imgPath = "script/map_selector/e.jpg";
  }%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>
      <%=cm.cms("sites_coordinates-choice_title")%>
    </title>
    <style type="text/css">
      body {
        margin : 0px;
        padding : 0px;
        background-color : white;
      }
      .noshow
      {
        visibility : hidden;
      }
    </style>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/map_selector/c_RubberRectangle.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/map_selector/c_rbox.js"></script>
    <script language="JavaScript" type="text/javascript">
      function boxprocess(OrigX,OrigY,DestX,DestY)
      {
        picw = document.getElementById('bkgnd').width;
        pich = document.getElementById('bkgnd').height;
        OrigY=pich-OrigY;
        DestY=pich-DestY;
        MMminx=Math.min(OrigX,DestX);
        MMmaxx=Math.max(OrigX,DestX);
        MMminy=Math.min(OrigY,DestY);
        MMmaxy=Math.max(OrigY,DestY);
<%
  if (type.equalsIgnoreCase("world"))
  {
%>
        pixelX=360/picw; //360 deg
        pixelY=180/pich; //180 deg
        mapMinx=MMminx*pixelX-180.0;
        mapMiny=MMminy*pixelY-90.0;
        mapMaxx=MMmaxx*pixelX-180.0;
        mapMaxy=MMmaxy*pixelY-90.0;
<%
  }
  else
  {
%>
        pixelX=78/picw; //360 deg
        pixelY=51.18/pich; //180 deg
        mapMinx=MMminx*pixelX-28.0;
        mapMiny=MMminy*pixelY+33.0;
        mapMaxx=MMmaxx*pixelX-28.0;
        mapMaxy=MMmaxy*pixelY+33.0;
<%
  }
  if (null != callback)
  {
%>
        opener.<%=callback%>(mapMinx, mapMiny, mapMaxx, mapMaxy);
<%
  }
%>
        this.close();
      }

      function display_coordinates()
      {
<%
  if (type.equalsIgnoreCase("world"))
  {
%>
        // world
        var mapoffsetX=-180;
        var mapoffsetY=-90;
        var	xDistance = 360;
        var yDistance = 180;
<%
  }
  else
  {
%>
        // europe
        var mapoffsetX=-28;
        var mapoffsetY=33;
        var	xDistance = 78.00;
        var yDistance = 51.18;
<%
  }
%>
        var disp_string2;
        var br_x;
        var br_y;
        var nMyElementsTrueXposition = document.getElementById('bkgnd').offsetLeft;
        var nMyElementsTrueYposition = document.getElementById('bkgnd').offsetTop;
        br_x = window.event.x - nMyElementsTrueXposition;
        br_y = window.event.y - nMyElementsTrueYposition;

        pixelX = xDistance / document.getElementById('bkgnd').width;
        pixelY = yDistance / document.getElementById('bkgnd').height;

        mouseX = br_x;
        mapX = pixelX * mouseX +mapoffsetX;

        mouseY = document.getElementById('bkgnd').height - br_y;
        mapY = pixelY * mouseY + mapoffsetY;

        disp_string2 = 'East:' + Math.round(mapX*1000)/1000 +' North:' + Math.round(mapY*1000)/1000
        window.status= 	'Map coordinates: ' + disp_string2 + ' (Dec. Deg.) '
      }

      function stop_display()
      {
       window.status = "Done"
      }
    </script>
  </head>
  <body onload="JavaScript:initMap();">
    <div id="map">
      <input alt="<%=cm.cms("sites_coordinates_choice_map_alt")%>" title="<%=cm.cms("sites_coordinates_choice_map_title")%>" id="bkgnd" type="image" name="mapImage" src="<%=imgPath%>" border="1" width="800" height="400" onmousemove="javascript:display_coordinates();" onmouseout="javascript:stop_display();" />
      <%=cm.cmsAlt("sites_coordinates_choice_map_alt")%>
      <%=cm.cmsTitle("sites_coordinates_choice_map_title")%>
      <div id="box" class="noshow">
        <div class="noshow"></div>
      </div>
    </div>
    <%=cm.cmsMsg("sites_coordinates-choice_title")%>
  </body>
</html>
