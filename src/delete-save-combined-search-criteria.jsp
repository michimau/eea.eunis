<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are deleted from database saved combined search criteria.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.users.UsersUtility"%>
<%
  // Set NatureObject variable
  String NatureObject = request.getParameter("natureobject");

  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined"))
  {
    System.out.println("No nature object found - Default to Species");
    NatureObject="Species";
  }

  // Set the database connection parameters
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  // The record witch will be deteled is identified by fromWhere and criterianame parameters,
  // so they must be not null
  if (request.getParameter("fromWhere") != null && request.getParameter("criterianame") != null)
  {
      UsersUtility.deleteUserSaveCombinedCriteria(request.getParameter("fromWhere"),
                                                  request.getParameter("criterianame"),
                                                  SQL_DRV,
                                                  SQL_URL,
                                                  SQL_USR,
                                                  SQL_PWD);
      // Redirect to page where delete record was made
      response.sendRedirect(request.getParameter("fromWhere")+"?expandCriterias=yes&action=keep&natureobject="+NatureObject);
      return;
  } else {
    // Redirect to index.jsp page
    response.sendRedirect("index.jsp");
    return;
  }
%>