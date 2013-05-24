<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>
    <%--
      - Author(s) : The EUNIS Database Team.
      - Date :
      - Copyright : (c) 2002-2010 EEA - European Environment Agency.
      - Description : Template
    --%>
    <%@page contentType="text/html;charset=UTF-8"%>

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
        <link rel="stylesheet" type="text/css" href="http://serverapi.arcgisonline.com/jsapi/arcgis/2.7/js/dojo/dijit/themes/claro/claro.css"/>
        <script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.7"></script>

        <stripes:layout-component name="head"/>
    </head>
    <body>
        <jsp:include page="/header.jsp" />
        <!-- visual portal wrapper -->
        <div id="visual-portal-wrapper">

            <!-- The wrapper div. It contains the two columns. -->
            <div id="portal-columns">

                <!-- start of the content column -->
                <div id="portal-column-content">

                    <div id="content">

                        <!--  TODO check if this is really needed.
                            It seems that it does not build btrail.
                            Some old jsps (search results) uses downloadLinks to build TSV downloads
                            Needs refactoring.
                        -->
                        <jsp:include page="/header-dynamic.jsp">
                            <jsp:param name="location" value="${actionBean.btrail}" />
                        </jsp:include>

                        <!-- MESSAGES -->
                        <stripes:layout-render name="/stripes/common/messages.jsp"/>


                        <!-- MAIN CONTENT -->
                        <stripes:layout-component name="contents"/>

                        </div>
                        <!--END content -->
                    </div>
                    <!-- END of the main content-column -->

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
