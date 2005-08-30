<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats geographical information' function - display links to all habitat searches.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities" %>
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Used in habitat factsheet for 'Habitat geographical distribution'.
--%>
<%
  String url = Utilities.formatString(request.getParameter("url"));
  String url2 = Utilities.formatString(request.getParameter("url2"));
%>
<script language="javascript" type="text/javascript">
<!--
var map_const;
var quer;
var shade;
var old_shade;

map_const = "Standard_b";
quer = "<%=url2%>"
    shade = 'heat7';

    function map_refresh()
    {
      switch (map_const) {
        case 'Biogeographic':
          quer = '<%=url%>'
          shade=''
          break
       case 'Biogeographic_b':
          quer = '<%=url%>'
          shade=''
          break
       case "Europe":
         quer = "<%=url2%>"
         break
       case "Europe_b":
         quer = "<%=url2%>"
         break
       case "Standard":
         quer = "<%=url2%>"
         break
       case "Standard_b":
         quer = "<%=url2%>"
         break
      }
      document.eeamap.src = "<%=application.getInitParameter("EEA_MAP_SERVER")%>/getmap.asp?coordsys=LL&size=W345H300&ImageQuality=100&Q=" + quer + "&PredefShade=" + shade + "&maptype=" + map_const
    }

    function biog_onclick() {
      map_const = "Biogeographic"
      map_refresh();
    }
    function biog_b_onclick() {
      map_const = "Biogeographic_b"
      map_refresh();
    }
    function eur_onclick() {
      map_const = "Europe"
      map_refresh();
    }
    function eur_b_onclick() {
      map_const = "Europe_b"
      map_refresh();
    }
    function std_onclick() {
      map_const = "Standard"
      map_refresh();
    }
    function std_b_onclick() {
      map_const = "Standard_b"
      map_refresh();
    }
    function zoom_in_onclick() {
      zoom_const = 1
      map_refresh();
    }
    function zoom_out_onclick() {
      zoom_const = 0
      map_refresh();
    }

    function setshade(shade_legend){
      shade = shade_legend;
      map_refresh();
    }
  //-->
</script>
<noscript>Your browser does not support JavaScript!</noscript>
<table summary="layout" border="0">
  <tr>
    <td valign="middle" align="center" width="345" height="300" rowspan="8">
      <img alt="Change map display" id="eeamap" style="width: 345px" src="javascript:map_refresh();" align="middle" border="0" name="eeamap" />
    </td>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA standard map" id="std" style="height: 39px" onclick="return std_onclick()" height="39" src="images/map/std.jpg" width="40" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA standard map with boundaries" id="std_b" style="height: 39px" onclick="return std_b_onclick()" height="39" src="images/map/std_b.jpg" width="40" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA Europe map" id="eur" style="height: 39px" onclick="return eur_onclick()" height="39" src="images/map/eur.jpg" width="40" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA Europe map with boundaries" id="eur_b" style="height: 39px" onclick="return eur_b_onclick()" height="39" src="images/map/eur_b.jpg" width="40" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA biogeographic map" id="biog" style="WIDTH: 40px; height: 39px" onclick="return biog_onclick()" height="39" hspace="0" src="images/map/biog.jpg" width="40" border="0" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="35" colspan="2" height="40">
      <img alt="Change map display" title="EEA biogeographic map with boundaries" id="biog_b" style="height: 39px" onclick="return biog_b_onclick()" height="39" src="images/map/biog_b.jpg" width="40" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="15" height="12">
      <img alt="Change map color to blue" title="Set map color" id="Blue" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getmap.asp?PreDefShade=Blue6&amp;Symbol=4&amp;size=10:20" onclick="setshade('Blue6')" width="16" height="16" />
    </td>
    <td valign="middle" align="center" width="15" height="12">
      <img alt="Change map color to heat" title="Set map color" id="Heat" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?PreDefShade=Heat7&amp;Symbol=4&amp;size=10:20" onclick="setshade('Heat7')" width="16" height="16" />
    </td>
  </tr>
  <tr>
    <td valign="middle" align="center" width="15" height="12">
      <img alt="Change map color to purple" title="Set map color" id="Purple" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?PreDefShade=Purple5&amp;Symbol=4&amp;size=10:20" onclick="setshade('Purple5')" width="16" height="16" />
    </td>
    <td valign="middle" align="center" width="15" height="12">
      <img alt="Change map color to green" title="Set map color" id="Green" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?PreDefShade=Green6&amp;Symbol=4&amp;size=10:20" onclick="setshade('Green5')" width="16" height="16" />
    </td>
  </tr>
</table>
