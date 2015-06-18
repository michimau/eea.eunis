<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are deleted from database saved advanced search criteria.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.users.UsersUtility"%>
<%

  // The record witch will be deteled is identified by natureobject, fromWhere and criterianame parameters,
  // so they must be not null
  if (request.getParameter("natureobject") != null
          && request.getParameter("fromWhere") != null
          && request.getParameter("criterianame") != null)
  {
      // Delete the record
      UsersUtility.deleteUserSaveAdvancedCriteria(request.getParameter("natureobject"),
                                                  request.getParameter("fromWhere"),
                                                  request.getParameter("criterianame")
      );
      // Redirect to page where delete record was made
      response.sendRedirect(request.getParameter("fromWhere")+"?expandCriterias=yes");
  } else
  {
  // Redirect to index.jsp page
  response.sendRedirect("index.jsp");
  }
%>
