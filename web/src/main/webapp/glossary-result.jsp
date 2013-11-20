<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Glossary' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.Utilities,
                java.util.List,
                ro.finsiel.eunis.jrfTables.species.glossary.Chm62edtGlossaryPersist,
                ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.formBeans.AbstractFormBean"%>
<%@ page import="ro.finsiel.eunis.jrfTables.DcIndexDomain"%>
<%@ page import="ro.finsiel.eunis.jrfTables.DcIndexPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
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

  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,glossary#glossary.jsp,results";
  if (results.isEmpty())
  {
%>
    <jsp:forward page="emptyresults.jsp">
      <jsp:param name="location" value="<%=location%>" />
    </jsp:forward>
<%
  }
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Glossary results") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <script language="JavaScript" src="<%=request.getContextPath()%>/script/species-result.js" type="text/javascript"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("Glossary")%>
                </h1>
<%
                String terms = cm.cms("generic_glossary-result_03");
                String and1 = cm.cms("and");
                String definitions = cm.cms("generic_glossary-result_05");
%>
                <%=cm.cmsPhrase("You searched for")%>
                <%=(useTerms) ? terms : ""%> <%=(useTerms && useDefs) ? " " + and1 + " " : ""%><%=(useDefs) ? " " + definitions + " " : ""%>
                <%=cm.cmsPhrase("that contains")%>
                '<strong><%=formBean.getSearchString()%></strong>'
                <br />
                <br />
<%
  for (int i = 0; i < results.size(); i++)
  {
    Chm62edtGlossaryPersist result = (Chm62edtGlossaryPersist)results.get(i);
%>
                <table summary="<%=cm.cms("glossary_term_details")%>" class="datatable fullwidth">
                  <tr>
                    <td width="">
                      <%=cm.cmsPhrase("Term")%>
                    </td>
                    <td width="90%">
                      <strong>
                        <%=result.getTerm()%>
                      </strong>
<%
    // If user has rights to edit glossary
    if (SessionManager.isAuthenticated() && SessionManager.isEdit_glossary())
    {
%>
                      &nbsp;
                      [<a title="<%=cm.cms("open_glossary_editor")%>" href="glossary-editor.jsp?term=<%=result.getTerm()%>&amp;idLanguage=<%=result.getIdLanguage()%>&amp;source=<%=result.getSource()%>"><%=cm.cmsPhrase("Edit")%></a><%=cm.cmsTitle("open_glossary_editor")%>]
<%
    }
%>
                      &nbsp;
                      [<a title="<%=cm.cms("search_dictionary")%>" href="http://dictionary.reference.com/search?q='<%=result.getTerm()%>'">dictionary.com</a>]
                      <%=cm.cmsTitle("search_dictionary")%>&nbsp;
                      [<a title="<%=cm.cms("search_gemet")%>" href="http://www.eionet.europa.eu/gemet/search?query=<%=result.getTerm()%>">GEMET</a>]
                      <%=cm.cmsTitle("search_gemet")%>&nbsp;
                      [<a title="<%=cm.cms("search_google")%>" href="http://www.google.com/search?q=define:<%=result.getTerm()%>">google.com</a>]
                      <%=cm.cmsTitle("search_google")%>&nbsp;
                      [<a title="<%=cm.cms("search_answers")%>" href="http://www.answers.com/<%=result.getTerm()%>">answers.com</a>]
                      <%=cm.cmsTitle("search_answers")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase("Language")%>
                    </td>
                    <td>
                      <%=HabitatsSearchUtility.GetLanguage(result.getIdLanguage())%>
                    </td>
                  </tr>
<%
    if (showURL)
    {

%>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Url")%>
                    </td>
                    <td>
<%
      if(result.getLinkUrl().length()>0)
      {
%>
                      <a title="<%=cm.cms("open_url")%>" href="<%=result.getLinkUrl()%>"><strong><%=result.getLinkDescription()%></strong></a>
                      <%=cm.cmsTitle("open_url")%>
<%
      }
      else
      {
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
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase("Source")%>
                    </td>
                    <td>
                      <%=result.getSource()%>
                    </td>
                  </tr>
<%
    }
    if (showReference)
    {
      boolean hasReferences = false;
      List refs;
      try
      {
        refs = new DcIndexDomain().findWhere("ID_DC="+result.getIdDc());
        for (int ii = 0; ii < refs.size(); ii++)
        {
          DcIndexPersist aRef = (( DcIndexPersist ) refs.get(ii));
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
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Reference")%>
                    </td>
                    <td>
<%
      if( hasReferences )
      {
%>
                    <jsp:include page="glossary-references.jsp">
                      <jsp:param name="idDc" value="<%=result.getIdDc()%>" />
                    </jsp:include>
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
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsPhrase("Definition")%>
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
                <%=cm.cmsMsg("generic_glossary-result_03")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("and")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("generic_glossary-result_05")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("glossary_term_details")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>