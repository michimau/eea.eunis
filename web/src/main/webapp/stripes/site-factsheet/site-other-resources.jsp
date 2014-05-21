<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <c:choose>
        <c:when test="${ actionBean.typeNatura2000 or actionBean.typeCDDA }">
            <table class="listing fullwidth">
                <tr>
                    <td>
                        <a href="http://natura2000.eea.europa.eu" target="_BLANK">Natura 2000 map viewer</a>
                    </td>
                    <td>
                        Interactive map designed for showing and querying Natura 2000 sites. Other information such as Nationally designated areas and LIFE projects are also available.
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="http://www.protectedplanet.net" target="_BLANK">Protected planet map viewer</a>
                    </td>
                    <td>
                        Interactive map showing the World Database on Protected Areas
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="http://www.eea.europa.eu/data-and-maps/explore-interactive-maps/european-protected-areas" target="_BLANK">European protected sites map viewer</a>
                    </td>
                    <td>
                        Simple interactive map showing Natura 2000 sites and Nationally designated areas
                    </td>
                </tr>
                <c:if test="actionBean.typeNatura2000">
                    <tr>
                        <td>
                            <a href="http://www.eea.europa.eu/data-and-maps/data/natura-3" target="_BLANK">Data download</a>
                        </td>
                        <td>

                        </td>
                    </tr>
                </c:if>
            </table>
        </c:when>
        <c:otherwise>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}
            <script>
                $("#other-resources-accordion").addClass("nodata");
            </script>
        </c:otherwise>
    </c:choose>

</stripes:layout-definition>