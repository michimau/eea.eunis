<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Page common to site searches which shows the selectable databases
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();

  String dbNatura2000 = Utilities.formatString(cm.cms("natura_2000"), "Natura 2000");
  String dbCDDANational = Utilities.formatString(cm.cms("cdda_national"), "CDDA National");
  String dbDiploma = Utilities.formatString(cm.cms("european_diploma"), "European Diploma");
  String dbEmerald = Utilities.formatString(cm.cms("emerald"), "Emerald");
%>
<script language="JavaScript" type="text/javascript">
  //<![CDATA[
  function choiceprec(URL) {
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
  }

  function checkValidSelection() {
    if (!document.eunis.DB_NATURA2000.checked && !document.eunis.DB_CDDA_NATIONAL.checked &&
//          !document.eunis.DB_EMERALD.checked &&
            !document.eunis.DB_DIPLOMA.checked ) {
            alert("<%=cm.cms("please_select_source_data_sets")%>");
            return false;
    }
    return true;
  }

function isNumber1(s)
    {
    var nr = parseInt(s);
    if (isNaN(nr)) return false;
    else return true;
    }

    function isNumber(s)
    {
      if(s==null) return false;
      else
       {
         var isGoodNumber = true;
         for (i=0;i<s.length;i++) if (isNumber1(s.charAt(i))==false) isGoodNumber = false;
         return isGoodNumber;
       }
    }


  function toggleSelection() {
    if (document.eunis.checkAll.checked != false)
    {
      document.eunis.DB_NATURA2000.checked = true;
      document.eunis.DB_CDDA_NATIONAL.checked = true;
      document.eunis.DB_DIPLOMA.checked = true;
//      document.eunis.DB_EMERALD.checked = true;
      document.eunis.dynText.value = "Check none";
    } else {
      document.eunis.DB_NATURA2000.checked = false;
      document.eunis.DB_CDDA_NATIONAL.checked = false;
      document.eunis.DB_DIPLOMA.checked = false;
//      document.eunis.DB_EMERALD.checked = false;
      document.eunis.dynText.value = "Check all";
    }
  }

  function setSelection(status)
  {
    if (status == "true")
    {
      document.eunis.DB_CDDA_NATIONAL.checked = true;
      document.eunis.DB_NATURA2000.checked = true;
      document.eunis.DB_DIPLOMA.checked = true;
//      document.eunis.DB_EMERALD.checked = true;
    } else {
      document.eunis.DB_NATURA2000.checked = false;
      document.eunis.DB_CDDA_NATIONAL.checked = false;
      document.eunis.DB_DIPLOMA.checked = false;
//      document.eunis.DB_EMERALD.checked = false;
    }
  }

  //]]>
</script>
<%--
This site is common to all searches from SITES part of the site.
The following fields are declared below:
 - Years for sites
   yearMin - Lower value
   yearMax - Upper value

 - Country where search is done (multiple values seperated by comma - ";" )
   country

 - Projects where search is done (checkboxes):
    NATURA 2000         - DB_NATURA2000
    CDDA  National      - DB_CDDA_NATIONAL
    European Diploma    - DB_DIPLOMA
    Emerald             - DB_EMERALD
--%>
<br />
<table width="100%" border="1" cellpadding="1" cellspacing="2" style="border-collapse: collapse" summary="layout">
  <col style="width:50%"/>
  <col style="width:50%"/>
  <%--<col style="width:34%"/>--%>
  <tr>
    <td colspan="1">
      <%=cm.cmsPhrase("Select data set:")%>
    </td>
    <td align="right">
      <input id="checkAll" type="button" name="checkAll"
             value="<%=cm.cmsPhrase("Select all")%>"
             onkeypress="javascript:setSelection('true');"
             onclick="javascript:setSelection('true');"
             class="standardButton" />
      <input id="checkNone" type="button" name="checkNone"
             value="<%=cm.cmsPhrase("Select none")%>"
             onkeypress="javascript:setSelection('false');"
             onclick="javascript:setSelection('false');"
             class="standardButton" />
    </td>
  </tr>
  <tr>
    <td>
      <input type="checkbox" name="DB_NATURA2000" id="DB_NATURA2000" value="ON" />
      <label for="DB_NATURA2000"><%=cm.cmsPhrase("Natura 2000")%></label>
    </td>
    <td>
      <input type="checkbox" name="DB_CDDA_NATIONAL" id="DB_CDDA_NATIONAL" value="ON" />
      <label for="DB_CDDA_NATIONAL"><%=cm.cmsPhrase("Nationally designated areas (CDDA)")%></label>
    </td>
  </tr>
  <tr>
    <td>
      <input type="checkbox" name="DB_DIPLOMA" id="DB_DIPLOMA" value="ON" />
      <label for="DB_DIPLOMA"><%=cm.cmsPhrase("European Diploma")%></label>
    </td>
    <td>
      <a href="sites-download.jsp"><%=cm.cmsPhrase("Download full data set")%></a>
    </td>
  </tr>
</table>
<%=cm.br()%>
<%=cm.cmsMsg("please_select_source_data_sets")%>
