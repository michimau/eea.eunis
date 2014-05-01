<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value=""/>
<c:set var="notExistErrMsg" value="${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested site does not exist')}"/>
<c:choose>
    <c:when test="${eunis:exists(actionBean.factsheet)}">
        <c:set var="title" value="${actionBean.pageTitle }"></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="title" value="${notExistErrMsg}"></c:set>
    </c:otherwise>
</c:choose>
<%
    String btrail = "eea#" + application.getInitParameter( "EEA_HOME" ) + ",home#index.jsp,sites";
%>
<stripes:layout-render name="/stripes/common/template.jsp" hideMenu="true" pageTitle="${title}" btrail="<%= btrail %>">
    <stripes:layout-component name="head">
        <script>
            function openSection(sectionName) {
                if($('#' + sectionName + ' ~ h2').attr('class').indexOf('current')==-1)
                    $('#' + sectionName + ' ~ h2').click();
            }
        </script>

        <style>
            .interactive-map-more {
                float: right;
                font-size: 10px;
            }
        </style>

        <link rel="alternate" type="application/rdf+xml" title="RDF"
              href="${pageContext.request.contextPath}/sites/${actionBean.idsite}/rdf" />
    </stripes:layout-component>

    <stripes:layout-component name="contents">
        <!-- MAIN CONTENT -->
        <c:choose>
            <c:when test="${eunis:exists(actionBean.factsheet)}">

                <h1>${actionBean.siteName}</h1>
                <%-- Site map --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-map.jsp"/>

                <%-- Quick facts --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-quickfacts.jsp"/>

                <%-- Accordion --%>
                <br/>
                <div>
                    <div class="eea-accordion-panels non-exclusive">
                        <div class="eea-accordion-panel" style="clear: both;" id="tab-description-accordion">
                            <h2 class="notoc eea-icon-right-container">Description</h2>
                            <div class="pane">
                                <stripes:layout-render name="/stripes/site-factsheet/site-diploma-description.jsp"/>
                            </div>
                        </div>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <div class="error-msg">${notExistErrMsg}</div>
            </c:otherwise>
        </c:choose>
        <!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>
