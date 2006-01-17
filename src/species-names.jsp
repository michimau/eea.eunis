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
                 ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist,
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
        realOper = "<%=cm.cms("species_names_01_Msg")%>";
        if (val == "")
        {
          // errMessageForm1 - defined in species-names.js
          alert(errMessageForm1);
        } else {
          if (cur_oper.value == <%=Utilities.OPERATOR_CONTAINS%>) realOper = "<%=cm.cms("species_names_01_Msg")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_IS%>) realOper = "<%=cm.cms("species_names_02_Msg")%>";
          if (cur_oper.value == <%=Utilities.OPERATOR_STARTS%>) realOper = "<%=cm.cms("species_names_03_Msg")%>";
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
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,species_names_location" />
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
                    <%=cm.cmsText("species_names_searchTitle1")%>
                  </h1>
                  <%=cm.cmsText("species_names_searchExample1")%>
                  <br />
                  <br />
                  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <strong>
                          <%=cm.cmsText("species_names_searchDescription")%>
                        </strong>
                      </td>
                    </tr>
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <input title="<%=cm.cms("species_names_05_Title")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                          <label for="checkbox1"><%=cm.cmsText("species_names_chkGroup")%></label>
                          <%=cm.cmsTitle("species_names_05_Title")%>
                        <input title="<%=cm.cms("species_names_06_Title")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                          <label for="checkbox2"><%=cm.cmsText("species_names_chkOrder")%></label>
                          <%=cm.cmsTitle("species_names_06_Title")%>
                        <input title="<%=cm.cms("species_names_07_Title")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                          <label for="checkbox3"><%=cm.cmsText("species_names_chkFamily")%></label>
                          <%=cm.cmsTitle("species_names_07_Title")%>
                        <input title="<%=cm.cms("species_names_08_Title")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                          <label for="checkbox4"><%=cm.cmsText("species_names_chkScientificName")%></label>
                          <%=cm.cmsTitle("species_names_08_Title")%>
                        <input title="<%=cm.cms("species_names_09_Title")%>" id="checkbox6" type="checkbox" name="showValidName" value="true" checked="checked" />
                          <label for="checkbox6"><%=cm.cmsText("species_names_chkValidName")%></label>
                          <%=cm.cmsTitle("species_names_09_Title")%>
                        <input title="<%=cm.cms("species_names_10_Title")%>" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" checked="checked" />
                          <label for="checkbox5"><%=cm.cmsText("species_names_chkVernacularName")%></label>
                          <%=cm.cmsTitle("species_names_10_Title")%>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td>
                  <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("species_names_titleImgRed_Alt")%>" title="<%=cm.cms("species_names_titleImgRed")%>" src="images/mini/field_mandatory.gif" />
                  <%=cm.cmsAlt("species_names_titleImgRed_Alt")%>
                  <%=cm.cmsTitle("species_names_titleImgRed")%>
                  <strong>
                    <label for="scientificName"><%=cm.cmsText("species_names_searchObject1")%></label>
                  </strong>
                  <label for="select1" class="noshow"><%=cm.cms("species_names_11_Msg")%></label>
                  <select id="select1" title="<%=cm.cms("species_names_11_Title")%>" name="relationOp" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("species_names_operatorIs")%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("species_names_operatorContains")%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("species_names_operatorStartWith")%></option>
                  </select>
                  <%=cm.cmsTitle("species_names_11_Title")%>
                  <%=cm.cmsLabel("species_names_11_Msg")%>
                  <input id="scientificName" alt="<%=cm.cms("species_names_12_Alt")%>" size="32" name="scientificName" value="" class="inputTextField" title="<%=cm.cms("species_names_12_Title")%>" />
                  <%=cm.cmsAlt("species_names_12_Alt")%>
                  <%=cm.cmsTitle("species_names_12_Title")%>
                  <a title="<%=cm.cms("species_names_13_Title")%>" href="javascript:openHelper1('document.eunis1.scientificName','ScientificName','Species','document.eunis1.relationOp');"><img alt="<%=cm.cms("species_names_13_Alt")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                  <%=cm.cmsTitle("species_names_13_Title")%>
                  <%=cm.cmsAlt("species_names_13_Alt")%>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td>
                  <input type="checkbox" title="<%=cm.cms("species_names_chkSearchSynonyms")%>" id="searchSynonyms" name="searchSynonyms" value="true" checked="checked" />
                  <%=cm.cmsTitle("species_names_chkSearchSynonyms")%>
                  <label for="searchSynonyms"><%=cm.cmsText("species_names_chkSearchSynonyms")%></label>
                </td>
              </tr>
              <tr>
                <td style="text-align:right">
                  <input id="Reset" type="reset" value="<%=cm.cms("species_names_btnReset")%>"
                    name="Reset" class="inputTextField" title="<%=cm.cms("species_names_btnReset_Title")%>" />
                  <%=cm.cmsInput("species_names_btnReset")%>
                  <%=cm.cmsTitle("species_names_btnReset_Title")%>
                  <input id="Search" type="submit" value="<%=cm.cms( "species_names_btnSearch" )%>"
                    name="submit" class="inputTextField" title="<%=cm.cms("species_names_btnSearch_Title")%>" />
                    <%=cm.cmsTitle("species_names_btnSearch_Title")%>
                    <%=cm.cmsInput("species_names_btnSearch")%>
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
                  <%=cm.cmsText("species_names_lnkSaveCriteria")%>:
                  <a title="<%=cm.cms("species_names_14_Title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm1(),'species-names.jsp','2','eunis1',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("species_names_14_Alt")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("species_names_14_Title")%>
                  <%=cm.cmsAlt("species_names_14_Alt")%>
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
                    <h1>
                      <%=cm.cmsText("species_names_searchTitle2")%>
                    </h1>
                    <%=cm.cmsText("species_names_searchExample2")%>
                    <br />
                    <br />
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <strong>
                            <%=cm.cmsText("species_names_searchDescription")%>
                          </strong>
                        </td>
                      </tr>
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <input title="<%=cm.cms("species_names_16_Title")%>" id="checkbox11" type="checkbox" name="showGroup" value="true" checked="checked" />
                            <label for="checkbox11"><%=cm.cmsText("species_names_chkGroup")%></label>
                            <%=cm.cmsTitle("species_names_16_Title")%>
                          <input title="<%=cm.cms("species_names_17_Title")%>" id="checkbox12" type="checkbox" name="showOrder" value="true" checked="checked" />
                            <label for="checkbox12"><%=cm.cmsText("species_names_chkOrder")%></label>
                            <%=cm.cmsTitle("species_names_17_Title")%>
                          <input title="<%=cm.cms("species_names_18_Title")%>" id="checkbox13" type="checkbox" name="showFamily" value="true" checked="checked" />
                            <label for="checkbox13"><%=cm.cmsText("species_names_chkFamily")%></label>
                            <%=cm.cmsTitle("species_names_18_Title")%>
                          <input title="<%=cm.cms("species_names_19_Title")%>" id="checkbox14" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                            <label for="checkbox14"><%=cm.cmsText("species_names_chkScientificName")%></label>
                            <%=cm.cmsTitle("species_names_19_Title")%>
                          <%--<input id="checkbox15" type="checkbox" name="showKingdom" value="true" checked="checked" /><label for="checkbox15"><%=cm.cmsText("species_names_chkKindom")%></label>--%>
                          <input title="<%=cm.cms("species_names_20_Title")%>" id="checkbox17" type="checkbox" name="showValidName" value="true" checked="checked" />
                            <label for="checkbox17"><%=cm.cmsText("species_names_chkValidName")%></label>
                            <%=cm.cmsTitle("species_names_20_Title")%>
                          <input title="<%=cm.cms("species_names_21_Title")%>" id="checkbox16" type="checkbox" name="showVernacularNames" value="true" disabled="disabled" checked="checked" />
                            <label for="checkbox16"><%=cm.cmsText("species_names_chkVernacularNames")%></label>
                            <%=cm.cmsTitle("species_names_21_Title")%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("species_names_titleImgRed")%>" title="<%=cm.cms("species_names_titleImgRed")%>" src="images/mini/field_mandatory.gif" />
                    <%=cm.cmsAlt("species_names_titleImgRed")%>
                    <%=cm.cmsTitle("species_names_titleImgRed")%>
                    <strong>
                      <label for="vernacularName"><%=cm.cmsText("species_names_searchObject2")%></label>
                    </strong>
                    <label for="select2" class="noshow"><%=cm.cms("species_names_22_Label")%></label>
                    <select id="select2" title="<%=cm.cms("species_names_22_Title")%>" size="1" name="relationOp" class="inputTextField">
                      <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("species_names_operatorIs")%></option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("species_names_operatorContains")%></option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("species_names_operatorStartWith")%></option>
                    </select>
                    <%=cm.cmsLabel("species_names_22_Label")%>
                    <%=cm.cmsTitle("species_names_22_Title")%>
                    <input id="vernacularName" alt="<%=cm.cms("species_names_23_Alt")%>" size="30" name="vernacularName" value="" class="inputTextField"
                        title="<%=cm.cms("species_names_23_Title")%>" />
                    <%=cm.cmsAlt("species_names_23_Alt")%>
                    <%=cm.cmsTitle("species_names_23_Title")%>
                    <a title="<%=cm.cms("species_names_24_Title")%>" href="javascript:openHelper2('species-names-choice.jsp')"><img alt="<%=cm.cms("species_names_24_Alt")%>" style="vertical-align:middle" src="images/helper/helper.gif" border="0" /></a>
                    <%=cm.cmsTitle("species_names_24_Title")%>
                    <%=cm.cmsAlt("species_names_24_Alt")%>
                    &nbsp;
                    <strong>
                    <%=cm.cmsText("species_names_in")%>
                    </strong>
                    <label for="select3" class="noshow"><%=cm.cms("species_names_25_Label")%></label>
                    <select id="select3" title="<%=cm.cms("species_names_25_Title")%>" size="1" name="language" class="inputTextField200">
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
                    <%=cm.cmsLabel("species_names_25_Label")%>
                    <%=cm.cmsTitle("species_names_25_Title")%>
                    <br />
                  </td>
                </tr>
                <tr>
                  <td style="text-align:right">
                    <input id="Reset1" type="reset" value="<%=cm.cms("species_names_btnReset")%>" name="Reset" class="inputTextField" title="<%=cm.cms("species_names_btnReset_Title")%>" />
                    <%=cm.cmsInput("species_names_btnReset")%>
                    <%=cm.cmsTitle("species_names_btnReset_Title")%>
                    <input id="Search1" type="submit" value="<%=cm.cms("species_names_btnSearch")%>" name="submit" class="inputTextField" title="<%=cm.cms("species_names_btnSearch_Title")%>" />
                    <%=cm.cmsLabel("species_names_btnSearch_Title")%>
                    <%=cm.cmsInput("species_names_btnSearch")%>
                    <%=cm.cmsTitle("species_names_btnSearch_Title")%>
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
          <br />
          <script language="JavaScript" type="text/javascript" src="script/species-names-vernacular-save-criteria.js"></script>
          <%=cm.cmsText("species_names_lnkSaveCriteria")%>:
          <a title="<%=cm.cms("species_names_27_Title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm2(),'species-names.jsp','4','eunis2',attributesNames2,formFieldAttributes2,operators2,formFieldOperators2,booleans2,'save-criteria-search.jsp');"><img alt="<%=cm.cms("species_names_27_Alt")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%=cm.cmsTitle("species_names_27_Title")%>
          <%=cm.cmsAlt("species_names_27_Alt")%>
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
<%=cm.br()%>
<%=cm.cmsMsg("species_names_01_Msg")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_02_Msg")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_03_Msg")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_pageTitle")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_operatorIs")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_operatorContains")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_operatorStartWith")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names_anyLanguage")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-names.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>