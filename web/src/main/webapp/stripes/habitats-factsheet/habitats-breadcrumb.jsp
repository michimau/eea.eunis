<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<c:if test="${!empty actionBean.factsheet.otherHabitatsRelations}">
    <c:forEach items="${actionBean.factsheet.otherHabitatsRelations}" var="other" varStatus="loop">
        <tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
            <td>
                &nbsp;
            </td>
            <td>
                ${other.eunisCode}
            </td>
            <td>
                <c:choose>
                    <c:when test="${other.idHabitat != '10000'}">
                        <a href="habitats/${other.idHabitat}">${eunis:bracketsToItalics(eunis:replaceTags(other.scientificName))}</a>
                    </c:when>
                    <c:otherwise>
                        ${other.scientificName}
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:if test="${other.level < 3 && eunis:execMethodParamString('ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet', 'isEunis', other.idHabitat)}">
                    <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Go to key navigator, starting with this habitat')}" href="habitats-key.jsp?pageCode=${other.eunisCode}&amp;level=${other.level + 1}">
                        <img src="images/mini/key_out.png" alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Go to key navigator, starting with this habitat')}" border="0" />
                    </a>
                </c:if>
                &nbsp;&nbsp;&nbsp;${other.relation}
            </td>
        </tr>
    </c:forEach>
</c:if>

</stripes:layout-definition>