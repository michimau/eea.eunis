<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are deleted from database saved easy search criteria.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.users.UsersUtility"%>
<%

  // The record witch will be deteled is identified by userName, pageName and criteriaName parameters,
  // so they must be not null
  if (request.getParameter("userName") != null
          && request.getParameter("pageName") != null
          && request.getParameter("criteriaName") != null)
  {
    // Delete the record
    UsersUtility.deleteUserSaveCriteria(request.getParameter("userName"),
                                        request.getParameter("pageName"),
                                        request.getParameter("criteriaName")
    );
    // Redirect to page where delete record was made
    response.sendRedirect(request.getParameter("pageName")+"?expandSearchCriteria=yes");
    return;
  } else {
    // Redirect to index.jsp page
    response.sendRedirect("index.jsp");
    return;
  }
%>
