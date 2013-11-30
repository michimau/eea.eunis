<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Copyright page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReferencesDomain,
                 java.util.Iterator,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReferencesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,copyright_and_disclaimer_title";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Copyright and disclaimer") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">

    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase("Copyright, disclaimer and privacy statement notice")%></h1>

<!-- MAIN CONTENT -->
                <%=cm.cmsText("generic_copyright_01")%>
                <table class="datatable" style="table-layout:fixed">
		  <col style="width:40%"/>
		  <col style="width:50%"/>
		  <col style="width:10%"/>
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsPhrase("Author")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Title")%>
                      </th>
                      <th style="text-align: center;">
                        <%=cm.cmsPhrase("Publication date")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  try {
                    Chm62edtReferencesDomain nd = new Chm62edtReferencesDomain();
                    // List of all 'REFERENCES'
                    String sSQL = "SELECT `ID_DC`,";
                    sSQL += " `SOURCE`,";
                    sSQL += " CONCAT(`CREATED`),";
                    sSQL += " `TITLE`,";
                    sSQL += " `ALTERNATIVE`,";
                    sSQL += " `EDITOR`,";
                    sSQL += " `JOURNAL_TITLE`,";
                    sSQL += " `BOOK_TITLE`,";
                    sSQL += " `JOURNAL_ISSUE`,";
                    sSQL += " `PUBLISHER`,";
                    sSQL += " `ISBN`,";
                    sSQL += " `URL`";
                    sSQL += " FROM  `DC_INDEX`";
                    sSQL += " WHERE `COMMENT` = 'REFERENCES'";
                    sSQL += " ORDER BY `SOURCE` ASC";

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
					<a href="references/<%=nl.getIdReference()%>"><%=Utilities.treatURLSpecialCharacters( nl.getAuthor() )%></a>
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
              </table>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>