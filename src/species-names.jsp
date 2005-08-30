<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species names' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                 java.util.Iterator,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.names.NameSortCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <script type="text/javascript" language="JavaScript">
    <!--
      function openHelper1(ctl, lov, natureobject, oper) {
        var cur_ctl = eval(ctl);
        cur_ctl.value = trim(cur_ctl.value);
        var cur_oper = eval(oper);
        var control = eval(cur_ctl);
        var val = trim(cur_ctl.value);
        realOper = "contains";
        if (val == "")
        {
          // errMessageForm1 - defined in species-names.js
          alert(errMessageForm1);
        } else {
          if (cur_oper.value == <%=Utilities.OPERATOR_CONTAINS%>) realOper = "contains";
          if (cur_oper.value == <%=Utilities.OPERATOR_IS%>) realOper = "equal with";
          if (cur_oper.value == <%=Utilities.OPERATOR_STARTS%>) realOper = "starts with";
          URL = 'search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + realOper;
          eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
        }
      }
    //-->
    </script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_names_pageTitle", false )%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Names" />
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
                  <h5>
                    <%=contentManagement.getContent("species_names_searchTitle1")%>
                  </h5>
                  <%=contentManagement.getContent("species_names_searchExample1")%>
                  <br />
                  <br />
                  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <strong>
                          <%=contentManagement.getContent("species_names_searchDescription")%>
                        </strong>
                      </td>
                    </tr>
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox1"><%=contentManagement.getContent("species_names_chkGroup")%></label>
                        <input title="Order" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox2"><%=contentManagement.getContent("species_names_chkOrder")%></label>
                        <input title="Family" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox3"><%=contentManagement.getContent("species_names_chkFamily")%></label>
                        <input title="Scientific name" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox4"><%=contentManagement.getContent("species_names_chkScientificName")%></label>
                        <input title="Valid name" id="checkbox6" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox6"><%=contentManagement.getContent("species_names_chkValidName")%></label>
                        <input title="Vernacular name" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" checked="checked" /><label for="checkbox5"><%=contentManagement.getContent("species_names_chkVernacularName")%></label>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td>
                  <img width="11" height="12" style="vertical-align:middle" alt="<%=contentManagement.getContent("species_names_titleImgRed", false)%>" title="<%=contentManagement.getContent("species_names_titleImgRed", false)%>" src="images/mini/field_mandatory.gif" />
                  <%=contentManagement.writeEditTag( "species_names_titleImgRed",false )%>
                  <strong>
                    <label for="scientificName"><%=contentManagement.getContent("species_names_searchObject1")%></label>
                  </strong>
                  <label for="select1" class="noshow">Operator</label>
                  <select id="select1" title="Operator" name="relationOp" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_names_operatorIs", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_names_operatorContains", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("species_names_operatorStartWith", false)%></option>
                  </select>
                  <input id="scientificName" alt="Scientific name" size="32" name="scientificName" value="" class="inputTextField" title="Species scientific name" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper1('document.eunis1.scientificName','ScientificName','Species','document.eunis1.relationOp');"><img alt="List of values" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td>
                  <input type="checkbox" title="<%=contentManagement.getContent("species_names_chkSearchSynonyms",false)%>" id="searchSynonyms" name="searchSynonyms" value="true" checked="checked" />
                  <label for="searchSynonyms"><%=contentManagement.getContent("species_names_chkSearchSynonyms")%></label>
                </td>
              </tr>
              <tr>
                <td style="text-align:right">
                  <label for="Reset" class="noshow"><%=contentManagement.getContent( "species_names_btnReset", false )%></label>
                  <input id="Reset" type="reset" value="<%=contentManagement.getContent( "species_names_btnReset", false )%>"
                    name="Reset" class="inputTextField" title="Reset" />
                  <%=contentManagement.writeEditTag( "species_names_btnReset" )%>
                  <label for="Search" class="noshow"><%=contentManagement.getContent( "species_names_btnSearch", false )%></label>
                  <input id="Search" type="submit" value="<%=contentManagement.getContent( "species_names_btnSearch", false )%>"
                    name="submit" class="inputTextField" title="Search" />
                    <%=contentManagement.writeEditTag( "species_names_btnSearch" )%>
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
                  <%=contentManagement.getContent("species_names_lnkSaveCriteria")%>:
                  <a title="Save criteria" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm1(),'species-names.jsp','2','eunis1',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save criteria" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>

            <%
              }
            %>
              <br />
              <div class="horizontal_line"><img alt="" src="images/pixel.gif" width="100%" height="1" /></div>
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
                    <h5>
                      <%=contentManagement.getContent("species_names_searchTitle2")%>
                    </h5>
                    <%=contentManagement.getContent("species_names_searchExample2")%>
                    <br />
                    <br />
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <strong>
                            <%=contentManagement.getContent("species_names_searchDescription")%>
                          </strong>
                        </td>
                      </tr>
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <input title="Group" id="checkbox11" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox11"><%=contentManagement.getContent("species_names_chkGroup")%></label>
                          <input title="Order" id="checkbox12" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox12"><%=contentManagement.getContent("species_names_chkOrder")%></label>
                          <input title="Family" id="checkbox13" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox13"><%=contentManagement.getContent("species_names_chkFamily")%></label>
                          <input title="Scientific name" id="checkbox14" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox14"><%=contentManagement.getContent("species_names_chkScientificName")%></label>
                          <%--<input id="checkbox15" type="checkbox" name="showKingdom" value="true" checked="checked" /><label for="checkbox15"><%=contentManagement.getContent("species_names_chkKindom")%></label>--%>
                          <input title="Valid name" id="checkbox17" type="checkbox" name="showValidName" value="true" checked="checked" /><label for="checkbox17"><%=contentManagement.getContent("species_names_chkValidName")%></label>
                          <input title="Vernacular name" id="checkbox16" type="checkbox" name="showVernacularNames" value="true" disabled="disabled" checked="checked" /><label for="checkbox16"><%=contentManagement.getContent("species_names_chkVernacularNames")%></label>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    <img width="11" height="12" style="vertical-align:middle" alt="<%=contentManagement.getContent("species_names_titleImgRed", false)%>" title="<%=contentManagement.getContent("species_names_titleImgRed", false)%>" src="images/mini/field_mandatory.gif" />
                    <%=contentManagement.writeEditTag( "species_names_titleImgRed",false )%>
                    <strong>
                      <label for="vernacularName"><%=contentManagement.getContent("species_names_searchObject2")%></label>
                    </strong>
                    <label for="select2" class="noshow">Operator</label>
                    <select id="select2" title="Operator" size="1" name="relationOp" class="inputTextField">
                      <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_names_operatorIs", false )%></option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_names_operatorContains", false )%></option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("species_names_operatorStartWith", false )%></option>
                    </select>
                    <input id="vernacularName" alt="Vernacular name" size="30" name="vernacularName" value="" class="inputTextField"
                        title="Species vernacular name" />
                    <a title="List of values. Link will open a new window." href="javascript:openHelper2('species-names-choice.jsp')"><img alt="List of values" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                    &nbsp;
                    <strong>
                    <%=contentManagement.getContent("species_names_in")%>
                    </strong>
                    <label for="select3" class="noshow">Language</label>
                    <select id="select3" title="Language" size="1" name="language" class="inputTextField200">
                      <option value="any" selected="selected">
                        <%=contentManagement.getContent("species_names_anyLanguage", false)%>
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
                    <br />
                  </td>
                </tr>
                <tr>
                  <td style="text-align:right">
                    <label for="Reset1" class="noshow"><%=contentManagement.getContent("species_names_btnReset", false )%></label>
                    <input id="Reset1" type="reset" value="<%=contentManagement.getContent("species_names_btnReset", false )%>" name="Reset" class="inputTextField" title="Reset" />
                    <%=contentManagement.writeEditTag( "species_names_btnReset" )%>
                    <label for="Search1" class="noshow"><%=contentManagement.getContent("species_names_btnSearch", false )%></label>
                    <input id="Search1" type="submit" value="<%=contentManagement.getContent("species_names_btnSearch", false)%>" name="submit" class="inputTextField" title="Search" />
                    <%=contentManagement.writeEditTag( "species_names_btnSearch" )%>
                  </td>
                </tr>
            </table>
             </form>
          </td>
        </tr>
      </table>
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
          <noscript>Your browser does not support JavaScript!</noscript>
          <br />
          <script language="JavaScript" type="text/javascript" src="script/species-names-vernacular-save-criteria.js"></script>
          <%=contentManagement.getContent("species_names_lnkSaveCriteria")%>:
          <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm2(),'species-names.jsp','4','eunis2',attributesNames2,formFieldAttributes2,operators2,formFieldOperators2,booleans2,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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

    <div class="horizontal_line"><img alt="" src="images/pixel.gif" width="100%" height="1" /></div>
    <br />
    
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
<%
        }
%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-names.jsp" />
    </jsp:include>
  </div>
  </body>
</html>