<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species advanced search.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=request.getParameter("natureobject")!=null?request.getParameter("natureobject"):""%> advanced search</title>
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
      alert('Zero-length values are not permitted! The previous value was restored.');
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
  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }
  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    NatureObject="Species";
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
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Advanced Search"/>
    </jsp:include>
    <h5>Species advanced search</h5>
    Search species information using multiple characteristics
    <br />
    <br />
    <table summary="layout" border="0">
      <tr>
        <td id="status">
          Specify the search criteria:
        </td>
      </tr>
    </table>
<%
  String listcriteria="";
  String explainedcriteria="";
%>
<form method="post" action="species-advanced.jsp" name="criteria" id="criteria">
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
  int SQL_LIMIT=100000;

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
          alert('Error deleting root!');
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
         alert('Error adding branch!. You can not add more than 9 branches.');
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
         alert('Error deleting branch!');
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
         alert('Error composing branch. You can not add more than 3 levels.!');
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
  //if(1==1){
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
        if(IdNode.length()<=3) {
          %>
          <a title="Add criterion" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="Add condition" title="Add new criterion" /></a>
          <%
        }
        if(IdNode.equalsIgnoreCase("1")) {
          %>
          <img border="0" alt="" src="images/mini/space.gif" />
          <%
        } else {
          out.println("<a title=\"Delete criterion\" href=\"javascript:submitButtonForm('delete','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" title=\"Delete criterion\" alt=\"Delete criterion\" /></a>");
        }
        if(IdNode.length()<3) {
          if(NodeType.equalsIgnoreCase("Criteria")) {
            out.println("<a title=\"Compose criterion\" href=\"javascript:submitButtonForm('compose','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/compose.gif\" width=\"13\" height=\"13\" alt=\"Transform this node into a combination of criteria\" title=\"Transform this node into a combination of criteria\" /></a>");
          }
        }
        out.println("&nbsp;"+IdNode);
      } else {
        out.println("<a title=\"Delete root\" href=\"javascript:submitButtonForm('deleteroot','"+IdNode+"');\"><img border=\"0\" src=\"images/mini/delete.gif\" width=\"13\" height=\"13\" alt=\"Delete the criterion node, including the subnode\" title=\"Delete the criterion node, including the subnode\" /></a>");
      }

      if(!NodeType.equalsIgnoreCase("Criteria")) {
        out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">Criteria</label>");
        out.println("<select name=\"Criteria"+IdNode+"\" id=\"Criteria"+IdNode+"\" class=\"inputTextField\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select criteria\"></a>");
        if(NodeType.equalsIgnoreCase("All")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"All\">All</option>");
        if(NodeType.equalsIgnoreCase("Any")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Any\">Any</option>");
        out.println("</select> of following criteria are met:");
        out.println("<br />");
      } else {
        val=rs.getString("ATTRIBUTE");
        currentAttribute = val;
        out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">Attribute</label>");
        out.println("<select name=\"Attribute"+IdNode+"\" title=\"Attribute\" id=\"Attribute"+IdNode+"\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\"></a>");
        if(NatureObject.equalsIgnoreCase("Species")) {
          if(val.equalsIgnoreCase("ScientificName")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"ScientificName\">Scientific Name</option>");
          if(val.equalsIgnoreCase("VernacularName")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"VernacularName\">Vernacular Name</option>");
          if(val.equalsIgnoreCase("Group")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Group\">Group</option>");
          if(val.equalsIgnoreCase("ThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"ThreatStatus\">Threat Status</option>");
          if(val.equalsIgnoreCase("InternationalThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"InternationalThreatStatus\">International Threat Status</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">Country</option>");
          if(val.equalsIgnoreCase("Biogeoregion")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Biogeoregion\">Biogeoregion</option>");
//          if(val.equalsIgnoreCase("LegalStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
//          out.println("<option"+selected+" value=\"LegalStatus">Legal Status</option>");
          if(val.equalsIgnoreCase("Author")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Author\">Reference author</option>");
          if(val.equalsIgnoreCase("Title")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Title\">Reference title</option>");
          if(val.equalsIgnoreCase("LegalInstrument")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"LegalInstrument\">Legal instr. title</option>");
          if(val.equalsIgnoreCase("Taxonomy")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Taxonomy\">Taxonomy</option>");
          if(val.equalsIgnoreCase("Abundance")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Abundance\">Abundance</option>");
          if(val.equalsIgnoreCase("Trend")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Trend\">Trend</option>");
          if(val.equalsIgnoreCase("DistributionStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"DistributionStatus\">Distribution Status</option>");
//          if(val.equalsIgnoreCase("SpeciesStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
//          out.println("<option"+selected+" value=\"SpeciesStatus">Species Status</option>");
//          if(val.equalsIgnoreCase("InfoQuality")) { selected=" selected=\"selected\""; } else { selected=""; }
//          out.println("<option"+selected+" value=\"InfoQuality">Info Quality</option>");
        }
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("OPERATOR");
        currentOperator = val;
        out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">Operator</label>");
        out.println("<select name=\"Operator"+IdNode+"\" id=\"Operator"+IdNode+"\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select operator type\">");
        if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Equal\">Equal</option>");
        if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Contains\">Contains</option>");
        if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Between\">Between</option>");
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("FIRST_VALUE");
        currentValue = val;
        %>
        <label for="First_Value<%=IdNode%>" class="noshow">List of values</label>
        <input type="text" title="List of values" class="inputTextField" name="First_Value<%=IdNode%>" id="First_Value<%=IdNode%>" size="25" value="<%=val%>" onBlur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
        <a title="List of values" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="Display list of values" /></a>
        <%
        if(rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
          out.println(" and ");
          val=rs.getString("LAST_VALUE");
          currentValue = val;
          %>
          <label for="Last_Value<%=IdNode%>" class="noshow">List of values</label>
          <input type="text" title="List of values" class="inputTextField" name="Last_Value<%=IdNode%>" id="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onBlur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
          <a title="List of values" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="Display list of values" /></a>
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
    <input type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="Save" id="Save" name="Save" title="Save" />
    &nbsp;&nbsp;&nbsp;
    <label for="Search" class="noshow">Search</label>
    <input type="submit" class="inputTextField" value="Search" id="Search" name="Search" title="Search" />
    &nbsp;&nbsp;&nbsp;
    <label for="Reset" class="noshow">Reset</label>
    <input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="Reset" id="Reset" name="Reset" title="Reset values" />
    <%
  } else {
    %>
    <a title="Add root" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" title="Add new criterion" alt="Add new criterion" /></a>&nbsp;Add new criteria
    <%
  }

  rs.close();

  %>
  </form>
  <br />
  <strong>Note: Advanced search might take a long time</strong>
  <br />
  <%

  String criteria=tas.createCriteria(IdSession,NatureObject);
  out.println("Calculated Search criteria expression: ");
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

    if(NatureObject.equalsIgnoreCase("Species")) {
      ro.finsiel.eunis.search.AdvancedSearch tsas;
      tsas = new ro.finsiel.eunis.search.AdvancedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      pos_start=criteria.indexOf('#');
      pos_end=criteria.indexOf('#',pos_start+1);
      while(pos_start!=-1 && pos_end!=-1) {
        node=criteria.substring(pos_start+1,pos_end);
        interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
        //add criteria to the list of criteria passed to the results page
        listcriteria+=node+": "+interpretedcriteria+"<br />";
        out.println("Searching for: "+interpretedcriteria+"...");
        out.flush();
        intermediatefilter=tsas.BuildFilter(node,IdSession,NatureObject);
        out.println("found: <strong>"+tsas.getResultCount() + "</strong>");
        if(tsas.getResultCount()>=SQL_LIMIT) {
          out.println("<br />&nbsp;&nbsp;(Only first "+SQL_LIMIT+" results were retrieved - this can lead to partial,incomplete or no combined search results at all - you should refine this criteria)");
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

    //System.out.println("Starting final search...");
    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    String str=tsas.calculateCriteria(IdSession,NatureObject);

    tsas.DeleteResults(IdSession,NatureObject);

    str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_"+NatureObject.toUpperCase()+" WHERE ("+str+")";
    String query = tsas.ExecuteFilterSQL(str,"");
    out.println("<br /><strong>Total species matching your combined criteria found in database: " + tsas.getResultCount() + "</strong><br />");
    out.flush();

    if (tsas.getResultCount() > 0) {
      tsas.AddResult(IdSession,NatureObject,query);
    }

    if (tsas.getResultCount() > 0) {
    %>
    <form name="search" action="select-columns.jsp" method="post">
      <label for="NextStep" class="noshow">Proceed to next step</label>
      <input type="submit" id="NextStep" name="Proceed to next step" value="Proceed to next step" title="Proceed to next step" class="inputTextField" />
      <input type="hidden" name="searchedNatureObject" value="Species" />
      <input type="hidden" name="origin" value="Advanced" />
      <input type="hidden" name="explainedcriteria" value="<%=explainedcriteria%>" />
      <input type="hidden" name="listcriteria" value="<%=listcriteria%>" />
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
        <form name="saveCriteriaSearch" action="save-species-or-habitats-advanced-search-criteria.jsp" method="post">
          <label for="SaveCriteria" class="noshow">Save Criteria</label>
          <input type="button" id="SaveCriteria" name="Save Criteria" title="Save Criteria" value="Save Criteria" class="inputTextField" onClick="javascript:SaveCriteria();" />
          <input type="hidden" name="idsession" value="<%=IdSession%>" />
          <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
          <input type="hidden" name="username" value="<%=SessionManager.getUsername()%>" />
          <input type="hidden" name="fromWhere" value="species-advanced.jsp" />
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
       <br />No results were found matching your combined criteria.<br />
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
          <img border="0" alt="Expand-Collapse" align="middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>"><a title="Expand-Collapse" href="species-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? "Hide":"Show")%> saved search criteria</a>
        </td>
      </tr>
    </table>
  <%
    // If list is expanded
    if (exp !=null && exp.equals("yes"))
    {
  %>
      <form name="loadSaveCriteria" method="post" action="species-advanced.jsp">
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

  <%  // list of saved searches
      out.print(SaveAdvancedSearchCriteria.ExpandSaveCriteriaForThisPage(SQL_DRV,
                                                                        SQL_URL,
                                                                        SQL_USR,
                                                                        SQL_PWD,
                                                                        SessionManager.getUsername(),
                                                                        "species-advanced.jsp"));
    }
  }
%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-advanced.jsp" />
    </jsp:include>
  </div>
  </body>
</html>
<%out.flush();%>
