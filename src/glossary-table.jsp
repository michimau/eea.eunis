<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        : 23.10
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Editor for glossary' function - table page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();

  // action specifies an operation to do. If null, no action was specified.
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
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent( "generic_glossary-table_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
    <!--
      function deleteEntry(index)
      {
        if ( confirm( "<%=contentManagement.getContent( "generic_glossary-table_01" , false )%>" ) )
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
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,Glossary editor"/>
    </jsp:include>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=contentManagement.getContent( "generic_glossary-table_02" )%>
        </td>
      </tr>
    </table>
    <br />
    <%-- SEARCH TABLE --%>
    <form action="" name="filter" method="post">
      <table summary="layout" border="1" cellpadding="2" cellspacing="0" style="border-collapse:collapse" bgcolor="#EEEEEE">
        <tr>
          <td>
            <strong>
              <%=contentManagement.getContent( "generic_glossary-table_03" )%>
            </strong>
          </td>
        </tr>
        <tr>
          <td valign="middle">
            <%=contentManagement.getContent( "generic_glossary-table_04" )%>
            <label for="filter" class="noshow">Search value</label>
            <input title="Searh value" type="text" name="filter" id="filter" value="<%=filter%>" size="30" class="inputTextField" />
            <label for="search" class="noshow">Search</label>
            <input title="Search" type="submit" name="search" id="search" value="<%=contentManagement.getContent( "generic_glossary-table_05",false )%>" class="inputTextField" />
            <%
              if (null != sort && !sort.equalsIgnoreCase(""))
              {
            %>
                <input type="hidden" name="sort" value="<%=sort%>" />
            <%
              }
            %>
          </td>
        </tr>
      </table>
    </form>
    <br />
    <a title="Open glossary editor" href="glossary-editor.jsp"><%=contentManagement.getContent( "generic_glossary-table_06" )%></a>
<%
  if (rows.size() > 0)
  {
%>
    <table summary="layout" border="1" cellpadding="2" cellspacing="" style="border-collapse:collapse">
      <tr>
        <th class="resultHeader" nowrap="nowrap">
          &nbsp;
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=TERM<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("TERM") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%>
            <%=contentManagement.getContent( "generic_glossary-table_07" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
            <%=contentManagement.getContent( "generic_glossary-table_08" )%>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=SOURCE<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("SOURCE") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_09" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=DEFINITION<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("DEFINITION") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_10" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=LINK_DESCRIPTION<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("LINK_DESCRIPTION") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_11" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=LINK_URL<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("LINK_URL") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_12" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=REFERENCE<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("REFERENCE") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_13" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=DATE_CHANGED<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("DATE_CHANGED") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_14" )%>
          </a>
        </th>
        <th align="center" class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=CURRENT<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("CURRENT") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_15" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=TERM_DOMAIN<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("TERM_DOMAIN") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_16" )%>
          </a>
        </th>
        <th class="resultHeader" nowrap="nowrap">
          <a title="Sort results on this column" href="glossary-table.jsp?sort=SEARCH_DOMAIN<%=filterURLParam%>">
            <%=sort.equalsIgnoreCase("SEARCH_DOMAIN") ? Utilities.getSortImageTag(AbstractSortCriteria.ASCENDENCY_ASC).toString() : ""%><%=contentManagement.getContent( "generic_glossary-table_17" )%>
          </a>
        </th>
      </tr>
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
%>
      <tr bgcolor="<%=((i % 2) == 0) ? "#EEEEEE" : "#FFFFFF"%>">
        <td valign="top" align="center">
          <form name="glossary<%=i%>" method="post" action="glossary-table.jsp">
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
            <a title="Delete term" href="javascript: deleteEntry(<%=i%>);"><img alt="Delete term" src="images/mini/delete.jpg" border="0" /></a>
          </form>
        </td>
        <td valign="top">
          <a title="Open glossary editor" href="glossary-editor.jsp?term=<%=row.getTerm()%>&amp;idLanguage=<%=row.getIdLanguage()%>&amp;source=<%=row.getSource()%><%=sortURLParam%><%=filterURLParam%>">
            <%=row.getTerm()%>
          </a>
        </td>
        <td valign="top">
          <%=language%>
        </td>
        <td valign="top">
          <%=source%>
        </td>
        <td valign="top">
          <%=definition%>
        </td>
        <td valign="top">
          <%=linkDescription%>
        </td>
        <td valign="top">
        <%
          if (linkUrl != null)
          {
        %>
            <a title="Open URL" href="<%=linkUrl%>"><%=row.getLinkUrl()%></a>
        <%
          } else {
        %>
            <%=DEFAULT_CELL_VALUE%>
        <%
          }
        %>
        </td>
        <td valign="top">
          <%=reference%>
        </td>
        <td valign="top">
          <%=dateChanged%>
        </td>
        <td valign="top" align="center">
          <%=(current) ? "Yes" : "No"%>
        </td>
        <td valign="top">
          <%=termDomain%>
        </td>
        <td valign="top">
          <%=searchDomain%>
        </td>
      </tr>
<%
    }
%>
    </table>
<%
  }
%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="glossary-table.jsp" />
    </jsp:include>
    </div>
  </body>
</html>