<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites module function - display links to all sites searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites";
//  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
//  String []tabs = { cm.cmsPhrase("Easy search"), cm.cmsPhrase("Advanced search"), cm.cmsPhrase("Statistical data"), cm.cmsPhrase("Help") };
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Sites") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">

        <a name="documentContent"></a>
        <h1 class="documentFirstHeading">
          <%=cm.cmsPhrase("Sites search")%>
        </h1>
<!-- MAIN CONTENT -->
                <div class="documentDescription">
                  <%=cm.cmsPhrase("Access information about protected and other designated sites relevant for fauna, flora and habitat protection in Europe")%>
                </div>
                <div style="text-align : center; padding-left : 10px; width : 90%; vertical-align : middle;">
                  <form name="quick_search" id="quick_search" action="sites-names-result.jsp" method="post" onsubmit="return validateQS();">
                    <input type="hidden" name="showSourceDB" value="true" />
                    <input type="hidden" name="showCountry" value="true" />
                    <input type="hidden" name="showDesignationTypes" value="true" />
                    <input type="hidden" name="showName" value="true" />
                    <input type="hidden" name="showCoordinates" value="true" />
                    <input type="hidden" name="showSize" value="true" />
                    <input type="hidden" name="showDesignationYear" value="true" />
                    <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_RELEVANCE%>" />
                    <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                    <input type="hidden" name="DB_NATURA2000" value="ON" />
                    <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
                    <input type="hidden" name="DB_DIPLOMA" value="ON" />
                    <%--<input type="hidden" name="DB_EMERALD" value="ON" />--%>
                    <input type="hidden" name="fuzzySearch" value="true" />
                    <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
                    <label for="englishName"><%=cm.cmsPhrase("Search sites by code or by name starting with:")%></label>
                    <input type="text"
                           size="32"
                           name="englishName"
                           id="englishName"
                           value="<%=cm.cmsPhrase("Enter code or site name here...")%>"
                           onfocus="if(this.value=='<%=cm.cmsPhrase("Enter code or site name here...")%>')this.value='';"
                           onblur="if(this.value=='')this.value='<%=cm.cmsPhrase("Enter code or site name here...")%>';" />
                    <input type="submit" value="<%=cm.cmsPhrase("Search")%>" name="Submit" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                    <a href="fuzzy-search-help.jsp" title="<%=cm.cmsPhrase("Help on fuzzy search")%>"><img alt="" src="images/mini/help.jpg" border="0" style="vertical-align:middle" /></a>
                  </form>
                  <br />
                </div>
                <br />
        <div class="eea-accordion-panels non-exclusive">

        <div class="eea-accordion-panel" style="clear: both;">
        <h2 class="notoc eea-icon-right-container"><%= cm.cms("easy_search") %></h2>
        <div class="pane">
        <h4><%=cm.cmsPhrase("A set of predefined functions to search the database") %></h4>
        <table class="fullwidth">
        <colgroup>
            <col style="width: 310px; white-space: nowrap;">
            <col>
        </colgroup>

              <tbody>
                <tr>
                  <td>
                    <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                    <a href="sites-names.jsp">
                      <strong>
                        <%=cm.cmsPhrase("Name")%>
                      </strong>
                    </a>
                  </td>
                  <td>
                    <%=cm.cmsPhrase("Search sites by name and type")%>
                  </td>
                </tr>
              </tbody>
            </table>
        </div>
        </div>
        <div class="eea-accordion-panel" style="clear: both;">
        <h2 class="notoc eea-icon-right-container"><%=cm.cms("advanced_searches")%></h2>
        <div class="pane">
        <h4><%=cm.cmsPhrase("A flexible search tool to build your own query") %></h4>
        <table class="fullwidth">
        <colgroup>
            <col style="width: 310px; white-space: nowrap;">
            <col>
        </colgroup>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a href="sites-advanced.jsp?natureobject=Sites">
                              <strong>
                                <%=cm.cmsPhrase("Advanced Search")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites information using more complex filtering capabilities")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a href="advanced-help.jsp">
                              <strong>
                                <%=cm.cmsPhrase("How to use Advanced search")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Help on sites Advanced Search")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
        </div>
        </div>
        <div class="eea-accordion-panel" style="clear: both;">
        <h2 class="notoc eea-icon-right-container">Statistical data</h2>
        <div class="pane">
        <h4><%=cm.cmsPhrase("A search tool to build aggregated data") %></h4>
        <table class="fullwidth">
        <colgroup>
            <col style="width: 310px; white-space: nowrap;">
            <col>
        </colgroup>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a href="sites-statistical.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Number/Total area")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Find statistical data about sites")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
        </div>
        </div>
        <div class="eea-accordion-panel" style="clear: both;">
        <h2 class="notoc eea-icon-right-container"><%=cm.cms("help")%></h2>
        <div class="pane">
        <h4><%=cm.cmsPhrase("General information on EUNIS application") %></h4>
        <table class="fullwidth">
        <colgroup>
            <col style="width: 310px; white-space: nowrap;">
            <col>
        </colgroup>
                  <tbody>
                    <tr>
                      <td>
                        <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <a href="easy-help.jsp">
                          <strong>
                            <%=cm.cmsPhrase("How to use Easy search")%>
                          </strong>
                        </a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on sites <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <img alt=""src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <a href="sites-help.jsp">
                          <strong>
                            <%=cm.cmsPhrase("How to use")%>
                          </strong>
                        </a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Sites online help")%>
                      </td>
                    </tr>
                  </tbody>
                </table>
<!-- END MAIN CONTENT -->
            </div>
        </div>
    </div>


    </stripes:layout-component>
</stripes:layout-render>
