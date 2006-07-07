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
  String dynHeaderDownloadLink = Utilities.formatString( request.getParameter("downloadLink"), "null" );
  if ( dynHeaderDownloadLink.equalsIgnoreCase( "null" ) )
  {
    dynHeaderDownloadLink = null;
  }
  // Get the backtrail from string (order of objects is preserved).
  Vector backtrailObjects = BacktrailUtil.parseBacktrailString( dynHeaderLocation, cm );
%>
<div id="eunistrail">
  <div style="width: 100%; padding: 0px; margin: 0px; display:table-cell;">
<%
  for (int i = 0; i < backtrailObjects.size(); i++)
  {
    BacktrailObject backtrailObject = ( BacktrailObject ) backtrailObjects.elementAt(i);
    if (i > 0)
    {
      out.print( "<span style=\"margin-left: 2px; margin-right: 2px;\">&raquo;</span>" );
    }
    out.print( backtrailObject.toURLString() );
  }
%>
  </div>
<%
  if (null != dynHeaderPrintLink || null != dynHeaderDownloadLink || null != dynHeaderHelpLink)
  {
%>
  <div style="width: 100%; text-align:right;">
<%
    if (null != dynHeaderPrintLink)
    {
%>
          <a href="<%=dynHeaderPrintLink%>" title="<%=cm.cms( "header_download_pdf_title" )%>"><%=cm.cmsText( "header_download_pdf" )%></a>
          <%=cm.cmsTitle( "header_download_pdf_title" )%>
<%
    }
    if (null != dynHeaderDownloadLink)
    {
%>
            <a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><img alt="<%=cm.cms( "header_download_alt" )%>" src="images/mini/download.gif" width="16" height="16" border="0" style="vertical-align:middle" /></a>
            <%=cm.cmsTitle( "header_download_tsv_title" )%><%=cm.cmsAlt( "header_download_alt" )%>
            <a href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><%=cm.cmsText( "header_download_tsv" )%></a>
            <%=cm.cmsTitle( "header_download_tsv_title" )%>
<%
    }
    if (null != dynHeaderHelpLink)
    {
%>

            <a href="<%=domain%>/<%=dynHeaderHelpLink%>" title="<%=cm.cms( "header_help_title" )%>"><%=cm.cmsText( "help" )%></a>
            <%=cm.cmsTitle( "header_help_title" )%>
<%
    }
%>
  </div>
<%
  }
%>
</div>
<a name="main_content" title="<%=cm.cms("header_main_content")%>" accesskey="2"><img alt="" src="images/pixel.gif" width="1" height="1" /></a>
<%=cm.cmsTitle("header_main_content")%>
