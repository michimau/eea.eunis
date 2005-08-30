<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites year" function - Map page displaying results of search visually, on image from map server.
--%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.CountryUtil,
                 ro.finsiel.eunis.search.sites.year.YearPaginator,
                 ro.finsiel.eunis.jrfTables.sites.year.YearDomain,
                 ro.finsiel.eunis.jrfTables.sites.year.YearPersist,
                 ro.finsiel.eunis.WebContentManagement"%><%@ page import="java.util.ArrayList"%>
<%@ page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.year.YearBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  boolean[] source = {(formBean.getDB_NATURA2000()==null?false:true),(formBean.getDB_CORINE()==null?false:true),(formBean.getDB_DIPLOMA()==null?false:true),(formBean.getDB_CDDA_NATIONAL()==null?false:true),(formBean.getDB_CDDA_INTERNATIONAL()==null?false:true),(formBean.getDB_BIOGENETIC()==null?false:true),false};
  YearPaginator mapPaginator = new YearPaginator(new YearDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), source));
  List sites = new ArrayList();
  try
  {
    mapPaginator.setPageSize( mapPaginator.countResults() );
    mapPaginator.setCurrentPage( 0 );
    sites = mapPaginator.getPage( 0 );
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
  String sitesIds = "";
  for ( int i = 0; i < sites.size(); i++ )
  {
    YearPersist site = ( YearPersist )sites.get( i );
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
    <title>
      <%=contentManagement.getContent("sites_year-map_title", false )%>
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
  </body>
</html>