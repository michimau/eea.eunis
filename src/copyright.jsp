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
                 ro.finsiel.eunis.WebContentManagement" %>
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
  <div id="outline">
  <div id="alignment">
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="home#index.jsp,copyright_and_disclaimer_title"/>
  </jsp:include>
  <%=cm.cmsText("generic_copyright_01")%>
  <table summary="<%=cm.cms("references")%>" border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" width="100%">
  <tr>
    <th width="40%" class="resultHeader">
      <%=cm.cmsText("author")%>
    </th>
    <th width="50%" class="resultHeader">
      <%=cm.cmsText("title")%>
    </th>
    <th width="10%" class="resultHeader" align="center">
      <%=cm.cmsText("publication_date")%>
    </th>
  </tr>
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
        while(it.hasNext()) {
          Chm62edtReferencesPersist nl = (Chm62edtReferencesPersist) it.next();
          if(!nl.getAuthor().equalsIgnoreCase("No additional references") && !nl.getAuthor().equalsIgnoreCase("--")) {
            cnt++;
  %>
  <tr bgcolor="<%=(0 == (cnt % 2) ? "#EEEEEE" : "#FFFFFF")%>">
    <td width="40%" id="A<%=cnt%>1">
      <a title="<%=cm.cms("copyright_search_for_author")%>" target="_blank" href="http://www.google.com/search?hl=en&amp;lr=&amp;ie=UTF-8&amp;oe=UTF-8&amp;q=<%=nl.getAuthor()%>"><%=nl.getAuthor()%></a>
      <%=cm.cmsTitle("copyright_search_for_author")%>
    </td>
    <td width="50%"><%=nl.getTitle()%></td>
    <td width="10%" align="center"><%=nl.getPublicationDate()%></td>
  </tr>
  <%
          }
        }
      }
    } catch(Exception e) {
      e.printStackTrace();
    }
  %>
  <tr>
    <th width="40%" class="resultHeader">
      <%=cm.cmsText("author")%>
    </th>
    <th width="50%" class="resultHeader">
      <%=cm.cmsText("title")%>
    </th>
    <th width="10%" class="resultHeader" style="text-align : center;">
      <%=cm.cmsText("publication_date")%>
    </th>
  </tr>
</table>
  <%=cm.cmsMsg("copyright_and_disclaimer_title")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("references")%>
  <%=cm.br()%>
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="copyright.jsp"/>
  </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
