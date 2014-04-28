<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <c:choose>
        <c:when test="${ actionBean.typeNatura2000 or actionBean.typeCDDA }">
            <div>
                <p><a href="http://natura2000.eea.europa.eu" target="_BLANK">Natura 2000 map viewer</a></p>
                <p><a href="http://www.protectedplanet.net" target="_BLANK">Protected planet map viewer</a></p>
                <c:if test="actionBean.typeNatura2000">
                    <p><a href="http://www.eea.europa.eu/data-and-maps/data/natura-3" target="_BLANK">Data download</a></p>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}
            <script>
                $("#other-resources-accordion").addClass("nodata");
            </script>
        </c:otherwise>
    </c:choose>

</stripes:layout-definition>