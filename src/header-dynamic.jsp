<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Header dynamic'
--%>
<%@page import="ro.finsiel.eunis.backtrail.BacktrailObject,
                 ro.finsiel.eunis.backtrail.BacktrailUtil,
                java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
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
<%
  // Request parameters.
  String dynHeaderLocation = request.getParameter("location");
  String dynHeaderHelpLink = request.getParameter("helpLink");
  String dynHeaderPrintLink = request.getParameter("printLink");
  String dynHeaderDownloadLink = request.getParameter("downloadLink");

  // Get the backtrail from string (order of objects is preserved).
  Vector backtrailObjects = BacktrailUtil.parseBacktrailString(dynHeaderLocation);
//  String lightColor = (null != dynHeadSessionManager) ? dynHeadSessionManager.getThemeManager().getLightColor() : "#669ACC";
//  String darkColor = (null != dynHeadSessionManager) ? dynHeadSessionManager.getThemeManager().getDarkColor() : "#669ACC";
%>
<jsp:include page="header-static.jsp"/>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<div style="width : 740px;">
<table summary="layout" border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td width="60%">
      <img alt="Current location in web site" src="images/path.gif" width="20" height="16" align="middle" />
      <%
        for (int i = 0; i < backtrailObjects.size(); i++)
        {
          BacktrailObject backtrailObject = ( BacktrailObject ) backtrailObjects.elementAt(i);
          backtrailObject.setCssStyle( "breadcrumbtrail" );
      %>
          <%if (i > 0) {%>
            <span class="breadcrumbtrailNormalFont">&gt;&gt;&nbsp;</span>
         <%}%>
         <%=backtrailObject.toURLString()%>
      <%
        }
      %>
    </td>
    <%
      if (null != dynHeaderHelpLink)
      {
    %>
        <td width="7%" align="left">
          <a class="breadcrumbtrail" href="<%=dynHeaderHelpLink%>" title="Help information">Help</a>
        </td>
    <%
      } else {
    %>
        <td width="7%" align="left">
          &nbsp;
        </td>
    <%
      }
    %>
    <%
      if (null != dynHeaderPrintLink)
      {
    %>
        <td width="15%" align="left">
          <a class="breadcrumbtrail" href="<%=dynHeaderPrintLink%>" title="Create downloadable PDF page content">Downloadable PDF</a>
        </td>
    <%
      } else {
    %>
        <td width="10%" align="left">&nbsp;</td>
    <%
      }
    %>
    <%
      if (null != dynHeaderDownloadLink)
      {
    %>
        <td width="15%" align="left">
          <a class="breadcrumbtrail" href="<%=dynHeaderDownloadLink%>" title="Create Excel compatible file with search result">
            <img alt="Download" src="images/mini/download.gif" width="16" height="16" border="0" align="middle" />
            </a>
          <a class="breadcrumbtrail" href="<%=dynHeaderDownloadLink%>" title="Create Excel compatible file with search result">Download results</a>
        </td>
    <%
      }
      else
      {
    %>
        <td width="15%" align="left">
          &nbsp;
        </td>
    <%
      }
    %>
  </tr>
  <tr>
    <td colspan="5">
      <div class="horizontal_line"><img alt="" src="images/pixel.gif" width="740" height="1" /></div>
    </td>
  </tr>
  <tr>
    <td colspan="5" class="fontSmall" align="right">
      <span class="textVersion">
        <%=contentManagement.getContent("generic_last_update_01")%>
      </span>
    </td>
  </tr>
</table>
</div>
<a name="main_content" title="Main content of the page" accesskey="2"><img alt="" src="images/pixel.gif" width="1" height="1" /></a>
