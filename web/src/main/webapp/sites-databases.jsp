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
  //<![CDATA[

  function checkValidSelection() {
    if (!document.criteria.NATURA2000.checked && !document.criteria.CDDA_NATIONAL.checked && !document.criteria.NATURENET.checked &&
        !document.criteria.CORINE.checked && !document.criteria.CDDA_INTERNATIONAL.checked && !document.criteria.DIPLOMA.checked &&
        !document.criteria.BIOGENETIC.checked && !document.criteria.EMERALD.checked) {
            alert('<%=cm.cms("please_select_source_data_sets")%>');
            return false;
    }
    return true;
  }

  function Db2Url() {
    var url = "";
    if (document.criteria.NATURA2000.checked)       url += "&DB_NATURA2000=true";
    if (document.criteria.CDDA_NATIONAL.checked)      url += "&DB_CDDA_NATIONAL=true";
    if (document.criteria.DIPLOMA.checked)            url += "&DB_DIPLOMA=true";
//    if (document.criteria.EMERALD.checked)          url += "&DB_EMERALD=true";
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

  //]]>
</script>
<%
  String DIPLOMA = "";
  if(request.getParameter("DIPLOMA") != null) DIPLOMA="checked";
  String CDDA_NATIONAL = "";
  if(request.getParameter("CDDA_NATIONAL") != null) CDDA_NATIONAL="checked";
  String NATURA2000 = "";
  if(request.getParameter("NATURA2000") != null) NATURA2000="checked";
  String EMERALD = "";
  if(request.getParameter("EMERALD") != null) EMERALD="checked";
  //EMERALD = null; // Disable EMERALD for now

  String dbNatura2000 = Utilities.formatString(cm.cmsPhrase("Natura 2000"), "Natura 2000");
  String dbCDDANational = Utilities.formatString(cm.cmsPhrase("Nationally designated areas (CDDA)"), "CDDA National");
  String dbDiploma = Utilities.formatString(cm.cmsPhrase("European Diploma"), "European Diploma");
  String dbEmerald = Utilities.formatString(cm.cmsPhrase("Emerald"), "Emerald");
%>
<div style="width : 100%;">
<table summary="layout" border="1" cellpadding="0" cellspacing="2" style="border-collapse: collapse; border-color : black;" width="100%">
<colgroup><col style="width: 50%"><col style="width: 50%"></colgroup>
  <tr>
    <td>
      <%=cm.cmsPhrase("Select data set:")%>
    </td>
    <td style="text-align: right;">
      <input type="button" id="checkAll" name="checkAll"
             title="<%=cm.cms("select_all")%>" value="<%=cm.cms("select_all")%>"
             onclick="javascript:setSelection('true');"
             onkeypress="javascript:setSelection('true');"
             class="standardButton" />
      <%=cm.cmsTitle("select_all")%>
      <%=cm.cmsInput("select_all")%>
      &nbsp;
      <input type="button" id="checkNone" name="checkNone"
             title="<%=cm.cms("select_none")%>" value="<%=cm.cms("select_none")%>"
             onclick="javascript:setSelection('false');"
             onkeypress="javascript:setSelection('false');"
             class="standardButton" />
      <%=cm.cmsTitle("select_none")%>
      <%=cm.cmsInput("select_none")%>
    </td>
  </tr>
  <tr>
    <td>
      <input type="checkbox" id="NATURA2000" title="NATURA2000" name="NATURA2000" value="<%=NATURA2000%>"  checked="checked" />
      <label for="NATURA2000"><%=dbNatura2000%></label>
    </td>
    <td>
      <input type="checkbox" id="CDDA_NATIONAL" title="CDDA_NATIONAL" name="CDDA_NATIONAL" value="<%=CDDA_NATIONAL%>" checked="checked" />
      <label for="CDDA_NATIONAL"><%=dbCDDANational%></label>
    </td>
  </tr>
  <tr>
    <td>
      <input type="checkbox" id="DIPLOMA" title="DIPLOMA" name="DIPLOMA" value="<%=DIPLOMA%>" checked="checked" />
      <label for="DIPLOMA"><%=dbDiploma%></label>
    </td>
    <%--<td width="33%">--%>
      <%--<input type="checkbox" id="EMERALD" title="EMERALD" name="EMERALD" value="<%=EMERALD%>" checked="checked" />--%>
      <%--<label for="EMERALD"><%=dbEmerald%></label>--%>
    <%--</td>--%>
    <td>
      <a title="<%=cm.cms("sites_databases_03_title")%>" href="sites-download.jsp"><%=cm.cmsPhrase("Download full data set")%></a>
      <%=cm.cmsTitle("sites_databases_03_title")%>
    </td>
  </tr>
</table>
  <%=cm.br()%>
  <%=cm.cmsMsg("please_select_source_data_sets")%>
  <%=cm.br()%>      
</div>
