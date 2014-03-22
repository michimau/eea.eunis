<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<c:choose>
    <c:when test="${not empty actionBean.habitats}">
        <table summary=" ${eunis:cms(actionBean.contentManagement, 'sites_factsheet_166')}" class="listing fullwidth  table-inline">
        <thead>
        <tr>
            <th scope="col">
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type code')}
            </th>
            <th scope="col">
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type english name')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Cover(%)')}
            </th>
        </tr>
        </thead>
        <tbody>

        <c:forEach items="${actionBean.habitats}" var="habitat">
        <tr>
            <td>
                <a href="habitats/${habitat.habitat.idHabitat}">${habitat.habitat.code2000}</a>
            </td>
            <td>
                <a href="habitats/${habitat.habitat.idHabitat}">${habitat.habitat.habitatDescription}</a>
            </td>
            <td style="text-align : right">
                ${habitat.cover}
            </td>
        </tr>
        </c:forEach>

        </tbody>
        </table>
    </c:when>
    <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'No information reported')}</c:otherwise>

</c:choose>


</stripes:layout-definition>