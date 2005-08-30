<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Sites coordinates calculator' function - Utility to transform coordinates from
                   decimal degrees to degrees, minutes, seconds and vice-versa.
--%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <%
      // Web content manager used in this page.
      WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
    <title>
      <%=contentManagement.getContent("sites_coordinates-calc_title", false )%>
    </title>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
    <!--
      function transform(form) {
        if (0 != form.decimal.value.length) {
          if (0 == form.degrees.value.length) {
            toDegMinSec(form);
          } else {
            alert( "<%=contentManagement.getContent("sites_coordinates-calc_01", false )%>");
          }
        } else {
          if (0 != form.degrees.value.length) {
            toDecimalDegrees(form);
          } else {
            alert( "<%=contentManagement.getContent("sites_coordinates-calc_01", false )%>" );
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
          alert("<%=contentManagement.getContent("sites_coordinates-calc_02", false )%>");
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
          alert("<%=contentManagement.getContent("sites_coordinates-calc_03", false )%>");
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

    //-->
    </script>
  </head>
  <body>
    <form name="converter" id="converter" action="" method="post">
      <div style="width : 100%">
        <br />
        <label for="degrees">Degrees</label>
        <input id="degrees" name="degrees" type="text" size="5" class="inputTextField" title="Degrees" />
        &deg;
        <label for="minutes">Minutes</label>
        <input id="minutes" name="minutes" type="text" size="5" class="inputTextField" title="Minutes" />
        '
        <label for="seconds">Seconds</label>
        <input id="seconds" name="seconds" type="text" size="5" class="inputTextField" title="Seconds" />
        &quot;
        <br />
        <br />
        <label for="decimal"><%=contentManagement.getContent("sites_coordinates-calc_05")%></label>
        <input name="decimal" id="decimal" type="text" size="20" class="inputTextField" title="Decimal" />
        <br />
        <div style="width : 100%; text-align : right;">
        <br />
        <label for="reset" class="noshow">Reset</label>
        <input id="reset" type="reset" name="Reset" value="Reset" class="inputTextField" title="Reset" />
          &nbsp;
        <label for="calculate" class="noshow">Calculate</label>
        <input id="calculate" type="button" name="calculate" value="Transform" onclick="javascript:transform(document.converter);" class="inputTextField" title="Calculate" />
        </div>
      </div>
    </form>
  </body>
</html>
