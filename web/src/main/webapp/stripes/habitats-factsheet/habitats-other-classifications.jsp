<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <c:if test="${!empty actionBean.factsheet.otherClassifications}">
        <h3>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Relationships with other classifications')}
        </h3>
        <table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Relationships with other classifications')}" class="listing fullwidth" style="display: table">
            <col style="width:30%"/>
            <col style="width:15%"/>
            <col style="width:40%"/>
            <col style="width:15%"/>
            <thead>
            <tr>
                <th scope="col">
                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Classification')}
                </th>
                <th scope="col">
                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Code')}
                </th>
                <th scope="col">
                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type name')}
                </th>
                <th scope="col">
                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Relationship type')}
                </th>
            </tr>
            </thead>
            <tbody>
                <c:forEach items="${actionBean.otherClassifications}" var="classif" varStatus="loop">
                    <tr>
                        <td>
                                ${eunis:formatString(eunis:treatURLSpecialCharacters(classif.name), '&nbsp;')}
                        </td>
                        <td>
                                ${eunis:formatString(classif.code, '&nbsp;')}
                        </td>
                        <td>
                                ${eunis:bracketsToItalics(eunis:replaceTags(eunis:formatString(classif.title, '&nbsp;')))}
                        </td>
                        <td>
                                ${eunis:execMethodParamString('ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet', 'mapHabitatsRelations', classif.relationType)}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    ${eunis:cmsPhrase(actionBean.contentManagement, 'For relation to plant communities (syntaxa), see Vegetation types')}

</stripes:layout-definition>