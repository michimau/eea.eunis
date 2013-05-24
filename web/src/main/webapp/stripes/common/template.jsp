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
            <base href="${actionBean.context.domainName}/${base}"/>
            <jsp:include page="/header-page.jsp">
                <jsp:param name="metaDescription" value="${eunis:replaceTags(actionBean.metaDescription)}" />
            </jsp:include>

            <title>
                <c:choose>
                    <c:when test="${empty pageTitle}">
                        EUNIS
                    </c:when>
                    <c:otherwise>
                        ${eunis:replaceTags(pageTitle)}
                    </c:otherwise>
                </c:choose>
            </title>
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
                                    <jsp:include page="/header-dynamic.jsp">
                                          <jsp:param name="location" value="${actionBean.btrail}"/>
                                    </jsp:include>
                                    <a name="documentContent"></a>
                                    <!-- MAIN CONTENT -->
                                    <stripes:layout-component name="messages">
                                    <c:choose>
                                        <c:when test="${actionBean.context.severity == 1}">
                                            <div class="system-msg">
                                                <stripes:messages/>
                                            </div>
                                        </c:when>
                                        <c:when test="${actionBean.context.severity == 2}">
                                            <div class="caution-msg">
                                                <strong>Caution ...</strong>
                                                <p><stripes:messages/></p>
                                            </div>
                                        </c:when>
                                        <c:when test="${actionBean.context.severity == 3}">
                                            <div class="warning-msg">
                                                <strong>Warnings ...</strong>
                                                <p><stripes:messages/></p>
                                            </div>
                                        </c:when>
                                        <c:when test="${actionBean.context.severity == 4}">
                                            <div class="error-msg">
                                                <strong>Errors ...</strong>
                                                <p><stripes:messages/></p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </stripes:layout-component>

                                <stripes:layout-component name="contents"/>
                        </div>
                        <!--END content -->

                    </div>
                    <!-- END of the main content-column -->
                    <stripes:layout-component name="foot"/>

                </div>
                <!-- END column wrapper -->
            </div>
            <!-- END visual portal wrapper -->
        <jsp:include page="/footer-static.jsp" />
  </body>
</html>
</stripes:layout-definition>
