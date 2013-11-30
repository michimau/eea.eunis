<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species names' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,species_names_location";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_names_pageTitle") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="species-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>

    <script type="text/javascript" language="JavaScript">
    //<![CDATA[
      function openHelper1(ctl, lov, natureobject, oper) {
        var cur_ctl = eval(ctl);
        cur_ctl.value = trim(cur_ctl.value);
        var cur_oper = eval(oper);
        var control = eval(cur_ctl);
        var val = trim(cur_ctl.value);
        realOper = "<%=cm.cmsPhrase("contains")%>";
        if (val == "")
        {
          // errMessageForm1 - defined in species-names.js
          alert(errMessageForm1);
        } else {
          if (cur_oper.value == <%=Utilities.OPERATOR_CONTAINS%>) realOper = "<%=cm.cmsPhrase("contains")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_IS%>) realOper = "<%=cm.cms("species_names_02_Msg")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_STARTS%>) realOper = "<%=cm.cmsPhrase("starts with")%>";
          URL = 'search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + realOper;
          eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
        }
      }
    //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("Scientific name")%>
          </h1>

<!-- MAIN CONTENT -->
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
                              <%=cm.cmsPhrase("Classification, distribution and threat status of species selected by scientific name <br />(ex.: search all species having <strong>acrocephalus</strong> in their scientific name)")%>
                              <br />
                              <br />
                              <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                                <tr>
                                  <td>
                                    <strong>
                                      <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                                    </strong>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                                    <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox2"><%=cm.cmsPhrase("Order")%></label>
                                      <%=cm.cmsTitle("order_column")%>
                                    <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox3"><%=cm.cmsPhrase("Family")%></label>
                                      <%=cm.cmsTitle("family")%>
                                    <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox4"><%=cm.cmsPhrase("Scientific name")%></label>
                                    <input title="<%=cm.cms("valid_name")%>" id="checkbox6" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox6"><%=cm.cmsPhrase("Valid name")%></label>
                                      <%=cm.cmsTitle("valid_name")%>
                                    <input title="<%=cm.cms("vernacular_name")%>" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" checked="checked" /><label for="checkbox5"><%=cm.cmsPhrase("Vernacular Name")%></label>
                                      <%=cm.cmsTitle("vernacular_name")%>
                                  </td>
                                </tr>
                              </table>
                              <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />
                              <label for="scientificName"><%=cm.cmsPhrase("Scientific name")%></label>
                              <select id="select1" title="<%=cm.cmsPhrase("Operator")%>" name="relationOp">
                                <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                              <input id="scientificName" alt="<%=cm.cmsPhrase("Scientific name")%>" size="32" name="scientificName" value="" title="<%=cm.cms("species_scientific_name")%>" />
                              <%=cm.cmsTitle("species_scientific_name")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper1('document.eunis1.scientificName','ScientificName','Species','document.eunis1.relationOp');"><img alt="<%=cm.cmsPhrase("List of values")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <br />
                              <input type="checkbox" title="<%=cm.cms("search_synonyms")%>" id="searchSynonyms" name="searchSynonyms" value="true" checked="checked" />
                              <%=cm.cmsTitle("search_synonyms")%>
                              <label for="searchSynonyms"><%=cm.cmsPhrase("Search in synonyms")%></label>
                              <div style="width : 100%; text-align: right;">
                                <input id="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>"
                                  name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                                <input id="Search" type="submit" value="<%=cm.cmsPhrase("Search" )%>"
                                  name="submit" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
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
                                    //<![CDATA[
                                      var source1='';
                                      var source2='';
                                      var database1='';
                                      var database2='';
                                      var database3='';
                                    //]]>
                                    </script>
                                    <br />
                            <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-names-save-criteria.js"></script>
                            <%=cm.cmsPhrase("Save your criteria")%>:
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
                                  <%=cm.cmsPhrase("Vernacular Name")%>
                                </h1>
                                <%=cm.cmsPhrase("Classification, distribution and threat status of species selected by vernacular name<br />(ex.: search for species with popular name <strong>red fox</strong>)")%>
                                <br />
                                <br />
                                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                                  <tr>
                                    <td>
                                      <strong>
                                        <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                                      </strong>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>
                                      <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox11" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox11"><%=cm.cmsPhrase("Group")%></label>
                                      <input title="<%=cm.cms("order_column")%>" id="checkbox12" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox12"><%=cm.cmsPhrase("Order")%></label>
                                        <%=cm.cmsTitle("order_column")%>
                                      <input title="<%=cm.cms("family")%>" id="checkbox13" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox13"><%=cm.cmsPhrase("Family")%></label>
                                        <%=cm.cmsTitle("family")%>
                                      <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox14" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox14"><%=cm.cmsPhrase("Scientific name")%></label>
                                      <%--<input id="checkbox15" type="checkbox" name="showKingdom" value="true" checked="checked" /><label for="checkbox15"><%=cm.cmsPhrase("Kingdom")%></label>--%>
                                      <input title="<%=cm.cms("valid_name")%>" id="checkbox17" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox17"><%=cm.cmsPhrase("Valid name")%></label>
                                        <%=cm.cmsTitle("valid_name")%>
                                      <input title="<%=cm.cms("vernacular_name")%>" id="checkbox16" type="checkbox" name="showVernacularNames" value="true" disabled="disabled" checked="checked" /><label for="checkbox16"><%=cm.cmsPhrase("Vernacular names")%></label>
                                        <%=cm.cmsTitle("vernacular_name")%>
                                    </td>
                                  </tr>
                                </table>
                                <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />
                                <label for="vernacularName"><%=cm.cmsPhrase("Vernacular Name")%></label>
                                <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" size="1" name="relationOp">
                                  <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                                  <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                                  <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                                </select>
                                <input id="vernacularName" alt="<%=cm.cms("vernacular_name")%>" size="30" name="vernacularName" value=""
                                    title="<%=cm.cms("species_vernacular_name")%>" />
                                <%=cm.cmsAlt("vernacular_name")%>
                                <%=cm.cmsTitle("species_vernacular_name")%>
                                <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper2('species-names-choice.jsp')"><img alt="<%=cm.cmsPhrase("List of values")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                                <%=cm.cmsTitle("list_values_link")%>
                                &nbsp;
                                <strong>
                                <%=cm.cmsPhrase("in")%>
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
                                  <input id="Reset1" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                                  <input id="Search1" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
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
                                 //<![CDATA[
                                   // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
                                   var source1='';
                                   var source2='';
                                   var database1='';
                                   var database2='';
                                   var database3='';
                                //]]>
                                </script>
                                <br />
                                <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-names-vernacular-save-criteria.js"></script>
                                <%=cm.cmsPhrase("Save your criteria")%>:
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
                <%=cm.cmsMsg("species_names_02_Msg")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_names_pageTitle")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_names_anyLanguage")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
