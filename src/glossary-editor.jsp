<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Edit or add new glossary terms.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<%
  WebContentManagement cm = SessionManager.getWebContent();

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
      <%=cm.cms( "generic_glossary-editor_title")%>
    </title>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,services_location#services.jsp,glossary_editor_location#glossary-table.jsp,edit_glossary_location"/>
    </jsp:include>
    <form name="addTerm" method="post" action="glossary-editor.jsp">
      <input type="hidden" name="action" value="save" />
      <table width="100%" border="0" summary="layout">
        <tr>
          <td>
            <%=cm.cmsText("generic_glossary-editor_01")%>
          </td>
        </tr>
        <tr>
          <td>
            <input title="<%=cm.cms("reset_btn")%>" type="reset" name="reset" id="reset" value="<%=cm.cms("reset_btn")%>" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
            <input title="<%=cm.cms("save_btn")%>" type="submit" name="save" id="save" value="<%=cm.cms("save_btn")%>" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
          </td>
        </tr>
        <tr>
          <td>
            <table summary="layout" width="600" border="1" cellpadding="2" cellspacing="0" style="border-collapse:collapse" bgcolor="#EEEEEE">
              <tr bgcolor ="#EEEEEE">
                <td width="200">
                  <label for="term"><%=cm.cmsText("glossary_term")%></label>
                </td>
                <td>
                  <input type="text" title="<%=cm.cms("glossary_term")%>" name="term" id="term" size="50" value="<%=Utilities.formatString(termPersist.getTerm(), "")%>" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <%=cm.cmsText( "generic_glossary-editor_02" )%>
                </td>
                <td>
                  <label for="idLanguage" class="noshow"><%=cm.cms("glossary_language")%></label>
                  <select title="<%=cm.cms("glossary_language")%>" name="idLanguage" id="idLanguage" class="inputTextField">
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
                  <%=cm.cmsLabel("glossary_language")%>
                </td>
              </tr>
              <tr bgcolor="#EEEEEE">
                <td>
                  <label for="source"><%=cm.cmsText( "generic_glossary-editor_03" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_03" )%>" type="text" name="source" id="source" value="<%=Utilities.formatString(termPersist.getSource(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="definition"><%=cm.cmsText( "generic_glossary-editor_04" )%></label>
                </td>
                <td>
                  <textarea title="<%=cm.cms( "generic_glossary-editor_04" )%>" name="definition" id="definition" rows="5" cols="80" class="inputTextField"><%=Utilities.formatString(termPersist.getDefinition(), "")%></textarea>
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="linkDescription"><%=cm.cmsText( "generic_glossary-editor_05" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_05" )%>" type="text" name="linkDescription" id="linkDescription" value="<%=Utilities.formatString(termPersist.getLinkDescription(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="link"><%=cm.cmsText( "generic_glossary-editor_06" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_06" )%>" type="text" name="link" id="link" value="<%=Utilities.formatString(termPersist.getLinkUrl(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="reference"><%=cm.cmsText( "generic_glossary-editor_07" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_07" )%>" type="text" name="reference" id="reference" value="<%=Utilities.formatString(termPersist.getReference(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <label for="dateChanged"><%=cm.cmsText( "generic_glossary-editor_08" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_08" )%>" type="text" name="dateChanged" id="dateChanged" value="<%=Utilities.formatString(termPersist.getDateChanged(), "")%>" size="50" class="inputTextField" />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <label for="current"><%=cm.cmsText( "generic_glossary-editor_09" )%></label>
                </td>
                <td>
                  <input title="<%=cm.cms( "generic_glossary-editor_09" )%>" type="checkbox" name="current" id="current" <%=(current) ? "checked=\"checked\"" : ""%> />
                </td>
              </tr>
              <tr bgcolor ="#EEEEEE">
                <td>
                  <%=cm.cmsText( "generic_glossary-editor_10" )%>
                </td>
                <td>
                  <label for="SPECIES" class="noshow"><%=cm.cms("glossary_species")%></label>
                  <input title="<%=cm.cms("glossary_species")%>" type="checkbox" name="SPECIES" id="SPECIES" <%=termDomain.lastIndexOf("SPECIES") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsText("glossary_species")%><br />
                  <%=cm.cmsLabel("glossary_species")%>
                  <label for="HABITAT" class="noshow"><%=cm.cms("glossary_habitats")%></label>
                  <input title="<%=cm.cms("glossary_habitats")%>" type="checkbox" name="HABITAT" id="HABITAT" <%=termDomain.lastIndexOf("HABITAT") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsText("glossary_habitats")%><br />
                  <%=cm.cmsLabel("glossary_habitats")%>
                  <label for="SITE" class="noshow"><%=cm.cms("glossary_sites")%></label>
                  <input title="<%=cm.cms("glossary_sites")%>" type="checkbox" name="SITE" id="SITE" <%=termDomain.lastIndexOf("SITE") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsText("glossary_sites")%><br />
                  <%=cm.cmsLabel("glossary_sites")%>
                </td>
              </tr>
              <tr bgcolor ="#FFFFFF">
                <td>
                  <%=cm.cmsText( "generic_glossary-editor_11" )%>
                </td>
                <td>
                  <label for="EASY" class="noshow"><%=cm.cms("glossary_easy")%></label>
                  <input title="<%=cm.cms("glossary_easy")%>" type="checkbox" name="EASY" id="EASY" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> /><%=cm.cmsText("glossary_easy")%><br />
                  <%=cm.cmsLabel("glossary_easy")%>
                  <label for="ADVANCED" class="noshow"><%=cm.cms("glossary_advanced")%></label>
                  <input title="<%=cm.cms("glossary_advanced")%>" type="checkbox" name="ADVANCED" id="ADVANCED" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> /><%=cm.cmsText("glossary_advanced")%><br />
                  <%=cm.cmsLabel("glossary_advanced")%>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <input title="<%=cm.cms("reset_btn")%>" type="reset" name="reset" id="reset2" value="Reset" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
            <input title="<%=cm.cms("save_btn")%>" type="submit" name="save" id="save2" value="Save" class="inputTextField" />
            &nbsp;&nbsp;&nbsp;
          </td>
        </tr>
      </table>
    </form>
    <%=cm.cmsMsg( "generic_glossary-editor_title")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="glossary-editor.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>