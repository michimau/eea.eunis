<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Step 2 of 'Combined search' function - Selection of 2nd nature object filter.
  - Request params :
      * previousnatureobject -
      * natureobject -
      * idsession -
      * nextnatureobject -
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("previousnatureobject") != null ? request.getParameter("previousnatureobject") : ""%>
  <%=contentManagement.getContent("generic_combined-search-step2_title", false)%>
</title>
<script language="JavaScript" type="text/javascript">
<!--
  var current_selected = "";
//-->
</script>

<script language="JavaScript" type="text/javascript">
<!--
  function MM_jumpMenu(targ,selObj,restore){ //v3.0
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }

  function setCurrentSelected(val) {
<%--    alert(val);--%>
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
<%--    alert("criteria=" + criteria.value + ", idnode=" + idnode);--%>
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
    document.getElementById("status").innerHTML="<span style=\"color:Red\">Press 'Save' to save criteria.</span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:Red\">Your criteria has been saved.</span>"
  }

  function submitAttributeForm(attribute, idnode) {
<%--    alert("attribute=" + attribute.value + ", idnode=" + idnode);--%>
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
      alert('<%=contentManagement.getContent("generic_combined-search-step2_09",false)%>');
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
<%--      alert(current_selected);--%>
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
      <%-- Same message as above --%>
      alert('<%=contentManagement.getContent("generic_combined-search-step2_09",false)%>');
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
<%--    alert("action=" + action + ", idnode=" + idnode);--%>
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


  function submitClearData() {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value="";
    document.criteria.action.value="clear";
    document.criteria.submit();
  }

  function submitKeepData(natureobject) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value="";
    if (document.criteria.natureobject != null && natureobject != null)
       document.criteria.natureobject.value=natureobject;
    document.criteria.action.value="keep";
    document.criteria.submit();
  }


//  function changeNatureObject() {
//<%--    alert(document.criteria.natureobject.value);--%>
//    document.criteria.submit();
//  }

  function changeNatureObject(action) {
<%--    alert(document.criteria.natureobject.value);--%>
     document.criteria.action.value=action;
    document.criteria.submit();
  }
//-->
</script>
</head>

<body>
<div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Combined search#combined-search.jsp,Combined search - step 2" />
  <jsp:param name="helpLink" value="combined-help.jsp" />
</jsp:include>
<%=contentManagement.getContent("generic_combined-search-step2_01")%>
<br />
<table summary="layout" border="0">
  <tr>
    <td id="status">
      <%=contentManagement.getContent("generic_combined-search-step2_02")%>
    </td>
  </tr>
</table>
<%
  if(request.getParameter("combinednatureobject1") != null && SessionManager.getCombinednatureobject1() == null) {
    SessionManager.setCombinednatureobject1(request.getParameter("combinednatureobject1"));
    SessionManager.setCombinedlistcriteria1(request.getParameter("combinedlistcriteria1"));
    SessionManager.setCombinedexplainedcriteria1(request.getParameter("combinedexplainedcriteria1"));
  }
  if(request.getParameter("sourcedbcriteria") != null && SessionManager.getSourcedb() == null) {
    SessionManager.setSourcedb(request.getParameter("sourcedbcriteria"));
  }

  String combinednatureobject2 = "";
  String combinedlistcriteria2 = "";
  String combinedexplainedcriteria2 = "";
  String sourcedbcriteria = "";

  String IdSession = request.getParameter("idsession");
  String NatureObject = request.getParameter("natureobject");
  String PreviousNatureObject = request.getParameter("previousnatureobject");
  String NextNatureObject = request.getParameter("nextnatureobject");
//  System.out.println("NatureObject = " + NatureObject);
  if(IdSession == null || IdSession.length() == 0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession = request.getSession().getId();
  }
  if(NatureObject == null || NatureObject.length() == 0 || NatureObject.equalsIgnoreCase("undefined")) {
    System.out.println("No nature object found - Default to Habitats");
    PreviousNatureObject = "Species";
    NatureObject = "Habitat";
    NextNatureObject = "Sites";
  }

  String SourceDB = "";
  if(request.getParameter("DIPLOMA") != null) SourceDB += ",'DIPLOMA'";
  if(request.getParameter("CDDA_NATIONAL") != null) SourceDB += ",'CDDA_NATIONAL'";
  if(request.getParameter("CDDA_INTERNATIONAL") != null) SourceDB += ",'CDDA_INTERNATIONAL'";
  if(request.getParameter("BIOGENETIC") != null) SourceDB += ",'BIOGENETIC'";
  if(request.getParameter("NATURA2000") != null) SourceDB += ",'NATURA2000'";
  if(request.getParameter("NATURENET") != null) SourceDB += ",'NATURENET'";
  if(request.getParameter("EMERALD") != null) SourceDB += ",'EMERALD'";
  if(request.getParameter("CORINE") != null) SourceDB += ",'CORINE'";

  if(SourceDB.equalsIgnoreCase("")) {
    SourceDB = "''";
  } else {
    if(SourceDB.length() > 1) {
      SourceDB = SourceDB.substring(1, SourceDB.length());
    }
  }
  sourcedbcriteria = SourceDB;
%>
<form method="post" action="combined-search-2.jsp" name="criteria">
<strong>Step 2.</strong>
<%
  if(PreviousNatureObject.equalsIgnoreCase("Species")) {
%>
<%=contentManagement.getContent("generic_combined-search-step2_03")%>
<%
  }
  if(PreviousNatureObject.equalsIgnoreCase("Habitat")) {
%>
<%=contentManagement.getContent("generic_combined-search-step2_04")%>
<%
  }
  if(PreviousNatureObject.equalsIgnoreCase("Sites")) {
%>
<%=contentManagement.getContent("generic_combined-search-step2_05")%>
<%
  }
%>
<hr width="740" size="1" align="left" />
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
<input type="hidden" name="previousnatureobject" value="<%=PreviousNatureObject%>" />
<input type="hidden" name="nextnatureobject" value="<%=NextNatureObject%>" />
<input type="hidden" name="idsession" value="<%=IdSession%>" />
<%
  //  System.out.println("NatureObject = " + NatureObject);
//  System.out.println("IdSession = " + IdSession);
  String SQL_DRV = "";
  String SQL_URL = "";
  String SQL_USR = "";
  String SQL_PWD = "";
  int SQL_LIMIT = 500000;

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

  //Utilities.dumpRequestParams(request);
  String p_action = request.getParameter("action");
  if(p_action == null) p_action = "";
  String p_idnode = request.getParameter("idnode");
  if(p_idnode == null) p_idnode = "";
  String p_criteria = request.getParameter("criteria");
  if(p_criteria == null) p_criteria = "";
  String p_attribute = request.getParameter("attribute");
  if(p_attribute == null) p_attribute = "";
  String p_operator = request.getParameter("operator");
  if(p_operator == null) p_operator = "";
  String p_firstvalue = request.getParameter("firstvalue");
  if(p_firstvalue == null) p_firstvalue = "";
  String p_lastvalue = request.getParameter("lastvalue");
  if(p_lastvalue == null) p_lastvalue = "";

  ro.finsiel.eunis.search.CombinedSearch tas = new ro.finsiel.eunis.search.CombinedSearch();
  tas.SetSQLLimit(SQL_LIMIT);

  tas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

  //prelucram actiunea curenta
  if(p_action.equalsIgnoreCase("reset")) {
    ro.finsiel.eunis.search.CombinedSearch tsas;
    tsas = new ro.finsiel.eunis.search.CombinedSearch();
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
    String attribute = "ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    tsas.DeleteRoot(IdSession, NatureObject, attribute);
  }

  if(p_action.equalsIgnoreCase("deleteroot")) {
    //out.println("Delete root");
    String attribute = "ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    if(!tas.DeleteRootNoInitialize(IdSession, NatureObject, attribute)) {
      System.out.println("Error deleting root!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=contentManagement.getContent("generic_combined-search-step2_20",false)%>');
      //-->
      </script>
      <%
    }
  }

  if(p_action.equalsIgnoreCase("addroot")) {
    //out.println("Add root");
    String attribute = "ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    tas.CreateInitialBranch(IdSession, NatureObject, attribute);
  }

  if(p_action.equalsIgnoreCase("add")) {
    //out.println("Add branch for node: "+p_idnode);
    String attribute = "ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute = "Name";
    }
    if(!tas.InsertBranch(p_idnode, IdSession, NatureObject, attribute)) {
%>
<script language="JavaScript" type="text/javascript">
<!--
  alert('<%=contentManagement.getContent("generic_combined-search-step2_10",false)%>');
//-->
</script>
<%
    }
  }

  if(p_action.equalsIgnoreCase("delete")) {
    //out.println("Delete branch for node: "+p_idnode);
    if(!tas.DeleteBranch(p_idnode, IdSession, NatureObject)) {
      System.out.println("Error deleting branch!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=contentManagement.getContent("generic_combined-search-step2_11",false)%>');
      //-->
      </script>
<%
    }
  }

  if(p_action.equalsIgnoreCase("compose")) {
    //out.println("Compose branch for node: "+p_idnode);
    if(!tas.ComposeBranch(p_idnode, IdSession, NatureObject)) {
      System.out.println("Error composing branch!");
      %>
      <script language="JavaScript" type="text/javascript">
      <!--
      alert('<%=contentManagement.getContent("generic_combined-search-step2_12",false)%>');
      //-->
      </script>
      <%
    }
  }

  if(p_action.length() == 0) {
    if(p_criteria.length() != 0) {
      //out.println("New criteria: "+p_criteria+" for node: "+p_idnode);
      tas.ChangeCriteria(p_idnode, IdSession, NatureObject, p_criteria);
    }
    if(p_attribute.length() != 0) {
      //out.println("New attribute: "+p_attribute+" for node: "+p_idnode);
      tas.ChangeAttribute(p_idnode, IdSession, NatureObject, p_attribute);
    }
    if(p_operator.length() != 0) {
      //out.println("New operator: "+p_operator+" for node: "+p_idnode);
      tas.ChangeOperator(p_idnode, IdSession, NatureObject, p_operator);
    }
    if(p_firstvalue.length() != 0) {
      //out.println("New first value: "+p_firstvalue+" for node: "+p_idnode);
//      System.out.println("first value:" + p_firstvalue);
      tas.ChangeFirstValue(p_idnode, IdSession, NatureObject, p_firstvalue);
    }
    if(p_lastvalue.length() != 0) {
      //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
//      System.out.println("last value:" + p_lastvalue);
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
  catch(Exception e) {
    e.printStackTrace();
    return;
  }

  SQL = "SELECT ";
  SQL += "EUNIS_COMBINED_SEARCH.ID_NODE,";
  SQL += "EUNIS_COMBINED_SEARCH.NODE_TYPE,";
  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.ATTRIBUTE,";
  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.OPERATOR,";
  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.FIRST_VALUE,";
  SQL += "EUNIS_COMBINED_SEARCH_CRITERIA.LAST_VALUE ";
  SQL += "FROM ";
  SQL += "EUNIS_COMBINED_SEARCH ";
  SQL += "LEFT OUTER JOIN EUNIS_COMBINED_SEARCH_CRITERIA ON (EUNIS_COMBINED_SEARCH.ID_SESSION = EUNIS_COMBINED_SEARCH_CRITERIA.ID_SESSION) AND (EUNIS_COMBINED_SEARCH.NATURE_OBJECT = EUNIS_COMBINED_SEARCH_CRITERIA.NATURE_OBJECT) AND (EUNIS_COMBINED_SEARCH.ID_NODE = EUNIS_COMBINED_SEARCH_CRITERIA.ID_NODE) ";
  SQL += "WHERE (EUNIS_COMBINED_SEARCH.ID_SESSION='" + IdSession + "') ";
  SQL += "AND (EUNIS_COMBINED_SEARCH.NATURE_OBJECT='" + NatureObject + "') ";
  SQL += "ORDER BY ";
  SQL += "EUNIS_COMBINED_SEARCH.ID_NODE ";

  try {
    ps = con.prepareStatement(SQL);
  } catch(SQLException e) {
    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
  }
  try {
    rs = ps.executeQuery();
  } catch(SQLException e) {
    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
  }
  if(rs.isBeforeFirst()) {
    //if(1==1){
    while(rs.next()) {
      IdNode = rs.getString("ID_NODE");
      NodeType = rs.getString("NODE_TYPE");
      if(!IdNode.equalsIgnoreCase("0")) {
        out.println("&nbsp;");
        out.println("&nbsp;");
      }
      for(int i = 1; i <= IdNode.length() * 3; i++) {
        if(!IdNode.equalsIgnoreCase("0")) {
          out.println("&nbsp;");
        }
      }
      ;

      if(!IdNode.equalsIgnoreCase("0")) {
        if(IdNode.length() <= 3) {
%>
  <a title="Add criteria" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="Add criteria" border="0" src="images/mini/add.gif" width="13" height="13" title="Add new criterion" /></a>
  <%
    }
    if(IdNode.equalsIgnoreCase("1")) {
  %>
  <img alt="" border="0" src="images/mini/space.gif" />
  <%
    } else {
      out.println("<a title=\"Delete\" href=\"javascript:submitButtonForm('delete','" + IdNode + "');\"><img alt=\"Delete\" border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" title=\"Delete criterion\" /></a>");
    }
    if(IdNode.length() < 3) {
      if(NodeType.equalsIgnoreCase("Criteria")) {
        out.println("<a title=\"Compose\" href=\"javascript:submitButtonForm('compose','" + IdNode + "');\"><img alt=\"Compose\" border=\"0\" src=\"images/mini/compose.gif\" width=\"13\" height=\"13\" title=\"Transform this node into a combination of criteria\" /></a>");
      }
    }
    out.println(" " + IdNode);
  } else {
    out.println("<a title=\"Delete root\" href=\"javascript:submitButtonForm('deleteroot','" + IdNode + "');\"><img alt=\"Delete root\" border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" title=\"Delete the criterion node, including the subnode\" /></a>");
  }

  if(!NodeType.equalsIgnoreCase("Criteria")) {
    out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">Criteria</label>");
    out.println("<select name=\"Criteria" + IdNode + "\" class=\"inputTextField\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select criteria\" id=\"Criteria" + IdNode + "\">");
    if(NodeType.equalsIgnoreCase("All")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"All\">All</option>");
    if(NodeType.equalsIgnoreCase("Any")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Any\">Any</option>");
    out.println("</select> of following criteria are met:");
    out.println("<br />");
  } else {
    val = rs.getString("ATTRIBUTE");
    currentAttribute = val;
    out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">Attribute</label>");
    out.println("<select title=\"Attribute\" name=\"Attribute" + IdNode + "\" id=\"Attribute" + IdNode + "\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\">");
    if(NatureObject.equalsIgnoreCase("Habitat")) {
      if(val.equalsIgnoreCase("ScientificName")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"ScientificName\">Name</option>");
      if(val.equalsIgnoreCase("LegalInstruments")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      if(val.equalsIgnoreCase("Code")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Code\">Code (EUNIS or Annex I)</option>");
      out.println("<option" + selected + " value=\"LegalInstruments\">Legal Instruments</option>");
      if(val.equalsIgnoreCase("SourceDatabase")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"SourceDatabase\">Source Database</option>");
      if(val.equalsIgnoreCase("Country")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Country\">Country</option>");
      if(val.equalsIgnoreCase("Biogeoregion")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Biogeoregion\">Biogeoregion</option>");
      if(val.equalsIgnoreCase("Author")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Author\">Reference author</option>");
      if(val.equalsIgnoreCase("Title")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Title\">Reference title</option>");
      if(val.equalsIgnoreCase("Altitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Altitude\">Altitude</option>");
      if(val.equalsIgnoreCase("Chemistry")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Chemistry\">Chemistry</option>");
      if(val.equalsIgnoreCase("Climate")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Climate\">Climate</option>");
      if(val.equalsIgnoreCase("Cover")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Cover\">Cover</option>");
      if(val.equalsIgnoreCase("Depth")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Depth\">Depth</option>");
      if(val.equalsIgnoreCase("Geomorph")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Geomorph\">Geomorph</option>");
      if(val.equalsIgnoreCase("Humidity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Humidity\">Humidity</option>");
      if(val.equalsIgnoreCase("LifeForm")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LifeForm\">Life Form</option>");
      if(val.equalsIgnoreCase("LightIntensity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LightIntensity\">Light Intensity</option>");
      if(val.equalsIgnoreCase("Marine")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Marine\">Marine</option>");
      if(val.equalsIgnoreCase("Salinity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Salinity\">Salinity</option>");
      if(val.equalsIgnoreCase("Spatial")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Spatial\">Spatial</option>");
      if(val.equalsIgnoreCase("Substrate")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Substrate\">Substrate</option>");
      if(val.equalsIgnoreCase("Temporal")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Temporal\">Temporal</option>");
      if(val.equalsIgnoreCase("Tidal")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Tidal\">Tidal</option>");
      if(val.equalsIgnoreCase("Water")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Water\">Water</option>");
      if(val.equalsIgnoreCase("Usage")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Usage\">Usage</option>");
    } else if(NatureObject.equalsIgnoreCase("Species")) {
      if(val.equalsIgnoreCase("ScientificName")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"ScientificName\">Scientific Name</option>");
      if(val.equalsIgnoreCase("VernacularName")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"VernacularName\">Vernacular Name</option>");
      if(val.equalsIgnoreCase("Group")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Group\">Group</option>");
      if(val.equalsIgnoreCase("ThreatStatus")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"ThreatStatus\">Threat Status</option>");
      if(val.equalsIgnoreCase("InternationalThreatStatus")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"InternationalThreatStatus\">International Threat Status</option>");
      if(val.equalsIgnoreCase("Country")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Country\">Country</option>");
      if(val.equalsIgnoreCase("Biogeoregion")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Biogeoregion\">Biogeoregion</option>");
      if(val.equalsIgnoreCase("Author")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Author\">Reference author</option>");
      if(val.equalsIgnoreCase("Title")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Title\">Reference title</option>");
      if(val.equalsIgnoreCase("LegalInstrument")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LegalInstrument\">Legal instr. title</option>");
      if(val.equalsIgnoreCase("Taxonomy")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Taxonomy\">Taxonomy</option>");
      if(val.equalsIgnoreCase("Abundance")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Abundance\">Abundance</option>");
      if(val.equalsIgnoreCase("Trend")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Trend\">Trend</option>");
      if(val.equalsIgnoreCase("DistributionStatus")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"DistributionStatus\">Distribution Status</option>");
    } else if(NatureObject.equalsIgnoreCase("Sites")) {
      if(val.equalsIgnoreCase("Name")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Name\">Name</option>");
      if(val.equalsIgnoreCase("Code")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Code\">Code</option>");
      if(val.equalsIgnoreCase("DesignationYear")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"DesignationYear\">Designation Year</option>");
      if(val.equalsIgnoreCase("Country")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Country\">Country</option>");
      if(val.equalsIgnoreCase("Size")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Size\">Size</option>");
      if(val.equalsIgnoreCase("Longitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Longitude\">Longitude</option>");
      if(val.equalsIgnoreCase("Latitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Latitude\">Latitude</option>");
      if(val.equalsIgnoreCase("MinimumAltitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"MinimumAltitude\">Minimum Altitude</option>");
      if(val.equalsIgnoreCase("MaximumAltitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"MaximumAltitude\">Maximum Altitude</option>");
      if(val.equalsIgnoreCase("MeanAltitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"MeanAltitude\">Mean Altitude</option>");
      if(val.equalsIgnoreCase("Designation")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Designation\">Designation</option>");
      if(val.equalsIgnoreCase("HumanActivity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"HumanActivity\">HumanActivity</option>");
      if(val.equalsIgnoreCase("Motivation")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Motivation\">Motivation</option>");
      if(val.equalsIgnoreCase("RegionCode")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"RegionCode\">RegionCode</option>");
    }
    out.println("</select>");

    out.println("&nbsp;");

    val = rs.getString("OPERATOR");
    currentOperator = val;
    out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">Operator</label>");
    out.println("<select name=\"Operator" + IdNode + "\" id=\"Operator"+IdNode+"\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select operator type\">");
    if(val.equalsIgnoreCase("Equal")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Equal\">Equal</option>");
    if(val.equalsIgnoreCase("Contains")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Contains\">Contains</option>");
    if(val.equalsIgnoreCase("Between")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Between\">Between</option>");
    out.println("</select>");

    out.println("&nbsp;");

    val = rs.getString("FIRST_VALUE");
    currentValue = val;
%>
<label for="First_Value<%=IdNode%>" class="noshow">First search value</label>
<input type="text" title="List of values" class="inputTextField" name="First_Value<%=IdNode%>" id="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
<a title="List of values" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="Display list of possible values" /></a>
<%
  if(rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
    out.println(" and ");
    val = rs.getString("LAST_VALUE");
    currentValue = val;
%>
<label for="Last_Value<%=IdNode%>" class="noshow">Second search value</label>
<input type="text" title="List of values" class="inputTextField" name="Last_Value<%=IdNode%>" id="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
<a title="List of values" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="Display list of possible values" /></a>
<%
  }
%>
<br />
<%
    }
  }
%>
<% if(NatureObject.equalsIgnoreCase("Sites")) { %>
<br />
<jsp:include page="sites-databases.jsp" />
<br />
<% } %>
<br />
<label for="Save" class="noshow">Save criteria</label>
<input type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="Save" name="Save" id="Save" alt="Save search criteria" />
&nbsp;&nbsp;&nbsp;
<label for="Search" class="noshow">Search</label>
<input type="submit" class="inputTextField" value="Search" name="Search" id="Search" alt="Execute search" />
&nbsp;&nbsp;&nbsp;
<label for="Reset" class="noshow">Reset</label>
<input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="Reset" name="Reset" id="Reset" alt="Clear search criteria" />
<%
} else {
%>
<a title="Add root" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="Add condition" /></a>
<%=contentManagement.getContent("generic_combined-search-step2_06")%>
<%
  }
  rs.close();
%>
</form>
<br />
<strong>
  <%=contentManagement.getContent("generic_combined-search-step2_07")%>
</strong>
<br />
<%
  String criteria = tas.createCriteria(IdSession, NatureObject);
  out.println("Calculated search criteria expression: ");
  combinedexplainedcriteria2 = criteria.replace('#', ' ').replace('[', '(').replace(']', ')').replaceAll("AND", "<strong>AND</strong>").replaceAll("OR", "<strong>OR</strong>");
  out.println(combinedexplainedcriteria2);

  out.println("<br />");
  out.println("<br />");
  out.flush();

  if(request.getParameter("Search") != null) {
    String finalwhere = "";
    String node = "";
    int pos_start = -1;
    int pos_end = -1;
    String interpretedcriteria = "";
    String intermediatefilter = "";

    if(NatureObject.equalsIgnoreCase("Species")) {
      combinednatureobject2 = "Species";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
      pos_start = criteria.indexOf('#');
      pos_end = criteria.indexOf('#', pos_start + 1);
      while(pos_start != -1 && pos_end != -1) {
        node = criteria.substring(pos_start + 1, pos_end);
        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
        out.println("Searching for: " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
        out.println("found: <strong>" + tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount() >= SQL_LIMIT) {
          String str = contentManagement.getContent("generic_combined-search-step2_13");
          if(str != null) {
            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
            out.println(str);
          }
        }
        out.println("<br />");
        out.flush();

        finalwhere = "";
        finalwhere += criteria.substring(0, pos_start);
        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
        finalwhere += criteria.substring(pos_end + 1);
        criteria = finalwhere;

        pos_start = criteria.indexOf('#', pos_end + 1);
        if(pos_start != -1) {
          pos_end = criteria.indexOf('#', pos_start + 1);
        } else {
        }
      }
    }

    if(NatureObject.equalsIgnoreCase("Habitat")) {
      combinednatureobject2 = "Habitats";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
      pos_start = criteria.indexOf('#');
      pos_end = criteria.indexOf('#', pos_start + 1);
      while(pos_start != -1 && pos_end != -1) {
        node = criteria.substring(pos_start + 1, pos_end);
        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
        out.println("Searching for: " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
        out.println("found: <strong>" + tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount() >= SQL_LIMIT) {
          String str = contentManagement.getContent("generic_combined-search-step2_13");
          if(str != null) {
            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
            out.println(str);
          }
        }
        out.println("<br />");
        out.flush();

        finalwhere = "";
        finalwhere += criteria.substring(0, pos_start);
        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
        finalwhere += criteria.substring(pos_end + 1);
        criteria = finalwhere;

        pos_start = criteria.indexOf('#', pos_end + 1);
        if(pos_start != -1) {
          pos_end = criteria.indexOf('#', pos_start + 1);
        } else {
        }
      }
    }

    if(NatureObject.equalsIgnoreCase("Sites")) {
      combinednatureobject2 = "Sites";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSourceDB(SourceDB);
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
      pos_start = criteria.indexOf('#');
      pos_end = criteria.indexOf('#', pos_start + 1);
      while(pos_start != -1 && pos_end != -1) {
        node = criteria.substring(pos_start + 1, pos_end);
        interpretedcriteria = tsas.InterpretCriteria(node, IdSession, NatureObject);
        combinedlistcriteria2 += node + ": " + interpretedcriteria + "<br />";
        out.println("Searching for: " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
        out.println("found: <strong>" + tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount() >= SQL_LIMIT) {
          String str = contentManagement.getContent("generic_combined-search-step2_13");
          if(str != null) {
            str = str.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
            out.println(str);
          }
        }
        out.println("<br />");
        out.flush();

        finalwhere = "";
        finalwhere += criteria.substring(0, pos_start);
        finalwhere += "ID_NATURE_OBJECT IN (" + intermediatefilter + ")";
        finalwhere += criteria.substring(pos_end + 1);
        criteria = finalwhere;

        pos_start = criteria.indexOf('#', pos_end + 1);
        if(pos_start != -1) {
          pos_end = criteria.indexOf('#', pos_start + 1);
        } else {
        }
      }
    }

    ro.finsiel.eunis.search.CombinedSearch tsas;
    tsas = new ro.finsiel.eunis.search.CombinedSearch();
    tsas.SetSourceDB(SourceDB);
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
    String str = tsas.calculateCriteria(IdSession, NatureObject);

    tsas.DeleteResults(IdSession, NatureObject);

    if(NatureObject.equalsIgnoreCase("Species")) {
      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE (" + str + ")";
    }
    if(NatureObject.equalsIgnoreCase("Habitat")) {

      String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";
      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT WHERE   " + isGoodHabitat + " AND (" + str + ")";
    }
    if(NatureObject.equalsIgnoreCase("Sites")) {
      str = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE (" + str + ")";
    }
    String query = tsas.ExecuteFilterSQL(str, "");
    out.println("<br /><strong>Total found in database: " + tsas.getResultCount() + "</strong><br /><br />");
    out.flush();

    if(tsas.getResultCount() > 0) {
      tsas.AddResult(IdSession, NatureObject, query);
    }

    if(tsas.getResultCount() > 0) {%>
<br />
<form name="search" action="combined-search-3.jsp" method="post">
  <input type="hidden" name="combinedexplainedcriteria2" value="<%=combinedexplainedcriteria2%>" />
  <input type="hidden" name="combinedlistcriteria2" value="<%=combinedlistcriteria2%>" />
  <input type="hidden" name="combinednatureobject2" value="<%=combinednatureobject2%>" />
  <%
    if(NatureObject.equalsIgnoreCase("Species")) {
  %>
  <label for="NextPageSpecies" class="noshow">Proceed to next page</label>
  <input type="submit" name="Proceed to next page" title="<%=contentManagement.getContent("generic_combined-search-step2_14",false)%>" id="NextPageSpecies" value="<%=contentManagement.getContent("generic_combined-search-step2_14",false)%>" class="inputTextField" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Habitat")) {
  %>
  <label for="NextPageHabitat" class="noshow">Proceed to next page</label>
  <input type="submit" title="<%=contentManagement.getContent("generic_combined-search-step2_15",false)%>" name="Proceed to next page" id="NextPageHabitat" value="<%=contentManagement.getContent("generic_combined-search-step2_15",false)%>" class="inputTextField" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Sites")) {
  %>
  <label for="NextPageSites" class="noshow">Proceed to next page</label>
  <input type="submit" title="<%=contentManagement.getContent("generic_combined-search-step2_16",false)%>" name="Proceed to next page" id="NextPageSites" value="<%=contentManagement.getContent("generic_combined-search-step2_16",false)%>" class="inputTextField" />
  <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
  <%
    }
  %>
  <input type="hidden" name="idsession" value="<%=IdSession%>" />
  <input type="hidden" name="secondnatureobject" value="<%=NatureObject%>" />
  <%
    if(NatureObject.equalsIgnoreCase("Species")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Sites" />
  <input type="hidden" name="natureobject" value="Habitat" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Habitat")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Species" />
  <input type="hidden" name="natureobject" value="Sites" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Sites")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Habitat" />
  <input type="hidden" name="natureobject" value="Species" />
  <%
    }
  %>
</form>
<br />
<form name="search_skip" action="combined-search-3.jsp" method="post">
  <input type="hidden" name="combinedexplainedcriteria2" value="<%=combinedexplainedcriteria2%>" />
  <input type="hidden" name="combinedlistcriteria2" value="<%=combinedlistcriteria2%>" />
  <input type="hidden" name="combinednatureobject2" value="<%=combinednatureobject2%>" />
  <%
    if(NatureObject.equalsIgnoreCase("Species")) {
  %>
  <label for="NextPageSpecies2" class="noshow">Proceed to next page</label>
  <input type="submit" name="Proceed to next page" title="<%=contentManagement.getContent("generic_combined-search-step2_17",false)%>" id="NextPageSpecies2" value="<%=contentManagement.getContent("generic_combined-search-step2_17",false)%>" class="inputTextField" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Habitat")) {
  %>
  <label for="NextPageHabitat2" class="noshow">Proceed to next page</label>
  <input type="submit" name="Proceed to next page" title="<%=contentManagement.getContent("generic_combined-search-step2_18",false)%>" id="NextPageHabitat2" value="<%=contentManagement.getContent("generic_combined-search-step2_18",false)%>" class="inputTextField" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Sites")) {
  %>
  <label for="NextPageSites2" class="noshow">Proceed to next page</label>
  <input type="submit" name="Proceed to next page" title="<%=contentManagement.getContent("generic_combined-search-step2_19",false)%>" id="NextPageSites2" value="<%=contentManagement.getContent("generic_combined-search-step2_19",false)%>" class="inputTextField" />
  <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
  <%
    }
  %>
  <input type="hidden" name="idsession" value="<%=IdSession%>" />
  <input type="hidden" name="idsession" value="<%=IdSession%>" />
  <input type="hidden" name="secondnatureobject" value="<%=NatureObject%>" />
  <%
    if(NatureObject.equalsIgnoreCase("Species")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Sites" />
  <input type="hidden" name="natureobject" value="Habitat" />
  <input type="hidden" name="skip" value="Habitat" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Habitat")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Species" />
  <input type="hidden" name="natureobject" value="Sites" />
  <input type="hidden" name="skip" value="Sites" />
  <%
    }
  %>
  <%
    if(NatureObject.equalsIgnoreCase("Sites")) {
  %>
  <input type="hidden" name="firstnatureobject" value="Habitat" />
  <input type="hidden" name="natureobject" value="Species" />
  <input type="hidden" name="skip" value="Species" />
  <%
    }
  %>
</form>
<%--    end modify--%>
<%} else { %>
<br />
<%=contentManagement.getContent("generic_combined-search-step2_08")%>
<br />
<% }
}
  con.close();
%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="combined-search-2.jsp" />
</jsp:include>
</div>
</body>
</html>
<%out.flush();
%>