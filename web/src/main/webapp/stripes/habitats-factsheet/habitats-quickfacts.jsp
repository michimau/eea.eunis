<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- quick facts -->
    <!--  Description on the left -->
    <div class="left-area">
        <div>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'English name')}:
            <span class="bold">${eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(actionBean.factsheet.habitatDescription))}</span>
            <c:forEach items="${actionBean.descriptions}" var="desc" varStatus="loop">
                <c:if test="${fn:toLowerCase(desc.language) == 'english'}">
                    <h4>
                            ${eunis:cmsPhrase(actionBean.contentManagement, 'Description')} ( ${desc.language} )
                    </h4>
                    <p>
                            ${eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(desc.description))}
                    </p>
                    <c:if test="${!empty desc.ownerText && !fn:toLowerCase(desc.ownerText) == 'n/a'}">
                        <h3>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Additional note')}
                        </h3>
                        <p>
                                ${desc.ownerText}
                        </p>
                    </c:if>
                    <%--<c:if test="${!empty desc.idDc && idDc != -1}">--%>
                        <%--<c:set var="ssource" value="${eunis:execMethodParamInteger('ro.finsiel.eunis.factsheet.species.SpeciesFactsheet', 'getBookAuthorDate', desc.idDc)}"/>--%>
                        <%--<c:if test="${!empty ssource}">--%>
                            <%--<h4>--%>
                                    <%--${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}--%>
                            <%--</h4>--%>
                            <%--<p>--%>
                                <%--<a href="references/${desc.idDc}">${eunis:treatURLSpecialCharacters(ssource)}</a>--%>
                            <%--</p>--%>
                        <%--</c:if>--%>
                    <%--</c:if>--%>
                </c:if>
            </c:forEach>
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

    <!-- END quick facts -->
</stripes:layout-definition>