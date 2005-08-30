<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display tree of the Annex I habitats.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist" %>
<%@ page import="java.util.Iterator" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <jsp:useBean id="tree1" scope="session" class="ro.finsiel.eunis.search.habitats.HabitatAnnex1Tree" />
  <jsp:useBean id="treeBean" class="ro.finsiel.eunis.formBeans.HabitatAnnex1TreeBean" scope="request">
    <jsp:setProperty name="treeBean" property="*" />
  </jsp:useBean>
  <%
    // Request parameters
    String habCode2000, habID;
    habCode2000 = treeBean.getHabCode2000();
    habID = treeBean.getHabID();
    int level = (null == request.getParameter("level")) ? 2 : Integer.parseInt(request.getParameter("level"));
  %>
  <link rel="StyleSheet" href="css/tree.css" type="text/css" />
  <script language="JavaScript" type="text/javascript" src="script/tree.js"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
  function MM_jumpMenu(targ,selObj,restore){ //v3.0
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }

  var Tree2 = new Array;
  // nodeId | parentNodeId | nodeName | nodeUrl | hasChild | isLastSibling | childId,childiD ...
  <%
        // Set the tree string for habitat with CODE_2000 = habCode2000, and display it
        if (habCode2000 != null && habID == null)
        {
          tree1.maxlevel=4;
          tree1.getTree("Tree2",2,habCode2000);
      %>
          <%=tree1.tree.toString()%>
          var level1 = "<%=tree1.level1%>";
      <%
        }
        // Tree string is already set, so it is displayed; for habID != null is dispayed the short factshhet for the habitat
        if (habCode2000==null && habID != null )
        {
      %>
        <%=tree1.tree.toString()%>
        var level1 = "<%=tree1.level1%>";
      <%
        }
      %>
    //-->
  </script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_annex1-browser_title", false)%>
  </title>
  <%
    int mx = 0;
  %>
</head>

<body bgcolor="#ffffff">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,ANNEX I habitat type hierarchical view" />
</jsp:include>
<h5>
  <%=contentManagement.getContent("habitats_annex1-browser_01")%>
</h5>
<table summary="layout" width="100%" border="0">
<tr>
<td>
  <%
    // The level list is displayed only when habCode2000 != null
    if (request.getParameter("habCode2000") != null)
    {
      // Set the max level of three for this habitat(with CODE_2000 = habCode2000)
      mx = tree1.maxLevel(request.getParameter("habCode2000").substring(0, 1));
  %>
  <form name="setings" action="habitats-annex1-browser.jsp" method="post">
    <label for="depth" class="noshow"><%=contentManagement.getContent("habitats_annex1-browser_03")%>:</label>
    <select title="Level" name="depth" id="depth" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
      <option value="habitats-annex1-browser.jsp" <%=(request.getParameter("level")==null ? "selected=\"selected\"" : "")%>>
        <%=contentManagement.getContent("habitats_annex1-browser_02", false)%>
      </option>
      <%
      // Display the levels
      for (int ii = 2; ii <= mx; ii++) {
      %>
        <option value="habitats-annex1-browser.jsp?level=<%=ii%>&amp;habCode2000=<%=habCode2000%>" <%=(request.getParameter("level") != null && request.getParameter("level").equals((new Integer(ii)).toString())) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("habitats_annex1-browser_04", false)%>&nbsp;<%=ii%></option>
      <%
      }
      %>
    </select>
  </form>
  <%
    }
  %>
  <table border="0" summary="layout" width="100%" title="Habit types on root level">
    <%
      // If the short factsheet of habitat is not open
      if (habID == null) {
    %>
    <tr>
      <td>
        <%
          // List annex1 habitats from first level
          Iterator it = tree1.getIterator();
          if (it.hasNext()) {
          %>
            <ul>
          <%
            while (it.hasNext()) {
              Chm62edtHabitatPersist h = (Chm62edtHabitatPersist) it.next();
        %>
             <li>
               <a title="Expand data for the habitat type" href="habitats-annex1-browser.jsp?habCode2000=<%=h.getCode2000()%>">
               <%=h.getCode2000()%> : <%=h.getScientificName()%>
               </a>
             </li>
        <%
          }
          %>
            </ul>
          <%

        } else {
        %>
        <!--
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=1000">1. Opean sea and tidal areas</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=1000">1. Opean sea and tidal areas</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=2000">2. Coastal sand dunes and inland dunes</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=3000">3. Freshwater habitat type</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=4000">4. Temperate heath and scrub</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=5000">5. Sclerophyllous scrub (Matoral)</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=6000">6. natural and semi-natural grassland formations</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=7000">7. Raised bogs and mires and fens</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=8000">8. Rocky habitat type and caves</a>
        <LI><a href="habitats-annex1-browser.jsp?habCode2000=9000">9. Forests</a>
        -->
        <%
          }
        %>
      </td>
    </tr>
    <%
      }
      // If tree string was displayed, it must be displayed nice
      if (habCode2000 != null || habID != null) {
    %>
    <tr>
      <td>
        <div id="tree">
          <script type="text/javascript" language="javascript">
          <!--
          createTree(<%=level%>, level1, Tree2, 0<%=(habID==null)?",0":","+treeBean.getOpenNode()%>, 'habitats-annex1-browser.jsp');
                    //-->
          </script>
          <noscript>Your browser does not support JavaScript!</noscript>
        </div>
      </td>
    </tr>
    <%
      }
      // If habID != null, the short factsheet of the habitat with ID_HABITAT = habID is displyed
      if (habID != null) {
    %>
    <tr>
      <td>
        <br />
        <br />
        <a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habID%>">Open full factsheet</a>
        <br />
        <script language="JavaScript" type="text/javascript" src="script/sort-table.js"></script>
        <jsp:include page="habitats-factsheet-general.jsp">
          <jsp:param name="idHabitat" value="<%=habID%>" />
        </jsp:include>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</td>
</tr>
</table>
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="habitats-annex1-browser.jsp" />
  </jsp:include>
  </div>
</body>
</html>