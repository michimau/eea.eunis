<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats advanced search' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.PreparedStatement,
                 java.sql.ResultSet" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<jsp:include page="header-page.jsp" />
<script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("natureobject") != null ? request.getParameter("natureobject") : ""%><%=cm.cms("advanced_search")%>
</title>
<script language="JavaScript" type="text/javascript">
<!--
  var current_selected="";
-->
</script>
<script language="JavaScript" type="text/javascript">
<!--
  function MM_jumpMenu(targ,selObj,restore){ //v3.0
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }

  function setCurrentSelected(val) {
    current_selected = val;
    return true;
  }

  function choice(ctl, lov, natureobject, oper) {
    var cur_ctl = "window.document.criteria['"+ctl+"'].value";
    var val = eval(cur_ctl);
    URL = 'advanced-search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + oper;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }

  function getkey(e)
  {
    if (window.event)
       return window.event.keyCode;
    else if (e)
       return e.which;
    else
       return null;
  }

  function textChanged(e)
  {
    var key, keychar;
    key = getkey(e);
    if (key == null) return true;

    // get character
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();

    // control keys
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 ) {
      return false;
    }

    enableSaveButton();
    return true;
  }

  // action specifies what to do (how to modify the submited url...
  function submitCriteriaForm(criteria, idnode) {
    document.criteria.criteria.value=criteria.value;
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function enableSaveButton() {
    document.criteria.Save.disabled=false;
    document.criteria.Search.disabled=true;
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=cm.cms("press_save_to_save_criteria")%></span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=cm.cms("criteria_saved")%></span>"
  }

  function submitAttributeForm(attribute, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value=attribute.value;
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitOperatorForm(operator, idnode) {
<%--    alert("operator=" + operator.value + ", idnode=" + idnode);--%>
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value=operator.value;
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitFirstValueForm(firstvalue, idnode) {
    if(firstvalue.value == "") {
      firstvalue.value = document.criteria.oldfirstvalue.value;
      alert('<%=cm.cms("previous_values_was_restored")%>');
      firstvalue.focus();
		  return(false);
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value=firstvalue.value;
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var ofv = document.criteria.oldfirstvalue.value;
    var fv = document.criteria.firstvalue.value;
    if(ofv != fv) {
      if(current_selected == "first_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("First_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitLastValueForm(lastvalue, idnode) {
    if(lastvalue.value == "") {
      lastvalue.value = document.criteria.oldlastvalue.value;
      alert('<%=cm.cms("previous_values_was_restored")%>');
      firstvalue.focus();
		  return false;
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value=lastvalue.value;
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var olv = document.criteria.oldlastvalue.value;
    var lv = document.criteria.lastvalue.value;
    if(olv != lv) {
<%--      alert(current_selected);--%>
      if(current_selected == "last_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("Last_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitButtonForm(action, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value=action;
    document.criteria.submit();
  }

  function saveFirstValue(val) {
    document.criteria.oldfirstvalue.value=val.value;
  }

  function saveLastValue(val) {
    document.criteria.oldlastvalue.value=val.value;
  }

  function SaveCriteriaFunction() {

  var URL2 = "save-species-or-habitats-advanced-search-criteria.jsp?";
  URL2 += "&idsession="+document.saveCriteriaSearch.idsession.value;
  URL2 += "&natureobject="+document.saveCriteriaSearch.natureobject.value;
  URL2 += "&username="+document.saveCriteriaSearch.username.value;
  URL2 += "&fromWhere="+document.saveCriteriaSearch.fromWhere.value;
  URL2 += "&saveThisCriteria=false";

  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=80');");
  }

function setFormLoadSaveCriteria(fromWhere,criterianame,natureobject) {

      document.loadSaveCriteria.fromWhere.value = fromWhere;
      document.loadSaveCriteria.criterianame.value = criterianame;
      document.loadSaveCriteria.natureobject.value = natureobject;

      document.loadSaveCriteria.submit();
   }

function setFormDeleteSaveCriteria(fromWhere,criterianame,natureobject) {

      document.deleteSaveCriteria.fromWhere.value = fromWhere;
      document.deleteSaveCriteria.criterianame.value = criterianame;
      document.deleteSaveCriteria.natureobject.value = natureobject;

      document.deleteSaveCriteria.submit();
   }
//-->
</script>

<%
  String IdSession = request.getParameter("idsession");
  String NatureObject = request.getParameter("natureobject");
  if (IdSession == null || IdSession.length() == 0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession = request.getSession().getId();
  }
  if (NatureObject == null || NatureObject.length() == 0 || NatureObject.equalsIgnoreCase("undefined")) {
    NatureObject = "Habitat";
  }
  // Load saved search
  if (request.getParameter("loadCriteria") != null && request.getParameter("loadCriteria").equalsIgnoreCase("yes")) {
%>
<jsp:include page="load-save-criteria.jsp">
  <jsp:param name="fromWhere" value="<%=request.getParameter("fromWhere")%>"/>
  <jsp:param name="criterianame" value="<%=request.getParameter("criterianame")%>"/>
  <jsp:param name="siteName" value="<%=request.getParameter("siteName")%>"/>
  <jsp:param name="natureobject" value="<%=NatureObject%>"/>
  <jsp:param name="idsession" value="<%=IdSession%>"/>
</jsp:include>
<%
  }
%>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,advanced_search" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<%=cm.cmsText("habitats_advanced_01")%>
<br />
<table summary="layout" border="0">
  <tr>
    <td id="status">
      <%=cm.cmsText("habitats_advanced_03")%>:
    </td>
  </tr>
</table>
<%
  String listcriteria = "";
  String explainedcriteria = "";
%>
<form method="post" action="habitats-advanced.jsp" name="criteria">
<input type="hidden" name="criteria" value="" />
<input type="hidden" name="attribute" value="" />
<input type="hidden" name="operator" value="" />
<input type="hidden" name="firstvalue" value="" />
<input type="hidden" name="lastvalue" value="" />
<input type="hidden" name="oldfirstvalue" value="" />
<input type="hidden" name="oldlastvalue" value="" />
<input type="hidden" name="action" value="" />
<input type="hidden" name="idnode" value="" />
<input type="hidden" name="natureobject" value="<%=NatureObject%>" />
<input type="hidden" name="idsession" value="<%=IdSession%>" />
<%
  //  System.out.println("NatureObject = " + NatureObject);
  //  System.out.println("IdSession = " + IdSession);
  int SQL_LIMIT = Integer.parseInt(application.getInitParameter("SQL_LIMIT"));

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  //Utilities.dumpRequestParams(request);
  String p_action = request.getParameter("action");
  if (p_action == null) p_action = "";
  String p_idnode = request.getParameter("idnode");
  if (p_idnode == null) p_idnode = "";
  String p_criteria = request.getParameter("criteria");
  if (p_criteria == null) p_criteria = "";
  String p_attribute = request.getParameter("attribute");
  if (p_attribute == null) p_attribute = "";
  String p_operator = request.getParameter("operator");
  if (p_operator == null) p_operator = "";
  String p_firstvalue = request.getParameter("firstvalue");
  if (p_firstvalue == null) p_firstvalue = "";
  String p_lastvalue = request.getParameter("lastvalue");
  if (p_lastvalue == null) p_lastvalue = "";

  ro.finsiel.eunis.search.AdvancedSearch tas = new ro.finsiel.eunis.search.AdvancedSearch();
  tas.SetSQLLimit(SQL_LIMIT);

  tas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

  //prelucram actiunea curenta
  if (p_action.equalsIgnoreCase("reset")) {
    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
    String attribute = "ScientificName";
    if (NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    if (!tsas.DeleteRoot(IdSession, NatureObject, attribute)) {
      System.out.println("Error deleting root!");
    }
  }

  if (p_action.equalsIgnoreCase("deleteroot")) {
    //out.println("Delete root");
    String attribute = "ScientificName";
    if (NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    if (!tas.DeleteRootNoInitialize(IdSession, NatureObject, attribute)) {
      System.out.println("Error deleting root!");
%>
<script language="JavaScript" type="text/javascript">
<!--
alert('<%=cm.cms("error_deleting_root")%>');
//-->
</script>
<%
    }
  }

  if (p_action.equalsIgnoreCase("addroot")) {
    //out.println("Add root");
    String attribute = "ScientificName";
    if (NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    //System.out.println("attribute = " + attribute);
    tas.CreateInitialBranch(IdSession, NatureObject, attribute);
  }

  if (p_action.equalsIgnoreCase("add")) {
    //out.println("Add branch for node: "+p_idnode);
    String attribute = "ScientificName";
    if (NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    if (!tas.InsertBranch(p_idnode, IdSession, NatureObject, attribute)) {
      System.out.println("Error adding branch!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=cm.cms("error_adding_branch")%>');
      //-->
      </script>
      <%
    }
  }

  if (p_action.equalsIgnoreCase("delete")) {
    //out.println("Delete branch for node: "+p_idnode);
    if (!tas.DeleteBranch(p_idnode, IdSession, NatureObject)) {
      System.out.println("Error deleting branch!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=cm.cms("error_deleting_branch")%>');
      //-->
      </script>
      <%
    }
  }

  if (p_action.equalsIgnoreCase("compose")) {
    //out.println("Compose branch for node: "+p_idnode);
    if (!tas.ComposeBranch(p_idnode, IdSession, NatureObject)) {
      System.out.println("Error composing branch!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=cm.cms("error_compsing_branch_1")%>');
      //-->
      </script>
      <%
    }
  }

  if (p_action.length() == 0) {
    if (p_criteria.length() != 0) {
      //out.println("New criteria: "+p_criteria+" for node: "+p_idnode);
      tas.ChangeCriteria(p_idnode, IdSession, NatureObject, p_criteria);
    }
    if (p_attribute.length() != 0) {
      //out.println("New attribute: "+p_attribute+" for node: "+p_idnode);
      tas.ChangeAttribute(p_idnode, IdSession, NatureObject, p_attribute);
    }
    if (p_operator.length() != 0) {
      //out.println("New operator: "+p_operator+" for node: "+p_idnode);
      tas.ChangeOperator(p_idnode, IdSession, NatureObject, p_operator);
    }
    if (p_firstvalue.length() != 0) {
      //out.println("New first value: "+p_firstvalue+" for node: "+p_idnode);
      //System.out.println("first value:" + p_firstvalue);
      tas.ChangeFirstValue(p_idnode, IdSession, NatureObject, p_firstvalue);
    }
    if (p_lastvalue.length() != 0) {
      //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
      //System.out.println("last value:" + p_lastvalue);
      tas.ChangeLastValue(p_idnode, IdSession, NatureObject, p_lastvalue);
    }
  }

  String SQL = "";
  String NodeType = "";
  String IdNode = "";
  String val = "";
  String selected = "";
  String currentAttribute = "";
  String currentOperator = "";
  String currentValue = "";

  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  try {
    Class.forName(SQL_DRV);
    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
  }
  catch (Exception e) {
    e.printStackTrace();
    return;
  }

  SQL = "SELECT ";
  SQL += "EUNIS_ADVANCED_SEARCH.ID_NODE,";
  SQL += "EUNIS_ADVANCED_SEARCH.NODE_TYPE,";
  SQL += "EUNIS_ADVANCED_SEARCH_CRITERIA.ATTRIBUTE,";
  SQL += "EUNIS_ADVANCED_SEARCH_CRITERIA.OPERATOR,";
  SQL += "EUNIS_ADVANCED_SEARCH_CRITERIA.FIRST_VALUE,";
  SQL += "EUNIS_ADVANCED_SEARCH_CRITERIA.LAST_VALUE ";
  SQL += "FROM ";
  SQL += "EUNIS_ADVANCED_SEARCH ";
  SQL += "LEFT OUTER JOIN EUNIS_ADVANCED_SEARCH_CRITERIA ON (EUNIS_ADVANCED_SEARCH.ID_SESSION = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_SESSION) AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT = EUNIS_ADVANCED_SEARCH_CRITERIA.NATURE_OBJECT) AND (EUNIS_ADVANCED_SEARCH.ID_NODE = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_NODE) ";
  SQL += "WHERE (EUNIS_ADVANCED_SEARCH.ID_SESSION='" + IdSession + "') ";
  SQL += "AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT='" + NatureObject + "') ";
  SQL += "ORDER BY ";
  SQL += "EUNIS_ADVANCED_SEARCH.ID_NODE ";

  ps = con.prepareStatement(SQL);
  rs = ps.executeQuery();
  if (rs.isBeforeFirst()) {
    //if(1==1){
    while (rs.next()) {
      IdNode = rs.getString("ID_NODE");
      NodeType = rs.getString("NODE_TYPE");
      if (!IdNode.equalsIgnoreCase("0")) {
        out.println("&nbsp;");
        out.println("&nbsp;");
      }
      for (int i = 1; i <= IdNode.length() * 3; i++) {
        if (!IdNode.equalsIgnoreCase("0")) {
          out.println("&nbsp;");
        }
      }

      if (!IdNode.equalsIgnoreCase("0")) {
        if (IdNode.length() <= 3) {
          %>
          <a title="<%=cm.cms("add_criterion")%>" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="<%=cm.cms("add_criterion")%>" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_criterion")%>" /></a><%=cm.cmsTitle("add_criterion")%>
          <%
        }
        if (IdNode.equalsIgnoreCase("1")) {
        %>
        <img border="0" src="images/mini/space.gif" alt="" />
        <%
        } else {
        %>
        <a title="<%=cm.cms("delete_criterion")%>" href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img border="0" src="images/mini/delete.gif" alt="<%=cm.cms("delete_criterion")%>" width="13" height="13" title="<%=cm.cms("delete_criterion")%>" /></a><%=cm.cmsTitle("delete_criterion")%>
        <%
        }

        if (IdNode.length() < 3) {
          if (NodeType.equalsIgnoreCase("Criteria")) {
          %>
          <a title="<%=cm.cms("compose_criterion")%>" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="<%=cm.cms("compose_criterion")%>" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=cm.cms("compose_criterion")%>" /></a><%=cm.cmsTitle("compose_criterion")%>
          <%
          }
        }
          out.println("&nbsp;" + IdNode);
      } else {
        %>
        <a title="<%=cm.cms("delete_root_criterion")%>" href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="<%=cm.cms("delete_root_criterion")%>" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_root_criterion")%>" /></a><%=cm.cmsTitle("delete_root_criterion")%>
        <%
      }

  String cmsCriteria = cm.cms("criteria");
  String cmsAttribute = cm.cms("advanced_attribute");
  String cmsOperator = cm.cms("operator");
  String cmsAll = cm.cms("all");
  String cmsAny = cm.cms("any");
  String cmsFollowingCriteria = cm.cms("of_following_criteria_are_met");

  if (!NodeType.equalsIgnoreCase("Criteria")) {
    out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">"+cmsCriteria+"</label>");
    out.println("<select name=\"Criteria" + IdNode + "\" class=\"inputTextField\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsCriteria+"\" id=\"Criteria"+ IdNode + "\">");
    if (NodeType.equalsIgnoreCase("All")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"All\">"+cmsAll+"</option>");
    if (NodeType.equalsIgnoreCase("Any")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Any\">"+cmsAny+"</option>");
    out.println("</select> " + cmsFollowingCriteria + ":");
    out.println("<br />");
  } else {
    val = rs.getString("ATTRIBUTE");
    currentAttribute = val;
    out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">"+cmsAttribute+"</label>");
    out.println("<select name=\"Attribute" + IdNode + "\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsAttribute+"\" id=\"Attribute" + IdNode + "\">");

    if (NatureObject.equalsIgnoreCase("Habitat")) {
      if (val.equalsIgnoreCase("ScientificName")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"ScientificName\">" + cm.cms("name") + "</option>");
      if (val.equalsIgnoreCase("Code")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Code\">" + cm.cms("code_eunis_annex") + "</option>");
      if (val.equalsIgnoreCase("LegalInstruments")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"LegalInstruments\">" + cm.cms("legal_instruments") + "</option>");
      if (val.equalsIgnoreCase("SourceDatabase")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"SourceDatabase\">" + cm.cms("source_database") + "</option>");
      if (val.equalsIgnoreCase("Country")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Country\">" + cm.cms("country") + "</option>");
      if (val.equalsIgnoreCase("Biogeoregion")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Biogeoregion\">" + cm.cms("biogeographic_region") + "</option>");
      if (val.equalsIgnoreCase("Author")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Author\">" + cm.cms("reference_author") + "</option>");
      if (val.equalsIgnoreCase("Title")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Title\">" + cm.cms("reference_title") + "</option>");
      if (val.equalsIgnoreCase("Altitude")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Altitude\">" + cm.cms("altitude") + "</option>");
      if (val.equalsIgnoreCase("Chemistry")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Chemistry\">" + cm.cms("chemistry") + "</option>");
      if (val.equalsIgnoreCase("Climate")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Climate\">" + cm.cms("climate") + "</option>");
      if (val.equalsIgnoreCase("Cover")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Cover\">" + cm.cms("cover") + "</option>");
      if (val.equalsIgnoreCase("Depth")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Depth\">" + cm.cms("depth") + "</option>");
      if (val.equalsIgnoreCase("Geomorph")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Geomorph\">" + cm.cms("geomorph") + "</option>");
      if (val.equalsIgnoreCase("Humidity")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Humidity\">" + cm.cms("humidity") + "</option>");
      if (val.equalsIgnoreCase("LifeForm")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"LifeForm\">" + cm.cms("life_form") + "</option>");
      if (val.equalsIgnoreCase("LightIntensity")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"LightIntensity\">" + cm.cms("light_intensity") + "</option>");
      if (val.equalsIgnoreCase("Salinity")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Salinity\">" + cm.cms("salinity") + "</option>");
      if (val.equalsIgnoreCase("Spatial")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Spatial\">" + cm.cms("spatial") + "</option>");
      if (val.equalsIgnoreCase("Substrate")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Substrate\">" + cm.cms("substrate") + "</option>");
      if (val.equalsIgnoreCase("Temporal")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Temporal\">" + cm.cms("temporal") + "</option>");
      if (val.equalsIgnoreCase("Water")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Water\">" + cm.cms("water") + "</option>");
      if (val.equalsIgnoreCase("Usage")) { selected = " selected=\"selected\""; } else { selected = ""; }
      out.println("<option" + selected + " value=\"Usage\">" + cm.cms("usage") + "</option>");
    }
    out.println("</select>");
    %>
    <%=cm.cmsInput("name")%>
    <%=cm.cmsInput("code_eunis_annex")%>
    <%=cm.cmsInput("legal_instruments")%>
    <%=cm.cmsInput("source_database")%>
    <%=cm.cmsInput("country")%>
    <%=cm.cmsInput("biogeographic_region")%>
    <%=cm.cmsInput("reference_author")%>
    <%=cm.cmsInput("reference_title")%>
    <%=cm.cmsInput("altitude")%>
    <%=cm.cmsInput("chemistry")%>
    <%=cm.cmsInput("climate")%>
    <%=cm.cmsInput("cover")%>
    <%=cm.cmsInput("depth")%>
    <%=cm.cmsInput("geomorph")%>
    <%=cm.cmsInput("humidity")%>
    <%=cm.cmsInput("life_form")%>
    <%=cm.cmsInput("light_intensity")%>
    <%=cm.cmsInput("marine")%>
    <%=cm.cmsInput("salinity")%>
    <%=cm.cmsInput("spatial")%>
    <%=cm.cmsInput("substrate")%>
    <%=cm.cmsInput("temporal")%>
    <%=cm.cmsInput("tidal")%>
    <%=cm.cmsInput("water")%>
    <%=cm.cmsInput("usage")%>
    <%
    out.println("&nbsp;");

    val = rs.getString("OPERATOR");
    currentOperator = val;
    out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">"+cmsOperator+"</label>");
    out.println("<select name=\"Operator" + IdNode + "\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsOperator+"\" id=\"Operator" + IdNode + "\">");

    if (val.equalsIgnoreCase("Equal")) {
      selected = " selected";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Equal\">" + cm.cms("equal") + "</option>");

    if (val.equalsIgnoreCase("Contains")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Contains\">" + cm.cms("contains") + "</option>");

    if (val.equalsIgnoreCase("Between")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    if (!rs.getString("ATTRIBUTE").equalsIgnoreCase("LegalInstruments")) {
      out.println("<option" + selected + " value=\"Between\">" + cm.cms("between") + "</option>");
    }

    if (val.equalsIgnoreCase("Regex")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Regex\">Regex</option>");

    out.println("</select>");
    %>
    <%=cm.cmsInput("equal")%>
    <%=cm.cmsInput("contains")%>
    <%=cm.cmsInput("between")%>
    <%
    out.println("&nbsp;");

    val = rs.getString("FIRST_VALUE");
    currentValue = val;
%>
<label for="First_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
<input type="text" title="<%=cm.cms("list_of_values")%>" class="inputTextField" id="First_Value<%=IdNode%>" name="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
<%=cm.cmsTitle("list_of_values")%>
<a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cms("list_of_values")%>" /></a>
<%
  if (rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
    out.println(cm.cmsText("and"));
    val = rs.getString("LAST_VALUE");
    currentValue = val;
%>
<label for="Last_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
<input type="text" title="<%=cm.cms("list_of_values")%>" class="inputTextField" id="Last_Value<%=IdNode%>" name="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
<%=cm.cmsTitle("list_of_values")%>
<a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cms("list_of_values")%>" /></a>
<%
  }
%>
<br />
<%
    }
  }
%>
    <br />
    <input type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="Save" id="Save" name="Save" title="<%=cm.cms("save")%>" />
    <%=cm.cmsTitle("save")%>
    &nbsp;&nbsp;&nbsp;
    <input type="submit" class="inputTextField" value="Search" id="Search" name="Search" title="<%=cm.cms("search")%>" />
    <%=cm.cmsTitle("search")%>
    &nbsp;&nbsp;&nbsp;
    <input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="Reset" id="Reset" name="Reset" title="<%=cm.cms("reset")%>" />
    <%=cm.cmsTitle("reset")%>
    <%
} else {
    %>
    <a title="<%=cm.cms("add_root")%>" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_root")%>" alt="<%=cm.cms("add_root")%>" /></a>&nbsp;<%=cm.cmsText("add_root")%>
    <%
}

rs.close();
%>
</form>
<br />
<strong>
  <%=cm.cmsText("advanced_search_might_take_long_time")%>
</strong>
<br />
<%

  String criteria = tas.createCriteria(IdSession, NatureObject);
  out.println(cm.cmsText("habitats_advanced_50") + ":");
  explainedcriteria=criteria.replace('#',' ').replace('[','(').replace(']',')').replaceAll("AND","<strong>AND</strong>").replaceAll("OR","<strong>OR</strong>");
  out.println(explainedcriteria);

  out.println("<br />");
  out.println("<br />");
  out.flush();

  if (request.getParameter("Search") != null) {
    String finalwhere = "";
    String node = "";
    int pos_start = -1;
    int pos_end = -1;
    String interpretedcriteria = "";
    String intermediatefilter = "";

    if (NatureObject.equalsIgnoreCase("Habitat")) {
      ro.finsiel.eunis.search.AdvancedSearch tsas;
      tsas = new ro.finsiel.eunis.search.AdvancedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
      pos_start = criteria.indexOf('#');
      pos_end = criteria.indexOf('#', pos_start + 1);
      while (pos_start != -1 && pos_end != -1) {
        node = criteria.substring(pos_start + 1, pos_end);
        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
        listcriteria += node + ": " + interpretedcriteria + "<br />";
        out.println(cm.cmsText("searching_for") + " " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
        out.println(cm.cmsText("advanced_found") + " <strong>" + tsas.getResultCount() + "</strong>");
        if (tsas.getResultCount() >= SQL_LIMIT) {
          out.println("<br />&nbsp;&nbsp;(" + cm.cmsText("advanced_only_first") + " "+SQL_LIMIT + " " + cm.cmsText("advanced_were_retrieved") + ")");
        }
        out.println("<br />");
        out.flush();

        finalwhere = "";
        finalwhere += criteria.substring(0, pos_start);
        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
        finalwhere += criteria.substring(pos_end + 1);
        criteria = finalwhere;

        pos_start = criteria.indexOf('#', pos_end + 1);
        if (pos_start != -1) {
          pos_end = criteria.indexOf('#', pos_start + 1);
        } else {
        }
      }
    }

    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
    String str = tsas.calculateCriteria(IdSession, NatureObject);

    tsas.DeleteResults(IdSession, NatureObject);

    str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_" + NatureObject.toUpperCase() + " WHERE (" + str + ")";
    String query = tsas.ExecuteFilterSQL(str, "");
%>
<br />
<strong>
  <%=cm.cmsText("habitats_advanced_54")%>: <%=tsas.getResultCount()%>
</strong>
<br />
<%
  out.flush();

  if (tsas.getResultCount() > 0) {
    tsas.AddResult(IdSession, NatureObject, query);
  }

  if (tsas.getResultCount() > 0) {
%>
<form name="search" action="select-columns.jsp" method="post">
  <input type="submit" name="Proceed to next step" title="<%=cm.cms("proceed_to_next_step")%>" id="NextStep" value="<%=cm.cms("proceed_to_next_step")%>" class="inputTextField" />
  <%=cm.cmsInput("proceed_to_next_step")%>
  <input type="hidden" name="searchedNatureObject" value="Habitats" />
  <input type="hidden" name="origin" value="Advanced" />
  <input type="hidden" name="explainedcriteria" value="<%=explainedcriteria%>" />
  <input type="hidden" name="listcriteria" value="<%=listcriteria%>" />
</form>
<%
  // Save this advanced search
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
%>
<br />
<br />
<table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <form name="saveCriteriaSearch" action="save-species-or-habitats-advanced-search-criteria.jsp" method="post">
        <input type="button" name="Save Criteria" title="<%=cm.cms("save_criteria")%>" id="SaveCriteria" value="<%=cm.cms("habitats_advanced_56")%>" class="inputTextField" onclick="javascript:SaveCriteriaFunction();" />
        <%=cm.cmsInput("habitats_advanced_56")%>
        <input type="hidden" name="idsession" value="<%=IdSession%>" />
        <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
        <input type="hidden" name="username" value="<%=SessionManager.getUsername()%>" />
        <input type="hidden" name="fromWhere" value="habitats-advanced.jsp" />
      </form>
    </td>
  </tr>
</table>
<%
  }
%>
<%
} else {
%>
<br />
<%=cm.cmsText("no_results")%>
<br />
<%
    }
  }
  con.close();
  // Expand saved advanced searches list for this jsp page
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
  {
    String exp = (request.getParameter("expandCriterias") == null ? "no" : request.getParameter("expandCriterias"));
  %>
  <br />
  <br />
  <table summary="layout" width="100%" border="0">
    <tr>
      <td>
        <img alt="<%=cm.cms("advanced_expand_collapse")%>" border="0" style="vertical-align:middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="<%=cm.cms("advanced_expand_collapse")%>" href="habitats-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? cm.cms("hide") : cm.cms("habitats_advanced_60"))%> <%=cm.cmsText("generic_index_07")%></a>
        <%=cm.cmsTitle("advanced_expand_collapse")%>
        <%=cm.cmsTitle("hide")%>
        <%=cm.cmsTitle("habitats_advanced_60")%>
      </td>
    </tr>
  </table>
  <%
  // If list is expanded
  if (exp !=null && exp.equals("yes"))
  {
%>
<form name="loadSaveCriteria" method="post" action="habitats-advanced.jsp">
  <input type ="hidden" name="loadCriteria" value="yes" />
  <input type ="hidden" name="fromWhere" value="" />
  <input type ="hidden" name="criterianame" value="" />
  <input type ="hidden" name="natureobject" value="" />
  <input type ="hidden" name="expandCriterias" value="yes" />
</form>

<form name="deleteSaveCriteria" method="post" action="delete-save-advanced-search-criteria.jsp">
  <input type ="hidden" name="fromWhere" value="" />
  <input type ="hidden" name="criterianame" value="" />
  <input type ="hidden" name="natureobject" value="" />
</form>

<%      // list of saved searches
  out.print(SaveAdvancedSearchCriteria.ExpandSaveCriteriaForThisPage(SQL_DRV,
    SQL_URL,
    SQL_USR,
    SQL_PWD,
    SessionManager.getUsername(),
    "habitats-advanced.jsp"));
}
}
%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_search")%>
<%=cm.br()%>
<%=cm.cmsMsg("press_save_to_save_criteria")%>
<%=cm.br()%>
<%=cm.cmsMsg("criteria_saved")%>
<%=cm.br()%>
<%=cm.cmsMsg("previous_values_was_restored")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_search")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_deleting_root")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_adding_branch")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_deleting_branch")%>
<%=cm.br()%>
<%=cm.cmsMsg("criteria")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_attribute")%>
<%=cm.br()%>
<%=cm.cmsMsg("operator")%>
<%=cm.br()%>
<%=cm.cmsMsg("all")%>
<%=cm.br()%>
<%=cm.cmsMsg("any")%>
<%=cm.br()%>
<%=cm.cmsMsg("of_following_criteria_are_met")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_deleting_root")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_adding_branch")%>
<%=cm.br()%>
<%=cm.cmsMsg("error_deleting_branch")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-advanced.jsp" />
</jsp:include>
  </div>
  </div>
  </div>
</body>
</html>

