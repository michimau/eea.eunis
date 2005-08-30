<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Page common to site searches which shows the selectable databases
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  boolean showCorine = Utilities.checkedStringToBoolean( request.getParameter( "showCorine" ), true );
  String enableCorine = ( !showCorine ) ? "disabled" : "";

  WebContentManagement dbContentManagement = SessionManager.getWebContent();
  String dbNatura2000 = Utilities.formatString(dbContentManagement.getContent("sites_databases_Natura 2000", false ), "Natura 2000");
  String dbCDDANational = Utilities.formatString(dbContentManagement.getContent("sites_databases_CDDA National", false ), "CDDA National");
  String dbNatureNet = Utilities.formatString(dbContentManagement.getContent("sites_databases_Nature Net", false ), "Nature Net");
  String dbDiploma = Utilities.formatString(dbContentManagement.getContent("sites_databases_European Diploma", false ), "European Diploma");
  String dbCDDAInternational = Utilities.formatString(dbContentManagement.getContent("sites_databases_CDDA International", false ), "CDDA International");
  String dbCorine = Utilities.formatString(dbContentManagement.getContent("sites_databases_Corine Biotopes", false ), "Corine Biotopes");
  String dbBiogenetic = Utilities.formatString(dbContentManagement.getContent("sites_databases_Biogenetic Reserve", false ), "Biogenetic Reserve");
  String dbEmerald = Utilities.formatString(dbContentManagement.getContent("sites_databases_Emerald", false ), "Emerald");
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
            alert("<%=contentManagement.getContent("sites_search-common_01", false)%>");
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
      <%=contentManagement.getContent("sites_search-common_02")%>
    </td>
    <td align="right">
      <label for="checkAll" class="noshow"><%=contentManagement.getContent("sites_search-common_03", false)%></label>
      <input id="checkAll" type="button" name="checkAll"
             value="<%=contentManagement.getContent("sites_search-common_03", false)%>"
             onkeypress="javascript:setSelection('true');"
             onclick="javascript:setSelection('true');"
             class="inputTextField"
             title="<%=contentManagement.getContent("sites_search-common_03", false)%>" />
      &nbsp;
      <label for="checkNone" class="noshow"><%=contentManagement.getContent("sites_search-common_04", false)%></label>
      <input id="checkNone" type="button" name="checkNone"
             value="<%=contentManagement.getContent("sites_search-common_04", false)%>"
             onkeypress="javascript:setSelection('false');"
             onclick="javascript:setSelection('false');"
             class="inputTextField"
             title="<%=contentManagement.getContent("sites_search-common_04", false)%>" />
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_NATURA2000" id="DB_NATURA2000" value="ON" title="<%=dbNatura2000%>" />
      <label for="DB_NATURA2000"><%=dbNatura2000%></label>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_CDDA_NATIONAL" id="DB_CDDA_NATIONAL" value="ON" title="<%=dbCDDANational%>" />
      <label for="DB_CDDA_NATIONAL"><%=dbCDDANational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" name="DB_NATURE_NET" id="DB_NATURE_NET" value="ON" disabled="disabled" title="<%=dbNatureNet%>" />
      <label for="DB_NATURE_NET"><%=dbNatureNet%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_DIPLOMA" id="DB_DIPLOMA" value="ON" title="<%=dbDiploma%>" />
      <label for="DB_DIPLOMA"><%=dbDiploma%></label>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_CDDA_INTERNATIONAL" id="DB_CDDA_INTERNATIONAL" value="ON" title="<%=dbCDDAInternational%>" />
      <label for="DB_CDDA_INTERNATIONAL"><%=dbCDDAInternational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" name="DB_CORINE" id="DB_CORINE" value="ON" <%=enableCorine%> title="<%=dbCorine%>" />
      <label for="DB_CORINE"><%=dbCorine%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" name="DB_BIOGENETIC" id="DB_BIOGENETIC" value="ON" title="<%=dbBiogenetic%>" />
      <label for="DB_BIOGENETIC"><%=dbBiogenetic%></label>
    </td>
    <td width="33%">
      <input type="checkbox" name="DB_EMERALD" id="DB_EMERALD" value="ON" title="<%=dbEmerald%>" />
      <label for="DB_EMERALD"><%=dbEmerald%></label>
    </td>
    <td width="34%">
      <a title="Download sites data" href="sites-download.jsp"><%=contentManagement.getContent("sites_search-common_05")%></a>
    </td>
  </tr>
</table>