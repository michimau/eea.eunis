<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are deleted from database saved easy search criteria.
--%>
<%@ page import="ro.finsiel.eunis.search.users.UsersUtility"%>
<%
  // Set the database connection parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

  // The record witch will be deteled is identified by userName, pageName and criteriaName parameters,
  // so they must be not null
  if (request.getParameter("userName") != null
          && request.getParameter("pageName") != null
          && request.getParameter("criteriaName") != null)
  {
    // Delete the record
    UsersUtility.deleteUserSaveCriteria(request.getParameter("userName"),
                                        request.getParameter("pageName"),
                                        request.getParameter("criteriaName"),
                                        SQL_DRV,
                                        SQL_URL,
                                        SQL_USR,
                                        SQL_PWD);
    // Redirect to page where delete record was made
    response.sendRedirect(request.getParameter("pageName")+"?expandSearchCriteria=yes");
    return;
  } else {
    // Redirect to index.jsp page
    response.sendRedirect("index.jsp");
    return;
  }
%>