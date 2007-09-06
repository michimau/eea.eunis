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
<%@page import="ro.finsiel.eunis.backtrail.BacktrailObject,
                 ro.finsiel.eunis.backtrail.BacktrailUtil,
                java.util.Vector"%>
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
  String dynHeaderHelpLink = request.getParameter("helpLink");
  String dynHeaderPrintLink = request.getParameter("printLink");
  String dynHeaderGoogleLink = request.getParameter("kmlLink");
  String dynHeaderDownloadLink = Utilities.formatString( request.getParameter("downloadLink"), "null" );
  if ( dynHeaderDownloadLink.equalsIgnoreCase( "null" ) )
  {
    dynHeaderDownloadLink = null;
  }
  // Get the backtrail from string (order of objects is preserved).
  Vector backtrailObjects = BacktrailUtil.parseBacktrailString( dynHeaderLocation, cm );
%>
<%
  if (null != dynHeaderPrintLink || null != dynHeaderDownloadLink || null != dynHeaderHelpLink || null != dynHeaderGoogleLink)
  {
%>
  <h2>Operations</h2>
  <ul>
<%
    if (null != dynHeaderHelpLink)
    {
%>

            <li><a href="<%=domain%>/<%=dynHeaderHelpLink%>" title="<%=cm.cms( "header_help_title" )%>"><%=cm.cmsText( "help" )%></a>
            <%=cm.cmsTitle( "header_help_title" )%></li>
<%
    }
    if (null != dynHeaderPrintLink)
    {
%>
          <li><a href="<%=dynHeaderPrintLink%>" title="<%=cm.cms( "header_download_pdf_title" )%>"><%=cm.cmsText( "header_download_pdf" )%></a>
          <%=cm.cmsTitle( "header_download_pdf_title" )%></li>
<%
    }
    if (null != dynHeaderGoogleLink)
    {
%>
          <li><a href="<%=dynHeaderGoogleLink%>" title="<%=cm.cms( "header_download_kml_title" )%>"><%=cm.cmsText( "header_download_kml" )%></a>
          <%=cm.cmsTitle( "header_download_kml_title" )%></li>
<%
    }
    if (null != dynHeaderDownloadLink)
    {
%>
            <li><a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><img alt="<%=cm.cms( "header_download_alt" )%>" src="images/mini/download.gif" width="16" height="16" border="0" style="vertical-align:middle" /></a>
            <%=cm.cmsTitle( "header_download_tsv_title" )%><%=cm.cmsAlt( "header_download_alt" )%>
            <a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><%=cm.cmsText( "header_download_tsv" )%></a>
            <%=cm.cmsTitle( "header_download_tsv_title" )%></li>
<%
    }
%>
  </ul>
<%
  }
%>
