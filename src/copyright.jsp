<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Copyright page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReferencesDomain,
                 java.util.Iterator,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReferencesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <title><%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("copyright_and_disclaimer_title")%>
  </title>
</head>

<body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getHeader?site=eunis" )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
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
                  <jsp:param name="location" value="home#index.jsp,copyright_and_disclaimer_title"/>
                </jsp:include>
                <%=cm.cmsText("generic_copyright_01")%>
                <table summary="<%=cm.cms("references")%>" class="datatable">
                  <thead>
                    <tr>
                      <th width="40%">
                        <%=cm.cmsText("author")%>
                      </th>
                      <th width="50%">
                        <%=cm.cmsText("title")%>
                      </th>
                      <th width="10%" style="text-align: center;">
                        <%=cm.cmsText("publication_date")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  try {
                    Chm62edtReferencesDomain nd = new Chm62edtReferencesDomain();
                    // List of all 'REFERENCES'
                    String sSQL = "SELECT `DC_INDEX`.`ID_DC`,";
                    sSQL += " `DC_SOURCE`.`SOURCE`,";
                    sSQL += " CONCAT(`DC_DATE`.`CREATED`),";
                    sSQL += " `DC_TITLE`.`TITLE`,";
                    sSQL += " `DC_TITLE`.`ALTERNATIVE`,";
                    sSQL += " `DC_SOURCE`.`EDITOR`,";
                    sSQL += " `DC_SOURCE`.`JOURNAL_TITLE`,";
                    sSQL += " `DC_SOURCE`.`BOOK_TITLE`,";
                    sSQL += " `DC_SOURCE`.`JOURNAL_ISSUE`,";
                    sSQL += " `DC_PUBLISHER`.`PUBLISHER`,";
                    sSQL += " `DC_SOURCE`.`ISBN`,";
                    sSQL += " `DC_SOURCE`.`URL`";
                    sSQL += " FROM  `DC_INDEX`";
                    sSQL += " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
                    sSQL += " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
                    sSQL += " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
                    sSQL += " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
                    sSQL += " WHERE `DC_INDEX`.`COMMENT` = 'REFERENCES'";
                    sSQL += " ORDER BY `DC_SOURCE`.`SOURCE` ASC";

                    List list = nd.findCustom(sSQL);

                    if(null != list && list.size() > 0) {
                      Iterator it = list.iterator();
                      int cnt = 0;
                      while(it.hasNext())
                      {
                        Chm62edtReferencesPersist nl = (Chm62edtReferencesPersist) it.next();
                        if(!nl.getAuthor().equalsIgnoreCase("No additional references") && !nl.getAuthor().equalsIgnoreCase("--"))
                        {
                          String cssClass = cnt++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                %>
                <tr<%=cssClass%>>
                  <td id="A<%=cnt%>1">
                    <a title="<%=cm.cms("copyright_search_for_author")%>" target="_blank" href="http://www.google.com/search?hl=en&amp;lr=&amp;ie=UTF-8&amp;oe=UTF-8&amp;q=<%=Utilities.treatURLSpecialCharacters( nl.getAuthor() )%>"><%=Utilities.treatURLSpecialCharacters( nl.getAuthor() )%></a>
                    <%=cm.cmsTitle("copyright_search_for_author")%>
                  </td>
                  <td>
                    <%=Utilities.treatURLSpecialCharacters( nl.getTitle() )%>
                  </td>
                  <td style="text-align: center;">
                    <%=nl.getPublicationDate()%>
                  </td>
                </tr>
                <%
                        }
                      }
                    }
                  } catch(Exception e) {
                    e.printStackTrace();
                  }
                %>
                </tbody>
                <thead>
                  <tr>
                    <th>
                      <%=cm.cmsText("author")%>
                    </th>
                    <th>
                      <%=cm.cmsText("title")%>
                    </th>
                    <th style="text-align : center;">
                      <%=cm.cmsText("publication_date")%>
                    </th>
                  </tr>
                </thead>
              </table>
                <%=cm.cmsMsg("copyright_and_disclaimer_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("references")%>
                <%=cm.br()%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="copyright.jsp"/>
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
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
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getFooter?site=eunis" )%>
    </div>
  </body>
</html>
