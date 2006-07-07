<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species names' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                 java.util.Iterator,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.names.NameSortCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <script type="text/javascript" language="JavaScript">
    <!--
      function openHelper1(ctl, lov, natureobject, oper) {
        var cur_ctl = eval(ctl);
        cur_ctl.value = trim(cur_ctl.value);
        var cur_oper = eval(oper);
        var control = eval(cur_ctl);
        var val = trim(cur_ctl.value);
        realOper = "<%=cm.cms("contains")%>";
        if (val == "")
        {
          // errMessageForm1 - defined in species-names.js
          alert(errMessageForm1);
        } else {
          if (cur_oper.value == <%=Utilities.OPERATOR_CONTAINS%>) realOper = "<%=cm.cms("contains")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_IS%>) realOper = "<%=cm.cms("species_names_02_Msg")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_STARTS%>) realOper = "<%=cm.cms("starts_with")%>";
          URL = 'search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + realOper;
          eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
        }
      }
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_names_pageTitle")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getHeader?site=eunis" )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
              <jsp:include page="header-dynamic.jsp">
                <jsp:param name="location" value="home#index.jsp,species#species.jsp,species_names_location" />
                <jsp:param name="helpLink" value="species-help.jsp" />
              </jsp:include>
              <table summary="layout" width="100%" border="0">
                <tr>
                  <td>
                      <form name="eunis1" method="get" onsubmit="return(validateForm1());" action="species-names-result.jsp">
                          <input type="hidden" name="typeForm" value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC%>" />
                          <input type="hidden" name="showScientificName" value="true" />
                          <input type="hidden" name="searchVernacular" value="false" />
                          <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
                          <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                        <table summary="layout" width="100%" border="0" style="text-align:left">
                          <tr>
                            <td>
                              <h1>
                                <%=cm.cmsText("scientific_name")%>
                              </h1>
                              <%=cm.cmsText("species_names_searchExample1")%>
                              <br />
                              <br />
                              <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                                <tr>
                                  <td>
                                    <strong>
                                      <%=cm.cmsText("search_will_provide_2")%>
                                    </strong>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    <input title="<%=cm.cms("group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox1"><%=cm.cmsText("group")%></label>
                                      <%=cm.cmsTitle("group")%>
                                    <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox2"><%=cm.cmsText("order_column")%></label>
                                      <%=cm.cmsTitle("order_column")%>
                                    <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox3"><%=cm.cmsText("family")%></label>
                                      <%=cm.cmsTitle("family")%>
                                    <input title="<%=cm.cms("scientific_name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox4"><%=cm.cmsText("scientific_name")%></label>
                                      <%=cm.cmsTitle("scientific_name")%>
                                    <input title="<%=cm.cms("valid_name")%>" id="checkbox6" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox6"><%=cm.cmsText("valid_name")%></label>
                                      <%=cm.cmsTitle("valid_name")%>
                                    <input title="<%=cm.cms("vernacular_name")%>" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" checked="checked" /><label for="checkbox5"><%=cm.cmsText("vernacular_name")%></label>
                                      <%=cm.cmsTitle("vernacular_name")%>
                                  </td>
                                </tr>
                              </table>
                              <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                              <%=cm.cmsAlt("field_mandatory")%>
                              <%=cm.cmsTitle("field_mandatory")%>
                              <strong>
                                <label for="scientificName"><%=cm.cmsText("scientific_name")%></label>
                              </strong>
                              <label for="select1" class="noshow"><%=cm.cms("operator")%></label>
                              <select id="select1" title="<%=cm.cms("operator")%>" name="relationOp">
                                <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("starts_with")%></option>
                              </select>
                              <%=cm.cmsTitle("operator")%>
                              <%=cm.cmsLabel("operator")%>
                              <input id="scientificName" alt="<%=cm.cms("scientific_name")%>" size="32" name="scientificName" value="" title="<%=cm.cms("species_scientific_name")%>" />
                              <%=cm.cmsAlt("scientific_name")%>
                              <%=cm.cmsTitle("species_scientific_name")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper1('document.eunis1.scientificName','ScientificName','Species','document.eunis1.relationOp');"><img alt="<%=cm.cms("list_of_values")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <%=cm.cmsAlt("list_of_values")%>
                              <br />
                              <input type="checkbox" title="<%=cm.cms("search_synonyms")%>" id="searchSynonyms" name="searchSynonyms" value="true" checked="checked" />
                              <%=cm.cmsTitle("search_synonyms")%>
                              <label for="searchSynonyms"><%=cm.cmsText("search_synonyms")%></label>
                              <div style="width : 100%; text-align: right;">
                                <input id="Reset" type="reset" value="<%=cm.cms("reset")%>"
                                  name="Reset" class="standardButton" title="<%=cm.cms("reset")%>" />
                                <%=cm.cmsInput("reset")%>
                                <%=cm.cmsTitle("reset")%>
                                <input id="Search" type="submit" value="<%=cm.cms( "search" )%>"
                                  name="submit" class="searchButton" title="<%=cm.cms("search")%>" />
                                  <%=cm.cmsTitle("search")%>
                                  <%=cm.cmsInput("search")%>
                              </div>
                          </td>
                        </tr>
                      </table>
                    </form>
                      <%
                        if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                        {
                      %>
                                 <script type="text/javascript" language="JavaScript">
                                    <!--
                                      var source1='';
                                      var source2='';
                                      var database1='';
                                      var database2='';
                                      var database3='';
                                    //-->
                                    </script>
                                    <br />
                            <script language="JavaScript" type="text/javascript" src="script/species-names-save-criteria.js"></script>
                            <%=cm.cmsText("save_your_criteria")%>:
                            <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm1(),'species-names.jsp','2','eunis1',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                            <%=cm.cmsTitle("save_open_link")%>
                            <%=cm.cmsAlt("save_open_link")%>
                      <%
                        }
                      %>
                      <br />
                      <hr class="horizontal_line" />
                      <br />
                    </td>
                  </tr>
                  <tr>
                  <td>
                      <form name="eunis2" method="get" onsubmit="return(validateForm2());" action="species-names-result.jsp">
                        <input type="hidden" name="typeForm" value="<%=NameSearchCriteria.CRITERIA_VERNACULAR%>" />
                        <input type="hidden" name="expand" value="true" />
                        <input type="hidden" name="showScientificName" value="true" />
                        <input type="hidden" name="showVernacularNames" value="true" />
                        <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
                        <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                        <input type="hidden" name="noSoundex" value="true" />
                          <table summary="layout" width="100%" border="0" style="text-align:left">
                            <tr>
                              <td>
                                <h1>
                                  <%=cm.cmsText("vernacular_name")%>
                                </h1>
                                <%=cm.cmsText("species_names_searchExample2")%>
                                <br />
                                <br />
                                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                                  <tr>
                                    <td>
                                      <strong>
                                        <%=cm.cmsText("search_will_provide_2")%>
                                      </strong>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>
                                      <input title="<%=cm.cms("group")%>" id="checkbox11" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox11"><%=cm.cmsText("group")%></label>
                                        <%=cm.cmsTitle("group")%>
                                      <input title="<%=cm.cms("order_column")%>" id="checkbox12" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox12"><%=cm.cmsText("order_column")%></label>
                                        <%=cm.cmsTitle("order_column")%>
                                      <input title="<%=cm.cms("family")%>" id="checkbox13" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox13"><%=cm.cmsText("family")%></label>
                                        <%=cm.cmsTitle("family")%>
                                      <input title="<%=cm.cms("scientific_name")%>" id="checkbox14" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox14"><%=cm.cmsText("scientific_name")%></label>
                                        <%=cm.cmsTitle("scientific_name")%>
                                      <%--<input id="checkbox15" type="checkbox" name="showKingdom" value="true" checked="checked" /><label for="checkbox15"><%=cm.cmsText("kingdom")%></label>--%>
                                      <input title="<%=cm.cms("valid_name")%>" id="checkbox17" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox17"><%=cm.cmsText("valid_name")%></label>
                                        <%=cm.cmsTitle("valid_name")%>
                                      <input title="<%=cm.cms("vernacular_name")%>" id="checkbox16" type="checkbox" name="showVernacularNames" value="true" disabled="disabled" checked="checked" /><label for="checkbox16"><%=cm.cmsText("vernacular_names")%></label>
                                        <%=cm.cmsTitle("vernacular_name")%>
                                    </td>
                                  </tr>
                                </table>
                                <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                                <%=cm.cmsAlt("field_mandatory")%>
                                <%=cm.cmsTitle("field_mandatory")%>
                                <strong>
                                  <label for="vernacularName"><%=cm.cmsText("vernacular_name")%></label>
                                </strong>
                                <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
                                <select id="select2" title="<%=cm.cms("operator")%>" size="1" name="relationOp">
                                  <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("is")%></option>
                                  <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                                  <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("starts_with")%></option>
                                </select>
                                <%=cm.cmsLabel("operator")%>
                                <%=cm.cmsTitle("operator")%>
                                <input id="vernacularName" alt="<%=cm.cms("vernacular_name")%>" size="30" name="vernacularName" value=""
                                    title="<%=cm.cms("species_vernacular_name")%>" />
                                <%=cm.cmsAlt("vernacular_name")%>
                                <%=cm.cmsTitle("species_vernacular_name")%>
                                <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper2('species-names-choice.jsp')"><img alt="<%=cm.cms("list_of_values")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                                <%=cm.cmsTitle("list_values_link")%>
                                <%=cm.cmsAlt("list_of_values")%>
                                &nbsp;
                                <strong>
                                <%=cm.cmsText("species_names_in")%>
                                </strong>
                                <label for="select3" class="noshow"><%=cm.cms("language")%></label>
                                <select id="select3" title="<%=cm.cms("language")%>" size="1" name="language">
                                  <option value="any" selected="selected">
                                    <%=cm.cms("species_names_anyLanguage")%>
                                  </option>
                                  <%
                                    // List of languages
                                     String SQL_DRV = application.getInitParameter("JDBC_DRV");
                                     String SQL_URL = application.getInitParameter("JDBC_URL");
                                     String SQL_USR = application.getInitParameter("JDBC_USR");
                                     String SQL_PWD = application.getInitParameter("JDBC_PWD");

                                    Iterator it = SpeciesSearchUtility.findAllLanguagesWithVernacularNames(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD).iterator();
                                    while (it.hasNext())
                                    {
                                      String language = (String)it.next();%>
                                      <option value="<%=language%>"><%=language%></option>
                                  <%
                                    }
                                  %>
                                </select>
                                <%=cm.cmsLabel("language")%>
                                <%=cm.cmsTitle("language")%>
                                <br />
                                <div style="width: 100%; text-align:right">
                                  <input id="Reset1" type="reset" value="<%=cm.cms("reset")%>" name="Reset" class="standardButton" title="<%=cm.cms("reset")%>" />
                                  <%=cm.cmsInput("reset")%>
                                  <%=cm.cmsTitle("reset")%>
                                  <input id="Search1" type="submit" value="<%=cm.cms("search")%>" name="submit" class="searchButton" title="<%=cm.cms("search")%>" />
                                  <%=cm.cmsLabel("search")%>
                                  <%=cm.cmsInput("search")%>
                                  <%=cm.cmsTitle("search")%>
                                </div>
                              </td>
                            </tr>
                          </table>
                        </form>
                      <%
                              // Save search criteria
                              if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                              {
                      %>
                                 <script type="text/javascript" language="JavaScript">
                                 <!--
                                   // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
                                   var source1='';
                                   var source2='';
                                   var database1='';
                                   var database2='';
                                   var database3='';
                                //-->
                                </script>
                                <br />
                                <script language="JavaScript" type="text/javascript" src="script/species-names-vernacular-save-criteria.js"></script>
                                <%=cm.cmsText("save_your_criteria")%>:
                                <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm2(),'species-names.jsp','4','eunis2',attributesNames2,formFieldAttributes2,operators2,formFieldOperators2,booleans2,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                                <%=cm.cmsTitle("save_open_link")%>
                                <%=cm.cmsAlt("save_open_link")%>
                                    <%
                                        // Set Vector for URL string
                                        Vector show = new Vector();
                                        show.addElement("showGroup");
                                        show.addElement("showFamily");
                                        show.addElement("showOrder");
                                        show.addElement("showScientificName");
                                        show.addElement("showVernacularNames");
                                        String pageName = "species-names.jsp";
                                        String pageNameResult = "species-names-result.jsp?"+Utilities.writeURLCriteriaSave(show);
                                        // Expand or not save criterias list
                                        String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
                                    %>
                              <br />

                                          <jsp:include page="show-criteria-search.jsp">
                                            <jsp:param name="pageName" value="<%=pageName%>" />
                                            <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                                            <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                                          </jsp:include>
                          <%
                                  }
                          %>
                    </td>
                  </tr>
                </table>
                <%=cm.br()%>
                <%=cm.cmsMsg("contains")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_names_02_Msg")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("starts_with")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_names_pageTitle")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("is")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("contains")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("starts_with")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_names_anyLanguage")%>
                <%=cm.br()%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="species-names.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getFooter?site=eunis" )%>
    </div>
  </body>
</html>