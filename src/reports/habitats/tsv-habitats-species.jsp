<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Habitat species search tvs.
--%>
<%@ page import="ro.finsiel.eunis.reports.AbstractTSVReport,
                 ro.finsiel.eunis.reports.habitats.species.TSVHabitatSpeciesReport,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria"%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>TSV file report</title>
    <jsp:include page="../../header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="../../script/tsv.js"></script>
  </head>
  <body>
    <img alt="In progress" src="../../images/progress/top.jpg" width="400" height="178" />
<%
  try
  {
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
    AbstractTSVReport report = new TSVHabitatSpeciesReport(request.getSession().getId(),
                                                              formBean,
                                                              SessionManager.getShowEUNISInvalidatedSpecies(),
                                                              searchAttribute);
    int resultsCount = report.countResults();
    int maxReportResults = Utilities.checkedStringToInt( application.getInitParameter( "TSV_REPORT_RESULTS_LIMIT_WARNING" ), 4000 );
    boolean skip_check = Utilities.checkedStringToBoolean( request.getParameter( "skip_check" ), false );
    if ( resultsCount > maxReportResults && !skip_check )
    {
%>
    <jsp:include page="../tsv-check-size.jsp">
      <jsp:param name="resultsCount" value="<%=resultsCount%>" />
      <jsp:param name="page_name" value="tsv-habitats-species.jsp" />
    </jsp:include>
<%
    }
    else
    {
%>
    <img id="loading" src="<%=request.getContextPath()%>/images/loading_tsv.gif" width="200" height="10" alt="Loading animation" />
    <div id="status">
      &nbsp;
    </div>
    <script language="JavaScript" type="text/javascript">
      <!--
      updateText('Generating TSV file, please wait...');
      //-->
    </script>
<%
    out.flush();
    report.writeData();
%>
    <noscript>Your browser does not support JavaScript!</noscript>

    <script language="JavaScript" type="text/javascript">
    <!--
       updateText('The TSV document is ready.');
       showLoadingProgress( false );
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <a title="Open TSV(Tab Separated Values) file" target="_blank" href="<%=request.getContextPath()%>/temp/<%=report.getFilename()%>">Open TSV(Tab Separated Values) file</a>
<%
    }
  }
  catch( Exception ex )
  {
%>
    <script language="JavaScript" type="text/javascript">
    <!--
       updateText('An error occurred while generating document.');
       showLoadingProgress( false );
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
    ex.printStackTrace();
  }
%>
  </body>
</html>