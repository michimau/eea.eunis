<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- quick facts -->

    <!--  Description on the left -->
    <div class="left-area">
        <div>
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
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'EUNIS habitat type')}:
                    <span class="bold">${eunis:formatString(actionBean.factsheet.eunisHabitatCode, '')}</span>
                </li>
                <li>
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Protected by')}:
                    <span class="bold">[not implemented] EU Habitats Directive, CoE Bern Convention </span>
                    <%--todo--%>
                </li>
                <li>
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'English name')}:
                    <span class="bold">${eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(actionBean.factsheet.habitatDescription))}</span>
                </li>
            </ul>
        </div>
    </div>

    <!-- END quick facts -->
</stripes:layout-definition>