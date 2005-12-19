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
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
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
<jsp:include page="header-static.jsp"/>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
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
<div class="headerdynamicprint">
<table summary="layout" border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align : left;">
  <tr>
    <td width="60%">
      <img alt="<%=cm.cms( "header_current_location_alt" )%>" src="images/path.gif" width="20" height="16" align="middle" /><%=cm.cmsAlt("header_current_location_alt")%>
<%
        for (int i = 0; i < backtrailObjects.size(); i++)
        {
          BacktrailObject backtrailObject = ( BacktrailObject ) backtrailObjects.elementAt(i);
          backtrailObject.setCssStyle( "breadcrumbtrail" );
          if (i > 0)
          {
%>
            <span class="breadcrumbtrailNormalFont">&gt;&gt;</span>
<%
          }
%>
         <%=backtrailObject.toURLString()%>
<%
        }
%>
    </td>
<%
      if (null != dynHeaderHelpLink)
      {
%>
        <td width="7%" align="right">
          <a class="breadcrumbtrail" href="<%=dynHeaderHelpLink%>" title="<%=cm.cms( "header_help_title" )%>"><%=cm.cmsText( "header_help" )%></a>
          <%=cm.cmsTitle( "header_help_title" )%>
        </td>
<%
      }
      else
      {
%>
        <td width="7%" align="right">
          &nbsp;
        </td>
<%
      }
%>
  </tr>
</table>
<table summary="layout" border="0" cellpadding="0" cellspacing="0" width="100%">
<%
  if (null != dynHeaderPrintLink || null != dynHeaderDownloadLink) {
%>

  <tr>
<%
      if (null != dynHeaderPrintLink)
      {
%>
        <td width="100%" align="right">
          <a class="breadcrumbtrail" href="<%=dynHeaderPrintLink%>" title="<%=cm.cms( "header_download_pdf_title" )%>"><%=cm.cmsText( "header_download_pdf" )%></a>
          <%=cm.cmsTitle( "header_download_pdf_title" )%>
        </td>
<%
      }
      if (null != dynHeaderDownloadLink)
      {
%>
        <td width="100%" align="right">
          <a class="breadcrumbtrail" href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><img alt="<%=cm.cms( "header_download_alt" )%>" src="images/mini/download.gif" width="16" height="16" border="0" align="middle" /></a>
          <%=cm.cmsTitle( "header_download_tsv_title" )%><%=cm.cmsAlt( "header_download_alt" )%>
          <a class="breadcrumbtrail" href="<%=dynHeaderDownloadLink%>" title="<%=cm.cms( "header_download_tsv_title" )%>"><%=cm.cmsText( "header_download_tsv" )%></a>
          <%=cm.cmsTitle( "header_download_tsv_title" )%>
        </td>
<%
      }
%>
  </tr>
<%
  }
%>
  <tr>
    <td colspan="2">
      <div class="horizontal_line"><img alt="" src="images/pixel.gif" width="100%" height="1" /></div>
    </td>
  </tr>
  <tr>
    <td class="fontSmall" align="right">
      <span class="textVersion">
        <%=cm.cmsText("generic_last_update_01")%>
      </span>
    </td>
  </tr>
</table>
</div>  
<a name="main_content" title="<%=cm.cms("header_main_content")%>" accesskey="2"><img alt="" src="images/pixel.gif" width="1" height="1" /></a>
<%=cm.cmsTitle("header_main_content")%>