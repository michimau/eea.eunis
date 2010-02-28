<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Sites coordinates calculator' function - Utility to transform coordinates from
                   decimal degrees to degrees, minutes, seconds and vice-versa.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cms("sites_coordinates-calc_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      function transform(form) {
        if (0 != form.decimal.value.length) {
          if (0 == form.degrees.value.length) {
            toDegMinSec(form);
          } else {
            alert( "<%=cm.cms("sites_coordinates-calc_01")%>");
          }
        } else {
          if (0 != form.degrees.value.length) {
            toDecimalDegrees(form);
          } else {
            alert( "<%=cm.cms("sites_coordinates-calc_01")%>" );
          }
        }
      }

      function toDecimalDegrees(form)
      {
        var decimal= 0;
        var tempp= 0;
        var NEG= 0;
        if (form.degrees.value==null||form.degrees.value.length==0)
        {
          alert("<%=cm.cms("sites_coordinates-calc_02")%>");
          return false;
        } else if(  (form.degrees.value<0) || (form.minutes.value<0) || (form.seconds.value<0)  ) {
          NEG = 1
        }
        degrees = form.degrees.value
        minutes = form.minutes.value
        seconds = form.seconds.value
        tempp = Math.abs(degrees / 1) + Math.abs(minutes / 60) + Math.abs(seconds / 3600)
        if(NEG == 0)
        {
          form.decimal.value = tempp
        } else {
          form.decimal.value = -tempp
        }
        return false;
      }

      function toDegMinSec(form)
      {
        var dec = 0;
        var deg = 0;
        var min = 0;
        var sec = 0;
        var NEG = 0;
        if(form.decimal.value==null || form.decimal.value.length==0)
        {
          alert("<%=cm.cms("sites_coordinates-calc_03")%>");
          return false;
        } else {
          decdeg = form.decimal.value
          decdeg = replaceAll( decdeg, ",", "." )
          if(form.decimal.value < 0) NEG = 1;
          if(NEG == 0)
          {
            dec = Math.floor(decdeg)
            min = Math.floor(   (decdeg - dec)*60   )
            sec = (((decdeg - dec)*60) - min)*60
          } else {
            dec = Math.floor(-decdeg)
            min = Math.floor(   (-decdeg - dec)*60   )
            sec = (((-decdeg - dec)*60) - min)*60
          }
          if(NEG == 0)
          {
            form.degrees.value = dec
          }
          else
          {
            form.degrees.value = -dec
          }
          if( (NEG == 1) && (dec == 0) )
          {
            form.minutes.value = -min
          } else {
            form.minutes.value = min
          }
          if( (NEG == 1) && (dec == 0) && (min == 0) )
          {
            form.seconds.value = -sec
          }
          else
          {
            form.seconds.value = sec
          }
        }
        return false;
      }

      function replaceAll( str, from, to )
      {
        var idx = str.indexOf( from );
        while ( idx > -1 )
        {
          str = str.replace( from, to );
          idx = str.indexOf( from );
        }
        return str;
      }

    //]]>
    </script>
  </head>
  <body>
    <form name="converter" id="converter" action="" method="post">
      <div style="width : 100%">
        <br />
        <label for="degrees"><%=cm.cmsPhrase("Degrees")%></label>
        <input id="degrees" name="degrees" type="text" size="5" title="<%=cm.cms("degrees")%>" />
        <%=cm.cmsTitle("degrees")%>
        &deg;
        <label for="minutes"><%=cm.cmsPhrase("Minutes")%></label>
        <input id="minutes" name="minutes" type="text" size="5" title="<%=cm.cms("minutes")%>" />
        <%=cm.cmsTitle("minutes")%>
        '
        <label for="seconds"><%=cm.cmsPhrase("Seconds")%></label>
        <input id="seconds" name="seconds" type="text" size="5" title="<%=cm.cms("seconds")%>" />
        <%=cm.cmsTitle("seconds")%>
        &quot;
        <br />
        <br />
        <label for="decimal"><%=cm.cmsPhrase("Decimal degrees:")%></label>
        <input name="decimal" id="decimal" type="text" size="20" title="<%=cm.cms("sites_coordinates-calc_05_title")%>" />
        <%=cm.cmsTitle("sites_coordinates-calc_05_title")%>
        <br />
        <div style="width : 100%; text-align : right;">
        <br />
        <input id="reset" type="reset" name="Reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset")%>" />
        <%=cm.cmsInput("reset")%>
        <%=cm.cmsTitle("reset")%>
          &nbsp;
        <input id="calculate" type="button" name="calculate" value="<%=cm.cms("sites_coordinates_calc_calculate_value")%>" onclick="javascript:transform(document.converter);" class="submitSearchButton" title="<%=cm.cms("calculate")%>" />
        <%=cm.cmsInput("sites_coordinates_calc_calculate_value")%>
        <%=cm.cmsTitle("calculate")%>
        </div>
      </div>
    </form>
    <%=cm.cmsMsg("sites_coordinates-calc_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("sites_coordinates-calc_01")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("sites_coordinates-calc_02")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("sites_coordinates-calc_03")%>
  </body>
</html>
