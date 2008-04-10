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
  // Get the parameters from request
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,glossary_editor#glossary-table.jsp,edit_glossary_location";
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
<%
    WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms( "glossary_editor")%>
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
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
<%
  if( SessionManager.isAuthenticated() && SessionManager.isEdit_glossary() )
  {
%>
                <form name="addTerm" method="post" action="glossary-editor.jsp">
                  <input type="hidden" name="action" value="save" />
                  <table width="100%" border="0" summary="layout">
                    <tr>
                      <td>
                        <%=cm.cmsPhrase("<h1>Insert new / Modify glossary term</h1>")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input title="<%=cm.cms("reset")%>" type="reset" name="reset" id="reset" value="<%=cm.cms("reset")%>" class="standardButton" />
                        &nbsp;&nbsp;&nbsp;
                        <input title="<%=cm.cms("save")%>" type="submit" name="save" id="save" value="<%=cm.cms("save")%>" class="searchButton" />
                        &nbsp;&nbsp;&nbsp;
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table summary="layout" width="90%" class="datatable">
                          <tr>
                            <td width="200">
                              <label for="term"><%=cm.cmsPhrase("Term")%></label>
                            </td>
                            <td>
                              <input type="text" title="<%=cm.cms("term")%>" name="term" id="term" size="50" value="<%=Utilities.formatString(termPersist.getTerm(), "")%>" />
                            </td>
                          </tr>
                          <tr class="zebraeven">
                            <td>
                              <%=cm.cmsPhrase( "Language" )%>
                            </td>
                            <td>
                              <label for="idLanguage" class="noshow"><%=cm.cms("language")%></label>
                              <select title="<%=cm.cms("language")%>" name="idLanguage" id="idLanguage">
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
                              <%=cm.cmsLabel("language")%>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <label for="source"><%=cm.cmsPhrase( "Source" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "source" )%>" type="text" name="source" id="source" value="<%=Utilities.formatString(termPersist.getSource(), "")%>" size="50" />
                            </td>
                          </tr>
                          <tr class="zebraeven">
                            <td>
                              <label for="definition"><%=cm.cmsPhrase( "Definition" )%></label>
                            </td>
                            <td>
                              <textarea title="<%=cm.cms( "definition" )%>" name="definition" id="definition" rows="5" cols="80"><%=Utilities.formatString(termPersist.getDefinition(), "")%></textarea>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <label for="linkDescription"><%=cm.cmsPhrase( "Link description" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "link_description" )%>" type="text" name="linkDescription" id="linkDescription" value="<%=Utilities.formatString(termPersist.getLinkDescription(), "")%>" size="50" />
                            </td>
                          </tr>
                          <tr class="zebraeven">
                            <td>
                              <label for="link"><%=cm.cmsPhrase( "Link" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "link" )%>" type="text" name="link" id="link" value="<%=Utilities.formatString(termPersist.getLinkUrl(), "")%>" size="50" />
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <label for="reference"><%=cm.cmsPhrase( "Reference" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "reference" )%>" type="text" name="reference" id="reference" value="<%=Utilities.formatString(termPersist.getReference(), "")%>" size="50" />
                            </td>
                          </tr>
                          <tr class="zebraeven">
                            <td>
                              <label for="dateChanged"><%=cm.cmsPhrase( "Date changed" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "date_changed" )%>" type="text" name="dateChanged" id="dateChanged" value="<%=Utilities.formatString(termPersist.getDateChanged(), "")%>" size="50" />
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <label for="current"><%=cm.cmsPhrase( "Current" )%></label>
                            </td>
                            <td>
                              <input title="<%=cm.cms( "current" )%>" type="checkbox" name="current" id="current" <%=(current) ? "checked=\"checked\"" : ""%> />
                            </td>
                          </tr>
                          <tr class="zebraeven">
                            <td>
                              <%=cm.cmsPhrase( "Domain" )%>
                            </td>
                            <td>
                              <label for="SPECIES" class="noshow"><%=cm.cms("glossary_species")%></label>
                              <input title="<%=cm.cms("glossary_species")%>" type="checkbox" name="SPECIES" id="SPECIES" <%=termDomain.lastIndexOf("SPECIES") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsPhrase("Species domain")%><br />
                              <%=cm.cmsLabel("glossary_species")%>
                              <label for="HABITAT" class="noshow"><%=cm.cms("glossary_habitats")%></label>
                              <input title="<%=cm.cms("glossary_habitats")%>" type="checkbox" name="HABITAT" id="HABITAT" <%=termDomain.lastIndexOf("HABITAT") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsPhrase("Habitat types domain")%><br />
                              <%=cm.cmsLabel("glossary_habitats")%>
                              <label for="SITE" class="noshow"><%=cm.cms("glossary_sites")%></label>
                              <input title="<%=cm.cms("glossary_sites")%>" type="checkbox" name="SITE" id="SITE" <%=termDomain.lastIndexOf("SITE") >= 0 ? "checked=\"checked\"" : ""%> /><%=cm.cmsPhrase("Sites domain")%><br />
                              <%=cm.cmsLabel("glossary_sites")%>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <%=cm.cmsPhrase( "Search domain" )%>
                            </td>
                            <td>
                              <label for="EASY" class="noshow"><%=cm.cms("easy_search")%></label>
                              <input title="<%=cm.cms("easy_search")%>" type="checkbox" name="EASY" id="EASY" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> /><%=cm.cmsPhrase("Easy search")%><br />
                              <%=cm.cmsLabel("easy_search")%>
                              <label for="ADVANCED" class="noshow"><%=cm.cms("advanced_search")%></label>
                              <input title="<%=cm.cms("advanced_search")%>" type="checkbox" name="ADVANCED" id="ADVANCED" <%=searchDomain.lastIndexOf("EASY") >= 0 ? "checked" : ""%> /><%=cm.cmsPhrase("Advanced Search")%><br />
                              <%=cm.cmsLabel("advanced_search")%>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input title="<%=cm.cms("reset")%>" type="reset" name="reset" id="reset2" value="Reset" class="standardButton" />
                        &nbsp;&nbsp;&nbsp;
                        <input title="<%=cm.cms("save")%>" type="submit" name="save" id="save2" value="Save" class="searchButton" />
                        &nbsp;&nbsp;&nbsp;
                      </td>
                    </tr>
                  </table>
                </form>
                <%=cm.cmsMsg( "glossary_editor")%>
<%
  }
  else
  {
%>
                <br />
                <br />
                <span style="color : red"><%=cm.cmsPhrase("You must be authenticated and have the proper right to access this page.")%></span>
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
                <jsp:param name="page_name" value="glossary-editor.jsp" />
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
