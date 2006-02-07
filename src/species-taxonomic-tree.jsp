<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");  
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.species.taxcode.TaxonomyTree"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
      TaxonomyTree tree = new TaxonomyTree();

      String idTaxExpanded = Utilities.formatString( request.getParameter( "idTaxExpanded" ), "" );
      String idTaxonomy = Utilities.formatString( request.getParameter( "idTaxonomy" ), "" );
      int startLevel = 2;
      int maxDepth;

      //get maxLevel
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");

      SQLUtilities sqlc = new SQLUtilities();
      sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

      maxDepth = Utilities.checkedStringToInt(sqlc.ExecuteSQL("SELECT count(DISTINCT LEVEL) FROM CHM62EDT_TAXONOMY"),0);
      maxDepth--;
      if( maxDepth < 0 ) maxDepth = 0;


    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,category_location#category.jsp"/>
        <jsp:param name="helpLink" value="help.jsp"/>
      </jsp:include>
      <h1><%=cm.cmsText("habitats_taxonomic-browser_01")%></h1>
      <ul>
      <%
        if( idTaxExpanded.equalsIgnoreCase( "" ) && idTaxonomy.equalsIgnoreCase( "" ) )
        {
          Iterator it = tree.getFirstLevelClassifications().iterator();
          while( it.hasNext() )
          {
            Chm62edtTaxcodePersist classification = (Chm62edtTaxcodePersist) it.next();
      %>
          <li>
            <a title="<%=cm.cms("taxonomic_browser")%>"
                 href="species-taxonomic-tree.jsp?idTaxonomy=<%=classification.getIdTaxcode()%>"><%=classification.getTaxonomicLevel()%><%=classification.getTaxonomicName()%></a><%=cm.cmsTitle("taxonomic_browser")%>
          </li>
      <%
          }
        }
        if( !idTaxonomy.equalsIgnoreCase( "" ) )
        {
          String taxLevel = "";
          String taxName = "";
          //String cod = (null == idTaxonomy) ? idTaxExpanded.substring(0,1)+"0000000000" : idTaxonomy;
          List ll1 = new Chm62edtTaxcodeDomain().findWhere("id_taxonomy = '"+idTaxonomy+"'");
          if (ll1 != null && !ll1.isEmpty())
          {
            Chm62edtTaxcodePersist t = (Chm62edtTaxcodePersist) ll1.get(0);
            taxLevel = t.getTaxonomicLevel();
            taxName = t.getTaxonomicName();
          }

          tree.maxlevel = maxDepth;
          try
          {
            tree.getTree( startLevel, idTaxonomy );
          }
          catch( Exception ex )
          {
            ex.printStackTrace();
          }
          System.out.println( "taxLevel=" + taxLevel );
          System.out.println( "taxName=" + taxName );
          System.out.println( "level=" + startLevel );
          System.out.println( "idTaxExpanded=" + idTaxExpanded );

          try
          {
            tree.createTreeSpeciesTaxonomy(
                taxLevel,
                taxName,
                startLevel,
                "1",
                "2",
                "0",
                "species-taxonomic-tree.jsp"
            );
            //out.print( tree.generateTree( 4 ) );
            out.print( tree.document );
          }
          catch( Exception ex )
          {
            ex.printStackTrace();
          }
      %>

          <%--<%=tree.document%>--%>
      <%
        }
      %>
      </ul>

      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="template.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
<%
  out.flush();
%>
