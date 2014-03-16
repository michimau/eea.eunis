<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<c:if test="${!empty actionBean.factsheet.otherHabitatsRelations}">

    <div id="portal-breadcrumbs" class='species-taxonomy'>
        <span id="breadcrumbs-home">
            <a href="${actionBean.context.domainName}">EUNIS Home</a>
            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <span id="breadcrumbs-0" dir="ltr">
            <a href="habitats-key.jsp">EUNIS habitat classification 2012</a>
            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <c:forEach items="${actionBean.factsheet.otherHabitatsRelations}" var="other" varStatus="loop">
            <span id="breadcrumbs-${loop.index + 1}" style="display: inline-block;" dir="ltr">
                <c:if test="${not empty other.eunisCode}">
                    ${other.eunisCode} -
                </c:if>
                <c:choose>
                    <c:when test="${other.idHabitat != '10000'}">
                        <a href="habitats/${other.idHabitat}">${eunis:bracketsToItalics(eunis:replaceTags(other.scientificName))}</a>
                    </c:when>
                    <c:otherwise>
                        ${other.scientificName}
                    </c:otherwise>
                </c:choose>
                <span class="breadcrumbSeparator">
                    &gt;
                </span>
            </span>
        </c:forEach>
        <span id="breadcrumbs-current" style="display: inline-block;" dir="ltr">
            <c:if test="${not empty actionBean.factsheet.eunisHabitatCode}">
                ${eunis:formatString(actionBean.factsheet.eunisHabitatCode, '')} -
            </c:if>
            ${eunis:bracketsToItalics(eunis:replaceTags(actionBean.factsheet.habitatScientificName))}
        </span>
    </div>

</c:if>

</stripes:layout-definition>