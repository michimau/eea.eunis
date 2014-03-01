<%@ include file="/stripes/common/taglibs.jsp"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />

<%--todo: the right menu is disabled here--%>
<c:set var="hideMenu" value="true"/>

<stripes:layout-definition>
    <%--
      - Author(s) : The EUNIS Database Team.
      - Date :
      - Copyright : (c) 2002-2010 EEA - European Environment Agency.
      - Description : Template
    Parameters:
      pageTitle: the page title
      btrail: breadcrumbs trail (not displayed now)
      downloadLink: link for downloads, displayed in the header
      hideMenu: hides the right column menu
      pdfLink: link for downloadable PDF
    --%>
    <%@page contentType="text/html;charset=UTF-8"%>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
<!DOCTYPE html>
<html>
    <head>
        <c:if test="${not empty actionBean.context.domainName}">
            <base href="${actionBean.context.domainName}/${base}"/>
        </c:if>
        <jsp:include page="/header-page.jsp">
            <jsp:param name="metaDescription" value="${eunis:replaceTags(actionBean.metaDescription)}" />
        </jsp:include>

        <title>
            <c:choose>
                <c:when test="${empty pageTitle}">EUNIS</c:when>
                <c:otherwise>${eunis:replaceTags(pageTitle)}</c:otherwise>
            </c:choose>
        </title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/eunis.css" />
        <%--<link rel="stylesheet" type="text/css" href="http://serverapi.arcgisonline.com/jsapi/arcgis/2.7/js/dojo/dijit/themes/claro/claro.css"/>--%>
        <%--<script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.7"></script>--%>

        <stripes:layout-component name="head"/>
    </head>
    <body>
        <jsp:include page="/header.jsp" />
        <!-- visual portal wrapper -->

        <div id="visual-portal-wrapper">
            <!-- The wrapper div. It contains the two columns. -->
            <div id="portal-columns">
                <div id="portal-column-content" <c:if test="${empty hideMenu}">class="column-area"</c:if>>



                    <c:set var="currentTab" value="${fn:substringAfter(btrail, '#index.jsp,')}" />
                    <c:if test="${fn:contains(currentTab, '#')}">
                        <c:set var="currentTab" value="${fn:substringBefore(currentTab, '#')}" />
                    </c:if>

                    <c:if test="${empty currentTab}">
                        <c:set var="currentTab" value="index" />
                    </c:if>

                    <%--<script>  alert("${btrail}" + "  " + "${currentTab}"); </script>--%>

                    <!-- EUNIS MENU with EIONET MARKUP but EEA tabbedmenu style -->
                    <div class="tabbedmenu">
                          <ul>
                                  <li><a href="index.jsp" class="first-tab <c:if test = "${currentTab == 'index'}">current</c:if>">EUNIS Home</a></li>
                                  <li><a href="species.jsp" <c:if test = "${currentTab == 'species'}">class="current"</c:if> >Species</a></li>
                                  <li><a href="habitats.jsp" <c:if test = "${currentTab == 'habitat_types'}">class="current"</c:if> >Habitat types</a></li>
                                  <li><a href="sites.jsp" <c:if test = "${currentTab == 'sites'}">class="current"</c:if> >Sites</a></li>
                                  <li><a href="combined-search.jsp" <c:if test = "${currentTab == 'combined_search'}">class="current"</c:if> >Combined search</a></li>
                                  <li><a href="externalglobal" <c:if test = "${currentTab == 'externalglobal'}">class="current"</c:if> >Global queries</a></li>
                                  <li><a href="gis-tool.jsp" <c:if test = "${currentTab == 'gis_tool'}">class="current"</c:if> >Interactive maps</a></li>
                                  <li><a href="references" <c:if test = "${currentTab == 'references'}">class="current"</c:if> >References</a></li>
                                  <li><a href="related-reports.jsp" class="last-tab <c:if test = "${currentTab == 'related_reports'}">current</c:if>">Downloads and links</a></li>
                          </ul>
                     </div>

                     <div id="content" class="border-tabbedmenu">

                        <%--todo: test this --%>
                        <c:if test="${empty btrail}"><c:set var="btrail" value="${actionBean.btrail}"/> </c:if>
                        <c:if test="${not empty btrail}">
                            <jsp:include page="/header-dynamic.jsp">
                                <jsp:param name="location" value="${btrail}" />
                                <jsp:param name="downloadLink" value="${downloadLink}"/>
                                <jsp:param name="printLink" value="${pdfLink}"/>
                            </jsp:include>
                        </c:if>

                        <!-- MESSAGES -->
                        <stripes:layout-render name="/stripes/common/messages.jsp"/>


                        <!-- MAIN CONTENT -->
                        <stripes:layout-component name="contents"/>

                        <!-- Document actions -->
                        <div class="visualClear"><!--&nbsp; --></div>

                            <div class="documentActions">
                                <h5 class="hiddenStructure">
                                    Document Actions
                                </h5>
                                <h2 class="share-title">Share with others</h2>

                                <table class="table-document-actions">
                                    <tr>
                                        <td>
                                            <div id="socialmedia-list">
                                                <div id="delicious" class="social-box">
                                                    <a href="http://www.delicious.com/save" onclick="window.open('http://www.delicious.com/save?v=5&amp;noui&amp;jump=close&amp;url='+encodeURIComponent(location.href)+'&amp;title='+encodeURIComponent(document.title), 'delicious','toolbar=no,width=550,height=550'); return false;">
                                                        <img src="http://www.eea.europa.eu/delicious20x20.png" alt="Delicious">
                                                    </a>
                                                </div>
                                                <div id="twitter" class="social-box">
                                                    <a href="https://twitter.com/share" class="twitter-share-button"></a>
                                                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
                                                </div>
                                                <div id="google" class="social-box">
                                                    <g:plusone size="medium"></g:plusone>
                                                    <script type="text/javascript">
                                                        (function() {
                                                            var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                                                            po.src = 'https://apis.google.com/js/plusone.js';
                                                            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
                                                        })();
                                                    </script>
                                                </div>
                                                <div id="facebook" class="social-box">
                                                    <div id="fb-root"></div>
                                                    <script>
                                                        (function(d, s, id) {
                                                            var js, fjs = d.getElementsByTagName(s)[0];
                                                            if (d.getElementById(id)) return;
                                                            js = d.createElement(s); js.id = id;
                                                            js.src = '//connect.facebook.net/en_GB/all.js#xfbml=1';
                                                            fjs.parentNode.insertBefore(js, fjs);
                                                        }(document, 'script', 'facebook-jssdk'));
                                                    </script>
                                                    <div class="fb-like" data-send="true" data-layout="button_count" data-show-faces="false"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="align-right">
                                            <ul>
                                                <li id="document-action-print">
                                                    <a href="javascript:this.print();">
                                                        <img src="http://www.eea.europa.eu/templates/print_icon.gif"
                                                             alt="<%=cm.cmsPhrase("Print this page")%>"
                                                             title="<%=cm.cmsPhrase("Print this page")%>" />
                                                    </a>
                                                </li>
                                                <c:if test="${not empty helpLink}">
                                                    <a href="<c:out value="${helpLink}"/>"><img src="images/help_icon.gif"
                                                                                                alt="<%=cm.cmsPhrase("Help information")%>"
                                                                                                title="<%=cm.cmsPhrase("Help information")%>" /></a>
                                                </c:if>
                                                <!-- component for adding page specific actions -->
                                                <stripes:layout-component name="documentActions"/>
                                            </ul>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- END Document actions -->

                    </div>
                        <!--END content -->
                </div>

                <div class="visualClear"><!-- --></div>

                    <!-- - TODO Check if we can replace foot by bottom menu  -->

                    <stripes:layout-component name="foot"/>
            </div>
                <!-- END column wrapper -->

        </div>
            <!-- END visual portal wrapper -->
        <jsp:include page="/footer-static.jsp" />
    </body>
</html>
</stripes:layout-definition>
