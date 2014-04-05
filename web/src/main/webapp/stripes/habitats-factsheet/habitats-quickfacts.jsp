<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- quick facts -->
    <!--  Description on the left -->
    <div class="left-area">
        <div style="margin-left: 5px;">
                ${eunis:cmsPhrase(actionBean.contentManagement, 'English name')}:
            <span class="bold">${eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(actionBean.factsheet.habitatDescription))}</span>
            <c:if test="${fn:length(actionBean.englishDescription)<actionBean.descriptionThreshold}">
                <stripes:layout-render name="/stripes/habitats-factsheet/habitats-quickfacts-description.jsp"/>
            </c:if>
        </div>
    </div>

    <!-- Textual facts on right -->
    <div class="right-area">
        <h4>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h4>
        <div>
            <ul>
                <li>
                    <span class="bold">${eunis:cmsPhrase(actionBean.contentManagement, 'EUNIS habitat type')}</span>
                    <span class="discreet">(code ${eunis:formatString(actionBean.factsheet.eunisHabitatCode, '')})</span>
                </li>
                <li>
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Protected by')}:
                    <c:choose>
                        <c:when test="${not empty actionBean.protectedBy}">
                            <a href="${ actionBean.pageUrl }#legal" onclick="openSection('legal');">
                            <c:forEach items="${actionBean.protectedBy}" var="legal" varStatus="stat">
                                <span class="bold">${legal}</span><c:if test="${not stat.last}">, </c:if>
                            </c:forEach>
                            </a>
                        </c:when>
                        <c:otherwise><span class="bold">Not available</span></c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>
    </div>
    <c:if test="${fn:length(actionBean.englishDescription)>=actionBean.descriptionThreshold}">
        <stripes:layout-render name="/stripes/habitats-factsheet/habitats-quickfacts-description.jsp"/>
    </c:if>

    <!-- END quick facts -->
</stripes:layout-definition>