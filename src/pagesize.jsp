<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Change number of results per page
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%
  /* PREAMBLE - This page represents the form to change the number of results displayed per page */
  // INPUT VARIABLES. This must exist in your including JSP !!! If you DO NOT, compilation error would occurr. I think
  // this is good since all pages would 'speak same language' so would appear discrepancies. For example all Form Beans
  // will have to be named formBean or this code would not work etc etc etc...you know what I mean :))
  // int guid                   - Global Unique IDentifier - This is a plain number 0, 1, 2...used to be incremented 
  //                              each time the page is included into a page because of the <form name='UNIQUE NAME">
  //                              pre-requisite (in plain english: There cannot be two forms in a page with the 
  //                              same name!). Cannot declare here due to compilation!
  // String pageName            - Currently using jsp - the JSP where this page is included.
  // Vector pageSizeFormFields  - This Vector would contain the form fields you want to be spitted out :) on the page
  // AbstractPaginator paginator - Paginator used to do the pagination...blah 
  int guidPageSize = Utilities.checkedStringToInt(request.getParameter("guid"), 1);
  String pageNameSize = request.getParameter("pageName");
  int pageSizeSize = Utilities.checkedStringToInt(request.getParameter("pageSize"), 10);
  if (pageSizeSize <= 0) pageSizeSize = 10;
  String toURLParamSize = request.getParameter("toFORMParam");

  int maxResultsPerPage = Utilities.checkedStringToInt( application.getInitParameter( "MAX_RESULTS_PER_PAGE" ), 250 );
%>
<br />
<form name="changePageSize<%=guidPageSize%>" method="get" action="<%=pageNameSize%>" onsubmit="if (checkRange()) return true; return false;">
  <label for="pageSize">
    Results displayed per page&nbsp;(max. <%=maxResultsPerPage%>)
  </label>
  <input title="Results displayed per page" class="inputTextFieldCenter" name="pageSize" id="pageSize" type="text" size="3" value="<%=pageSizeSize%>" />
  <label for="changePageSizeButton" class="noshow">Change</label>
  <input id="changePageSizeButton" title="Change" type="submit" name="Go" value="Change" class="inputTextField" />
  <%=toURLParamSize%>
  <script language="JavaScript" type="text/javascript">
    <!--
    function checkRange()
    {
      var currPageSize = parseInt(document.changePageSize<%=guidPageSize%>.pageSize.value);
      if (currPageSize > <%=maxResultsPerPage%>)
      {
        alert("Max. results displayed per page is set to <%=maxResultsPerPage%>");
        return false;
      }
      return true;
    }
    // -->
  </script>
  <noscript>Your browser does not support JavaScript!</noscript>
</form>