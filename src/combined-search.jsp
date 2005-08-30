<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Step 1 of 'Combined search' function - Selection of 1st nature object.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("generic_combined-search-step1_title", false )%>
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

  function changeNatureObject(action) {
<%--    alert(document.criteria.natureobject.value);--%>
     document.criteria.action.value=action;
    document.criteria.submit();
  }

  function SaveCriteria(natureObject) {
  var sourceDBIsChecked = true;
  if (natureObject.toLowerCase() == "sites")
   {
    sourceDBIsChecked = checkValidSelection();
   }
  if (sourceDBIsChecked)
    {
      var URL2 = "combined-search-save-criteria.jsp?";
      URL2 += "&idsession="+document.saveCriteriaSearch.idsession.value;
      URL2 += "&natureobject="+document.saveCriteriaSearch.natureobject.value;
      URL2 += "&username="+document.saveCriteriaSearch.username.value;
      URL2 += "&fromWhere="+document.saveCriteriaSearch.fromWhere.value;
      URL2 += "&saveThisCriteria=false";
      URL2 += "&expandCriterias=<%=request.getParameter("expandCriterias")%>";


      if (natureObject.toLowerCase() == "sites")
      {
        if(document.criteria.DIPLOMA.checked==true) URL2 += "&DIPLOMA=true";
        if(document.criteria.CDDA_NATIONAL.checked==true) URL2 += "&CDDA_NATIONAL=true";
        if(document.criteria.CDDA_INTERNATIONAL.checked==true) URL2 += "&CDDA_INTERNATIONAL=true";
        if(document.criteria.BIOGENETIC.checked==true) URL2 += "&BIOGENETIC=true";
        if(document.criteria.NATURA2000.checked==true) URL2 += "&NATURA2000=true";
        if(document.criteria.NATURENET.checked==true) URL2 += "&NATURENET=true";
        if(document.criteria.EMERALD.checked==true) URL2 += "&EMERALD=true";
        if(document.criteria.CORINE.checked==true) URL2 += "&CORINE=true";
      }

      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=500,height=400,left=300,top=80');");
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
  </head>
<%
  String IdSession = request.getParameter("idsession");

  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }

  String NatureObject = request.getParameter("natureobject");

  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    System.out.println("No nature object found - Default to Species");
    NatureObject="Species";
  }
  // Load saved search
  if(request.getParameter("loadCriteria") != null && request.getParameter("loadCriteria").equalsIgnoreCase("yes"))
  {
%>
<jsp:include page="load-save-combined-search.jsp">
  <jsp:param name="fromWhere" value="<%=request.getParameter("fromWhere")%>"/>
  <jsp:param name="criterianame" value="<%=request.getParameter("criterianame")%>"/>
  <jsp:param name="siteName" value="<%=request.getParameter("siteName")%>"/>
  <jsp:param name="natureobject" value="<%=NatureObject%>"/>
  <jsp:param name="idsession" value="<%=IdSession%>"/>
</jsp:include>
<%
  }
%>
<body>
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Combined search - step 1"/>
    <jsp:param name="helpLink" value="combined-help.jsp"/>
  </jsp:include>
  <%=contentManagement.getContent("generic_combined-search-step1_01")%>
  <br />
  <br />
  <table summary="layout" border="0">
    <tr>
      <td id="status">
        <%=contentManagement.getContent("generic_combined-search-step1_02")%>
      </td>
    </tr>
  </table>
<%
  SessionManager.setExplainedcriteria(null);
  SessionManager.setListcriteria(null);
  SessionManager.setCombinednatureobject1(null);
  SessionManager.setCombinedlistcriteria1(null);
  SessionManager.setCombinedexplainedcriteria1(null);
  SessionManager.setCombinednatureobject2(null);
  SessionManager.setCombinedlistcriteria2(null);
  SessionManager.setCombinedexplainedcriteria2(null);
  SessionManager.setCombinednatureobject3(null);
  SessionManager.setCombinedlistcriteria3(null);
  SessionManager.setCombinedexplainedcriteria3(null);
  SessionManager.setCombinedcombinationtype(null);
  String combinednatureobject1="";
  String combinedlistcriteria1="";
  String combinedexplainedcriteria1="";
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
<%
//  System.out.println("NatureObject = " + NatureObject);
//  System.out.println("IdSession = " + IdSession);
  int SQL_LIMIT=500000;

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  String f_action = request.getParameter("action");
  if(f_action==null) f_action="";
  ro.finsiel.eunis.search.CombinedSearch cs = new ro.finsiel.eunis.search.CombinedSearch();
  cs.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
  if(cs.CheckExistingSessionData(IdSession)) {
    if(f_action.equalsIgnoreCase("clear")) {
      cs.DeleteSessionData(IdSession);
    }
    if(f_action.equalsIgnoreCase("keep")) {
    }
    if(f_action.equalsIgnoreCase("")) {
      String f_idnode = request.getParameter("idnode");
      if(f_idnode==null) f_idnode="";
      String f_criteria = request.getParameter("criteria");
      if(f_criteria==null) f_criteria="";
      String f_attribute = request.getParameter("attribute");
      if(f_attribute==null) f_attribute="";
      String f_operator = request.getParameter("operator");
      if(f_operator==null) f_operator="";
      String f_firstvalue = request.getParameter("firstvalue");
      if(f_firstvalue==null) f_firstvalue="";
      String f_lastvalue = request.getParameter("lastvalue");
      if(f_lastvalue==null) f_lastvalue="";
      if((f_idnode+f_criteria+f_attribute+f_operator+f_firstvalue+f_lastvalue).length()==0 && request.getParameter("Search")==null)
      {
        %>
        <br />
        <%=contentManagement.getContent("generic_combined-search-step1_03")%>
        <form method="post" action="combined-search.jsp" name="criteria">
        <input type="hidden" name="criteria" value="" />
        <input type="hidden" name="attribute" value="" />
        <input type="hidden" name="operator" value="" />
        <input type="hidden" name="firstvalue" value="" />
        <input type="hidden" name="lastvalue" value="" />
        <input type="hidden" name="oldfirstvalue" value="" />
        <input type="hidden" name="oldlastvalue" value="" />
        <input type="hidden" name="action" value="" />
        <input type="hidden" name="idnode" value="" />
        <input type="hidden" name="idsession" value="<%=IdSession%>" />
        <%
        String clearData = contentManagement.getContent("generic_combined-search-step1_06",false);
        String clearDataAlt = contentManagement.getContent("generic_combined-search-step1_07",false);
        String keepData = contentManagement.getContent("generic_combined-search-step1_08",false);
        String keepDataAlt = contentManagement.getContent("generic_combined-search-step1_09",false);
        out.println("<br />");
        out.println("<input type=\"button\" class=\"inputTextField\" onclick=\"submitClearData()\" name=\"Clear\" value=\"" + clearData +"\" title=\"" + clearDataAlt + "\" />");
        out.println("<input type=\"button\" class=\"inputTextField\" onclick=\"submitKeepData(\""+NatureObject+"\") value=\"" + keepData + "\" name=\"Keep\" title=\"" + keepDataAlt + "\" />");
        out.println("</form>");
        %>
        <jsp:include page="footer.jsp">
          <jsp:param name="page_name" value="combined-search.jsp" />
        </jsp:include>
        </body>
        </html>
        <%
        return;
      }
    }
  }
  %>
<form method="post" action="combined-search.jsp" name="criteria">
<strong>
  <%=contentManagement.getContent("generic_combined-search-step1_04")%>
</strong>
<%=contentManagement.getContent("generic_combined-search-step1_05")%>
<label for="natureobject" class="noshow">Nature object type</label>
<select title="Nature object type" size="1" name="natureobject" id="natureobject" onchange="javascript:changeNatureObject('<%=request.getParameter("action")%>')">
  <option <%=NatureObject.equalsIgnoreCase("Species")?"selected=\"selected\"":""%> value="Species">
    <%=contentManagement.getContent("generic_combined-search-step1_12")%>
  </option>
  <option <%=NatureObject.equalsIgnoreCase("Habitat")?"selected=\"selected\"":""%> value="Habitat">
    <%=contentManagement.getContent("generic_combined-search-step1_13")%>
  </option>
  <option <%=NatureObject.equalsIgnoreCase("Sites")?"selected=\"selected\"":""%> value="Sites">
    <%=contentManagement.getContent("generic_combined-search-step1_14")%>
  </option>
</select>
  <%=contentManagement.getContent("generic_combined-search-step1_11")%>
<br />
<hr width="740" size="1" align="left" />
<br />
<input type="hidden" name="criteria" value="" />
<input type="hidden" name="attribute" value="" />
<input type="hidden" name="operator" value="" />
<input type="hidden" name="firstvalue" value="" />
<input type="hidden" name="lastvalue" value="" />
<input type="hidden" name="oldfirstvalue" value="" />
<input type="hidden" name="oldlastvalue" value="" />
<input type="hidden" name="action" value="" />
<input type="hidden" name="idnode" value="" />
<input type="hidden" name="idsession" value="<%=IdSession%>" />
<%
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

  ro.finsiel.eunis.search.CombinedSearch tas = new ro.finsiel.eunis.search.CombinedSearch();
  tas.SetSQLLimit(SQL_LIMIT);

  tas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  //prelucram actiunea curenta
  if(p_action.equalsIgnoreCase("reset")) {
    ro.finsiel.eunis.search.CombinedSearch tsas;
    tsas = new ro.finsiel.eunis.search.CombinedSearch();
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
          alert('<%=contentManagement.getContent("generic_combined-search-step1_15",false)%>');
        //-->
        </script>
      <%
    }
  }

  if(p_action.equalsIgnoreCase("addroot"))
  {
    //out.println("Add root");
    String attribute="ScientificName";
    if(NatureObject.equalsIgnoreCase("Sites")) {
      attribute="Name";
    }
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
         alert('<%=contentManagement.getContent("generic_combined-search-step1_16",false)%>');
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
         alert('<%=contentManagement.getContent("generic_combined-search-step1_17",false)%>');
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
          alert('<%=contentManagement.getContent("generic_combined-search-step1_18",false)%>');
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
//      System.out.println("first value:" + p_firstvalue);
      tas.ChangeFirstValue(p_idnode,IdSession,NatureObject,p_firstvalue);
    }
    if(p_lastvalue.length() != 0) {
      //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
//      System.out.println("last value:" + p_lastvalue);
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
  SQL+="EUNIS_COMBINED_SEARCH.ID_NODE,";
  SQL+="EUNIS_COMBINED_SEARCH.NODE_TYPE,";
  SQL+="EUNIS_COMBINED_SEARCH_CRITERIA.ATTRIBUTE,";
  SQL+="EUNIS_COMBINED_SEARCH_CRITERIA.OPERATOR,";
  SQL+="EUNIS_COMBINED_SEARCH_CRITERIA.FIRST_VALUE,";
  SQL+="EUNIS_COMBINED_SEARCH_CRITERIA.LAST_VALUE ";
  SQL+="FROM ";
  SQL+="EUNIS_COMBINED_SEARCH ";
  SQL+="LEFT OUTER JOIN EUNIS_COMBINED_SEARCH_CRITERIA ON (EUNIS_COMBINED_SEARCH.ID_SESSION = EUNIS_COMBINED_SEARCH_CRITERIA.ID_SESSION AND EUNIS_COMBINED_SEARCH.NATURE_OBJECT = EUNIS_COMBINED_SEARCH_CRITERIA.NATURE_OBJECT AND EUNIS_COMBINED_SEARCH.ID_NODE = EUNIS_COMBINED_SEARCH_CRITERIA.ID_NODE) ";
  SQL+="WHERE (EUNIS_COMBINED_SEARCH.ID_SESSION='"+IdSession+"') ";
  SQL+="AND (EUNIS_COMBINED_SEARCH.NATURE_OBJECT='"+NatureObject+"') ";
  SQL+="ORDER BY ";
  SQL+="EUNIS_COMBINED_SEARCH.ID_NODE ";

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
          <a title="Add criteria" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img alt="Add criteria" src="images/mini/add.gif" border="0" width="13" height="13" title="<%=contentManagement.getContent("generic_combined-search-step1_19",false)%>" /></a>
<%
        }
        if(IdNode.equalsIgnoreCase("1"))
        {
%>
          <img alt="" border="0" src="images/mini/space.gif" />
<%
        }
        else
        {
%>
          <a href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img alt="Delete criteria" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=contentManagement.getContent("generic_combined-search-step1_20",false)%>" /></a>
<%
        }
        if(IdNode.length()<3)
        {
          if(NodeType.equalsIgnoreCase("Criteria"))
          {
%>
            <a title="Compose criterion" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="Compose" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=contentManagement.getContent("generic_combined-search-step1_21",false)%>" /></a>
<%
          }
        }
        out.println("&nbsp;"+IdNode);
      } else {
%>
        <a title="Delete root" href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="Delete root" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=contentManagement.getContent("generic_combined-search-step1_22",false)%>" /></a>
<%
      }

      String criteriaTitle = contentManagement.getContent("generic_combined-search-step1_23",false);
      String all = contentManagement.getContent("generic_combined-search-step1_24",false);
      String any = contentManagement.getContent("generic_combined-search-step1_25",false);

      if(!NodeType.equalsIgnoreCase("Criteria")) {
        out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">Criteria</label>");
        out.println("<select name=\"Criteria"+IdNode+"\" class=\"inputTextField\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"" + criteriaTitle + "\" id=\"Criteria" + IdNode + "\">");
        if(NodeType.equalsIgnoreCase("All")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"All\">" + all + "</option>");
        if(NodeType.equalsIgnoreCase("Any")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Any\">" + any + "</option>");
        out.println("</select>");
        out.println( contentManagement.getContent("generic_combined-search-step1_26") );
        out.println("<br />");
      } else {
        val=rs.getString("ATTRIBUTE");
        currentAttribute = val;
        out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">Attribute</label>");
        out.println("<select title=\"Attribute\" name=\"Attribute"+IdNode+"\" id=\"Attribute" + IdNode + "\" class=\"inputTextField\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\">");
        if(NatureObject.equalsIgnoreCase("Habitat")) {
          if(val.equalsIgnoreCase("ScientificName")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"ScientificName\">" + contentManagement.getContent("generic_combined-search-step1_27") + "</option>");
          if(val.equalsIgnoreCase("Code")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Code\">" + contentManagement.getContent("generic_combined-search-step1_28") + "</option>");
          if(val.equalsIgnoreCase("LegalInstruments")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"LegalInstruments\">" + contentManagement.getContent("generic_combined-search-step1_29") + "</option>");
          if(val.equalsIgnoreCase("SourceDatabase")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"SourceDatabase\">" + contentManagement.getContent("generic_combined-search-step1_30") + "</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">" + contentManagement.getContent("generic_combined-search-step1_31") + "</option>");
          if(val.equalsIgnoreCase("Biogeoregion")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Biogeoregion\">" + contentManagement.getContent("generic_combined-search-step1_32") + "</option>");
          if(val.equalsIgnoreCase("Author")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Author\">" + contentManagement.getContent("generic_combined-search-step1_33") + "</option>");
          if(val.equalsIgnoreCase("Title")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Title\">" + contentManagement.getContent("generic_combined-search-step1_34") + "</option>");
          if(val.equalsIgnoreCase("Altitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Altitude\">" + contentManagement.getContent("generic_combined-search-step1_35") + "</option>");
          if(val.equalsIgnoreCase("Chemistry")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Chemistry\">" + contentManagement.getContent("generic_combined-search-step1_36") + "</option>");
          if(val.equalsIgnoreCase("Climate")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Climate\">" + contentManagement.getContent("generic_combined-search-step1_37") + "</option>");
          if(val.equalsIgnoreCase("Cover")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Cover\">" + contentManagement.getContent("generic_combined-search-step1_38") + "</option>");
          if(val.equalsIgnoreCase("Depth")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Depth\">" + contentManagement.getContent("generic_combined-search-step1_39") + "</option>");
          if(val.equalsIgnoreCase("Geomorph")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Geomorph\">" + contentManagement.getContent("generic_combined-search-step1_40") + "</option>");
          if(val.equalsIgnoreCase("Humidity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Humidity\">" + contentManagement.getContent("generic_combined-search-step1_41") + "</option>");
          if(val.equalsIgnoreCase("LifeForm")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"LifeForm\">" + contentManagement.getContent("generic_combined-search-step1_42") + "</option>");
          if(val.equalsIgnoreCase("LightIntensity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"LightIntensity\">" + contentManagement.getContent("generic_combined-search-step1_43") + "</option>");
          if(val.equalsIgnoreCase("Marine")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Marine\">" + contentManagement.getContent("generic_combined-search-step1_44") + "</option>");
          if(val.equalsIgnoreCase("Salinity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Salinity\">" + contentManagement.getContent("generic_combined-search-step1_45") + "</option>");
          if(val.equalsIgnoreCase("Spatial")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Spatial\">" + contentManagement.getContent("generic_combined-search-step1_46") + "</option>");
          if(val.equalsIgnoreCase("Substrate")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Substrate\">" + contentManagement.getContent("generic_combined-search-step1_47") + "</option>");
          if(val.equalsIgnoreCase("Temporal")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Temporal\">" + contentManagement.getContent("generic_combined-search-step1_48") + "</option>");
          if(val.equalsIgnoreCase("Tidal")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Tidal\">" + contentManagement.getContent("generic_combined-search-step1_49") + "</option>");
          if(val.equalsIgnoreCase("Water")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Water\">" + contentManagement.getContent("generic_combined-search-step1_50") + "</option>");
          if(val.equalsIgnoreCase("Usage")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Usage\">" + contentManagement.getContent("generic_combined-search-step1_51") + "</option>");
        } else if(NatureObject.equalsIgnoreCase("Species")) {
          if(val.equalsIgnoreCase("ScientificName")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"ScientificName\">" + contentManagement.getContent("generic_combined-search-step1_52") + "</option>");
          if(val.equalsIgnoreCase("VernacularName")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"VernacularName\">" + contentManagement.getContent("generic_combined-search-step1_53") + "</option>");
          if(val.equalsIgnoreCase("Group")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Group\">Group</option>");
          if(val.equalsIgnoreCase("ThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"ThreatStatus\">" + contentManagement.getContent("generic_combined-search-step1_54") + "</option>");
          if(val.equalsIgnoreCase("InternationalThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"InternationalThreatStatus\">" + contentManagement.getContent("generic_combined-search-step1_55") + "</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">" + contentManagement.getContent("generic_combined-search-step1_56") + "</option>");
          if(val.equalsIgnoreCase("Biogeoregion")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Biogeoregion\">" + contentManagement.getContent("generic_combined-search-step1_57") + "</option>");
          if(val.equalsIgnoreCase("Author")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Author\">" + contentManagement.getContent("generic_combined-search-step1_58") + "</option>");
          if(val.equalsIgnoreCase("Title")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Title\">" + contentManagement.getContent("generic_combined-search-step1_59") + "</option>");
          if(val.equalsIgnoreCase("LegalInstrument")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"LegalInstrument\">" + contentManagement.getContent("generic_combined-search-step1_60") + "</option>");
          if(val.equalsIgnoreCase("Taxonomy")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Taxonomy\">" + contentManagement.getContent("generic_combined-search-step1_61") + "</option>");
          if(val.equalsIgnoreCase("Abundance")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Abundance\">" + contentManagement.getContent("generic_combined-search-step1_62") + "</option>");
          if(val.equalsIgnoreCase("Trend")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Trend\">" + contentManagement.getContent("generic_combined-search-step1_63") + "</option>");
          if(val.equalsIgnoreCase("DistributionStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"DistributionStatus\">" + contentManagement.getContent("generic_combined-search-step1_64") + "</option>");
        } else if(NatureObject.equalsIgnoreCase("Sites")) {
          if(val.equalsIgnoreCase("Name")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Name\">" + contentManagement.getContent("generic_combined-search-step1_65") + "</option>");
          if(val.equalsIgnoreCase("Code")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Code\">" + contentManagement.getContent("generic_combined-search-step1_66") + "</option>");
          if(val.equalsIgnoreCase("DesignationYear")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"DesignationYear\">" + contentManagement.getContent("generic_combined-search-step1_67") + "</option>");
          if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Country\">" + contentManagement.getContent("generic_combined-search-step1_68") + "</option>");
          if(val.equalsIgnoreCase("Size")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Size\">" + contentManagement.getContent("generic_combined-search-step1_69") + "</option>");
          if(val.equalsIgnoreCase("Longitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Longitude\">" + contentManagement.getContent("generic_combined-search-step1_70") + "</option>");
          if(val.equalsIgnoreCase("Latitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Latitude\">" + contentManagement.getContent("generic_combined-search-step1_71") + "</option>");
          if(val.equalsIgnoreCase("MinimumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MinimumAltitude\">" + contentManagement.getContent("generic_combined-search-step1_72") + "</option>");
          if(val.equalsIgnoreCase("MaximumAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MaximumAltitude\">" + contentManagement.getContent("generic_combined-search-step1_73") + "</option>");
          if(val.equalsIgnoreCase("MeanAltitude")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"MeanAltitude\">" + contentManagement.getContent("generic_combined-search-step1_74") + "</option>");
          if(val.equalsIgnoreCase("Designation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Designation\">" + contentManagement.getContent("generic_combined-search-step1_75") + "</option>");
          if(val.equalsIgnoreCase("HumanActivity")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"HumanActivity\">" + contentManagement.getContent("generic_combined-search-step1_76") + "</option>");
          if(val.equalsIgnoreCase("Motivation")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"Motivation\">" + contentManagement.getContent("generic_combined-search-step1_77") + "</option>");
          if(val.equalsIgnoreCase("RegionCode")) { selected=" selected=\"selected\""; } else { selected=""; }
          out.println("<option"+selected+" value=\"RegionCode\">" + contentManagement.getContent("generic_combined-search-step1_78") + "</option>");
        }
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("OPERATOR");
        currentOperator = val;

        String operatorAlt = contentManagement.getContent("generic_combined-search-step1_79");
        String equal = contentManagement.getContent("generic_combined-search-step1_80");
        String contains = contentManagement.getContent("generic_combined-search-step1_81");
        String between = contentManagement.getContent("generic_combined-search-step1_82");

        out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">Operator</label>");
        out.println("<select name=\"Operator"+IdNode+"\" id=\"Operator"+IdNode+"\" class=\"inputTextField\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\"Select operator type\">");
        if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Equal\">" + equal + "</option>");
        if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
        out.println("<option"+selected+" value=\"Contains\">" + contains + "</option>");
        if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }

        if (NatureObject.equalsIgnoreCase("Habitat") && rs.getString("ATTRIBUTE").equalsIgnoreCase("LegalInstruments")) {}
        else out.println("<option"+selected+" value=\"Between\">" + between + "</option>");
        out.println("</select>");

        out.println("&nbsp;");

        val=rs.getString("FIRST_VALUE");
        currentValue = val;

        String popupAlt = contentManagement.getContent("generic_combined-search-step1_83",false);
        %>
        <label for="First_Value<%=IdNode%>" class="noshow">First search value</label>
        <input type="text" class="inputTextField" id="First_Value<%=IdNode%>" name="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" title="<%=popupAlt%>" />
        <a title="List of values" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=popupAlt%>" /></a>
        <%
        if(rs.getString("OPERATOR").equalsIgnoreCase("Between"))
        {
          out.println(" and ");
          val=rs.getString("LAST_VALUE");
          currentValue = val;
          %>
          <label for="Last_Value<%=IdNode%>" class="noshow">Second search value</label>
          <input type="text" id="Last_Value<%=IdNode%>" class="inputTextField" name="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" title="<%=popupAlt%>" />
          <a title="List of values" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=popupAlt%>" /></a>
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
    <%
    String save = contentManagement.getContent("generic_combined-search-step1_84",false);
    String reset = contentManagement.getContent("generic_combined-search-step1_85",false);
    %>
    <label for="Save" class="noshow">Save criteria</label>
    <input type="button" class="inputTextField" onclick="disableSaveButton()" disabled="disabled" value="<%=save%>" id="Save" name="Save" title="Save" />
    &nbsp;&nbsp;&nbsp;
    <label for="Search" class="noshow">Search</label>
    <input type="submit" class="inputTextField" value="Search" name="Search" id="Search" title="Search" />
    &nbsp;&nbsp;&nbsp;
    <label for="Reset" class="noshow">Reset</label>
    <input type="button" class="inputTextField" onclick="submitButtonForm('reset','0')" value="<%=reset%>" id="Reset" name="Reset" title="Reset values" />
    </form>
    <%
  } else {
    %>
    <a title="Add root" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="Add condition" /></a>
    <%=contentManagement.getContent("generic_combined-search-step1_86")%>
    </form>
    <%
  }
  rs.close();
  %>
  <br />
  <strong>
    <%=contentManagement.getContent("generic_combined-search-step1_87")%>
  </strong>
  <br />
  <%
  String criteria=tas.createCriteria(IdSession,NatureObject);
  out.println("Calculated search criteria expression: ");
  combinedexplainedcriteria1=criteria.replace('#',' ').replace('[','(').replace(']',')').replaceAll("AND","<strong>AND</strong>").replaceAll("OR","<strong>OR</strong>");
  out.println(combinedexplainedcriteria1);

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
      combinednatureobject1="Species";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      pos_start=criteria.indexOf('#');
      pos_end=criteria.indexOf('#',pos_start+1);
      while(pos_start!=-1 && pos_end!=-1) {
        node=criteria.substring(pos_start+1,pos_end);
        interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
        combinedlistcriteria1+=node+": "+interpretedcriteria+"<br />";
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

    if(NatureObject.equalsIgnoreCase("Habitat")) {
      combinednatureobject1="Habitats";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      pos_start=criteria.indexOf('#');
      pos_end=criteria.indexOf('#',pos_start+1);
      while(pos_start!=-1 && pos_end!=-1) {
        node=criteria.substring(pos_start+1,pos_end);
        interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
        combinedlistcriteria1+=node+": "+interpretedcriteria+"<br />";
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

    if(NatureObject.equalsIgnoreCase("Sites")) {
      combinednatureobject1="Sites";
      ro.finsiel.eunis.search.CombinedSearch tsas;
      tsas = new ro.finsiel.eunis.search.CombinedSearch();
      tsas.SetSourceDB(SourceDB);
      tsas.SetSQLLimit(SQL_LIMIT);
      tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      pos_start=criteria.indexOf('#');
      pos_end=criteria.indexOf('#',pos_start+1);
      while(pos_start!=-1 && pos_end!=-1) {
        node=criteria.substring(pos_start+1,pos_end);
        interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
        combinedlistcriteria1+=node+": "+interpretedcriteria+"<br />";
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

    ro.finsiel.eunis.search.CombinedSearch tsas;
    tsas = new ro.finsiel.eunis.search.CombinedSearch();
    tsas.SetSourceDB(SourceDB);
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    String str=tsas.calculateCriteria(IdSession,NatureObject);

    tsas.DeleteResults(IdSession,NatureObject);

    if(NatureObject.equalsIgnoreCase("Species")) {
      str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE ("+str+")";
    }
    if(NatureObject.equalsIgnoreCase("Habitat")) {
      str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT WHERE ("+str+")";
    }
    if(NatureObject.equalsIgnoreCase("Sites")) {
      str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ("+str+")";
    }
    String query = tsas.ExecuteFilterSQL(str,"");
    out.println("<br /><strong>Total matches found in database:&nbsp;" + tsas.getResultCount() + "</strong><br /><br />");
    out.flush();

    if (tsas.getResultCount() > 0) {
      tsas.AddResult(IdSession,NatureObject,query);
    }

    if (tsas.getResultCount() > 0) {%>
      <form name="search" action="combined-search-2.jsp" method="post">
      <input type="hidden" name="combinedexplainedcriteria1" value="<%=combinedexplainedcriteria1%>" />
      <input type="hidden" name="combinedlistcriteria1" value="<%=combinedlistcriteria1%>" />
      <input type="hidden" name="combinednatureobject1" value="<%=combinednatureobject1%>" />
      <%
      if(NatureObject.equalsIgnoreCase("Species")) {
        %>
        <label for="NextPageSpecies" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageSpecies" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_88",false)%>" class="inputTextField" />
        <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Habitat")) {
        %>
        <label for="NextPageHabitat" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageHabitat" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_89",false)%>" class="inputTextField" />
        <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Sites")) {
        %>
        <label for="NextPageSites" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageSites" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_90",false)%>" class="inputTextField" />
        <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
        <%
      }
      %>
      <input type="hidden" name="idsession" value="<%=IdSession%>" />
      <input type="hidden" name="previousnatureobject" value="<%=NatureObject%>" />
      <%
      if(NatureObject.equalsIgnoreCase("Species")) {
      %>
        <input type="hidden" name="natureobject" value="Habitat" />
        <input type="hidden" name="nextnatureobject" value="Sites" />
      <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Habitat")) {
      %>
        <input type="hidden" name="natureobject" value="Sites" />
        <input type="hidden" name="nextnatureobject" value="Species" />
      <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Sites")) {
      %>
        <input type="hidden" name="natureobject" value="Species" />
        <input type="hidden" name="nextnatureobject" value="Habitat" />
      <%
      }
      %>
      </form>
      <br />
      <form name="search_skip" action="combined-search-3.jsp" method="post">
      <input type="hidden" name="combinedexplainedcriteria1" value="<%=combinedexplainedcriteria1%>" />
      <input type="hidden" name="combinedlistcriteria1" value="<%=combinedlistcriteria1%>" />
      <input type="hidden" name="combinednatureobject1" value="<%=combinednatureobject1%>" />
      <%
      if(NatureObject.equalsIgnoreCase("Species")) {
        %>
        <label for="NextPageSpecies2" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageSpecies2" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_91",false)%>" class="inputTextField" />
        <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Habitat")) {
        %>
        <label for="NextPageHabitat2" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageHabitat2" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_92",false)%>" class="inputTextField" />
        <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Sites")) {
        %>
        <label for="NextPageSites2" class="noshow">Proceed to next page</label>
        <input type="submit" id="NextPageSites2" name="Proceed to next page" title="Proceed to next page" value="<%=contentManagement.getContent("generic_combined-search-step1_93",false)%>" class="inputTextField" />
        <input type="hidden" name="sourcedbcriteria" value="<%=sourcedbcriteria.replaceAll("'","")%>" />
        <%
      }
      %>
      <input type="hidden" name="idsession" value="<%=IdSession%>" />
      <input type="hidden" name="previousnatureobject" value="<%=NatureObject%>" />
      <%
      if(NatureObject.equalsIgnoreCase("Species")) {
      %>
        <input type="hidden" name="natureobject" value="Sites" />
        <input type="hidden" name="firstnatureobject" value="Species" />
        <input type="hidden" name="secondnatureobject" value="Habitat" />
        <input type="hidden" name="skip" value="Habitat">
      <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Habitat")) {
      %>
        <input type="hidden" name="natureobject" value="Species" />
        <input type="hidden" name="firstnatureobject" value="Habitat" />
        <input type="hidden" name="secondnatureobject" value="Sites" />
        <input type="hidden" name="skip" value="Sites" />
      <%
      }
      %>
      <%
      if(NatureObject.equalsIgnoreCase("Sites")) {
      %>
        <input type="hidden" name="natureobject" value="Habitat" />
        <input type="hidden" name="firstnatureobject" value="Sites" />
        <input type="hidden" name="secondnatureobject" value="Species" />
        <input type="hidden" name="skip" value="Species" />
      <%
      }
      %>
      </form>
<%--    end modify--%>
    <%
      // Save this combined search
      if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
      {
    %>
    <br />
    <br />
    <table summary="layout" width="100%" border="0">
    <tr>
      <td>
        <form name="saveCriteriaSearch" action="combined-search-save-criteria.jsp" method="post">
          <label for="SaveCriteria" class="noshow">Save Criteria</label>
          <input type="button" name="Save Criteria" title="Save criteria" id="SaveCriteria" value="Save Criteria" class="inputTextField" onclick="javascript:SaveCriteria('<%=NatureObject%>');" />
          <input type="hidden" name="idsession" value="<%=IdSession%>" />
          <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
          <input type="hidden" name="username" value="<%=SessionManager.getUsername()%>" />
          <input type="hidden" name="fromWhere" value="combined-search.jsp" />
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
       <%=contentManagement.getContent("generic_combined-search-step1_94")%>
       <br />
    <%
    }
  }
  con.close();
  // Expand saved combined searches list for this jsp page
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
  {
    String exp = (request.getParameter("expandCriterias") == null ? "no" : request.getParameter("expandCriterias"));
%>
    <br />
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <img alt="Expand-Collapse" border="0" align="middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="Expand-Collapse" href="combined-search.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>&amp;action=keep&amp;idsession=<%=IdSession%>&amp;natureobject=<%=NatureObject%>"><%=(exp.equalsIgnoreCase("yes") ? "Hide":"Show")%><%=contentManagement.getContent("generic_combined-search-step1_95",false)%></a>
        </td>
      </tr>
    </table>
  <%
    // If list is expanded
    if (exp !=null && exp.equals("yes"))
    {
  %>
      <form name="loadSaveCriteria" method="post" action="combined-search.jsp">
        <input type ="hidden" name="loadCriteria" value="yes" />
        <input type ="hidden" name="fromWhere" value="" />
        <input type ="hidden" name="criterianame" value="" />
        <input type ="hidden" name="natureobject" value="" />
        <input type ="hidden" name="action" value="keep" />
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

      <form name="deleteSaveCriteria" method="post" action="delete-save-combined-search-criteria.jsp">
        <input type ="hidden" name="fromWhere" value="" />
        <input type ="hidden" name="criterianame" value="" />
        <input type ="hidden" name="natureobject" value="" />
      </form>

  <%   // list of saved searches
      out.print(SaveCombinedSearchCriteria.ExpandSaveCriteriaForThisPage(NatureObject,
                                                                        SQL_DRV,
                                                                        SQL_URL,
                                                                        SQL_USR,
                                                                        SQL_PWD,
                                                                        SessionManager.getUsername(),
                                                                        "combined-search.jsp"));
    }
  }
%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="combined-search.jsp" />
    </jsp:include>
    </div>    
  </body>
</html>
<%out.flush();%>
