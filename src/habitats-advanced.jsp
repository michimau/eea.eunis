<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats advanced search' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.PreparedStatement,
                 java.sql.ResultSet" %>
<%@ page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<jsp:include page="header-page.jsp" />
<script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("natureobject") != null ? request.getParameter("natureobject") : ""%>
  <%=contentManagement.getContent("habitats_advanced_title", false)%>
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
    document.getElementById("status").innerHTML="<span style=\"color:red;\">Press 'Save' to save criteria.</span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:red;\">Your criteria has been saved.</span>"
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
      alert('Zero-length values are not permitted! The previous value was restored.');
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
      alert('<%=contentManagement.getContent("habitats_advanced_02",false)%>');
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

  function SaveCriteria() {

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
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Advanced Search" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<%=contentManagement.getContent("habitats_advanced_01")%>
<br />
<table summary="layout" border="0">
  <tr>
    <td id="status">
      <%=contentManagement.getContent("habitats_advanced_03")%>:
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
  int SQL_LIMIT = 500000;

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
alert('<%=contentManagement.getContent("habitats_advanced_04",false)%>');
//-->
</script>
<noscript>Your browser does not support JavaScript!</noscript>
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
      alert(''<%=contentManagement.getContent("habitats_advanced_05",false)%>'');
      //-->
      </script>
      <noscript>Your browser does not support JavaScript!</noscript>
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
      alert(''<%=contentManagement.getContent("habitats_advanced_06",false)%>'');
      //-->
      </script>
      <noscript>Your browser does not support JavaScript!</noscript>
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
      alert('<%=contentManagement.getContent("habitats_advanced_07",false)%>');
      //-->
      </script>
      <noscript>Your browser does not support JavaScript!</noscript>
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
          <a title="Add criterion" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="Add" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=contentManagement.getContent("habitats_advanced_08",false)%>" /></a>
          <%
        }
        if (IdNode.equalsIgnoreCase("1")) {
        %>
        <img border="0" src="images/mini/space.gif" alt="" />
        <%
        } else {
        %>
        <a title="Delete criterion" href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img border="0" src="images/mini/delete.gif" alt="Delete" width="13" height="13" title="<%=contentManagement.getContent("habitats_advanced_09",false)%>" /></a>
        <%
        }

        if (IdNode.length() < 3) {
          if (NodeType.equalsIgnoreCase("Criteria")) {
          %>
          <a title="Compose criterion" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="Compose" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=contentManagement.getContent("habitats_advanced_10",false)%>" /></a>
          <%
          }
        }
          out.println("&nbsp;" + IdNode);
      } else {
        %>
        <a href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="Delete" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=contentManagement.getContent("habitats_advanced_11",false)%>" /></a>
        <%
      }

  if (!NodeType.equalsIgnoreCase("Criteria")) {
    String sel = contentManagement.getContent("habitats_advanced_12");
    String str1 = contentManagement.getContent("habitats_advanced_13");
    out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">Criteria</label>");
    out.println("<select name=\"Criteria" + IdNode + "\" class=\"inputTextField\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select criteria type\" id=\"Criteria"+ IdNode + "\">");
    if (NodeType.equalsIgnoreCase("All")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"All\">All</option>");
    if (NodeType.equalsIgnoreCase("Any")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Any\">Any</option>");
    out.println("</select> " + str1 + ":");
    out.println("<br />");
  } else {
    val = rs.getString("ATTRIBUTE");
    currentAttribute = val;
    out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">Attribute</label>");
    out.println("<select name=\"Attribute" + IdNode + "\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Attribute\" id=\"Attribute" + IdNode + "\">");
    if (NatureObject.equalsIgnoreCase("Habitat")) {
      if (val.equalsIgnoreCase("ScientificName")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"ScientificName\">" + contentManagement.getContent("habitats_advanced_14") + "</option>");
      if (val.equalsIgnoreCase("Code")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Code\">" + contentManagement.getContent("habitats_advanced_15") + "</option>");
      if (val.equalsIgnoreCase("LegalInstruments")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LegalInstruments\">" + contentManagement.getContent("habitats_advanced_16") + "</option>");
      if (val.equalsIgnoreCase("SourceDatabase")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"SourceDatabase\">" + contentManagement.getContent("habitats_advanced_17") + "</option>");
      if (val.equalsIgnoreCase("Country")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Country\">" + contentManagement.getContent("habitats_advanced_18") + "</option>");
      if (val.equalsIgnoreCase("Biogeoregion")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Biogeoregion\">" + contentManagement.getContent("habitats_advanced_19") + "</option>");
      if (val.equalsIgnoreCase("Author")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Author\">" + contentManagement.getContent("habitats_advanced_20") + "</option>");
      if (val.equalsIgnoreCase("Title")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Title\">" + contentManagement.getContent("habitats_advanced_21") + "</option>");
      if (val.equalsIgnoreCase("Altitude")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Altitude\">" + contentManagement.getContent("habitats_advanced_22") + "</option>");
      if (val.equalsIgnoreCase("Chemistry")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Chemistry\">" + contentManagement.getContent("habitats_advanced_23") + "</option>");
      if (val.equalsIgnoreCase("Climate")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Climate\">" + contentManagement.getContent("habitats_advanced_24") + "</option>");
      if (val.equalsIgnoreCase("Cover")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Cover\">" + contentManagement.getContent("habitats_advanced_25") + "</option>");
      if (val.equalsIgnoreCase("Depth")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Depth\">" + contentManagement.getContent("habitats_advanced_26") + "</option>");
      if (val.equalsIgnoreCase("Geomorph")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Geomorph\">" + contentManagement.getContent("habitats_advanced_27") + "</option>");
      if (val.equalsIgnoreCase("Humidity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Humidity\">" + contentManagement.getContent("habitats_advanced_28") + "</option>");
      if (val.equalsIgnoreCase("LifeForm")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LifeForm\">" + contentManagement.getContent("habitats_advanced_29") + "</option>");
      if (val.equalsIgnoreCase("LightIntensity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"LightIntensity\">" + contentManagement.getContent("habitats_advanced_30") + "</option>");
      if (val.equalsIgnoreCase("Marine")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Marine\">" + contentManagement.getContent("habitats_advanced_31") + "</option>");
      if (val.equalsIgnoreCase("Salinity")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Salinity\">" + contentManagement.getContent("habitats_advanced_32") + "</option>");
      if (val.equalsIgnoreCase("Spatial")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Spatial\">" + contentManagement.getContent("habitats_advanced_33") + "</option>");
      if (val.equalsIgnoreCase("Substrate")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Substrate\">" + contentManagement.getContent("habitats_advanced_34") + "</option>");
      if (val.equalsIgnoreCase("Temporal")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Temporal\">" + contentManagement.getContent("habitats_advanced_35") + "</option>");
      if (val.equalsIgnoreCase("Tidal")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Tidal\">" + contentManagement.getContent("habitats_advanced_36") + "</option>");
      if (val.equalsIgnoreCase("Water")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Water\">" + contentManagement.getContent("habitats_advanced_37") + "</option>");
      if (val.equalsIgnoreCase("Usage")) {
        selected = " selected=\"selected\"";
      } else {
        selected = "";
      }
      out.println("<option" + selected + " value=\"Usage\">" + contentManagement.getContent("habitats_advanced_38") + "</option>");
    }
    out.println("</select>");

    out.println("&nbsp;");

    val = rs.getString("OPERATOR");
    currentOperator = val;
    out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">Operator</label>");
    out.println("<select name=\"Operator" + IdNode + "\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select operator type\" id=\"Operator" + IdNode + "\">");
    if (val.equalsIgnoreCase("Equal")) {
      selected = " selected";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Equal\">" + contentManagement.getContent("habitats_advanced_39") + "</option>");
    if (val.equalsIgnoreCase("Contains")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    out.println("<option" + selected + " value=\"Contains\">" + contentManagement.getContent("habitats_advanced_40") + "</option>");
    if (val.equalsIgnoreCase("Between")) {
      selected = " selected=\"selected\"";
    } else {
      selected = "";
    }
    if (!rs.getString("ATTRIBUTE").equalsIgnoreCase("LegalInstruments")) {
      out.println("<option" + selected + " value=\"Between\">" + contentManagement.getContent("habitats_advanced_41") + "</option>");
    }
    out.println("</select>");

    out.println("&nbsp;");

    val = rs.getString("FIRST_VALUE");
    currentValue = val;
%>
<label for="First_Value<%=IdNode%>" class="noshow">List of values</label>
<input type="text" title="List of values" class="inputTextField" id="First_Value<%=IdNode%>" name="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
<a href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=contentManagement.getContent("habitats_advanced_42",false)%>" /></a>
<%
  if (rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
    out.println(contentManagement.getContent("habitats_advanced_43"));
    val = rs.getString("LAST_VALUE");
    currentValue = val;
%>
<label for="Last_Value<%=IdNode%>" class="noshow">List of values</label>
<input type="text" title="List of values" class="inputTextField" id="Last_Value<%=IdNode%>" name="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
<a href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular" onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=contentManagement.getContent("habitats_advanced_42",false)%>" /></a>
<%
  }
%>
<br />
<%
    }
  }
%>
<br />
<label for="Save" class="noshow">Save</label>
<input type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="<%=contentManagement.getContent("habitats_advanced_44", false )%>" name="Save" id="Save" title="Save" />
<%=contentManagement.writeEditTag("habitats_advanced_44")%>
&nbsp;&nbsp;&nbsp;
<label for="Search" class="noshow">Search</label>
<input type="submit" class="inputTextField" value="<%=contentManagement.getContent("habitats_advanced_45", false)%>" name="Search" id="Search" title="Search" />
&nbsp;&nbsp;&nbsp;
<label for="Reset" class="noshow">Reset</label>
<input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="<%=contentManagement.getContent("habitats_advanced_46", false )%>" name="Reset" id="Reset" title="Reset values" />
<%=contentManagement.writeEditTag("habitats_advanced_46")%>
<%
} else {
%>
<a title="Add root" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="<%=contentManagement.getContent("habitats_advanced_47",false)%>" /></a>&nbsp;<%=contentManagement.getContent("habitats_advanced_48")%>
<%
  }
  rs.close();
%>
</form>
<br />
<strong>
  <%=contentManagement.getContent("habitats_advanced_49")%>
</strong>
<br />
<%

  String criteria = tas.createCriteria(IdSession, NatureObject);
  out.println(contentManagement.getContent("habitats_advanced_50") + ":");
  String and1 = contentManagement.getContent("habitats_advanced_51");
  String or1 = contentManagement.getContent("habitats_advanced_52");
  explainedcriteria = criteria.replace('#', ' ').replace('[', '(').replace(']', ')').replaceAll("AND", "<strong>" + and1 + "</strong>").replaceAll("OR", "<strong>" + or1 + "</strong>");
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
        out.println("Searching for: " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter = tsas.BuildFilter(node, IdSession, NatureObject);
        out.println("found: <strong>" + tsas.getResultCount() + "</strong>");
        if (tsas.getResultCount() >= SQL_LIMIT) {
          String limit = contentManagement.getContent("habitats_advanced_53");
          limit=limit.replaceAll("SQL_LIMIT", "" + SQL_LIMIT);
          out.println("<br />&nbsp;&nbsp;" + limit);
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
  <%=contentManagement.getContent("habitats_advanced_54")%>: <%=tsas.getResultCount()%>
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
  <label for="NextStep" class="noshow">Proceed to next step</label>
  <input type="submit" name="Proceed to next step" title="Proceed to next step" id="NextStep" value="<%=contentManagement.getContent("habitats_advanced_55", false)%>" class="inputTextField" />
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
        <label for="SaveCriteria" class="noshow">Save Criteria</label>
        <input type="button" name="Save Criteria" title="Save Criteria" id="SaveCriteria" value="<%=contentManagement.getContent("habitats_advanced_56", false )%>" class="inputTextField" onclick="javascript:SaveCriteria();" />
        <%=contentManagement.writeEditTag( "habitats_advanced_56" )%>
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
<%=contentManagement.getContent("habitats_advanced_57")%>
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
        <img alt="Expand-Collapse" border="0" align="middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="Expand-Collapse" href="habitats-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? contentManagement.getContent("habitats_advanced_59", false) : contentManagement.getContent("habitats_advanced_60",false))%> <%=contentManagement.getContent("habitats_advanced_58")%></a>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-advanced.jsp" />
</jsp:include>
  </div>
</body>
</html>

