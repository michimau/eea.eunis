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
  String dynHeaderPrintLink = request.getParameter("printLink");
  String dynHeaderDownloadLink = Utilities.formatString( request.getParameter("downloadLink"), "null" );
  if ( dynHeaderDownloadLink.equalsIgnoreCase( "null" ) )
  {
    dynHeaderDownloadLink = null;
  }
  // Get the backtrail from string (order of objects is preserved).
  Vector backtrailObjects = BacktrailUtil.parseBacktrailString( dynHeaderLocation, cm );
%>
<%--
  <div id="portal-breadcrumbs">
<%
  for (int i = 0; i < backtrailObjects.size(); i++)
  {
    out.print( "<span dir='ltr'>" );
    BacktrailObject backtrailObject = ( BacktrailObject ) backtrailObjects.elementAt(i);
    if( i < backtrailObjects.size() - 1 )
    {
      backtrailObject.setCssStyle( "breadcrumbitem" );
    }
    else
    {
      backtrailObject.setCssStyle( "breadcrumbitemlast" );
    }
    out.print( backtrailObject.toURLString() );
    out.print( "</span>" );
  }
%>
  </div>
--%>
<%
  if (null != dynHeaderPrintLink || null != dynHeaderDownloadLink)
  {
%>
  <div style="margin: 0px; padding: 0px; float:right;">
<%
    if (null != dynHeaderPrintLink)
    {
%>
          <a href="<%=dynHeaderPrintLink%>"><%=cm.cmsPhrase( "Downloadable PDF" )%></a>
<%
    }
    if (null != dynHeaderDownloadLink)
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
