<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2006 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="ro.finsiel.eunis.search.species.taxcode.TaxonomyTree"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,taxonomic_classification#species-taxonomy.jsp";
  String idTaxonomy = Utilities.formatString( request.getParameter( "idTaxonomy" ), "" ).trim();

  //get maxLevel
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  ArrayList IdTax;
  ArrayList IdTaxParent;
  ArrayList TaxTree;
  ArrayList o;

  IdTax = sqlc.SQL2Array("SELECT ID_TAXONOMY FROM CHM62EDT_TAXONOMY ORDER BY ID_TAXONOMY");
  IdTaxParent = sqlc.SQL2Array("SELECT ID_TAXONOMY_PARENT FROM CHM62EDT_TAXONOMY ORDER BY ID_TAXONOMY");
  TaxTree = sqlc.SQL2Array("SELECT TAXONOMY_TREE FROM CHM62EDT_TAXONOMY ORDER BY ID_TAXONOMY");

  String TaxName46 = sqlc.ExecuteSQL(TaxonomyTree.TaxName("46"));
  String TaxName47 = sqlc.ExecuteSQL(TaxonomyTree.TaxName("47"));
  String TaxName48 = sqlc.ExecuteSQL(TaxonomyTree.TaxName("48"));
  String TaxName3001 = sqlc.ExecuteSQL(TaxonomyTree.TaxName("3001"));

  o = new ArrayList(IdTax.size());
  ArrayList SpeciesList;
  for(int i = 0; i<IdTax.size();i++) {
    if(!IdTax.get(i).toString().equalsIgnoreCase("46") &&
      !IdTax.get(i).toString().equalsIgnoreCase("47") &&
        !IdTax.get(i).toString().equalsIgnoreCase("48") &&
          !IdTax.get(i).toString().equalsIgnoreCase("3001")) {
      o.add(TaxonomyTree.nbsp(TaxonomyTree.tokensCount(TaxTree.get(i).toString()))+IdTax.get(i));
    } else {
      o.add(IdTax.get(i));
    }
  }
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("taxonomic_classification")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("Species taxonomic classification")%>
                </h1>
                <br />
                <%=cm.cmsPhrase("Taxonomic tree view of species<br /><br /><strong>Warning: Expanding a branch with many species (Animalia) will take a longer time</strong>")%>
                <ul>
          <%
                  if( !idTaxonomy.equalsIgnoreCase( "" ) )
                  {
                    //get all myTree link
                    ArrayList myTree = new ArrayList();
                    boolean treeDone = false;
                    int i, j;
                    String currentIdTaxonomy = idTaxonomy;
                    myTree.add(0, currentIdTaxonomy);

                    while(!treeDone) {
                      for(i = 0; i<IdTax.size();i++) {
                        treeDone = true;
                        if(IdTax.get(i).toString().equalsIgnoreCase(currentIdTaxonomy)) {
                          if(!IdTaxParent.get(i).toString().equalsIgnoreCase(currentIdTaxonomy)) {
                            currentIdTaxonomy = IdTaxParent.get(i).toString();
                            myTree.add(0, currentIdTaxonomy);
                            treeDone = false;
                            break;
                          } else {
                            treeDone = true;
                            break;
                          }
                        }
                      }
                      if(i == IdTax.size()-1 && !treeDone) treeDone = true;
                    }

                    int selectedTaxRoot = new Integer(myTree.get(0).toString()).intValue();

                    for(i=0;i<IdTaxParent.size();i++) {
                      String idParent = IdTaxParent.get(i).toString();
                      if(idParent.equalsIgnoreCase(idTaxonomy)) {
                        if(!IdTax.get(i).toString().equalsIgnoreCase(idTaxonomy)) {
                          myTree.add(IdTax.get(i).toString());
                        }
                      }
                    }
                    if(selectedTaxRoot == 47)
                    {
          %>
                      <a href="species-taxonomy.jsp?idTaxonomy=46"><%=TaxName46%></a>
                      <br />
          <%
                    }
                    if(selectedTaxRoot == 48)
                    {
                      %>
                      <a href="species-taxonomy.jsp?idTaxonomy=46"><%=TaxName46%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=47"><%=TaxName47%></a>
                      <br />
          <%
                    }
                    if(selectedTaxRoot == 3001)
                    {
          %>
                      <a href="species-taxonomy.jsp?idTaxonomy=46"><%=TaxName46%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=47"><%=TaxName47%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=3001"><%=TaxName48%></a>
                      <br />
          <%
                    }

                    for(j = 0; j< myTree.size(); j++)
                    {
                      for(i = 0; i<IdTax.size();i++)
                      {
                        if(IdTax.get(i).toString().equalsIgnoreCase(myTree.get(j).toString())) {
                          String trimLink = o.get(i).toString().replace("&nbsp;","");
                          int cnt = (o.get(i).toString().indexOf(trimLink)+1)/18;
                          String TaxName = sqlc.ExecuteSQL(TaxonomyTree.TaxName(trimLink));
                          boolean hasChilds = !sqlc.ExecuteSQL("SELECT COUNT(*) FROM CHM62EDT_TAXONOMY WHERE ID_TAXONOMY_PARENT="+trimLink).equalsIgnoreCase("0");
                          if(hasChilds)
                          {
          %>
                            <%=TaxonomyTree.nbsp(cnt)%><a href="species-taxonomy.jsp?idTaxonomy=<%=trimLink%>"><%=TaxName%></a>
          <%
                          }
                          else
                          {
                            SpeciesList=sqlc.SQL2Array("SELECT CONCAT('<a href=\"species-factsheet.jsp?idSpecies=',ID_SPECIES,'&idSpeciesLink=',ID_SPECIES_LINK,'\">',SCIENTIFIC_NAME,'</a>') FROM CHM62EDT_SPECIES WHERE ID_TAXONOMY="+idTaxonomy);
          %>
                            <%=TaxonomyTree.nbsp(cnt)%><%=TaxName%>
          <%
                            if(SpeciesList.size()>0) {
                              for(i=0;i<SpeciesList.size();i++)
                              {
          %>
                              <br />
                              <%=TaxonomyTree.nbsp(cnt+1)+SpeciesList.get(i)%>
          <%
                              }
                            }
                            else
                            {
                              SpeciesList=sqlc.SQL2Array("SELECT CONCAT('<a href=\"species-factsheet.jsp?idSpecies=',ID_SPECIES,'&idSpeciesLink=',ID_SPECIES_LINK,'\">',SCIENTIFIC_NAME,'</a>') FROM CHM62EDT_SPECIES WHERE ID_TAXONOMY="+trimLink);
                              if(SpeciesList.size()>0) {
                                for(i=0;i<SpeciesList.size();i++) {
          %>
                                <br />
                                <%=TaxonomyTree.nbsp(cnt+2)+SpeciesList.get(i)%>
          <%
                                }
                              }
                            }
                          }
          %>
                          <br />
          <%
                          break;
                        }
                      }
                    }
                    if(selectedTaxRoot == 46)
                    {
          %>
                      <a href="species-taxonomy.jsp?idTaxonomy=47"><%=TaxName47%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=48"><%=TaxName48%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=3001"><%=TaxName3001%></a>
                      <br />
          <%
                    }
                    if(selectedTaxRoot == 47)
                    {
          %>
                      <a href="species-taxonomy.jsp?idTaxonomy=48"><%=TaxName48%></a>
                      <br />
                      <a href="species-taxonomy.jsp?idTaxonomy=3001"><%=TaxName3001%></a>
                      <br />
          <%
                    }
                    if(selectedTaxRoot == 48)
                    {
          %>
                      <a href="species-taxonomy.jsp?idTaxonomy=3001"><%=TaxName3001%></a>
                      <br />
          <%
                    }
                  }
                  else
                  {
          %>
                    <a href="species-taxonomy.jsp?idTaxonomy=46"><%=TaxName46%></a>
                    <br />
                    <a href="species-taxonomy.jsp?idTaxonomy=47"><%=TaxName47%></a>
                    <br />
                    <a href="species-taxonomy.jsp?idTaxonomy=48"><%=TaxName48%></a>
                    <br />
                    <a href="species-taxonomy.jsp?idTaxonomy=3001"><%=TaxName3001%></a>
                    <br />
          <%
                  }
          %>
                </ul>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-taxonomy.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
