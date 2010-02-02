<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats sites' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%> 
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectDomain,
                 ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  //int tab = Utilities.checkedStringToInt(request.getParameter("tab"), 0);
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  
  String p = request.getParameter("page");
  int limit = 50;
  if(p == null) p = "1";
  int mypage = Integer.parseInt(p);
  int myEnd = (limit * mypage);
  int myBase = (myEnd - limit);
  
  try
  {
    String isGoodHabitat = " IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ";
    // Sites for which this habitat is recorded.
    List sites = new SitesByNatureObjectDomain().findCustom("SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_HABITAT AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE   " + isGoodHabitat + " AND A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT");
      
    int count = sites.size();
    
    int last = myEnd;
    if(count <= myEnd)
    	last = count;
    
    // Sites for which this habitat is recorded - with paging
    List sitesSubList = new SitesByNatureObjectDomain().findCustom("SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_HABITAT AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE   " + isGoodHabitat + " AND A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT LIMIT "+myBase+","+limit);

    // Sites for habitat subtypes.
    List sitesForSubtypes = new SitesByNatureObjectDomain().findCustom("SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_HABITAT AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE A.ID_NATURE_OBJECT =" + factsheet.getHabitat().getIdNatureObject() +
      (factsheet.isAnnexI() ? " and right(A.code_2000,2) <> '00' and length(A.code_2000) = 4 AND if(right(A.code_2000,1) = '0',left(A.code_2000,3),A.code_2000) like '" + factsheet.getCode2000() + "%' and A.code_2000 <> '" + factsheet.getCode2000() + "'" : " AND A.EUNIS_HABITAT_CODE like '" + factsheet.getEunisHabitatCode() + "%' and A.EUNIS_HABITAT_CODE<> '" + factsheet.getEunisHabitatCode() + "'") +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT");

    if( ( null != sites && !sites.isEmpty() ) || ( null != sitesForSubtypes && !sitesForSubtypes.isEmpty() ) )
    {
      String ids = "";
      int maxSitesPerMap = Utilities.checkedStringToInt( application.getInitParameter( "MAX_SITES_PER_MAP" ), 2000 );
      if ( sites.size() < maxSitesPerMap )
      {
        for(int i = 0; i < sites.size(); i++)
        {
          SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sites.get(i);
          ids += "'" + site.getIDSite() + "'";
          if(i < sites.size() - 1) ids += ",";
        }
%>

  <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
    <input type="hidden" name="sites" value="<%=ids%>" />
    <input type="submit" name="Show map" id="ShowMap" value="<%=cm.cms("show_map")%>" title="<%=cm.cms("show_map")%>" class="standardButton" />
    <%=cm.cmsTitle("show_map")%>
  </form>
<%
      }
%>
  <br />
  <table width="100%" border="0">
  	<tr>
  		<td>
  			<h2>
			    <%=cm.cmsPhrase("Sites for which this habitat type is recorded")%>
   		    </h2>
  		</td>
  		<td align="right" valign="top">
			<a href="habitats-factsheet-sites-kml.jsp?idHabitat=<%=idHabitat%>" title="<%=cm.cms( "header_download_kml_title" )%>"><%=cm.cmsPhrase( "See sites in Google Earth (KML file, pre-requires Google Earth installed) " )%></a>
      		<%=cm.cmsTitle( "header_download_kml_title" )%>
		</td>
  	</tr>
  </table>
  <table summary="<%=cm.cms("habitat_sites")%>" class="listing" width="90%">
    <thead>
    <%
    if (sitesSubList != null && sitesSubList.size() > 0){
    %>
      <tr>
     	<td colspan="4" align="center" height="25">
     		<b>Found <%=count%> records. Showing records <%=myBase%> - <%=last%></b>
     	</td>
      </tr>
    <%
	}
    %>
      <tr>
        <th width="15%" style="text-align: left;">
          <%=cm.cmsPhrase("Site code")%>
        </th>
        <th width="15%" style="text-align: left;">
          <%=cm.cmsPhrase("Source data set")%>
        </th>
        <th width="20%" style="text-align: left;">
          <%=cm.cmsPhrase("Country")%>
        </th>
        <th width="50%" style="text-align: left;">
          <%=cm.cmsPhrase("Site name")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      // List of sites for which this habitat is recorded.
      for(int i = 0; i < sitesSubList.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sitesSubList.get(i);
        String SiteName = Utilities.formatString(site.getName());
        SiteName = SiteName.replaceAll("&","&amp;");
%>
    <tr<%=cssClass%>>
      <td>
        <%=Utilities.formatString(site.getIDSite())%>
      </td>
      <td>
        <strong>
          <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
        </strong>
      </td>
      <td>
        <%=Utilities.formatString(site.getAreaNameEn())%>
      </td>
      <td>
        <a href="sites/<%=site.getIDSite()%>"><%=SiteName%></a>
      </td>
    </tr>
<%
      }
      if(count > limit){
	                		%>
			<table summary="layout" width="90%" cellspacing="1" cellpadding="1" style="border-collapse:collapse">
				<tr>
					<%
					if(mypage > 1){
    					%>
    					<td align="left"><a href="habitats-factsheet.jsp?tab=4&amp;idHabitat=<%=idHabitat%>&amp;page=<%=(mypage - 1)%>">previous page</a></td>
    					<%	
					}
					%>
					<td align="center" height="25">
					<%
						int i=0;
						int cnt = count;
                        while(cnt>0) {
                            i++;
                            if(i != mypage){ %>
                            	<a href="habitats-factsheet.jsp?tab=4&amp;idHabitat=<%=idHabitat%>&amp;page=<%=i%>"><%=i%></a>&nbsp;&nbsp;
                            <% } else { %>
                            	<%=i%>&nbsp;&nbsp;
                            <% }
                            cnt-=limit;
                        }
					%>
					</td>
					<%
					if(count > myEnd){
    					%>
    					<td align="right"><a href="habitats-factsheet.jsp?tab=4&amp;idHabitat=<%=idHabitat%>&amp;page=<%=(mypage + 1)%>">next page</a></td>
    					<%	
					}
					%>
				</tr>
			</table>
		<%
	}
%>
    </tbody>
  </table>
  <%=cm.cmsMsg("habitat_sites")%>
<%
      if(null != sitesForSubtypes && !sitesForSubtypes.isEmpty())
      {
%>
  <br />
  <h2>
    <%=cm.cmsPhrase("Sites for habitat subtypes")%>
  </h2>
  <table summary="<%=cm.cms("habitat_related_sites")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th width="15%" style="text-align: left;">
          <%=cm.cmsPhrase("Site code")%>
        </th>
        <th width="15%" style="text-align: left;">
          <%=cm.cmsPhrase("Source data set")%>
        </th>
        <th width="20%" style="text-align: left;">
          <%=cm.cmsPhrase("Country")%>
        </th>
        <th width="50%" style="text-align: left;">
          <%=cm.cmsPhrase("Site name")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
        // List of sites for habitat subtypes
        for(int i = 0; i < sitesForSubtypes.size(); i++)
        {
          String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
          SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) sitesForSubtypes.get(i);
          String SiteName = Utilities.formatString(site.getName());
          SiteName = SiteName.replaceAll("&","&amp;");
%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.formatString(site.getIDSite())%>
        </td>
        <td>
          <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
        </td>
        <td>
          <%=Utilities.formatString(site.getAreaNameEn())%>
        </td>
        <td>
          <a title="<%=cm.cms("open_site_factsheet")%>" href="sites/<%=site.getIDSite()%>"><%=SiteName%></a>
          <%=cm.cmsTitle("open_site_factsheet")%>
        </td>
      </tr>
<%
        }
%>
    </tbody>
  </table>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_related_sites")%>
  <%=cm.br()%>
<%
      }
    }
  }
  catch(Exception _ex) {
    _ex.printStackTrace();
  }
%>
