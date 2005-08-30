<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display a table with designations of a site. Used in (almost all) results of search functions from Sites module.

--%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist,
                 java.util.ArrayList"%>
<%
  // This page is used in JSP include to display the designations for a site in results of a search.
  String idDesignation = request.getParameter("idDesignation");
  String idGeoscope = request.getParameter("idGeoscope");
  String sourceDB = request.getParameter("sourceDB");
  List results = new ArrayList();
  if(!sourceDB.equalsIgnoreCase("CORINE"))
  {
    results = SitesSearchUtility.findDesignationsForSite(idDesignation, idGeoscope);
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
      if (description.equalsIgnoreCase("")) {
        description = designation.getDescriptionFr();
      }
      if (!description.equalsIgnoreCase(""))
      {
%>
        <a title="Designation factsheet" href="designations-factsheet.jsp?idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=description%></a>
        <br />
<%
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