<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value=""/>
<c:set var="notExistErrMsg" value="${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}"/>
<c:choose>
    <c:when test="${eunis:exists(actionBean.factsheet)}">
        <c:set var="title" value="${actionBean.pageTitle }"></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="title" value="${notExistErrMsg}"></c:set>
    </c:otherwise>
</c:choose>
<stripes:layout-render name="/stripes/common/template.jsp" hideMenu="true" pageTitle="${title}">
    <stripes:layout-component name="head">
        <!-- Custom js needed for Species page -->
        <script type="text/javascript" src="<%=request.getContextPath()%>/script/init.js"></script>

        <style>
        .cell-title {
          font-weight: bold;
        }

        .cell-effort-driven {
          text-align: center;
        }
        </style>


        <link rel="alternate" type="application/rdf+xml" title="RDF"
            href="${pageContext.request.contextPath}/sites/${actionBean.idsite}/rdf" />
    </stripes:layout-component>

    <stripes:layout-component name="contents">
        <!-- MAIN CONTENT -->
        <c:choose>
            <c:when test="${eunis:exists(actionBean.factsheet)}">

<!-- TODO documentActions - PDF link ?? -->
<!-- TODO the old template added "Upload pictures" menu item to the left menu for logged in users -->

                <!-- TODO add name in English first and name in Latin in brackets. eg. Species: Iberian Lynx (Lynx pardinus) ?-->
                <h1>Site: ${actionBean.siteName}
                </h1>

				<%-- Quick facts --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-map.jsp"/>

                <%-- Quick facts --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-quickfacts.jsp"/>

            </c:when>
            <c:otherwise>
                <div class="error-msg">${notExistErrMsg}</div>
            </c:otherwise>
        </c:choose>
        <!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>
