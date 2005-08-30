<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites data source selection function - search page.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  boolean showCorine = Utilities.checkedStringToBoolean(request.getParameter("showCorine"), true);
  String enableCorine = ( !showCorine ) ? "disabled=\"disabled\"" : "";
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<script language="JavaScript" type="text/javascript">
  <!--

  function checkValidSelection() {
    if (!document.criteria.NATURA2000.checked && !document.criteria.CDDA_NATIONAL.checked && !document.criteria.NATURENET.checked &&
        !document.criteria.CORINE.checked && !document.criteria.CDDA_INTERNATIONAL.checked && !document.criteria.DIPLOMA.checked &&
        !document.criteria.BIOGENETIC.checked && !document.criteria.EMERALD.checked) {
            alert('<%=contentManagement.getContent("sites_databases_01", false )%>');
            return false;
    }
    return true;
  }

  function Db2Url() {
    var url = "";
    if (document.criteria.NATURA2000.checked)       url += "&DB_NATURA2000=true";
    if (document.criteria.CDDA_NATIONAL.checked)      url += "&DB_CDDA_NATIONAL=true";
    //if (document.criteria.NATURENET.checked)        url += "&DB_NATURE_NET=true";
    if (document.criteria.CORINE.checked)             url += "&DB_CORINE=true";
    if (document.criteria.CDDA_INTERNATIONAL.checked) url += "&DB_CDDA_INTERNATIONAL=true";
    if (document.criteria.DIPLOMA.checked)            url += "&DB_DIPLOMA=true";
    if (document.criteria.BIOGENETIC.checked)         url += "&DB_BIOGENETIC=true";
    if (document.criteria.EMERALD.checked)          url += "&DB_EMERALD=true";
    return url;
  }

  function setSelection(status) {
    if (status == "true") {
      document.criteria.CDDA_NATIONAL.checked = true;
      document.criteria.NATURA2000.checked = true;
      document.criteria.CORINE.checked = true;
      document.criteria.CDDA_INTERNATIONAL.checked = true;
      document.criteria.DIPLOMA.checked = true;
      document.criteria.BIOGENETIC.checked = true;
      document.criteria.EMERALD.checked = true;
    } else {
      document.criteria.NATURA2000.checked = false;
      document.criteria.CDDA_NATIONAL.checked = false;
      document.criteria.CORINE.checked = false;
      document.criteria.CDDA_INTERNATIONAL.checked = false;
      document.criteria.DIPLOMA.checked = false;
      document.criteria.BIOGENETIC.checked = false;
      document.criteria.EMERALD.checked = false;
    }
  }

  //-->
</script>
<%
  String CORINE = "";
  if(request.getParameter("CORINE") != null) CORINE="checked"; else CORINE="";
  String DIPLOMA = "";
  if(request.getParameter("DIPLOMA") != null) DIPLOMA="checked"; else DIPLOMA="";
  String CDDA_NATIONAL = "";
  if(request.getParameter("CDDA_NATIONAL") != null) CDDA_NATIONAL="checked"; else CDDA_NATIONAL="";
  String CDDA_INTERNATIONAL = "";
  if(request.getParameter("CDDA_INTERNATIONAL") != null) CDDA_INTERNATIONAL="checked"; else CDDA_INTERNATIONAL="";
  String BIOGENETIC = "";
  if(request.getParameter("BIOGENETIC") != null) BIOGENETIC="checked"; else BIOGENETIC="";
  String NATURA2000 = "";
  if(request.getParameter("NATURA2000") != null) NATURA2000="checked"; else NATURA2000="";
  String NATURENET = "";
  if(request.getParameter("NATURENET") != null) NATURENET="checked"; else NATURENET="";
  String EMERALD = "";
  if(request.getParameter("EMERALD") != null) EMERALD="checked"; else EMERALD="";
  //EMERALD = null; // Disable EMERALD for now

  WebContentManagement dbContentManagement = SessionManager.getWebContent();
  String dbNatura2000 = Utilities.formatString(dbContentManagement.getContent("sites_databases_Natura 2000"), "Natura 2000");
  String dbCDDANational = Utilities.formatString(dbContentManagement.getContent("sites_databases_CDDA National"), "CDDA National");
  String dbNatureNet = Utilities.formatString(dbContentManagement.getContent("sites_databases_Nature Net"), "Nature Net");
  String dbDiploma = Utilities.formatString(dbContentManagement.getContent("sites_databases_European Diploma"), "European Diploma");
  String dbCDDAInternational = Utilities.formatString(dbContentManagement.getContent("sites_databases_CDDA International"), "CDDA International");
  String dbCorine = Utilities.formatString(dbContentManagement.getContent("sites_databases_Corine Biotopes"), "Corine Biotopes");
  String dbBiogenetic = Utilities.formatString(dbContentManagement.getContent("sites_databases_Biogenetic Reserve"), "Biogenetic Reserve");
  String dbEmerald = Utilities.formatString(dbContentManagement.getContent("sites_databases_Emerald"), "Emerald");
%>
<div style="width:740px">
<table summary="layout" border="1" cellpadding="0" cellspacing="2" style="border-collapse: collapse; border-color : black;" width="100%">
  <tr>
    <td colspan="2">
      <%=contentManagement.getContent("sites_databases_02")%>
    </td>
    <td>
      <label for="checkAll" class="noshow">Check All</label>
      <input type="button" id="checkAll" name="checkAll"
             title="Select all" value="Select all"
             onclick="javascript:setSelection('true');"
             onkeypress="javascript:setSelection('true');"
             class="inputTextField" />
      &nbsp;
      <label for="checkNone" class="noshow">Check none</label>
      <input type="button" id="checkNone" name="checkNone"
             title="Select none" value="Select none"
             onclick="javascript:setSelection('false');"
             onkeypress="javascript:setSelection('false');"
             class="inputTextField" />
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="NATURA2000" title="NATURA2000" name="NATURA2000" value="<%=NATURA2000%>" />
      <label for="NATURA2000"><%=dbNatura2000%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="CDDA_NATIONAL" title="CDDA_NATIONAL" name="CDDA_NATIONAL" value="<%=CDDA_NATIONAL%>" />
      <label for="CDDA_NATIONAL"><%=dbCDDANational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" id="NATURENET" title="NATURENET" name="NATURENET" value="<%=NATURENET%>" disabled="disabled" />
      <label for="NATURENET"><%=dbNatureNet%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="DIPLOMA" title="DIPLOMA" name="DIPLOMA" value="<%=DIPLOMA%>" />
      <label for="DIPLOMA"><%=dbDiploma%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="CDDA_INTERNATIONAL" title="CDDA_INTERNATIONAL" name="CDDA_INTERNATIONAL" value="<%=CDDA_INTERNATIONAL%>" />
      <label for="CDDA_INTERNATIONAL"><%=dbCDDAInternational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" id="CORINE" title="CORINE" name="CORINE" value="<%=CORINE%>" <%=enableCorine%> />
      <label for="CORINE"><%=dbCorine%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="BIOGENETIC" title="BIOGENETIC" name="BIOGENETIC" value="<%=BIOGENETIC%>" />
      <label for="BIOGENETIC"><%=dbBiogenetic%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="EMERALD" title="EMERALD" name="EMERALD" value="<%=EMERALD%>" />
      <label for="EMERALD"><%=dbEmerald%></label>
    </td>
    <td width="34%">
      <a title="Download sites data" href="sites-download.jsp"><%=contentManagement.getContent("sites_databases_03")%></a>
    </td>
  </tr>
</table>
</div>
