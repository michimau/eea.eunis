<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
- Description : "Sites by designation types" function - Map page displaying results of search visually, on image from map server.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationDomain,
                 ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.designation_code.DesignationPaginator,
                 java.util.List" %><%@ page import="java.util.ArrayList"%><%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.designation_code.DesignationBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  String coordinates = "";
  boolean[] source = {
      formBean.getDB_NATURA2000() != null,
      formBean.getDB_CORINE() != null,
      formBean.getDB_DIPLOMA() != null,
      formBean.getDB_CDDA_NATIONAL() != null,
      formBean.getDB_CDDA_INTERNATIONAL() != null,
      formBean.getDB_BIOGENETIC() != null,
      false,
      formBean.getDB_EMERALD() != null
  };
  DesignationPaginator mapPaginator = new DesignationPaginator(new DesignationDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  mapPaginator.setPageSize(SitesSearchUtility.SITES_PER_MAP);
  mapPaginator.setCurrentPage(0);
  List sites = new ArrayList();
  try
  {
    sites = mapPaginator.getPage(0);
  }
  catch ( Exception ex )
  {
    ex.printStackTrace();
  }
  String sitesIds = "";
  for ( int i = 0; i < sites.size(); i++ )
  {
    DesignationPersist site = (DesignationPersist)sites.get(i);
    sitesIds += "'" + site.getIdSite() + "'";
    if ( i < sites.size() - 1 ) sitesIds += ",";
  }
  if ( sitesIds.equalsIgnoreCase( "" ) )
  {
    sitesIds = "none";
  }

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cms("site_by_designation_codes")%>
    </title>
  </head>
  <body style="margin : 0px; padding : 0px;" >
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="740" height="552" id="fl_eunis" align="middle">
      <param name="allowScriptAccess" value="sameDomain" />
      <param name="movie" value="gis/fl_eunis.swf" />
      <param name="quality" value="high" />
      <param name="bgcolor" value="#FFFFFF" />
      <param name="FlashVars"  value="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>&amp;v_sh_sites=<%=sitesIds%>" />
      <embed src="gis/fl_eunis.swf" FLASHVARS="v_color=<%=SessionManager.getUserPrefs().getThemeIndex()%>&amp;v_path=<%=application.getInitParameter( "DOMAIN_NAME" )%>&amp;v_sh_sites=<%=sitesIds%>" quality="high" bgcolor="#FFFFFF"  width="740" height="552" name="fl_eunis" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>
    <%=cm.cmsMsg("site_by_designation_codes")%>
  </body>
</html>