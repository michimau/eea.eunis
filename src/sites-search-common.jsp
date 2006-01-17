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
  boolean showCorine = Utilities.checkedStringToBoolean( request.getParameter( "showCorine" ), true );
  String enableCorine = ( !showCorine ) ? "disabled" : "";

  String dbNatura2000 = Utilities.formatString(cm.cms("sites_databases_Natura_2000"), "Natura 2000");
  String dbCDDANational = Utilities.formatString(cm.cms("sites_databases_CDDA_National"), "CDDA National");
  String dbNatureNet = Utilities.formatString(cm.cms("sites_databases_Nature_Net"), "Nature Net");
  String dbDiploma = Utilities.formatString(cm.cms("sites_databases_European_Diploma"), "European Diploma");
  String dbCDDAInternational = Utilities.formatString(cm.cms("sites_databases_CDDA_International"), "CDDA International");
  String dbCorine = Utilities.formatString(cm.cms("sites_databases_Corine_Biotopes"), "Corine Biotopes");
  String dbBiogenetic = Utilities.formatString(cm.cms("sites_databases_Biogenetic_Reserve"), "Biogenetic Reserve");
  String dbEmerald = Utilities.formatString(cm.cms("sites_databases_Emerald"), "Emerald");
%>
<script language="JavaScript" type="text/javascript">
  <!--
  function choiceprec(URL) {
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
  }

  function checkValidSelection() {
    if (!document.eunis.DB_NATURA2000.checked && !document.eunis.DB_CDDA_NATIONAL.checked && !document.eunis.DB_NATURE_NET.checked &&
        !document.eunis.DB_CORINE.checked && !document.eunis.DB_CDDA_INTERNATIONAL.checked && !document.eunis.DB_DIPLOMA.checked &&
        !document.eunis.DB_BIOGENETIC.checked && !document.eunis.DB_EMERALD.checked) {
            alert("<%=cm.cms("sites_search-common_01")%>");
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
      //document.eunis.DB_NATURE_NET.checked = true;
      if (!document.eunis.DB_CORINE.disabled) {
        document.eunis.DB_CORINE.checked = true;
      }
      document.eunis.DB_CDDA_INTERNATIONAL.checked = true;
      document.eunis.DB_DIPLOMA.checked = true;
      document.eunis.DB_BIOGENETIC.checked = true;
      document.eunis.DB_EMERALD.checked = true;
      document.eunis.dynText.value = "Check none";
    } else {
      document.eunis.DB_NATURA2000.checked = false;
      document.eunis.DB_CDDA_NATIONAL.checked = false;
      //document.eunis.DB_NATURE_NET.checked = false;
      if(!document.eunis.DB_CORINE.disabled) {
        document.eunis.DB_CORINE.checked = false;
      }
      document.eunis.DB_CDDA_INTERNATIONAL.checked = false;
      document.eunis.DB_DIPLOMA.checked = false;
      document.eunis.DB_BIOGENETIC.checked = false;
      document.eunis.DB_EMERALD.checked = false;
      document.eunis.dynText.value = "Check all";
    }
  }

  function setSelection(status)
  {
    if (status == "true")
    {
      document.eunis.DB_CDDA_NATIONAL.checked = true;
      document.eunis.DB_NATURA2000.checked = true;
      if (!document.eunis.DB_CORINE.disabled)
      {
        document.eunis.DB_CORINE.checked = true;
      }
      document.eunis.DB_CDDA_INTERNATIONAL.checked = true;
      document.eunis.DB_DIPLOMA.checked = true;
      document.eunis.DB_BIOGENETIC.checked = true;
      document.eunis.DB_EMERALD.checked = true;
    } else {
      document.eunis.DB_NATURA2000.checked = false;
      document.eunis.DB_CDDA_NATIONAL.checked = false;
      if(!document.eunis.DB_CORINE.disabled)
      {
        document.eunis.DB_CORINE.checked = false;
      }
      document.eunis.DB_CDDA_INTERNATIONAL.checked = false;
      document.eunis.DB_DIPLOMA.checked = false;
      document.eunis.DB_BIOGENETIC.checked = false;
      document.eunis.DB_EMERALD.checked = false;
    }
  }

  //-->
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
    NatureNet           - DB_NATURE_NET
    Corine Biotopes     - DB_CORINE
    CDDA International  - DB_CDDA_INTERNATIONAL
    European Diploma    - DB_DIPLOMA
    Biogenetic Reserve  - DB_BIOGENETIC
    Emerald             - DB_EMERALD
--%>
<br />
<table width="100%" border="1" cellpadding="0" cellspacing="2" style="border-collapse: collapse" summary="layout">
  <tr>
    <td colspan="2">
      <%=cm.cmsText("sites_search-common_02")%>
    </td>
    <td align="right">
      <input id="checkAll" type="button" name="checkAll"
             value="<%=cm.cms("check_all_btn_value")%>"
             onkeypress="javascript:setSelection('true');"
             onclick="javascript:setSelection('true');"
             class="inputTextField"
             title="<%=cm.cms("check_all_btn_title")%>" />
      <%=cm.cmsTitle("check_all_btn_title")%>
      <%=cm.cmsInput("check_all_btn_value")%>
      &nbsp;
      <input id="checkNone" type="button" name="checkNone"
             value="<%=cm.cms("check_none_btn_value")%>"
             onkeypress="javascript:setSelection('false');"
             onclick="javascript:setSelection('false');"
             class="inputTextField"
             title="<%=cm.cms("check_none_btn_title")%>" />
      <%=cm.cmsTitle("check_none_btn_title")%>
      <%=cm.cmsInput("check_none_btn_value")%>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_NATURA2000" id="DB_NATURA2000" value="ON" title="<%=cm.cms("sites_databases_Natura_2000")%>" />
      <label for="DB_NATURA2000"><%=cm.cmsText("sites_databases_Natura_2000")%></label>
      <%=cm.cmsTitle("sites_databases_Natura_2000")%>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_CDDA_NATIONAL" id="DB_CDDA_NATIONAL" value="ON" title="<%=cm.cms("sites_databases_CDDA_National")%>" />
      <label for="DB_CDDA_NATIONAL"><%=cm.cmsText("sites_databases_CDDA_National")%></label>
      <%=cm.cmsTitle("sites_databases_CDDA_National")%>
    </td>
    <td width="34%">
      <input type="checkbox" name="DB_NATURE_NET" id="DB_NATURE_NET" value="ON" disabled="disabled" title="<%=cm.cms("sites_databases_Nature_Net")%>" />
      <label for="DB_NATURE_NET"><%=cm.cmsText("sites_databases_Nature_Net")%></label>
      <%=cm.cmsTitle("sites_databases_Nature_Net")%>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_DIPLOMA" id="DB_DIPLOMA" value="ON" title="<%=cm.cms("sites_databases_European_Diploma")%>" />
      <label for="DB_DIPLOMA"><%=cm.cmsText("sites_databases_European_Diploma")%></label>
      <%=cm.cmsTitle("sites_databases_European_Diploma")%>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_CDDA_INTERNATIONAL" id="DB_CDDA_INTERNATIONAL" value="ON" title="<%=cm.cms("sites_databases_CDDA_International")%>" />
      <label for="DB_CDDA_INTERNATIONAL"><%=cm.cmsText("sites_databases_CDDA_International")%></label>
      <%=cm.cmsTitle("sites_databases_CDDA_International")%>
    </td>
    <td width="34%">
      <input type="checkbox" name="DB_CORINE" id="DB_CORINE" value="ON" <%=enableCorine%> title="<%=cm.cms("sites_databases_Corine_Biotopes")%>" />
      <label for="DB_CORINE"><%=cm.cmsText("sites_databases_Corine_Biotopes")%></label>
      <%=cm.cmsTitle("sites_databases_Corine_Biotopes")%>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_BIOGENETIC" id="DB_BIOGENETIC" value="ON" title="<%=cm.cms("sites_databases_Biogenetic_Reserve")%>" />
      <label for="DB_BIOGENETIC"><%=cm.cmsText("sites_databases_Biogenetic_Reserve")%></label>
      <%=cm.cmsTitle("sites_databases_Biogenetic_Reserve")%>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_EMERALD" id="DB_EMERALD" value="ON" title="<%=cm.cms("sites_databases_Emerald")%>" />
      <label for="DB_EMERALD"><%=cm.cmsText("sites_databases_Emerald")%></label>
      <%=cm.cmsTitle("sites_databases_Emerald")%>
    </td>
    <td width="34%">
      <a title="<%=cm.cms("sites_databases_03_title")%>" href="sites-download.jsp"><%=cm.cmsText("sites_databases_03")%></a>
      <%=cm.cmsTitle("sites_databases_03_title")%>
    </td>
  </tr>
</table>
<%=cm.br()%>
<%=cm.cmsMsg("sites_search-common_01")%>