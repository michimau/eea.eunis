<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<!-- Species synonyms and vernacular names -->

<h2 class="visualClear" id="synonyms">${eunis:cmsPhrase(actionBean.contentManagement, 'Synonyms and Vernacular names')}</h2>

<div class="left-area species">
    <h3 class="visualClear">${eunis:cmsPhrase(actionBean.contentManagement, 'Synonyms')}</h3>

    <div class="scroll-auto" style="height: 300px">
    <table summary="List of synonyms" class="listing fullwidth">
        <colgroup>
            <col style="width:40%">
            <col style="width:40%">
            <col style="width:20%">
        </colgroup>
        <thead>
        <tr>
            <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}

                <img src="http://www.eea.europa.eu/arrowUp.gif" height="6" width="9"></th>
            <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
                <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
            <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Type')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
                <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
        </tr>
        </thead>
        <tbody>

        <tr class="zebraeven">
            <td>
                ${eunis:treatURLSpecialCharacters(actionBean.scientificName)}</a>
            </td>
            <td>
                ${eunis:treatURLSpecialCharacters(actionBean.author)}
            </td>
            <td>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Valid name')}
            </td>
        </tr>

        <c:forEach items="${actionBean.factsheet.synonymsIterator}" var="synonym" varStatus="loop">
            <tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
                <td>
                    <a href="${pageContext.request.contextPath}/species/${synonym.idSpecies}">${eunis:treatURLSpecialCharacters(synonym.scientificName)}</a>
                </td>
                <td>
                    ${eunis:treatURLSpecialCharacters(synonym.author)}
                </td>
                <td>
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Synonym')}
                </td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
    </div>
</div>

<!-- Textual facts on right -->
<div class="right-area quickfacts">
    <h3 class="visualClear">${eunis:cmsPhrase(actionBean.contentManagement, 'Vernacular names')}</h3>

    <div class="scroll-auto" style="height: 300px">
    <table summary="Vernacular names" class="listing fullwidth">
        <thead>
        <tr>
            <th scope="col" style="cursor: pointer;"><img
                    src="http://www.eea.europa.eu/arrowBlank.gif"
                    height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Vernacular Name')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                <img src="http://www.eea.europa.eu/arrowUp.gif"
                     height="6" width="9"></th>
            <th scope="col" style="cursor: pointer;"><img
                    src="http://www.eea.europa.eu/arrowBlank.gif"
                    height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Language')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                <img src="http://www.eea.europa.eu/arrowBlank.gif"
                     height="6" width="9"></th>
            <th scope="col" style="cursor: pointer;"><img
                    src="http://www.eea.europa.eu/arrowBlank.gif"
                    height="6" width="9">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
                ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                <img src="http://www.eea.europa.eu/arrowBlank.gif"
                     height="6" width="9"></th>
        </tr>
        </thead>
        <tbody>


        <c:forEach items="${actionBean.vernNames}" var="vern" varStatus="loop">
            <c:set var="ref" value="-1"></c:set>
            <c:if test="${!empty vern.idDc}">
                <c:set var="ref" value="${vern.idDc}"></c:set>
            </c:if>
            <tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
                <td xml:lang="${vern.languageCode}">
                    ${eunis:treatURLSpecialCharacters(vern.name)}
                </td>
                <td>
                    ${vern.language}
                </td>
                <td>
                    <a class="link-plain" href="references/${ref}">${eunis:getAuthorAndUrlByIdDc(ref)}</a>
                </td>
            </tr>
        </c:forEach>


        </tbody>
    </table>
    </div>
</div>


<!-- END synonyms -->
</stripes:layout-definition>