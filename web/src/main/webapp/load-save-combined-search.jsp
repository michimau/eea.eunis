<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Used in combined search - load saved data in input from field.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%
  // Set IdSession and NatureObject variables
  String IdSession = request.getParameter("idsession");

  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }

  String NatureObject = request.getParameter("natureobject");

  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    System.out.println("No nature object found - Default to Species");
    NatureObject="";
  }

  String criterianame = request.getParameter("criterianame");

  int SQL_LIMIT=1000;

  // if NatureObject is valid
  if(!NatureObject.equalsIgnoreCase(""))
  {
    ro.finsiel.eunis.search.CombinedSearch tsas;
    tsas = new ro.finsiel.eunis.search.CombinedSearch();
    // Set SourceDB for NatureObject = 'Sites'
    if (NatureObject.equalsIgnoreCase("sites"))
    {
      tsas.SetSourceDB(ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria.getSourceDB(criterianame));
    }
    tsas.SetSQLLimit(SQL_LIMIT);
    // Delete old data by IdSession
    tsas.DeleteSessionData(IdSession);
    // Insert the saved search data
    ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria.insertEunisCombinedSearch(IdSession,criterianame,NatureObject);
    ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria.insertEunisCombinedSearchCriteria(IdSession,criterianame,NatureObject);
  }
%>



