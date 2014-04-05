<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<c:choose>
    <c:when test="${not empty actionBean.speciesForHabitats}">
    <table summary="${eunis:cms(actionBean.contentManagement, 'habitat_species')}" class="listing fullwidth">
        <thead>
        <tr>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Species scientific name')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic region')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Abundance')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Frequencies')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Faithfulness')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Comment')}
            </th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${actionBean.speciesForHabitats}" var="species">
            <tr>
                <td>
                    <a href="species/${species.idSpecies}">${species.speciesName}</a>
                </td>
                <td>
                    ${species.geoscope}
                </td>
                <td>
                    ${species.abundance}
                </td>
                <td>
                    ${species.frequencies}
                </td>
                <td>
                    ${species.faithfulness}
                </td>
                <td>
                    ${species.comment}
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </c:when>
    <c:otherwise>
        ${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}
    </c:otherwise>
</c:choose>
</stripes:layout-definition>