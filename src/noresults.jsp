<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : No results
--%>
</td>
</tr>
</table>
<br />
<%
   String fromRefine = (request.getParameter("fromRefine") != null ? request.getParameter("fromRefine") : "false");

   if("true".equalsIgnoreCase(fromRefine))
   {
%>
      No results found for refine search.
<%
} else {
%>
  No results found for this search.
<%
    }
%>
  <br />
  <br />
  The input rules were probably too restrictive, please try a more generic approach.
  <br />
  <br />
  Please go
  <strong>
    <a href="javascript:history.go(-1)" title="Go to previous page">Back</a>
  </strong>
  and review the search criteria.
  <br />
  <br />
  <br />
  <br />
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="noresults.jsp" />
</jsp:include>
</body>
</html>