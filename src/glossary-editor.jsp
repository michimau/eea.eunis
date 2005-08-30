<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Edit or add new glossary terms.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.Settings,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguageDomain,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist,
                 ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryDomain,
                 ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryPersist,
                 ro.finsiel.eunis.search.Utilities,
                 java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.PreparedStatement,
                 java.util.List"%>
<%@ page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();

  // Get the parameters from request
  String term = request.getParameter("term");
  String idLanguage = request.getParameter("idLanguage");
  String source = request.getParameter("source");
  String definition = request.getParameter("definition");
  String linkDescription = request.getParameter("linkDescription");
  String link = request.getParameter("link");
  String reference = request.getParameter("reference");
  String dateChanged = request.getParameter("dateChanged");
  String currentStr = request.getParameter("current");
  boolean current = false;
  String action = Utilities.formatString( request.getParameter("action"), "" );

  //Utilities.dumpRequestParams( request );

  if (null != currentStr && currentStr.equalsIgnoreCase("on"))
  {
    current = true;
  }
  String termDomain = "";
  String domainStr = request.getParameter("SPECIES");
  if (null != domainStr && domainStr.equalsIgnoreCase("on"))
  {
    termDomain += "SPECIES;";
  }
  domainStr = request.getParameter("HABITAT");
  if (null != domainStr && domainStr.equalsIgnoreCase("on"))
  {
    termDomain += "HABITAT;";
  }
  domainStr = request.getParameter("SITE");
  if (null != domainStr && domainStr.equalsIgnoreCase("on"))
  {
    termDomain += "SITE;";
  }

  String searchDomain = "";
  domainStr = request.getParameter("EASY");
  if (null != domainStr && domainStr.equalsIgnoreCase("on"))
  {
    searchDomain += "EASY;";
  }
  domainStr = request.getParameter("ADVANCED");
  if (null != domainStr && domainStr.equalsIgnoreCase("on"))
  {
    searchDomain += "ADVANCED;";
  }

  Chm62edtGlossaryPersist termPersist = null;
  // First we try to find if the term already exist on the database.
  boolean insert = false; // Do I insert or update?
  try
  {
    List terms = new Chm62edtGlossaryDomain().findWhere("TERM='" + term + "' AND ID_LANGUAGE='" + idLanguage + "' AND SOURCE='" + source + "'");
    if (terms.size() > 0)
    {
      termPersist = (Chm62edtGlossaryPersist)terms.get(0);
      insert = false; // Do not insert, value already exists, do an update
    }
    else
    {
      insert = true;
      termPersist = new Chm62edtGlossaryPersist();
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  if (null == termPersist)
  {
    termPersist = new Chm62edtGlossaryPersist();
  }

  if( !insert && !action.equalsIgnoreCase( "save" ) )
  {
    // Adjust current, termDomain and searchDomain after the new found object
    termDomain = Utilities.formatString(termPersist.getTermDomain(), "");
    searchDomain = Utilities.formatString(termPersist.getSearchDomain(), "");
    if (null != termPersist.getCurrent())
    {
      current = termPersist.getCurrent().intValue() == 0 ? false : true;
    }
  }

  if ( action.equalsIgnoreCase("save") )
  {
    termPersist.setTerm(term);
    termPersist.setIdLanguage(Utilities.checkedStringToInt(idLanguage, new Integer(25))); // 25 is the ID for English.
    termPersist.setSource(source);
    termPersist.setDefinition(definition);
    termPersist.setLinkDescription(linkDescription);
    termPersist.setLinkUrl(link);
    termPersist.setReference(reference);
    termPersist.setDateChanged(dateChanged);
    termPersist.setCurrent(current ? new Short((short)1) : new Short((short)0));
    //System.out.println( "termDomain = " + termDomain );
    termPersist.setTermDomain(termDomain);
    //System.out.println( "searchDomain = " + searchDomain );
    termPersist.setSearchDomain(searchDomain);
    String JDBC_DRV = Settings.getSetting("JDBC_DRV");
    String JDBC_URL = Settings.getSetting("JDBC_URL");
    String JDBC_USR = Settings.getSetting("JDBC_USR");
    String JDBC_PWD = Settings.getSetting("JDBC_PWD");
    try
    {
      Class.forName(JDBC_DRV);
      Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USR, JDBC_PWD);
      String sql = "";
      PreparedStatement stmt = null;
      if (insert)
      {
        //System.out.println("executing insert");
        sql = "INSERT INTO CHM62EDT_GLOSSARY " +
              "(TERM, ID_LANGUAGE, SOURCE, DEFINITION, LINK_DESCRIPTION, LINK_URL, REFERENCE, DATE_CHANGED, CURRENT, ID_DC, TERM_DOMAIN, SEARCH_DOMAIN) " +
              " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, termPersist.getTerm());
        stmt.setInt(2, termPersist.getIdLanguage().intValue());
        stmt.setString(3, termPersist.getSource());
        stmt.setString(4, termPersist.getDefinition());
        stmt.setString(5, termPersist.getLinkDescription());
        stmt.setString(6, termPersist.getLinkUrl());
        stmt.setString(7, termPersist.getReference());
        stmt.setString(8, termPersist.getDateChanged());
        stmt.setShort(9, termPersist.getCurrent().shortValue());
        stmt.setInt(10, 0);// ID_DC = 0
        stmt.setString(11, termPersist.getTermDomain());
        stmt.setString(12, termPersist.getSearchDomain());
        stmt.execute();
      } else {
        //System.out.println("executing update");
        sql = "UPDATE CHM62EDT_GLOSSARY SET TERM=?, ID_LANGUAGE=?, SOURCE=?, DEFINITION=?, LINK_DESCRIPTION=?, LINK_URL=?, REFERENCE=?," +
              " DATE_CHANGED=?, CURRENT=?, ID_DC=?, TERM_DOMAIN=?, SEARCH_DOMAIN=? WHERE TERM=? AND ID_LANGUAGE=? AND SOURCE=?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, termPersist.getTerm());
        stmt.setInt(2, termPersist.getIdLanguage().intValue());
        stmt.setString(3, termPersist.getSource());
        stmt.setString(4, termPersist.getDefinition());
        stmt.setString(5, termPersist.getLinkDescription());
        stmt.setString(6, termPersist.getLinkUrl());
        stmt.setString(7, termPersist.getReference());
        stmt.setString(8, termPersist.getDateChanged());
        stmt.setShort(9, termPersist.getCurrent().shortValue());
        stmt.setInt(10, 0);// ID_DC = 0
        stmt.setString(11, termPersist.getTermDomain());
        stmt.setString(12, termPersist.getSearchDomain());
        stmt.setString(13, termPersist.getTerm());
        stmt.setInt(14, termPersist.getIdLanguage().intValue());
        stmt.setString(15, termPersist.getSource());
        stmt.executeUpdate();
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  // Find languages
  String sql = "";
  sql = "SELECT ID_LANGUAGE,CODE,NAME_EN,SELECTION,NAME_FR,NAME_DE,FAMILY,COMMENT" +
        " FROM `CHM62EDT_LANGUAGE` WHERE LENGTH(NAME_EN)>0";
  List languages = new Chm62edtLanguageDomain().findCustom(sql);
%>
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent( "generic_glossary-editor_title", false )%>
    </title>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,Glossary editor#glossary-table.jsp,Edit glossary term"/>
    </jsp:include>
    <form name="addTerm" method="post" action="glossary-editor.jsp">
      <input type="hidden" name="action" value="save" />
      <table width="100%" border="0" summary="layout">
        <tr>
          <td>
            <%=contentManagement.getContent( "generic_glossary-editor_01" )%>
          </td>
        </tr>
        <tr>
          <td>
            <label for="reset" class="noshow">Reset values</label>
            <input title="Reset values" type="reset" name="reset" id="reset" value="Reset" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
            <label for="save" class="noshow">Save</label>
            <input title="Save" type="submit" name="save" id="save" value="Save" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
          </td>
        </tr>
        <tr>
          <td>
            <table summary="layout" width="600" border="1" cellpadding="2" cellspacing="0" style="border-collapse:collapse" bgcolor="#EEEEEE">
              <tr bgcolor ="#EEEEEE">
                <td width="200">
                  <label for="term">Term</label>
                </td>
                <td>
                  <input type="text" title="Term" name="term" id="term" size="50" value="<%=Utilities.formatString(termPersist.getTerm(), "")%>" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <%=contentManagement.getContent( "generic_glossary-editor_02" )%>
                </td>
                <td>
                  <label for="idLanguage" class="noshow">Language</label>
                  <select title="Language" name="idLanguage" id="idLanguage" class="inputTextField">
                    <%
                      for (int i = 0; i < languages.size(); i++)
                      {
                        Chm62edtLanguagePersist language = (Chm62edtLanguagePersist)languages.get(i);
                        String id = Utilities.formatString(language.getIdLanguage(), "");
                        String selected = (idLanguage != null && idLanguage.equalsIgnoreCase(id)) ? "selected" : "";
                    %>
                        <option value="<%=language.getIdLanguage()%>" <%=selected%>><%=language.getNameEn()%></option>
                    <%
                      }
                    %>
                  </select>
                </td>
              </tr>
              <tr bgcolor="#EEEEEE">
                <td>
                  <label for="source"><%=contentManagement.getContent( "generic_glossary-editor_03" )%></label>
                </td>
                <td>
                  <input title="Source" type="text" name="source" id="source" value="<%=Utilities.formatString(termPersist.getSource(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="definition"><%=contentManagement.getContent( "generic_glossary-editor_04" )%></label>
                </td>
                <td>
                  <textarea title="Definition" name="definition" id="definition" rows="5" cols="80" class="inputTextField"><%=Utilities.formatString(termPersist.getDefinition(), "")%></textarea>
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="linkDescription"><%=contentManagement.getContent( "generic_glossary-editor_05" )%></label>
                </td>
                <td>
                  <input title="Link description" type="text" name="linkDescription" id="linkDescription" value="<%=Utilities.formatString(termPersist.getLinkDescription(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="link"><%=contentManagement.getContent( "generic_glossary-editor_06" )%></label>
                </td>
                <td>
                  <input title="Link" type="text" name="link" id="link" value="<%=Utilities.formatString(termPersist.getLinkUrl(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="reference"><%=contentManagement.getContent( "generic_glossary-editor_07" )%></label>
                </td>
                <td>
                  <input title="Reference" type="text" name="reference" id="reference" value="<%=Utilities.formatString(termPersist.getReference(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="dateChanged"><%=contentManagement.getContent( "generic_glossary-editor_08" )%></label>
                </td>
                <td>
                  <input title="Date changed" type="text" name="dateChanged" id="dateChanged" value="<%=Utilities.formatString(termPersist.getDateChanged(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="current"><%=contentManagement.getContent( "generic_glossary-editor_09" )%></label>
                </td>
                <td>
                  <input title="Current definition" type="checkbox" name="current" id="current" <%=(current) ? "checked=\"checked\"" : ""%> />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <%=contentManagement.getContent( "generic_glossary-editor_10" )%>
                </td>
                <td>
                  <label for="SPECIES" class="noshow">Species domain</label>
                  <input title="Species term" type="checkbox" name="SPECIES" id="SPECIES" <%=termDomain.lastIndexOf("SPECIES") >= 0 ? "checked=\"checked\"" : ""%> />Species<br />
                  <label for="HABITAT" class="noshow">Habitat types domain</label>
                  <input title="Habitat types term" type="checkbox" name="HABITAT" id="HABITAT" <%=termDomain.lastIndexOf("HABITAT") >= 0 ? "checked=\"checked\"" : ""%> />Habitat types<br />
                  <label for="SITE" class="noshow">Sites domain</label>
                  <input title="Sites term" type="checkbox" name="SITE" id="SITE" <%=termDomain.lastIndexOf("SITE") >= 0 ? "checked=\"checked\"" : ""%> />Sites<br />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <%=contentManagement.getContent( "generic_glossary-editor_11" )%>
                </td>
                <td>
                  <label for="EASY" class="noshow">Combined search</label>
                  <input title="Easy searches term" type="checkbox" name="EASY" id="EASY" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> />Easy searches<br />
                  <label for="ADVANCED" class="noshow">Advanced search</label>
                  <input title="Advanced searches term" type="checkbox" name="ADVANCED" id="ADVANCED" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> />Advanced searches<br />
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <label for="reset2" class="noshow">Reset values</label>
            <input title="Reset values" type="reset" name="reset" id="reset2" value="Reset" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
            <label for="save2" class="noshow">Save</label>
            <input title="Save" type="submit" name="save" id="save2" value="Save" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
          </td>
        </tr>
      </table>
    </form>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="glossary-editor.jsp" />
    </jsp:include>
    </div>
  </body>
</html>