<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites advanced search.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<jsp:include page="header-page.jsp" />
<%
   // Web content manager used in this page.
    WebContentManagement cm = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("natureobject")!=null?request.getParameter("natureobject"):""%> <%=cm.cms("sites_advanced_01")%>
</title>
<script language="JavaScript" type="text/javascript">
<!--
  var current_selected="";
//-->
</script>

<script language="JavaScript" type="text/javascript">
<!--


 function SaveCriteriaFunction() {
    if (checkValidSelection()){
      var URL2 = "save-sites-advanced-search-criteria.jsp?";
      URL2 += "&idsession="+document.saveCriteriaSearch.idsession.value;
      URL2 += "&natureobject="+document.saveCriteriaSearch.natureobject.value;
      URL2 += "&username="+document.saveCriteriaSearch.username.value;
      URL2 += "&fromWhere="+document.saveCriteriaSearch.fromWhere.value;
      URL2 += "&saveThisCriteria=false";

      if(document.criteria.DIPLOMA.checked==true) URL2 += "&DIPLOMA=true";
      if(document.criteria.CDDA_NATIONAL.checked==true) URL2 += "&CDDA_NATIONAL=true";
      if(document.criteria.CDDA_INTERNATIONAL.checked==true) URL2 += "&CDDA_INTERNATIONAL=true";
      if(document.criteria.BIOGENETIC.checked==true) URL2 += "&BIOGENETIC=true";
      if(document.criteria.NATURA2000.checked==true) URL2 += "&NATURA2000=true";
      if(document.criteria.NATURENET.checked==true) URL2 += "&NATURENET=true";
      if(document.criteria.EMERALD.checked==true) URL2 += "&EMERALD=true";
      if(document.criteria.CORINE.checked==true) URL2 += "&CORINE=true";

      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=300,top=80');");
    }
  }

 function SaveCriteria() {
    if (checkValidSelection()){
      var URL2 = "save-sites-advanced-search-criteria.jsp?";
      URL2 += "&idsession="+document.saveCriteriaSearch.idsession.value;
      URL2 += "&natureobject="+document.saveCriteriaSearch.natureobject.value;
      URL2 += "&username="+document.saveCriteriaSearch.username.value;
      URL2 += "&fromWhere="+document.saveCriteriaSearch.fromWhere.value;
      URL2 += "&saveThisCriteria=false";

      if(document.criteria.DIPLOMA.checked==true) URL2 += "&DIPLOMA=true";
      if(document.criteria.CDDA_NATIONAL.checked==true) URL2 += "&CDDA_NATIONAL=true";
      if(document.criteria.CDDA_INTERNATIONAL.checked==true) URL2 += "&CDDA_INTERNATIONAL=true";
      if(document.criteria.BIOGENETIC.checked==true) URL2 += "&BIOGENETIC=true";
      if(document.criteria.NATURA2000.checked==true) URL2 += "&NATURA2000=true";
      if(document.criteria.NATURENET.checked==true) URL2 += "&NATURENET=true";
      if(document.criteria.EMERALD.checked==true) URL2 += "&EMERALD=true";
      if(document.criteria.CORINE.checked==true) URL2 += "&CORINE=true";

      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=300,top=80');");
    }
  }

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
    var URL = 'advanced-search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + oper;
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
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=cm.cms("your_criteria_has_been_saved")%></span>"
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



 function openQuestion(URL) {
      var width = 230, height = 125;
      var horizPos = centerHoriz(width);
      var vertPos = centerVert(height);
      window.open(URL, 'left=' + horizPos + ', top=' + vertPos + ', width=' + width + ', height=' + height + ', status=0, scrollbars=0, toolbar=0, resizable=1, location=0,menubar');
 }

function setFormLoadSaveCriteria(fromWhere,criterianame,natureobject,sourceDB) {
      var allSourceDB = "CORINE,DIPLOMA,CDDA_NATIONAL,CDDA_INTERNATIONAL,BIOGENETIC,NATURA2000,NATURENET,EMERALD";
      sourceDB = "," + sourceDB + ",";

      elementsArray = allSourceDB.split(",");
      if(elementsArray != null && elementsArray.length > 1)
         {
           for(i=0;i<elementsArray.length;i++)
             {
               if(sourceDB.indexOf("," + elementsArray[i] + ",") != -1)
                  document.loadSaveCriteria.elements[elementsArray[i]].value = true;
               else
                  document.loadSaveCriteria.elements[elementsArray[i]].disabled = true;
             }

         }

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
  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }
  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    NatureObject="Sites";
  }

  // Load saved search
  if(request.getParameter("loadCriteria") != null && request.getParameter("loadCriteria").equalsIgnoreCase("yes"))
  {
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
      <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_advanced_search_location"/>
      <jsp:param name="mapLink" value="show"/>
    </jsp:include>
  <h1><%=cm.cmsText("sites_advanced_02")%></h1>
  <%=cm.cmsText("sites_advanced_03")%>
  <br />
  <%=cm.cmsText("sites_advanced_04")%>
  <br />
  <table summary="layout" border="0">
    <tr><td id="status"><%=cm.cmsText("sites_advanced_05")%></td></tr>
  </table>
<%
  String listcriteria="";
  String explainedcriteria="";
  String sourcedbcriteria="";

  String SourceDB = "";
  if(request.getParameter("DIPLOMA")!=null) SourceDB+=",'DIPLOMA'";
  if(request.getParameter("CDDA_NATIONAL")!=null) SourceDB+=",'CDDA_NATIONAL'";
  if(request.getParameter("CDDA_INTERNATIONAL")!=null) SourceDB+=",'CDDA_INTERNATIONAL'";
  if(request.getParameter("BIOGENETIC")!=null) SourceDB+=",'BIOGENETIC'";
  if(request.getParameter("NATURA2000")!=null) SourceDB+=",'NATURA2000'";
  if(request.getParameter("NATURENET")!=null) SourceDB+=",'NATURENET'";
  if(request.getParameter("EMERALD")!=null) SourceDB+=",'EMERALD'";
  if(request.getParameter("CORINE")!=null) SourceDB+=",'CORINE'";

  if(SourceDB.equalsIgnoreCase("")) {
    SourceDB = "''";
  } else {
    if(SourceDB.length()>1) {
      SourceDB = SourceDB.substring(1,SourceDB.length());
    }
  }
  sourcedbcriteria = SourceDB;
%>
<form method="post" action="sites-advanced.jsp" name="criteria" onsubmit="return checkValidSelection();">
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
  if(p_action==null) p_action="";
  String p_idnode = request.getParameter("idnode");
  if(p_idnode==null) p_idnode="";
  String p_criteria = request.getParameter("criteria");
  if(p_criteria==null) p_criteria="";
  String p_attribute = request.getParameter("attribute");
  if(p_attribute==null) p_attribute="";
  String p_operator = request.getParameter("operator");
  if(p_operator==null) p_operator="";
  String p_firstvalue = request.getParameter("firstvalue");
  if(p_firstvalue==null) p_firstvalue="";
  String p_lastvalue = request.getParameter("lastvalue");
  if(p_lastvalue==null) p_lastvalue="";
  //System.out.println(requestURL);

  ro.finsiel.eunis.search.AdvancedSearch tas = new ro.finsiel.eunis.search.AdvancedSearch();
  tas.SetSQLLimit(SQL_LIMIT);

  tas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  //prelucram actiunea curenta
  if(p_action.equalsIgnoreCase("reset")) {
    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    String attribute="ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute="Name";
    }
    tsas.DeleteRoot(IdSession,NatureObject,attribute);
  }

  if(p_action.equalsIgnoreCase("deleteroot")) {
    //out.println("Delete root");
    String attribute="ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute="Name";
    }
    if(!tas.DeleteRootNoInitialize(IdSession,NatureObject,attribute)) {
      System.out.println("Error deleting root!");
      %>
        <script language="JavaScript" type="text/javascript">
        <!--
          alert('<%=cm.cms("sites_advanced_16")%>');
        //-->
        </script>
      <%
    }
  }

  if(p_action.equalsIgnoreCase("addroot")) {
    //out.println("Add root");
    String attribute="ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute="Name";
    }
    //System.out.println("attribute = " + attribute);
    tas.CreateInitialBranch(IdSession,NatureObject,attribute);
  }

  if(p_action.equalsIgnoreCase("add")) {
    //out.println("Add branch for node: "+p_idnode);
    String attribute="ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute="Name";
    }
    if(!tas.InsertBranch(p_idnode,IdSession,NatureObject,attribute)) {
     System.out.println("Error adding branch!");
     %>
       <script language="JavaScript" type="text/javascript">
       <!--
         alert('<%=cm.cms("sites_advanced_17")%>');
       //-->
       </script>
     <%
    }
  }

  if(p_action.equalsIgnoreCase("delete")) {
    //out.println("Delete branch for node: "+p_idnode);
    if(!tas.DeleteBranch(p_idnode,IdSession,NatureObject)) {
     System.out.println("Error deleting branch!");
     %>
       <script language="JavaScript" type="text/javascript">
       <!--
         alert('<%=cm.cms("sites_advanced_18")%>');
       //-->
       </script>
     <%
    }
  }

  if(p_action.equalsIgnoreCase("compose")) {
    //out.println("Compose branch for node: "+p_idnode);
    if(!tas.ComposeBranch(p_idnode,IdSession,NatureObject)) {
     System.out.println("Error composing branch!");
     %>
       <script language="JavaScript" type="text/javascript">
       <!--
         alert('<%=cm.cms("sites_advanced_19")%>');
       //-->
       </script>
     <%
    }
  }

  if(p_action.length()==0) {
    if(p_criteria.length() != 0) {
      //out.println("New criteria: "+p_criteria+" for node: "+p_idnode);
      tas.ChangeCriteria(p_idnode,IdSession,NatureObject,p_criteria);
    }
    if(p_attribute.length() != 0) {
      //out.println("New attribute: "+p_attribute+" for node: "+p_idnode);
      tas.ChangeAttribute(p_idnode,IdSession,NatureObject,p_attribute);
    }
    if(p_operator.length() != 0) {
      //out.println("New operator: "+p_operator+" for node: "+p_idnode);
      tas.ChangeOperator(p_idnode,IdSession,NatureObject,p_operator);
    }
    if(p_firstvalue.length() != 0) {
      //out.println("New first value: "+p_firstvalue+" for node: "+p_idnode);
      //System.out.println("first value:" + p_firstvalue);
      tas.ChangeFirstValue(p_idnode,IdSession,NatureObject,p_firstvalue);
    }
    if(p_lastvalue.length() != 0) {
      //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
      //System.out.println("last value:" + p_lastvalue);
      tas.ChangeLastValue(p_idnode,IdSession,NatureObject,p_lastvalue);
    }
  }

  String SQL="";
  String NodeType="";
  String IdNode="";
  String val="";
  String selected="";
  String currentAttribute="";
  String currentOperator="";
  String currentValue="";

  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs =null;

  try {
    Class.forName(SQL_DRV);
    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }

  SQL="SELECT ";
  SQL+="EUNIS_ADVANCED_SEARCH.ID_NODE,";
  SQL+="EUNIS_ADVANCED_SEARCH.NODE_TYPE,";
  SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.ATTRIBUTE,";
  SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.OPERATOR,";
  SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.FIRST_VALUE,";
  SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.LAST_VALUE ";
  SQL+="FROM ";
  SQL+="EUNIS_ADVANCED_SEARCH ";
  SQL+="LEFT OUTER JOIN EUNIS_ADVANCED_SEARCH_CRITERIA ON (EUNIS_ADVANCED_SEARCH.ID_SESSION = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_SESSION) AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT = EUNIS_ADVANCED_SEARCH_CRITERIA.NATURE_OBJECT) AND (EUNIS_ADVANCED_SEARCH.ID_NODE = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_NODE) ";
  SQL+="WHERE (EUNIS_ADVANCED_SEARCH.ID_SESSION='"+IdSession+"') ";
  SQL+="AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT='"+NatureObject+"') ";
  SQL+="ORDER BY ";
  SQL+="EUNIS_ADVANCED_SEARCH.ID_NODE ";

  ps = con.prepareStatement(SQL);
  rs = ps.executeQuery();
  if(rs.isBeforeFirst()){
    while(rs.next()) {
      IdNode=rs.getString("ID_NODE");
      NodeType=rs.getString("NODE_TYPE");
      if(!IdNode.equalsIgnoreCase("0")) {
        out.println("&nbsp;");out.println("&nbsp;");
      }
      for(int i=1;i<=IdNode.length()*3;i++) {
        if(!IdNode.equalsIgnoreCase("0")) {
          out.println("&nbsp;");
        }
      }

      if(!IdNode.equalsIgnoreCase("0")) {
        //restrict branching depth to 3 levels (Root/x/x.y nodes identifiers)
        if(IdNode.length()<=3) {
          %>
          <a title="<%=cm.cms("add_criterion")%>" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="<%=cm.cms("add_criterion")%>" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_criterion")%>" /></a><%=cm.cmsTitle("add_criterion")%>
          <%
        }
        if(IdNode.equalsIgnoreCase("1")) {
          %>
          <img alt="" border="0" src="images/mini/space.gif" />
          <%
        } else {
        %>
          <a title="<%=cm.cms("delete_criterion")%>" href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_criterion")%>" alt="<%=cm.cms("delete_criterion")%>" /></a><%=cm.cmsTitle("delete_criterion")%>
        <%
        }
        if(IdNode.length() < 3) {
          if(NodeType.equalsIgnoreCase("Criteria")) {
          %>
            <a title="<%=cm.cms("compose_criterion")%>" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="<%=cm.cms("compose_criterion")%>" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=cm.cms("compose_criterion")%>" /></a><%=cm.cmsTitle("compose_criterion")%>
          <%
          }
        }
        out.println("&nbsp;"+IdNode);
      } else {
        %>
        <a title="<%=cm.cms("delete_root_criterion")%>" href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="<%=cm.cms("delete_root_criterion")%>" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_root_criterion")%>" /></a><%=cm.cmsTitle("delete_root_criterion")%>
        <%
      }

      String cmsCriteria = cm.cms("advanced_criteria");
      String cmsAttribute = cm.cms("advanced_attribute");
      String cmsOperator = cm.cms("advanced_operator");
      String cmsAll = cm.cms("advanced_all");
      String cmsAny = cm.cms("advanced_any");
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

        if(NatureObject.equalsIgnoreCase("Sites")) {
          if(val.equalsIgnoreCase("Name")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Name\">"+cm.cms("sites_advanced_28")+"</option>");
          if(val.equalsIgnoreCase("Code")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Code\">"+cm.cms("sites_advanced_29")+"</option>");
          if(val.equalsIgnoreCase("DesignationYear")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"DesignationYear\">"+cm.cms("sites_advanced_30")+"</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">"+cm.cms("sites_advanced_31")+"</option>");
          if(val.equalsIgnoreCase("Size")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Size\">"+cm.cms("sites_advanced_32")+"</option>");
          if(val.equalsIgnoreCase("Longitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Longitude\">"+cm.cms("sites_advanced_33")+"</option>");
          if(val.equalsIgnoreCase("Latitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Latitude\">"+cm.cms("sites_advanced_34")+"</option>");
          if(val.equalsIgnoreCase("MinimumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MinimumAltitude\">"+cm.cms("sites_advanced_35")+"</option>");
          if(val.equalsIgnoreCase("MaximumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MaximumAltitude\">"+cm.cms("sites_advanced_36")+"</option>");
          if(val.equalsIgnoreCase("MeanAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MeanAltitude\">"+cm.cms("sites_advanced_37")+"</option>");
          if(val.equalsIgnoreCase("Designation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Designation\">"+cm.cms("sites_advanced_38")+"</option>");
          if(val.equalsIgnoreCase("HumanActivity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"HumanActivity\">"+cm.cms("sites_advanced_39")+"</option>");
          if(val.equalsIgnoreCase("Motivation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Motivation\">"+cm.cms("sites_advanced_40")+"</option>");
          if(val.equalsIgnoreCase("RegionCode")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"RegionCode\">"+cm.cms("sites_advanced_region")+"</option>");
        }
        out.println("</select>");
        %>
        <%=cm.cmsInput("sites_advanced_28")%>
        <%=cm.cmsInput("sites_advanced_29")%>
        <%=cm.cmsInput("sites_advanced_30")%>
        <%=cm.cmsInput("sites_advanced_31")%>
        <%=cm.cmsInput("sites_advanced_32")%>
        <%=cm.cmsInput("sites_advanced_33")%>
        <%=cm.cmsInput("sites_advanced_34")%>
        <%=cm.cmsInput("sites_advanced_35")%>
        <%=cm.cmsInput("sites_advanced_36")%>
        <%=cm.cmsInput("sites_advanced_37")%>
        <%=cm.cmsInput("sites_advanced_38")%>
        <%=cm.cmsInput("sites_advanced_39")%>
        <%=cm.cmsInput("sites_advanced_40")%>
        <%
        out.println("&nbsp;");

        val=rs.getString("OPERATOR");
        currentOperator = val;
        out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">"+cmsOperator+"</label>");
        out.println("<select name=\"Operator" + IdNode + "\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsOperator+"\" id=\"Operator" + IdNode + "\">");

        if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Equal\">"+cm.cms("sites_advanced_43")+"</option>");
        if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Contains\">"+cm.cms("sites_advanced_44")+"</option>");
        if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Between\">"+cm.cms("sites_advanced_45")+"</option>");
        if(val.equalsIgnoreCase("Regex")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Regex\">Regex</option>");
        out.println("</select>");
        %>
        <%=cm.cmsInput("sites_advanced_43")%>
        <%=cm.cmsInput("sites_advanced_44")%>
        <%=cm.cmsInput("sites_advanced_45")%>
        <%
        out.println("&nbsp;");

        val=rs.getString("FIRST_VALUE");
        currentValue = val;
        %>
        <label for="First_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
        <input type="text" title="<%=cm.cms("list_of_values")%>" class="inputTextField" id="First_Value<%=IdNode%>" name="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
        <%=cm.cmsTitle("list_of_values")%>
        <a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" title="<%=cm.cms("list_of_values")%>" width="11" height="18" border="0" align="middle" /></a>
        <%
        if(rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
          out.println(cm.cmsText("sites_advanced_47"));
          val=rs.getString("LAST_VALUE");
          currentValue = val;
          %>
          <label for="Last_Value<%=IdNode%>" class="noshow"><%=cm.cms("list_of_values")%></label>
          <input type="text" title="<%=cm.cms("list_of_values")%>" class="inputTextField" name="Last_Value<%=IdNode%>" id="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
          <%=cm.cmsTitle("list_of_values")%>
          <a title="<%=cm.cms("list_of_values")%>" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" title="<%=cm.cms("list_of_values")%>" width="11" height="18" border="0" align="middle" /></a>
          <%
        }
        %>
        <br />
        <%
      }
    }
    %>
    <br />
    <jsp:include page="sites-databases.jsp" />
    <br />
    <label for="Save" class="noshow"><%=cm.cms("save_btn")%></label>
    <input type="button" class="inputTextField" onclick="disableSaveButton()" value="Save" id="Save" name="Save" title="<%=cm.cms("save_btn")%>" />
        <%=cm.cmsTitle("save_btn")%>
    &nbsp;&nbsp;&nbsp;
    <label for="Search" class="noshow"><%=cm.cms("search_btn")%></label>
    <input type="submit" class="inputTextField" value="Search" id="Search" name="Search" title="<%=cm.cms("search_btn")%>" />
        <%=cm.cmsTitle("search_btn")%>
    &nbsp;&nbsp;&nbsp;
    <label for="Reset" class="noshow"><%=cm.cms("reset_btn")%></label>
    <input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="Reset" id="Reset" name="Reset" title="<%=cm.cms("reset_btn")%>" />
    <%=cm.cmsTitle("reset_btn")%>
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
  <strong><%=cm.cmsText("sites_advanced_07")%></strong>
  <br />
  <%

  String criteria=tas.createCriteria(IdSession,NatureObject);
  out.println(cm.cmsText("sites_advanced_52"));
  explainedcriteria=criteria.replace('#',' ').replace('[','(').replace(']',')').replaceAll("AND","<strong>AND</strong>").replaceAll("OR","<strong>OR</strong>");
  out.println(explainedcriteria);

  out.println("<br />");
  out.println("<br />");
  out.flush();

  if(request.getParameter("Search")!=null) {
    String finalwhere="";
    String node="";
    int pos_start=-1;
    int pos_end=-1;
    String interpretedcriteria="";
    String intermediatefilter="";

    if(NatureObject.equalsIgnoreCase("Sites")) {
      ro.finsiel.eunis.search.AdvancedSearch tsas;
      tsas = new ro.finsiel.eunis.search.AdvancedSearch();
      tsas.SetSourceDB(SourceDB);
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      pos_start=criteria.indexOf('#');
      pos_end=criteria.indexOf('#',pos_start+1);
      while(pos_start!=-1 && pos_end!=-1) {
        node=criteria.substring(pos_start+1,pos_end);
        interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
        listcriteria+=node+": "+interpretedcriteria+"<br />";
        out.println(cm.cmsText("advanced_searching_for") + " " + interpretedcriteria + "...");
        out.flush();
        intermediatefilter=tsas.BuildFilter(node,IdSession,NatureObject);
        out.println(cm.cmsText("advanced_found") + "&nbsp;<strong>"+tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount()>=SQL_LIMIT) {
          out.println("<br />&nbsp;&nbsp;(" + cm.cmsText("advanced_only_first") + " "+SQL_LIMIT + " " + cm.cmsText("advanced_were_retrieved") + ")");
        }
        out.println("<br />");
        out.flush();

        finalwhere="";
        finalwhere+=criteria.substring(0,pos_start);
        finalwhere+="ID_NATURE_OBJECT IN ("+intermediatefilter+")";
        finalwhere+=criteria.substring(pos_end+1);
        criteria=finalwhere;

        pos_start=criteria.indexOf('#',pos_end+1);
        if(pos_start!=-1) {
          pos_end=criteria.indexOf('#',pos_start+1);
        } else {
        }
      }
    }

    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    tsas.SetSourceDB(SourceDB);
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    String str=tsas.calculateCriteria(IdSession,NatureObject);

    tsas.DeleteResults(IdSession,NatureObject);

    str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_"+NatureObject.toUpperCase()+" WHERE ("+str+")";
    String query = tsas.ExecuteFilterSQL(str,"");
    out.println("<br /><strong>" + cm.cmsText("sites_advanced_10") + "&nbsp;" + tsas.getResultCount() + "</strong><br />");
    out.flush();

    if (tsas.getResultCount() > 0) {
      tsas.AddResult(IdSession,NatureObject,query);
    }

    if (tsas.getResultCount() > 0) {
    %>
    <br />
    <form name="search" action="select-columns.jsp" method="post">
      <label for="NextStep" class="noshow"><%=cm.cms("advanced_proceed_to_next_step")%></label>
      <input type="submit" id="NextStep" name="Proceed to next step" title="<%=cm.cms("advanced_proceed_to_next_step")%>" value="<%=cm.cms("sites_advanced_54")%>" class="inputTextField" />
      <%=cm.cmsLabel("advanced_proceed_to_next_step")%>
      <%=cm.cmsInput("sites_advanced_54")%>
      <input type="hidden" name="searchedNatureObject" value="Sites" />
      <input type="hidden" name="origin" value="Advanced" />
      <input type="hidden" name="explainedcriteria" value="<%=explainedcriteria%>" />
      <input type="hidden" name="listcriteria" value="<%=listcriteria%>" />
      <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
    </form>
    <%
      // Save this advanced search
      if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
      {
    %>
    <br />
    <br />
    <table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td>
        <form name="saveCriteriaSearch" action="save-sites-advanced-search-criteria.jsp" method="post">
          <label for="SaveCriteria" class="noshow"><%=cm.cms("advanced_save_criteria")%></label>
          <input type="button" id="SaveCriteria" title="<%=cm.cms("advanced_save_criteria")%>" name="SaveCriteria" value="<%=cm.cms("sites_advanced_55")%>" class="inputTextField" onclick="SaveCriteriaFunction()" />
          <%=cm.cmsLabel("advanced_save_criteria")%>
          <%=cm.cmsInput("sites_advanced_55")%>
          <input type="hidden" name="idsession" value="<%=IdSession%>" />
          <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
          <input type="hidden" name="username" value="<%=SessionManager.getUsername()%>" />
          <input type="hidden" name="fromWhere" value="sites-advanced.jsp" />
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
    <%=cm.cmsText("sites_advanced_11")%>
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
          <img alt="<%=cm.cms("advanced_expand_collapse")%>" border="0" align="middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="<%=cm.cms("advanced_expand_collapse")%>" href="sites-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? cm.cms("advanced_hide") : cm.cms("advanced_show"))%> <%=cm.cmsText("sites_advanced_12")%></a>
          <%=cm.cmsTitle("advanced_expand_collapse")%>
          <%=cm.cmsTitle("advanced_hide")%>
          <%=cm.cmsTitle("advanced_show")%>
        </td>
      </tr>
    </table>
  <%
    // If list is expanded
    if (exp !=null && exp.equals("yes"))
    {
  %>
      <form name="loadSaveCriteria" method="post" action="sites-advanced.jsp">
        <input type ="hidden" name="loadCriteria" value="yes" />
        <input type ="hidden" name="fromWhere" value="" />
        <input type ="hidden" name="criterianame" value="" />
        <input type ="hidden" name="natureobject" value="" />
        <input type ="hidden" name="expandCriterias" value="yes" />
        <input type ="hidden" name="CORINE" value="" />
        <input type ="hidden" name="DIPLOMA" value="" />
        <input type ="hidden" name="CDDA_NATIONAL" value="" />
        <input type ="hidden" name="CDDA_INTERNATIONAL" value="" />
        <input type ="hidden" name="BIOGENETIC" value="" />
        <input type ="hidden" name="NATURA2000" value="" />
        <input type ="hidden" name="NATURENET" value="" />
        <input type ="hidden" name="EMERALD" value="" />
      </form>

      <form name="deleteSaveCriteria" method="post" action="delete-save-advanced-search-criteria.jsp">
        <input type ="hidden" name="fromWhere" value="" />
        <input type ="hidden" name="criterianame" value="" />
        <input type ="hidden" name="natureobject" value="" />
      </form>

  <%  // list of saved searches
      out.print(SaveAdvancedSearchCriteria.ExpandSaveCriteriaForThisPage(SQL_DRV,
                                                                        SQL_URL,
                                                                        SQL_USR,
                                                                        SQL_PWD,
                                                                        SessionManager.getUsername(),
                                                                        "sites-advanced.jsp"));
    }
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("press_save_to_save_criteria")%>
<%=cm.br()%>
<%=cm.cmsMsg("your_criteria_has_been_saved")%>
<%=cm.br()%>
<%=cm.cmsMsg("previous_values_was_restored")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_search_location")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_16")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_17")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_18")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_advanced_19")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_criteria")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_attribute")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_operator")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_all")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_any")%>
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
    <jsp:param name="page_name" value="sites-advanced.jsp" />
  </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>
