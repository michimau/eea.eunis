<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- quick facts -->

    <!--  Description on the left -->
    <div class="left-area">
        <div style="margin-left: 5px;">
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
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'EU Habitats Directive')}
                    <span class="bold">${eunis:cmsPhrase(actionBean.contentManagement, 'Annex I habitat type')}</span>
                    <c:if test="${not empty actionBean.factsheet.code2000}">
                        <span class="discreet">(code ${eunis:formatString(actionBean.factsheet.code2000, '')})</span>
                    </c:if>
                </li>
                <li>
                    <a href="${ actionBean.pageUrl }#sites" onclick="openSection('species');"><span class="bold">${fn:length(actionBean.speciesForHabitats)}</span></a> characteristic species
                </li>
                <li>
                    Protected in
                    <a href="${ actionBean.pageUrl }#sites" onclick="openSection('sites');"><span class="bold">${fn:length(actionBean.sites)}</span></a>
                     Natura 2000 sites
                </li>
            </ul>
            <br>
            <c:if test="${actionBean.factsheet.annexI}">
                    <span class="discreet">
                    <c:forEach items="${actionBean.descriptions}" var="desc" varStatus="loop">
                        <c:if test="${!empty desc.idDc && idDc != -1}">
                            <c:set var="ssource" value="${eunis:execMethodParamInteger('ro.finsiel.eunis.factsheet.species.SpeciesFactsheet', 'getBookAuthorDate', desc.idDc)}"/>
                            <c:if test="${!empty ssource}">
                                <p>
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
                                    <a href="references/${desc.idDc}">${eunis:treatURLSpecialCharacters(ssource)}</a>
                                </p>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    </span>
            </c:if>
        </div>
    </div>

    <!-- END quick facts -->
</stripes:layout-definition>