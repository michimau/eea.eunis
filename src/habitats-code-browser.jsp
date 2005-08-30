<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display tree of the EUNIS habitats.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.jrfTables.*, ro.finsiel.eunis.WebContentManagement" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <jsp:useBean id="treeeunis" scope="session" class="ro.finsiel.eunis.search.habitats.HabitatEUNISTree" />
  <jsp:useBean id="treeBean1" class="ro.finsiel.eunis.formBeans.HabitatTreeBean" scope="request">
    <jsp:setProperty name="treeBean1" property="*" />
  </jsp:useBean>
  <link rel="StyleSheet" href="css/tree.css" type="text/css" />
  <script language="JavaScript" type="text/javascript" src="script/tree.js"></script>
  <%
    // Request parameters
    String habCode, habID, openNode;
    habCode=treeBean1.getHabCode();
    habID=treeBean1.getHabID();
    openNode = treeBean1.getOpenNode();
    int level = (null == request.getParameter("level")) ? 2 : Integer.parseInt(request.getParameter("level"));
  %>
  <script language="JavaScript" type="text/javascript">
  <!--
        function MM_jumpMenu(targ,selObj,restore)
        {
          eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
          if (restore) selObj.selectedIndex=0;
        }
        var Tree2 = new Array;
        // nodeId | parentNodeId | nodeName | nodeUrl | hasChild | isLastSibling | childId,childiD ...
<%
        // If this jsp was used by habitat factsheet
        if(request.getParameter("fromFactsheet") != null && request.getParameter("fromFactsheet").equalsIgnoreCase("yes"))
        {
          treeeunis.maxlevel=7;
          // EUNIS_HABITAT_CODE of first parent habitat( in tree hierarchy) of habitat with EUNIS_HABITAT_CODE = Code
          String forIt = (request.getParameter("Code") == null ? "0" : request.getParameter("Code").substring(0,1));
          treeeunis.setFactsheetIdHabitat(habID);
          treeeunis.getTree("Tree2",2,forIt);
%>
          <%=treeeunis.tree.toString()%>
          var level1 = "<%=treeeunis.level1%>";
<%
          openNode = treeeunis.getFactsheetOpenNode();
        }
        // Set the tree string for habitat with EUNIS_HABITAT_CODE = habCode, and display it
        if (habCode != null && habID == null)
        {
          treeeunis.maxlevel=7;
          treeeunis.getTree("Tree2",2,habCode);
%>
          <%=treeeunis.tree.toString()%>
          var level1 = "<%=treeeunis.level1%>";
<%
        }
        // Tree string is already set, so it is displayed; for habID != null is dispayed the short factshhet for the habitat
        if (habCode == null && habID != null )
        {
%>
          <%=treeeunis.tree.toString()%>
          var level1 = "<%=treeeunis.level1%>";
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
    <%=contentManagement.getContent("habitats_code-browser_title", false )%>
  </title>
</head>
<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,EUNIS habitat type hierarchical view" />
</jsp:include>
<h5>
  <%=contentManagement.getContent("habitats_code-browser_01")%>
</h5>
<%
  // Get max level
  int mx=0;
  if (habCode!=null)
  {
    mx = new Chm62edtHabitatDomain().maxlevel("ID_HABITAT>=1 and ID_HABITAT<10000 AND EUNIS_HABITAT_CODE LIKE '"+habCode+"%'").intValue();
  }
  // The level list is displayed only when habCode != null
  if (request.getParameter("habCode") != null)
  {
%>
<form name="setings" action="habitats-code-browser.jsp" method="post">
  <label for="depth" class="noshow"><%=contentManagement.getContent("habitats_code-browser_05")%>:</label>
  <select title="Level depth" name="depth" id="depth" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
    <option value="habitats-code-browser.jsp" <%=(request.getParameter("level")==null ? "selected=\"selected\"" : "")%> ><%=contentManagement.getContent("habitats_code-browser_03", false)%></option>
    <%
      for (int ii=2;ii<=mx;ii++)
      {
    %>
        <option value="habitats-code-browser.jsp?level=<%=ii%>&amp;habCode=<%=habCode%>" <%=(request.getParameter("level")!=null&&request.getParameter("level").equals((new Integer(ii)).toString())) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("habitats_code-browser_04", false)%>&nbsp;<%=ii%></option>
    <%
      }
    %>
  </select>
</form>
<%
  }
%>
<table summary="Habitat types" width="100%" border="0">
  <%
    // If the short factsheet of habitat is not open
    if (habID == null)
    {
  %>
  <tr>
    <td>
      <%
        // List eunis habitats from first level
        Iterator it=treeeunis.getIterator();
        if (it.hasNext())
        {
      %>
          <ul>
      <%
          while (it.hasNext())
          {
            Chm62edtHabitatPersist h= (Chm62edtHabitatPersist) it.next();%>
            <li>
              <a title="Expand data for the habitat type" href="habitats-code-browser.jsp?habCode=<%=h.getEunisHabitatCode()%>#factsheet"><%=h.getEunisHabitatCode()%> : <%=h.getScientificName()%></a>
            </li>
      <%
          }
      %>
          </ul>
      <%
        }
      %>
    </td>
  </tr>
  <%
    }
    // If tree string was displayed, it must be displayed nice
    if (habCode!=null || habID !=null)
    {
  %>
  <tr>
    <td>
      <div id="tree">
        <script type="text/javascript" language="javascript">
        <!--
        createTree(<%=level%>, level1, Tree2, 0<%=(habID==null)?",0":","+openNode%>, "habitats-code-browser.jsp");
              //-->
        </script>
        <noscript>Your browser does not support JavaScript!</noscript>
      </div>
    </td>
  </tr>
  <%
    }
  %>
  <tr>
    <td>
      <%
        String paragraph02 = contentManagement.getContent("habitats_code-browser_02");
        if (null != paragraph02) out.print(paragraph02);
      %>
    </td>
  </tr>
  <%
    // If habID != null, the short factsheet of the habitat with ID_HABITAT = habID is displyed
    if (habID !=null)
    {
  %>
  <tr>
    <td>
      <br />
      <br />
      <a href="habitats-factsheet.jsp?idHabitat=<%=habID%>">Open full factsheet</a>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-code-browser.jsp" />
</jsp:include>
  </div>
</body>
</html>
