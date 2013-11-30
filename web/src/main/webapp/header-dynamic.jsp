<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Header dynamic'
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
 <%--
Input parameters  on REQUEST:
  - SessionManager - to get theme info
  - location     - Link to the location on the web site (backtrail). SEE NOTES BELOW
  - glossaryLink - Link to the glossary page
  - helpLink - Link to the help page
  - printLink - Link to printable version (PDF) of the view
  - downloadLink - Link to Excel version (TSV) of the view
  If any of the parameters specified above missing, it will be only as text, no anchor (link)
  Below is a copy-and-paste example of how to include this jsp within your jsp:
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value=""/>
      <jsp:param name="printLink" value="javascript:openlink('reports/species/pdf.jsp?<%=formBean.toURLParam(reportFields)%>')"/>
      <jsp:param name="downloadLink" value="javascript:openlink('reports/species/tsv.jsp?<%=formBean.toURLParam(reportFields)%>')"/>
    </jsp:include>
--%>
<%--<jsp:include page="header-static.jsp"/>--%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String domain = application.getInitParameter( "DOMAIN_NAME" );
  WebContentManagement cm = SessionManager.getWebContent();
  // Request parameters.
  String dynHeaderLocation = request.getParameter("location");
  String dynHeaderPrintLink = request.getParameter("printLink");
  String dynHeaderDownloadLink = Utilities.formatString( request.getParameter("downloadLink"), "null" );
  if ( dynHeaderDownloadLink.equalsIgnoreCase( "null" ) )
  {
    dynHeaderDownloadLink = null;
  }


%>
<%
  if (null != dynHeaderPrintLink || null != dynHeaderDownloadLink)
  {
%>
  <div style="margin: 0px; padding: 0px; float:right;">
<%
    if (null != dynHeaderPrintLink && dynHeaderPrintLink.length()!=0)
    {
%>
      <a href="<%=dynHeaderPrintLink%>">
          <img src="images/pdf.png"
               alt="<%=cm.cmsPhrase("Download page as PDF")%>"
               title="<%=cm.cmsPhrase( "Download page as PDF")%>" />
          <%=cm.cmsPhrase("Download page as PDF")%>
      </a>
<%
    }
    if (null != dynHeaderDownloadLink && dynHeaderDownloadLink.length()!=0)
    {
%>
            <a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cmsPhrase( "Create Excel compatible file with search results" )%>"><img alt="" src="images/mini/download.gif" width="16" height="16" border="0" style="vertical-align:middle" /></a>
            <a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cmsPhrase( "Create Excel compatible file with search results" )%>"><%=cm.cmsPhrase( "Download results" )%></a>
<%
    }
%>
  </div>
<%
  }
%>
