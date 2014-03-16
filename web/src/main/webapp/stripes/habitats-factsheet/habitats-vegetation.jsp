<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <h3>
        ${eunis:cmsPhrase(actionBean.contentManagement, 'Relation to vegetation types (syntaxa)')}
    </h3>
    <table summary=" ${eunis:cms(actionBean.contentManagement, 'habitat_type_syntaxa')}" class="listing fullwidth">
        <col style="width:25%"/>
        <col style="width:6%"/>
        <col style="width:30%"/>
        <col style="width:20%"/>
        <col style="width:14%"/>
        <thead>
        <tr>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Name')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Relation')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Source (abbreviated)')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}
            </th>
            <th scope="col">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'References')}
            </th>
        </tr>
        </thead>
        <tbody>
        
        <c:forEach items="${actionBean.factsheet.habitatSintaxa}" var="syntaxa">
            <tr>
                <td>
                    ${syntaxa.name}
                </td>
                <td>
                    ${eunis:mapHabitatsRelations(syntaxa.relation)}
                </td>
                <td>
                    ${syntaxa.sourceAbbrev}
                </td>
                <td>
                    ${syntaxa.author}
                </td>

                <td>
                    <c:if test="${not (syntaxa.idDc eq 0)}">
                        <a href="references/${syntaxa.idDc}">${eunis:getAuthorAndUrlByIdDc(syntaxa.idDc)}</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</stripes:layout-definition>