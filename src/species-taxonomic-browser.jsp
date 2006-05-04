<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display tree of the species taxonomy.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.species.taxcode.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.SpeciesGroupSpeciesPersist,
                 ro.finsiel.eunis.utilities.SQLUtilities" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="treeBeantax" class="ro.finsiel.eunis.search.species.taxcode.TaxcodeTreeBean" scope="request">
  <jsp:setProperty name="treeBeantax" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
    <link rel="StyleSheet" href="css/tree.css" type="text/css" />
    <script language="JavaScript" type="text/javascript" src="script/tree.js"></script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("taxonomic_classification")%>
    </title>
    <%
      TaxonomicBrowser tree = new TaxonomicBrowser();
      int level = Utilities.checkedStringToInt(request.getParameter("generic_index_07"), 2);
      // Request parameters
      String idTaxonomy, idTaxExpanded;
      idTaxonomy=treeBeantax.getIdTaxonomy();
      idTaxExpanded=treeBeantax.getIdTaxExpanded();

      //get maxLevel
      String SQL_DRV="";
      String SQL_URL="";
      String SQL_USR="";
      String SQL_PWD="";

      SQL_DRV = application.getInitParameter("JDBC_DRV");
      SQL_URL = application.getInitParameter("JDBC_URL");
      SQL_USR = application.getInitParameter("JDBC_USR");
      SQL_PWD = application.getInitParameter("JDBC_PWD");

      SQLUtilities sqlc = new SQLUtilities();
      sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

      int noLevels = Utilities.checkedStringToInt(sqlc.ExecuteSQL("SELECT count(DISTINCT LEVEL) FROM CHM62EDT_TAXONOMY"),0);
      noLevels--;
      if(noLevels<0) noLevels = 0;

      String forIt = "";

      if(null == idTaxonomy && idTaxExpanded != null)
      {
        forIt = sqlc.ExecuteSQL(" SELECT TAXONOMY_TREE FROM CHM62EDT_TAXONOMY WHERE ID_TAXONOMY = '"+ idTaxExpanded +"'");
        if(forIt.indexOf("*") >= 0) forIt = forIt.substring(0,forIt.indexOf("*"));
      }

    %>
    <script language="JavaScript" type="text/JavaScript">
      <!--
        function MM_goToURL() { //v3.0
          var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
          for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
        }
        function MM_jumpMenu(targ,selObj,restore){ //v3.0
          eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
          if (restore) selObj.selectedIndex=0;
        }

        // Create here the array with the tree nodes and tree structure
        // Each element of the array contains an string with the following structure:
        // nodeId | parentNodeId | nodeName | nodeUrl | hasChild | isLastSibling | childId,childiD ...
        var Tree1 = new Array;
        <%
          String startlevel = null != treeBeantax.getStartlevel() ? treeBeantax.getStartlevel() : "2";
          // Set the tree string for taxonomy with ID_TAXONOMY = idTaxonomy, and display it
          if (idTaxonomy != null && idTaxExpanded == null)
          {
            tree.maxlevel = noLevels;
            tree.getTree("Tree1",new Integer(startlevel).intValue(),idTaxonomy);
        %>
            <%=tree.tree.toString()%>
            var level1 = "<%=tree.level1%>";
        <%
          }
          // Tree string is already set, so it is displayed;
          // for idTaxExpanded != null is dispayed species list related to this taxonomy((only for finals taxonomies))
          if (idTaxonomy==null && idTaxExpanded != null )
          {
            if (tree.tree != null)
            {
        %>
              <%=tree.tree.toString()%>
              var level1 = "<%=tree.level1%>";
        <%
            }
            else
            {
              tree.maxlevel=noLevels;
              // forIt - kindom ID_TAXONOMY of this idTaxExpanded
              //String forIt = idTaxExpanded.substring(0,1)+"0000000000";
              tree.getTree("Tree1",new Integer(startlevel).intValue(),forIt);

        %>
              <%=tree.tree.toString()%>
              var level1 = "<%=tree.level1%>";
        <%
            }
          }
        %>
 <%
   //System.out.println("tree="+(tree.tree == null ? "" : tree.tree.toString())+"+++++++++++++=");
        %>
    //-->
    </script>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
  <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,species#species.jsp,taxonomic_classification#species-taxonomic-browser.jsp" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h1>
      <%=cm.cmsText("habitats_taxonomic-browser_01")%>
    </h1>
    <noscript>
      <br />
      <br />
      <span style="color: red;">
        You do not have JavaScript enabled in your browser.
        Please visit the alternative page: <a href="species-taxonomy.jsp"><%=cm.cmsText("habitats_taxonomic-browser_01")%></a>.
      </span>
    </noscript>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=cm.cmsText("habitats_taxonomic-browser_02")%>
          <br />
          <br />
          <%
            int mx=noLevels;
            if (request.getParameter("openNode") == null)
            {
              // The level list is displayed only when idTaxonomy != null
              if (request.getParameter("idTaxonomy") != null)
              {
          %>
                <form name="setings" action="species-taxonomic-browser.jsp" method="post">
                  <%=cm.cmsText("expand_up_to")%>:
                 <label for="select1" class="noshow"><%=cm.cms("depth")%></label>
                 <select id="select1" title="<%=cm.cms("depth")%>" name="depth" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
                    <option value="species-taxonomic-browser.jsp" <%=(request.getParameter("generic_index_07")==null)?"selected=\"selected\"":""%> >
                      <%=cm.cms("please_select_a_level")%>
                    </option>
                    <%
                      // Display the levels
                      for (int ii=2;ii<=mx;ii++)
                      {
                    %>
                      <option value="species-taxonomic-browser.jsp?level=<%=ii%>&amp;idTaxonomy=<%=idTaxonomy%>" <%=(request.getParameter("generic_index_07")!=null&&request.getParameter("generic_index_07").equals((new Integer(ii)).toString())) ? "selected=\"selected\"" : ""%>>
                        <%=cm.cms("generic_index_07")%> <%=ii%>
                      </option>
                    <%
                      }
                    %>
                  </select>
                  <%=cm.cmsLabel("depth")%>
                  <%=cm.cmsTitle("depth")%>
                </form>
          <%
              }
            }
          %>
          <table summary="layout" border="0" width="100%">
          <%
            // If wasn't selected any taxonomy, will display first level taxonomies list
            if (idTaxExpanded == null && idTaxonomy == null)
            {
          %>
              <tr>
                <td>
                  <%
                  // Taxonomies list from first level
                  Iterator it=tree.getIterator();
                  while (it.hasNext())
                  {
                    Chm62edtTaxcodePersist h= (Chm62edtTaxcodePersist) it.next();%>
                        <a title="<%=cm.cms("taxonomic_browser")%>" href="species-taxonomic-browser.jsp?idTaxonomy=<%=h.getIdTaxcode()%>"><%=h.getTaxonomicLevel()%>&nbsp;<%=h.getTaxonomicName()%>
                      </a><%=cm.cmsTitle("taxonomic_browser")%> <br />
                <%
                  }
                %>
                </td>
              </tr>
          <%
            }
            // If tree string was displayed, it must be displayed nice
            if (idTaxonomy!=null || idTaxExpanded !=null)
            {
              String taxLevel = "";
              String taxName = "";
              //String cod = (null == idTaxonomy) ? idTaxExpanded.substring(0,1)+"0000000000" : idTaxonomy;
              String cod = (null == idTaxonomy) ? forIt : idTaxonomy;
              List ll1 = new Chm62edtTaxcodeDomain().findWhere("id_taxonomy = '"+cod+"'");
              if (ll1 != null && !ll1.isEmpty())
              {
                Chm62edtTaxcodePersist t = (Chm62edtTaxcodePersist) ll1.get(0);
                taxLevel = t.getTaxonomicLevel();
                taxName = t.getTaxonomicName();
              }
          %>
              <tr>
                <td>
                  <div id="tree">
                    <script language="JavaScript" type="text/javascript">
                    <!--
                      createTreeSpeciesTaxonomy('<%=taxLevel%>','<%=taxName%>',<%=level%>,level1,Tree1,0,<%=(idTaxExpanded==null)?"0":treeBeantax.getOpenNode()%>, "species-taxonomic-browser.jsp");
                    //-->
                    </script>
                  </div>
                </td>
              </tr>
          <%
            }
          %>
        </table>
        </td>
        </tr>
           <% // If was selected a nod from tree
             if (request.getParameter("openNode") != null && request.getParameter("idTaxExpanded") != null)
           {
             // Nod is a final taxonomy
             if (!SpeciesSearchUtility.IdTaxonomyHasChildren(request.getParameter("idTaxExpanded")))
             {
               // Species related to this taxonomy
               List species = SpeciesSearchUtility.FindSpeciesforIdTaxonomy(request.getParameter("idTaxExpanded"),SessionManager.getShowEUNISInvalidatedSpecies());
               if (species != null && species.size() > 0)
               {
           %>
             <tr style="background-color:#CCCCCC">
              <td>
                <strong>
                  <%=cm.cmsText("habitats_taxonomic-browser_06")%>
                </strong>
              </td>
            </tr>
             <tr>
               <td>
                  <table summary="<%=cm.cms("list_species")%>" border="1" style="border-collapse:collapse" cellpadding="1" cellspacing="1" width="100%" id="species">
                  <tr>
                    <th title="<%=cm.cms("sort_results_on_this_column")%>">
                      <strong>
                        <%=cm.cmsText("group_name")%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                    <th title="<%=cm.cms("sort_results_on_this_column")%>">
                      <strong>
                        <%=cm.cmsText("scientific_name")%>
                        <%=cm.cmsTitle("sort_results_on_this_column")%>
                      </strong>
                    </th>
                  </tr>
                  <%
                     for (int i=0;i<species.size();i++)
                     {
                       SpeciesGroupSpeciesPersist specie = (SpeciesGroupSpeciesPersist) species.get(i);
                  %>
                  <tr style="background-color:<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>">
                    <td>
                      <%=Utilities.formatString((specie.getCommonName() != null ? specie.getCommonName().replaceAll("&","&amp;") : ""),"&nbsp;")%>
                    </td>
                    <td>
                      <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.formatString(specie.getScientificName(),"&nbsp;")%></a>
                      <%=cm.cmsTitle("open_species_factsheet")%>
                    </td>
                  </tr>
                  <%
                     }
                  %>
                  </table>
               </td>
             </tr>
            <%
               }
               else
               {
%>
                  <tr>
                  <td>
                  <span style="color : red;"><%=cm.cmsText("habitats_taxonomic-browser_09")%>.</span>
                  </td>
                  </tr>
<%
               }
             }
           }
           %>
    </table>

<%=cm.br()%>  
<%=cm.cmsMsg("taxonomic_classification")%>
<%=cm.br()%>
<%=cm.cmsMsg("please_select_a_level")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_index_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_species")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-taxonomic-browser.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>