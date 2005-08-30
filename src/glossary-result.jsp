<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Glossary' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.search.Utilities,
                java.util.List,
                ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryPersist,
                ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.formBeans.AbstractFormBean"%><%@ page import="java.util.ArrayList"%><%@ page import="ro.finsiel.eunis.jrfTables.DcIndexDcSourceDomain"%><%@ page import="ro.finsiel.eunis.jrfTables.DcIndexDcSourcePersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/species-result.js" type="text/javascript"></script>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.GlossaryBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <%
//      Utilities.dumpRequestParams(request);
      boolean showReference = Utilities.checkedStringToBoolean(formBean.getShowReference(), AbstractFormBean.HIDE);
      boolean showSource = Utilities.checkedStringToBoolean(formBean.getShowSource(), AbstractFormBean.HIDE);
      boolean showURL = Utilities.checkedStringToBoolean(formBean.getShowURL(), AbstractFormBean.HIDE);

      String module = formBean.getModule();
      String searchString = formBean.getSearchString();
      Integer operand = Utilities.checkedStringToInt(formBean.getOperand(), Utilities.OPERATOR_CONTAINS);
      boolean useTerms = Utilities.checkedStringToBoolean(formBean.getSearchTerms(), false);
      boolean useDefs = Utilities.checkedStringToBoolean(formBean.getSearchDefinitions(), false);
      // List of results
      List results = Utilities.findGlossaryTerms(searchString, operand, useTerms, useDefs, module);

      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("generic_glossary-result_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Glossary#glossary.jsp,Results"/>
    </jsp:include>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <h5>
            <%=contentManagement.getContent("generic_glossary-result_01")%>
          </h5>
            <%
              String terms = contentManagement.getContent("generic_glossary-result_03");
              String and1 = contentManagement.getContent("generic_glossary-result_04");
              String definitions = contentManagement.getContent("generic_glossary-result_05");
            %>
            <%=contentManagement.getContent("generic_glossary-result_02")%>
            <%=(useTerms) ? terms : ""%> <%=(useTerms && useDefs) ? " " + and1 + " " : ""%><%=(useDefs) ? " " + definitions + " " : ""%>
            <%=contentManagement.getContent("generic_glossary-result_06")%>
            <strong>
              <%=formBean.getSearchString()%>
            </strong>
          <br />
          <br />
          <%if (results.isEmpty()) {%><jsp:include page="noresults.jsp" /><%return;}%>
          <%
            for (int i = 0; i < results.size(); i++)
            {
              Chm62edtGlossaryPersist result = (Chm62edtGlossaryPersist)results.get(i);%>
              <table summary="Term details" style="border-collapse:collapse" width="100%" border="1" cellspacing="0" cellpadding="0">
                <tr bgcolor="#CCCCCC">
                  <td width="10%">
                    <%=contentManagement.getContent("generic_glossary-result_07")%>
                  </td>
                  <td width="90%">
                    <strong><%=result.getTerm()%></strong>
                    <%
                      // If user has rights to edit glossary
                      if (SessionManager.isAuthenticated() && SessionManager.isEdit_glossary())
                      {
                    %>
                        &nbsp;
                        [<a title="Open glossary editor" href="glossary-editor.jsp?term=<%=result.getTerm()%>&amp;idLanguage=<%=result.getIdLanguage()%>&amp;source=<%=result.getSource()%>"><%=contentManagement.getContent("generic_glossary-result_08")%></a>]
                   <%
                      }
                   %>
                   &nbsp;
                    [<a title="Search dictionary.com" href="http://dictionary.reference.com/search?q='<%=result.getTerm()%>'">dictionary.com</a>]
                   &nbsp;
                    [<a title="Search GEMET" href="http://www.eionet.eu.int/GEMET">GEMET</a>]
                   &nbsp;
                    [<a title="Search Google definitions" href="http://www.google.com/search?q=define:<%=result.getTerm()%>">google.com</a>]
                   &nbsp;
                    [<a title="Search answers.com" href="http://www.answers.com/<%=result.getTerm()%>">answers.com</a>]
                  </td>
                </tr>
                <tr bgcolor="#EEEEEE">
                  <td>
                    <%=contentManagement.getContent("generic_glossary-result_09")%>
                  </td>
                  <td><%=HabitatsSearchUtility.GetLanguage(result.getIdLanguage())%></td>
                </tr>
                <%
                  if (showURL)
                  {
                %>
                  <tr bgcolor="#EEEEEE">
                    <td>
                      <%=contentManagement.getContent("generic_glossary-result_10")%>
                    </td>
                    <td>
                      <%
                        if(result.getLinkUrl().length()>0) {
                      %>
                        <a title="Open URL" href="<%=result.getLinkUrl()%>"><strong><%=result.getLinkDescription()%></strong></a>
                      <%
                        } else {
                      %>
                        &nbsp;
                      <%
                        }
                      %>
                    </td>
                  </tr>
                <%
                  }
                  if (showSource)
                  {
                %>
                  <tr bgcolor="#EEEEEE">
                    <td>
                      <%=contentManagement.getContent("generic_glossary-result_11")%>
                    </td>
                    <td><%=result.getSource()%></td>
                  </tr>
                <%
                  }
                  if (showReference)
                  {
                    boolean hasReferences = false;
                    List refs = new ArrayList();
                    try
                    {
                      refs = new DcIndexDcSourceDomain().findWhere("DC_INDEX.ID_DC="+result.getIdDc());
                      for (int ii = 0; ii < refs.size(); ii++)
                      {
                        DcIndexDcSourcePersist aRef = (( DcIndexDcSourcePersist ) refs.get(ii));
                        String title=Utilities.formatString(aRef.getTitle());
                        String source=Utilities.formatString(aRef.getSource());
                        String editor=Utilities.formatString(aRef.getEditor());
                        String publisher=Utilities.formatString(aRef.getPublisher());
                        String cond = ( editor+title+publisher+source ).trim();
                        if( cond.length() > 0 )
                        {
                          hasReferences = true;
                          break;
                        }
                      }
                    }
                    catch( Exception ex )
                    {
                      ex.printStackTrace();
                    }
%>
                  <tr bgcolor="#EEEEEE">
                    <td>
                      <%=contentManagement.getContent("generic_glossary-result_12")%>
                    </td>
                    <td>
<%
                      if( hasReferences )
                      {
%>
                      <a title="Open references page" href="javascript:openlink('glossary-references.jsp?idDc=<%=result.getIdDc()%>');"><%=result.getReference()%></a>
<%
                      }
                      else
                      {

%>
                      <%=result.getReference()%>
<%
                      }
%>
                    </td>
                  </tr>
                <%
                  }
                %>
                <tr bgcolor="#EEEEEE">
                  <td>
                    <%=contentManagement.getContent("generic_glossary-result_13")%>
                  </td>
                  <td>
                    <%=useDefs ? Utilities.highlightTerm(result.getDefinition(), searchString) : result.getDefinition()%>
                  </td>
                </tr>
              </table>
              <br />
          <%
            }
          %>
        </td>
      </tr>
    </table>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="glossary-result.jsp" />
    </jsp:include>
      </div>
  </body>
</html>