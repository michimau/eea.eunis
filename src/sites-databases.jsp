<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites data source selection function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  boolean showCorine = Utilities.checkedStringToBoolean(request.getParameter("showCorine"), true);
  String enableCorine = ( !showCorine ) ? "disabled=\"disabled\"" : "";
  WebContentManagement cm = SessionManager.getWebContent();
%>
<script language="JavaScript" type="text/javascript">
  <!--

  function checkValidSelection() {
    if (!document.criteria.NATURA2000.checked && !document.criteria.CDDA_NATIONAL.checked && !document.criteria.NATURENET.checked &&
        !document.criteria.CORINE.checked && !document.criteria.CDDA_INTERNATIONAL.checked && !document.criteria.DIPLOMA.checked &&
        !document.criteria.BIOGENETIC.checked && !document.criteria.EMERALD.checked) {
            alert('<%=cm.cms("sites_databases_01")%>');
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
  if(request.getParameter("CORINE") != null) CORINE="checked";
  String DIPLOMA = "";
  if(request.getParameter("DIPLOMA") != null) DIPLOMA="checked";
  String CDDA_NATIONAL = "";
  if(request.getParameter("CDDA_NATIONAL") != null) CDDA_NATIONAL="checked";
  String CDDA_INTERNATIONAL = "";
  if(request.getParameter("CDDA_INTERNATIONAL") != null) CDDA_INTERNATIONAL="checked";
  String BIOGENETIC = "";
  if(request.getParameter("BIOGENETIC") != null) BIOGENETIC="checked";
  String NATURA2000 = "";
  if(request.getParameter("NATURA2000") != null) NATURA2000="checked";
  String NATURENET = "";
  if(request.getParameter("NATURENET") != null) NATURENET="checked";
  String EMERALD = "";
  if(request.getParameter("EMERALD") != null) EMERALD="checked";
  //EMERALD = null; // Disable EMERALD for now

  String dbNatura2000 = Utilities.formatString(cm.cmsText("sites_databases_Natura 2000"), "Natura 2000");
  String dbCDDANational = Utilities.formatString(cm.cmsText("sites_databases_CDDA National"), "CDDA National");
  String dbNatureNet = Utilities.formatString(cm.cmsText("sites_databases_Nature Net"), "Nature Net");
  String dbDiploma = Utilities.formatString(cm.cmsText("sites_databases_European Diploma"), "European Diploma");
  String dbCDDAInternational = Utilities.formatString(cm.cmsText("sites_databases_CDDA International"), "CDDA International");
  String dbCorine = Utilities.formatString(cm.cmsText("sites_databases_Corine Biotopes"), "Corine Biotopes");
  String dbBiogenetic = Utilities.formatString(cm.cmsText("sites_databases_Biogenetic Reserve"), "Biogenetic Reserve");
  String dbEmerald = Utilities.formatString(cm.cmsText("sites_databases_Emerald"), "Emerald");
%>
<div style="width : 100%;">
<table summary="layout" border="1" cellpadding="0" cellspacing="2" style="border-collapse: collapse; border-color : black;" width="100%">
  <tr>
    <td colspan="2">
      <%=cm.cmsText("sites_databases_02")%>
    </td>
    <td>
      <input type="button" id="checkAll" name="checkAll"
             title="<%=cm.cms("check_all_btn_title")%>" value="<%=cm.cms("check_all_btn_value")%>"
             onclick="javascript:setSelection('true');"
             onkeypress="javascript:setSelection('true');"
             class="inputTextField" />
      <%=cm.cmsTitle("check_all_btn_title")%>
      <%=cm.cmsInput("check_all_btn_value")%>
      &nbsp;
      <input type="button" id="checkNone" name="checkNone"
             title="<%=cm.cms("check_none_btn_title")%>" value="<%=cm.cms("check_none_btn_value")%>"
             onclick="javascript:setSelection('false');"
             onkeypress="javascript:setSelection('false');"
             class="inputTextField" />
      <%=cm.cmsTitle("check_none_btn_title")%>
      <%=cm.cmsInput("check_none_btn_value")%>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="NATURA2000" title="NATURA2000" name="NATURA2000" value="<%=NATURA2000%>"  checked="<%=NATURA2000%>" />
      <label for="NATURA2000"><%=dbNatura2000%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="CDDA_NATIONAL" title="CDDA_NATIONAL" name="CDDA_NATIONAL" value="<%=CDDA_NATIONAL%>"  checked="<%=CDDA_NATIONAL%>" />
      <label for="CDDA_NATIONAL"><%=dbCDDANational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" id="NATURENET" title="NATURENET" name="NATURENET" value="<%=NATURENET%>" checked="<%=NATURENET%>" disabled="disabled" />
      <label for="NATURENET"><%=dbNatureNet%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="DIPLOMA" title="DIPLOMA" name="DIPLOMA" value="<%=DIPLOMA%>" checked="<%=DIPLOMA%>" />
      <label for="DIPLOMA"><%=dbDiploma%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="CDDA_INTERNATIONAL" title="CDDA_INTERNATIONAL" name="CDDA_INTERNATIONAL" value="<%=CDDA_INTERNATIONAL%>" checked="<%=CDDA_INTERNATIONAL%>" />
      <label for="CDDA_INTERNATIONAL"><%=dbCDDAInternational%></label>
    </td>
    <td width="34%">
      <input type="checkbox" id="CORINE" title="CORINE" name="CORINE" value="<%=CORINE%>" checked="<%=CORINE%>" <%=enableCorine%> />
      <label for="CORINE"><%=dbCorine%></label>
    </td>
  </tr>
  <tr>
    <td width="33%">
      <input type="checkbox" id="BIOGENETIC" title="BIOGENETIC" name="BIOGENETIC" value="<%=BIOGENETIC%>" checked="<%=BIOGENETIC%>" />
      <label for="BIOGENETIC"><%=dbBiogenetic%></label>
    </td>
    <td width="33%">
      <input type="checkbox" id="EMERALD" title="EMERALD" name="EMERALD" value="<%=EMERALD%>" checked="<%=EMERALD%>" />
      <label for="EMERALD"><%=dbEmerald%></label>
    </td>
    <td width="34%">
      <a title="<%=cm.cms("sites_databases_03_title")%>" href="sites-download.jsp"><%=cm.cmsText("sites_databases_03")%></a>
      <%=cm.cmsTitle("sites_databases_03_title")%>
    </td>
  </tr>
</table>
  <%=cm.br()%>
  <%=cm.cmsMsg("sites_databases_01")%>
  <%=cm.br()%>      
</div>
