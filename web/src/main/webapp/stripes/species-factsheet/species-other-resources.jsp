<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>


    <table class="listing fullwidth">
    <c:forEach items="${actionBean.links}" var="link" varStatus="loop">
        <tr>
            <td>
                <c:choose>
                    <c:when test="${!empty link.url}">
                        <a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
                    </c:when>
                    <c:otherwise>
                        ${link.name}
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                ${link.description}
            </td>
        </tr>
    </c:forEach>
    </table>

    <stripes:layout-render name="/stripes/species-factsheet/species-linkeddata.jsp"/>

</stripes:layout-definition>