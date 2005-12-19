<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Used in advanced search - load saved data in input from field.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%
  // Set IdSession, NatureObject and criterianame variables
  String idsession = request.getParameter("idsession");
  String natureobject = request.getParameter("natureobject");
  String criterianame = request.getParameter("criterianame");

  if(idsession == null || idsession.length()==0 || idsession.equalsIgnoreCase("undefined") || idsession.equalsIgnoreCase("null")) {
    idsession=request.getSession().getId();
  }
  if(natureobject == null || natureobject.length()==0 || natureobject.equalsIgnoreCase("undefined")) {
    natureobject="";
  }

  // Set the database connection parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";
  int SQL_LIMIT=1000;

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

  // if NatureObject is valid
  if(!natureobject.equalsIgnoreCase(""))
  {
    ro.finsiel.eunis.search.AdvancedSearch tsas;
    tsas = new ro.finsiel.eunis.search.AdvancedSearch();
    // Set SourceDB for NatureObject = 'Sites'
    if (natureobject.equalsIgnoreCase("sites"))
    {
      tsas.SetSourceDB(ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria.getSourceDB(criterianame,natureobject,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD));
    }
    tsas.SetSQLLimit(SQL_LIMIT);
    tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    // Delete old data by IdSession
    tsas.DeleteSessionDataForNatureObject(idsession,natureobject);
    // Insert the saved search data
    if (natureobject.equalsIgnoreCase("sites"))
    {
      ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria.insertEunisAdvancedSearch(idsession,criterianame,natureobject,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria.insertEunisAdvancedSearchCriteria(idsession,criterianame,natureobject,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    } else {
      ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria.insertEunisAdvancedSearch(idsession,criterianame,natureobject,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria.insertEunisAdvancedSearchCriteria(idsession,criterianame,natureobject,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    }
  }
%>



