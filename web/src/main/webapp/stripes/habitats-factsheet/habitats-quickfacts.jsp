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
                <c:if test="${actionBean.resolution4}">
                    <li>
                        <a href="${ actionBean.pageUrl }#legal" onclick="openSection('legal');"><span class="bold">Resolution 4 habitat type</span></a> used for designation of Emerald sites (Bern Convention)
                    </li>
                </c:if>
                <c:if test="${not empty actionBean.resolution4Parent}">
                    <li>
                        This habitat type is included in a <span class="bold">Resolution 4 habitat type</span> (Bern convention) at a higher level (<a href="/habitats/${actionBean.resolution4Parent.idHabitat}">${actionBean.resolution4Parent.eunisHabitatCode}</a>)

                    </li>
                </c:if>

                <c:if test="${actionBean.habitatsDirective}">
                    <li>
                        Relation to one or more <a href="${ actionBean.pageUrl }#legal" onclick="openSection('legal');"><span class="bold">Annex I habitat types</span></a> (EU Habitats Directive)
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
    <c:if test="${fn:length(actionBean.englishDescription)>=actionBean.descriptionThreshold}">
        <stripes:layout-render name="/stripes/habitats-factsheet/habitats-quickfacts-description.jsp"/>
    </c:if>

    <!-- END quick facts -->
</stripes:layout-definition>