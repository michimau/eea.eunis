<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display a table with designations of a site. Used in (almost all) results of search functions from Sites module.

--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist,
                 java.util.ArrayList"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // This page is used in JSP include to display the designations for a site in results of a search.
  String idSite = request.getParameter("idSite");
  String idDesignation = request.getParameter("idDesignation");
  String idGeoscope = request.getParameter("idGeoscope");
  String sourceDB = request.getParameter("sourceDB");
  List results = new ArrayList();
  if(!sourceDB.equalsIgnoreCase("CORINE"))
  {
    String SiteType = SitesSearchUtility.getSiteType(idSite);

    if(!sourceDB.equalsIgnoreCase("NATURA2000") || !SiteType.equalsIgnoreCase("C"))
    {
      results = SitesSearchUtility.findDesignationsForSite(idDesignation, idGeoscope);
    } else {
      results = SitesSearchUtility.findDesignationsTypeC();
    }
  }
  if (results.size() > 0)
  {
    for (int i = 0; i < results.size(); i++)
    {
      Chm62edtDesignationsPersist designation = (Chm62edtDesignationsPersist)results.get(i);
      String description = designation.getDescription();
      if (description.equalsIgnoreCase("")) {
        description = designation.getDescriptionEn();
      }
      if (!description.equalsIgnoreCase(""))
      {
%>
        <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations/<%=designation.getIdGeoscope()%>:<%=designation.getIdDesignation()%>"><%=description%></a>
        <%=cm.cmsTitle("open_designations_factsheet")%>
<%
        if(i < results.size()-1)
        {
%>
          <hr />
<%
        }
      }
    }
  }
  else
  {
%>
    n/a
<%
  }
%>
