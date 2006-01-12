<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display tree of the EUNIS habitats.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.*, ro.finsiel.eunis.WebContentManagement" %>
<%@ page import="java.util.*"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.search.habitats.HabitatEUNISTree"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <jsp:useBean id="treeBean1" class="ro.finsiel.eunis.formBeans.HabitatTreeBean" scope="request">
    <jsp:setProperty name="treeBean1" property="*" />
  </jsp:useBean>
  <link rel="StyleSheet" href="css/tree.css" type="text/css" />
  <script language="JavaScript" type="text/javascript" src="script/tree.js"></script>
  <%
    int level = Utilities.checkedStringToInt ( request.getParameter("level"), 2 );
    String fromFactsheet = Utilities.formatString( request.getParameter("fromFactsheet"), "" );
    String habCode = treeBean1.getHabCode();
    String habID=treeBean1.getHabID();
    String openNode = treeBean1.getOpenNode();

    HabitatEUNISTree treeeunis = new HabitatEUNISTree();
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
        if( fromFactsheet.equalsIgnoreCase( "yes" ) )
        {
          treeeunis.maxlevel=7;
          // EUNIS_HABITAT_CODE of first parent habitat( in tree hierarchy) of habitat with EUNIS_HABITAT_CODE = Code
          String code = "0";
          if( request.getParameter("Code") != null )
          {
            code = request.getParameter("Code").substring( 0, 1 );
          }
          treeeunis.setFactsheetIdHabitat(habID);
          treeeunis.getTree("Tree2",2,code);
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
          treeeunis.getTree( "Tree2" );
%>
          <%=treeeunis.tree.toString()%>
          var level1 = "<%=treeeunis.level1%>";
<%
        }
%>
    //-->
  </script>
  <%

    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_code-browser_title")%>
  </title>
</head>
<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,eunis_habitats_tree_location" />
</jsp:include>
<h1>
  <%=cm.cmsText("habitats_code-browser_01")%>
</h1>
<%
  // Get max level
  int mx=0;
  if ( habCode != null )
  {
    mx = new Chm62edtHabitatDomain().maxlevel("ID_HABITAT>=1 and ID_HABITAT<10000 AND EUNIS_HABITAT_CODE LIKE '"+habCode+"%'").intValue();
  }
  // The level list is displayed only when habCode != null
  if ( habCode != null)
  {
%>
<form name="setings" action="habitats-code-browser.jsp" method="post">
  <label for="depth" class="noshow"><%=cm.cms("habitats_code-browser_05")%>:</label>
  <select title="<%=cm.cms("habitats_code-browser_05")%>" name="depth" id="depth" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
    <option value="habitats-code-browser.jsp" <%=(request.getParameter("level")==null ? "selected=\"selected\"" : "")%> ><%=cm.cms("habitats_code-browser_03")%></option>
    <%
      for (int ii=2;ii<=mx;ii++)
      {
    %>
        <option value="habitats-code-browser.jsp?level=<%=ii%>&amp;habCode=<%=habCode%>" <%=(request.getParameter("level")!=null&&request.getParameter("level").equals((new Integer(ii)).toString())) ? "selected=\"selected\"" : ""%>><%=cm.cms("habitats_code-browser_04")%>&nbsp;<%=ii%></option>
    <%
      }
    %>
  </select>
  <%=cm.cmsLabel("habitats_code-browser_05")%>
  <%=cm.cmsInput("habitats_code-browser_03")%>
  <%=cm.cmsInput("habitats_code-browser_04")%>
</form>
<%
  }
%>
<table summary="<%=cm.cms("habitat_types")%>" width="100%" border="0">
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
              <a title="<%=cm.cms("expand_data_for_habitat_type")%>" href="habitats-code-browser.jsp?habCode=<%=h.getEunisHabitatCode()%>#factsheet"><%=h.getEunisHabitatCode()%> : <%=h.getScientificName()%></a>
              <%=cm.cmsTitle("expand_data_for_habitat_type")%>
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
      </div>
    </td>
  </tr>
  <%
    }
  %>
  <tr>
    <td>
      <%
        cm.cmsText("habitats_code-browser_02");
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
      <a href="habitats-factsheet.jsp?idHabitat=<%=habID%>"><%=cm.cmsText("open_habitat_factsheet")%></a>
      <br />
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
  </div>
  </div>
  <%=cm.cmsMsg("habitats_code-browser_title")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_types")%>
  <%=cm.br()%>
</body>
</html>
