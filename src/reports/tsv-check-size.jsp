<%@ page import="ro.finsiel.eunis.search.Utilities"%><%@ page import="java.util.Enumeration"%><%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Check the size of the results and determine if should proceed to the report generation or not.
--%>
<%
  Utilities.dumpRequestParams( request );
  int resultsCount = Utilities.checkedStringToInt( request.getParameter( "resultsCount" ), 0 );
  int maxReportResults = Utilities.checkedStringToInt( application.getInitParameter( "TSV_REPORT_RESULTS_LIMIT_WARNING" ), 4000 );
  if ( resultsCount > maxReportResults )
  {
    String page_name = request.getParameter( "page_name" );
    String parameters = request.getParameter( "parameters" );
%>
    The number of results is too big and report generation might take a very long time.
    <br />
    Are you sure you want to proceed?
    <form name="reportGenerator" action="<%=page_name%>">
      <input type="hidden" name="skip_check" value="true" />
<%
  Enumeration en = request.getParameterNames();
  while( en.hasMoreElements() )
  {
    String name = ( String )en.nextElement();
    String val = request.getParameter( name );
    if ( !name.equalsIgnoreCase( "resultsCount" ) && !name.equalsIgnoreCase( "page_name" ) )
    {
      out.print( Utilities.writeFormParameter( name, val ) );
    }
  }
%>
      <label for="Yes" class="noshow">Yes, proceed to report generation</label>
      <input type="submit" name="Yes" id="Yes" value="Yes" title="Yes, proceed to report generation" class="inputTextField" />
      <label for="No" class="noshow">No, abort report generation and close the window</label>
      <input type="button" name="No" id="No" value="No" title="No, abort generation and close the window" onkeypress="javascript:window.close();" onclick="javascript:window.close();" class="inputTextField" />
    </form>
<%
  }
%>