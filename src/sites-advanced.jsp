<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites advanced search.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<jsp:include page="header-page.jsp" />
<%
   // Web content manager used in this page.
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("natureobject")!=null?request.getParameter("natureobject"):""%> <%=contentManagement.getContent("sites_advanced_01", false )%></title>
<script language="JavaScript" type="text/javascript">
<!--
  var current_selected="";
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
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=contentManagement.getContent("sites_advanced_13",false)%></span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=contentManagement.getContent("sites_advanced_14",false)%></span>"
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
      alert('<%=contentManagement.getContent("sites_advanced_15",false)%>');
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
      alert('<%=contentManagement.getContent("sites_advanced_15",false)%>');
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
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Advanced Search"/>
      <jsp:param name="mapLink" value="show"/>
    </jsp:include>
  <h5><%=contentManagement.getContent("sites_advanced_02")%></h5>
  <%=contentManagement.getContent("sites_advanced_03")%>
  <br />
  <%=contentManagement.getContent("sites_advanced_04")%>
  <br />
  <table summary="layout" border="0">
    <tr><td id="status"><%=contentManagement.getContent("sites_advanced_05")%></td></tr>
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
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";
  int SQL_LIMIT=500000;

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

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
          alert('<%=contentManagement.getContent("sites_advanced_16",false)%>');
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
         alert('<%=contentManagement.getContent("sites_advanced_17",false)%>');
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
         alert('<%=contentManagement.getContent("sites_advanced_18",false)%>');
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
         alert('<%=contentManagement.getContent("sites_advanced_19",false)%>');
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
          <a title="Add criterion" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="Add criteria" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=contentManagement.getContent("sites_advanced_20",false)%>" /></a>
          <%
        }
        if(IdNode.equalsIgnoreCase("1")) {
          %>
          <img alt="" border="0" src="images/mini/space.gif" />
          <%
        } else {
          out.println("<a title=\"Delete criterion\" href=\"javascript:submitButtonForm('delete','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" title=\""+contentManagement.getContent("sites_advanced_21",false) +"\" /></a>");
        }
        if(IdNode.length()<3) {
          if(NodeType.equalsIgnoreCase("Criteria")) {
            out.println("<a title=\"Compose criterion\" href=\"javascript:submitButtonForm('compose','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/compose.gif\" width=\"13\" height=\"13\" title=\""+contentManagement.getContent("sites_advanced_22",false) +"\" /></a>");
          }
        }
        out.println("&nbsp;"+IdNode);
      } else {
        out.println("<a title=\"Delete root\" href=\"javascript:submitButtonForm('deleteroot','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" title=\""+contentManagement.getContent("sites_advanced_23",false) +"\" /></a>");
      }

      if(!NodeType.equalsIgnoreCase("Criteria")) {
        out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">Criteria</label>");
        out.println("<select name=\"Criteria"+IdNode+"\" id=\"Criteria"+IdNode+"\" class=\"inputTextFieldSpecial\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+contentManagement.getContent("sites_advanced_24",false) +"\">");
        if(NodeType.equalsIgnoreCase("All")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"All\">"+contentManagement.getContent("sites_advanced_25")+"</option>");
        if(NodeType.equalsIgnoreCase("Any")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Any\">"+contentManagement.getContent("sites_advanced_26")+"</option>");
        out.println("</select> " + contentManagement.getContent("sites_advanced_27"));
        out.println("<br />");
      } else {
        val=rs.getString("ATTRIBUTE");
        currentAttribute = val;
        out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">Attribute</label>");
        out.println("<select name=\"Attribute"+IdNode+"\" title=\"Attribute\" id=\"Attribute"+IdNode+"\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\">");
        if(NatureObject.equalsIgnoreCase("Sites")) {
          if(val.equalsIgnoreCase("Name")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Name\">"+contentManagement.getContent("sites_advanced_28")+"</option>");
          if(val.equalsIgnoreCase("Code")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Code\">"+contentManagement.getContent("sites_advanced_29")+"</option>");
          if(val.equalsIgnoreCase("DesignationYear")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"DesignationYear\">"+contentManagement.getContent("sites_advanced_30")+"</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">"+contentManagement.getContent("sites_advanced_31")+"</option>");
          if(val.equalsIgnoreCase("Size")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Size\">"+contentManagement.getContent("sites_advanced_32")+"</option>");
          if(val.equalsIgnoreCase("Longitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Longitude\">"+contentManagement.getContent("sites_advanced_33")+"</option>");
          if(val.equalsIgnoreCase("Latitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Latitude\">"+contentManagement.getContent("sites_advanced_34")+"</option>");
          if(val.equalsIgnoreCase("MinimumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MinimumAltitude\">"+contentManagement.getContent("sites_advanced_35")+"</option>");
          if(val.equalsIgnoreCase("MaximumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MaximumAltitude\">"+contentManagement.getContent("sites_advanced_36")+"</option>");
          if(val.equalsIgnoreCase("MeanAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MeanAltitude\">"+contentManagement.getContent("sites_advanced_37")+"</option>");
          if(val.equalsIgnoreCase("Designation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Designation\">"+contentManagement.getContent("sites_advanced_38")+"</option>");
          if(val.equalsIgnoreCase("HumanActivity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"HumanActivity\">"+contentManagement.getContent("sites_advanced_39")+"</option>");
          if(val.equalsIgnoreCase("Motivation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Motivation\">"+contentManagement.getContent("sites_advanced_40")+"</option>");
          if(val.equalsIgnoreCase("RegionCode")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"RegionCode\">"+contentManagement.getContent("sites_advanced_41")+"</option>");
        }
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("OPERATOR");
        currentOperator = val;
        out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">Operator</label>");
        out.println("<select name=\"Operator"+IdNode+"\" id=\"Operator"+IdNode+"\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+contentManagement.getContent("sites_advanced_42")+"\">");
        if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Equal\">"+contentManagement.getContent("sites_advanced_43")+"</option>");
        if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Contains\">"+contentManagement.getContent("sites_advanced_44")+"</option>");
        if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Between\">"+contentManagement.getContent("sites_advanced_45")+"</option>");
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("FIRST_VALUE");
        currentValue = val;
        %>
        <label for="First_Value<%=IdNode%>" class="noshow">List of values</label>
        <input type="text" title="List of values" class="inputTextField" id="First_Value<%=IdNode%>" name="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
        <a title="List of values" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <%
        if(rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
          out.println(contentManagement.getContent("sites_advanced_47"));
          val=rs.getString("LAST_VALUE");
          currentValue = val;
          %>
          <label for="Last_Value<%=IdNode%>" class="noshow">List of values</label>
          <input type="text" title="List of values" class="inputTextField" name="Last_Value<%=IdNode%>" id="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
          <a title="List of values" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
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
    <label for="Save" class="noshow">Save</label>
    <input title="Save" type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="<%=contentManagement.getContent("sites_advanced_48", false )%>" id="Save" name="Save" />
    <%=contentManagement.writeEditTag( "sites_advanced_48" )%>
    &nbsp;&nbsp;&nbsp;
    <label for="Search" class="noshow">Search</label>
    <input title="Search" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_advanced_49", false)%>" id="Search" name="Search" />
    &nbsp;&nbsp;&nbsp;
    <label for="Reset" class="noshow">Reset</label>
    <input title="Reset values" type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="<%=contentManagement.getContent("sites_advanced_50", false )%>" id="Reset" name="Reset" />
    <%=contentManagement.writeEditTag( "sites_advanced_50" )%>
    <%
  } else {
    %>
    <a title="Add root" href="javascript:submitButtonForm('addroot','0');"><img alt="Add root" border="0" src="images/mini/add.gif" width="13" height="13" title="<%=contentManagement.getContent("sites_advanced_50",false)%>" /></a>
    <%=contentManagement.getContent("sites_advanced_06")%>
    <%
  }

  rs.close();

  %>
  </form>
  <br />
  <strong><%=contentManagement.getContent("sites_advanced_07")%></strong>
  <br />
  <%

  String criteria=tas.createCriteria(IdSession,NatureObject);
  out.println(contentManagement.getContent("sites_advanced_52"));
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
        out.println(contentManagement.getContent("sites_advanced_53")+interpretedcriteria+"...");
        out.flush();
        intermediatefilter=tsas.BuildFilter(node,IdSession,NatureObject);
        out.println("found:&nbsp;<strong>"+tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount()>=SQL_LIMIT) {
          out.println(contentManagement.getContent("sites_advanced_08")+SQL_LIMIT+contentManagement.getContent("sites_advanced_09"));
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
    out.println("<br /><strong>" + contentManagement.getContent("sites_advanced_10") + "&nbsp;" + tsas.getResultCount() + "</strong><br />");
    out.flush();

    if (tsas.getResultCount() > 0) {
      tsas.AddResult(IdSession,NatureObject,query);
    }

    if (tsas.getResultCount() > 0) {
    %>
    <br />
    <form name="search" action="select-columns.jsp" method="post">
      <label for="NextStep" class="noshow">Proceed to next step</label>
      <input type="submit" id="NextStep" name="Proceed to next step" title="Proceed to next step" value="<%=contentManagement.getContent("sites_advanced_54",false)%>" class="inputTextField" />
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
          <label for="SaveCriteria" class="noshow">Save Criteria</label>
          <input type="button" id="SaveCriteria" title="Save Criteria" name="Save Criteria" value="<%=contentManagement.getContent("sites_advanced_55", false )%>" class="inputTextField" onclick="javascript:SaveCriteria();" />
          <%=contentManagement.writeEditTag( "sites_advanced_55" )%>
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
    <%=contentManagement.getContent("sites_advanced_11")%>
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
          <img alt="Expand-Collapse" border="0" align="middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="Expand-Collapse" href="sites-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? "Hide":"Show")%> <%=contentManagement.getContent("sites_advanced_12", false)%></a>
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
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="sites-advanced.jsp" />
  </jsp:include>
  </div>
  </body>
</html>
<%out.flush();%>



