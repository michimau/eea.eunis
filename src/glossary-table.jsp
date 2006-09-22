<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        : 23.10
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Editor for glossary' function - table page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryDomain,
                 ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryPersist,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguageDomain,
                 java.util.HashMap,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
// REQUEST PARAMETERS
// - action - specifies something to be done when entering page, for example: delete.
// - filter - Filter values from table
// - sort - Used to sort and specifies the name of the column to be sorted by.
//
// - term - Used when action is 'delete', specifies TERM column from table
// - idLanguage - Used when action is 'delete', specifies ID_LANGUAGE column from table.
// - source - Used when action is 'delete', specifies SOURCE column from table

  // action specifies an operation to do. If null, no action was specified.
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String action = Utilities.formatString(request.getParameter("action"), "");
  String filter = Utilities.formatString(request.getParameter("filter"), "");
  String sort =  Utilities.formatString(request.getParameter("sort"), "");
  // These three form the PK of the table.
  String term = Utilities.formatString(request.getParameter("term"), "");
  String idLanguage = Utilities.formatString(request.getParameter("idLanguage"), "");
  String source = Utilities.formatString(request.getParameter("source"), "");

  // Process the 'delete' action.
  if (null != action && action.equalsIgnoreCase("delete")) // If action is delete, delete the given row.
  {
    // Now delete the row.
    String sql = "";
    sql += " TERM='" + term + "'";
    sql += " AND ID_LANGUAGE='" + idLanguage + "'";
    sql += " AND SOURCE='" + source + "'";
    try
    {
      List rows = new Chm62edtGlossaryDomain().findWhere(sql);
      // This list should return *exactly* one row.
      if (rows.size() > 0)
      {
        Chm62edtGlossaryPersist row = (Chm62edtGlossaryPersist)rows.get(0);
        new Chm62edtGlossaryDomain().delete(row);
      } else {
        System.out.println("glossary-table.jsp :: Warning: term=" + term + " not found in database. Row not deleted.");
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  // Process the 'filter' action
  List rows = new Vector();
  if (null != filter && !filter.equalsIgnoreCase(""))
  {
    // Compute table's rows
    String sql = "";
    sql = " SELECT " +
          " TERM, ID_LANGUAGE, SOURCE, DEFINITION, LINK_DESCRIPTION, LINK_URL, REFERENCE, " +
          " TERM_DOMAIN, SEARCH_DOMAIN, DATE_CHANGED, CURRENT,ID_DC " +
          " FROM CHM62EDT_GLOSSARY " +
          " WHERE (1 = 1) ";
    // Add the filter clause (must be always specified, or table will be empty
    sql += " AND TERM LIKE '%" + filter + "%'";
    // Add the sort clause if specified
    if (null != sort && !sort.equalsIgnoreCase(""))
    {
      sql += " ORDER BY " + sort;
    }
    try
    {
      rows = new Chm62edtGlossaryDomain().findCustom(sql);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  // Find the languages from CHM62EDT_LANGUAGE and put them into a hashmap with
  // Key(ID_LANGUAGE) mapped to Value(NAME_EN) name.
  // They are used later to put retrieve the Language for an ID_LANGUAGE
  List languages = new Vector();
  HashMap languageMap = new HashMap();
  try
  {
    languages = new Chm62edtLanguageDomain().findAll();
  } catch (Exception ex) {
    ex.printStackTrace();
  }
  for (int i = 0; i < languages.size(); i++)
  {
    Chm62edtLanguagePersist language = (Chm62edtLanguagePersist)languages.get(i);
    languageMap.put(language.getIdLanguage(), language.getNameEn());
  }

  String filterURLParam = "";
  if (null != filter && !filter.equalsIgnoreCase(""))
  {
    filterURLParam = Utilities.writeURLParameter("filter", filter).toString();
  }
  String sortURLParam = "";
  if (null != sort && !sort.equalsIgnoreCase(""))
  {
    sortURLParam = Utilities.writeURLParameter("sort", sort).toString();
  }
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("glossary_editor")%>
    </title>
    <script language="JavaScript" type="text/javascript">
    <!--
      function deleteEntry(index)
      {
        if ( confirm( "<%=cm.cms( "generic_glossary-table_01")%>" ) )
        {
          var formObject = eval("document.glossary" + index);
          formObject.submit();
          return true;
        }
      }
    //-->
    </script>
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
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="eea#<%=eeaHome%>,home#index.jsp,services#services.jsp,glossary_editor"/>
                </jsp:include>
                <h1>
                  <%=cm.cmsText( "generic_glossary-table_02" )%>
                </h1>
<%
  if( SessionManager.isAuthenticated() && SessionManager.isEdit_glossary() )
  {
%>
                <br />
                <form action="" name="filter" method="post">
                  <%=cm.cmsText( "generic_glossary-table_04" )%>
                  <label for="filter" class="noshow"><%=cm.cms("glossary_search_value")%></label>
                  <input title="<%=cm.cms("glossary_search_value")%>" type="text" name="filter" id="filter" value="<%=filter%>" size="30" />
                  <%=cm.cmsLabel("glossary_search_value")%>
                  <input title="<%=cm.cms("search")%>" type="submit" name="search" id="search" value="<%=cm.cms( "generic_glossary-table_05")%>" class="searchButton" />
                  <%=cm.cmsInput( "generic_glossary-table_05")%>
<%
                  if (null != sort && !sort.equalsIgnoreCase(""))
                  {
%>
                  <input type="hidden" name="sort" value="<%=sort%>" />
<%
                  }
%>
                </form>
                <br />
                <a title="<%=cm.cms("open_glossary_editor")%>" href="glossary-editor.jsp"><%=cm.cmsText( "generic_glossary-table_06" )%></a><%=cm.cmsTitle("open_glossary_editor")%>
<%
                if (rows.size() > 0)
                {
%>
                <table class="sortable" width="90%">
                  <thead>
                    <tr>
                      <th scope="col">
                        &nbsp;
                      </th>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=TERM<%=filterURLParam%>"><%=sort.equalsIgnoreCase("TERM") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "term" )%></a>
                      </th>
                      <th scope="col">
                          <%=cm.cmsText( "language" )%>
                      </th>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=SOURCE<%=filterURLParam%>"><%=sort.equalsIgnoreCase("SOURCE") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "source" )%></a>
                      </th>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=DEFINITION<%=filterURLParam%>"><%=sort.equalsIgnoreCase("DEFINITION") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "definition" )%></a>
                      </th>
<%--
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=LINK_DESCRIPTION<%=filterURLParam%>"><%=sort.equalsIgnoreCase("LINK_DESCRIPTION") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "link_description" )%></a>
                      </th>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=LINK_URL<%=filterURLParam%>"><%=sort.equalsIgnoreCase("LINK_URL") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "link" )%></a>
                      </th>
--%>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=REFERENCE<%=filterURLParam%>"><%=sort.equalsIgnoreCase("REFERENCE") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "reference" )%></a>
                      </th>
                      <th scope="col">
                        <a href="glossary-table.jsp?sort=DATE_CHANGED<%=filterURLParam%>"><%=sort.equalsIgnoreCase("DATE_CHANGED") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "date_changed" )%></a>
                      </th>
                      <th scope="col" style="text-align : center; white-space : nowrap;">
                        <a href="glossary-table.jsp?sort=CURRENT<%=filterURLParam%>"><%=sort.equalsIgnoreCase("CURRENT") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "current" )%></a>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="glossary-table.jsp?sort=TERM_DOMAIN<%=filterURLParam%>"><%=sort.equalsIgnoreCase("TERM_DOMAIN") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "domain" )%></a>
                      </th>
                      <th scope="col">
                        <a title="<%=cm.cms("sort_results_on_this_column")%>" href="glossary-table.jsp?sort=SEARCH_DOMAIN<%=filterURLParam%>"><%=sort.equalsIgnoreCase("SEARCH_DOMAIN") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=cm.cmsText( "search_domain" )%></a>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
<%
                String DEFAULT_CELL_VALUE = "n/a"; // Default string if value is not available (displayed in cell)
                String language = "";
                String definition = "";
                String linkDescription = "";
                String linkUrl = "";
                String reference = "";
                String dateChanged = "";
                String termDomain = "";
                String searchDomain = "";
                boolean current = false;
                for (int i = 0; i < rows.size(); i++)
                {
                  Chm62edtGlossaryPersist row = (Chm62edtGlossaryPersist)rows.get(i);
                  // ID_LANGUAGE - Language
                  language = Utilities.formatString(languageMap.get(row.getIdLanguage()), DEFAULT_CELL_VALUE);
                  // SOURCE - Source - not formatted because it is a PK and cannot be null.
                  source = row.getSource();
                  // DEFINITION - Definition
                  definition = Utilities.formatString(row.getDefinition(), DEFAULT_CELL_VALUE);
                  // LINK_DESCRIPTION - Link description
                  linkDescription = Utilities.formatString(row.getLinkDescription(), DEFAULT_CELL_VALUE);
                  // LINK_URL - Link URL - default to null because if it's null we don't display the anchor tag.
                  linkUrl = Utilities.formatString(row.getLinkUrl(), null);
                  // REFERENCE - Reference from table
                  reference = Utilities.formatString(row.getReference(), DEFAULT_CELL_VALUE);
                  // DATE_CHANGED - Date changed
                  dateChanged = Utilities.formatString(row.getDateChanged(), DEFAULT_CELL_VALUE);
                  // CURRENT - boolean value with 0 or 1 possible values.
                  if (null != row.getCurrent())
                  {
                    current = Utilities.checkedStringToBoolean(row.getCurrent().toString(), false);
                  } else {
                    current = false;
                  }
                  // TERM_DOMAIN - Term domain where term is considered - One of the three modules - Species, Habitats or Sites)
                  termDomain = Utilities.formatString(row.getTermDomain(), DEFAULT_CELL_VALUE);
                  // SEARCH DOMAIN  - Search domain where term is considered - Either Easy or Advanced.
                  searchDomain = Utilities.formatString(row.getSearchDomain(), DEFAULT_CELL_VALUE);
                  String cssClass = i % 2 == 0 ? " class=\"zebraeven\"" : "";
%>
                    <tr<%=cssClass%>>
                      <td>
                        <form name="glossary<%=i%>" method="post" action="glossary-table.jsp" style="padding: 0px; margin: 0px;">
                          <input type="hidden" name="action" value="delete" />
                          <input type="hidden" name="term" value="<%=row.getTerm()%>" />
                          <input type="hidden" name="idLanguage" value="<%=row.getIdLanguage()%>" />
                          <input type="hidden" name="source" value="<%=row.getSource()%>" />
<%
                          if ( null != sort && !sort.equalsIgnoreCase("") )
                          {
%>
                          <input type="hidden" name="sort" value="<%=sort%>" />
<%
                          }
                          if (null != filter && !filter.equalsIgnoreCase(""))
                          {
%>
                          <input type="hidden" name="filter" value="<%=filter%>" />
<%
                          }
%>
                          <a title="<%=cm.cms("glossary_delete_term")%>" href="javascript: deleteEntry(<%=i%>);"><img alt="<%=cm.cms("glossary_delete_term")%>" src="images/mini/delete.jpg" border="0" /></a>
                          <%=cm.cmsTitle("glossary_delete_term")%>
                        </form>
                      </td>
                      <td>
                        <a title="<%=cm.cms("open_glossary_editor")%>" href="glossary-editor.jsp?term=<%=row.getTerm()%>&amp;idLanguage=<%=row.getIdLanguage()%>&amp;source=<%=row.getSource()%><%=sortURLParam%><%=filterURLParam%>">
                          <%=cm.cmsTitle("open_glossary_editor")%>
                          <%=row.getTerm()%>
                        </a>
                      </td>
                      <td>
                        <%=language%>
                      </td>
                      <td>
                        <%=source%>
                      </td>
                      <td>
                        <%=definition%>
                      </td>
<%--
                      <td>
                        <%=linkDescription%>
                      </td>
                      <td>
                    <%
                      if (linkUrl != null)
                      {
                    %>
                        <a title="<%=cm.cms("open_url")%>" href="<%=linkUrl%>"><%=row.getLinkUrl()%></a><%=cm.cmsTitle("open_url")%>
                    <%
                      }
                      else
                      {
                    %>
                        <%=DEFAULT_CELL_VALUE%>
                    <%
                      }
                    %>
                      </td>
--%>
                      <td>
                        <%=reference%>
                      </td>
                      <td>
                        <%=dateChanged%>
                      </td>
                      <td>
                        <%=(current) ? "Yes" : "No"%>
                      </td>
                      <td>
                        <%=termDomain%>
                      </td>
                      <td>
                        <%=searchDomain%>
                      </td>
                    </tr>
<%
                }
%>
                  </tbody>
                </table>
<%
              }
%>
                <%=cm.cmsMsg("glossary_editor")%>
                <%=cm.br()%>
                <%=cm.cmsMsg( "generic_glossary-table_01")%>
<%
  }
  else
  {

%>
                <br />
                <br />
                <span style="color : red"><%=cm.cmsText("users_bookmarks_20")%></span>
                <br />
                <br />
<%
  }
%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="glossary-table.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
