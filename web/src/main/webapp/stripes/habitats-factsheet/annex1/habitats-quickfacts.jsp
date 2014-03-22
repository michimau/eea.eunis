<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- quick facts -->

    <script>
        function openSection(sectionName) {
            if($('#' + sectionName + ' ~ h2').attr('class').indexOf('current')==-1)
                $('#' + sectionName + ' ~ h2').click();
        }
    </script>

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
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'EU Habitats Directive')}
                    <span class="bold">${eunis:cmsPhrase(actionBean.contentManagement, 'Annex I habitat type')}</span>
                    <c:if test="${not empty actionBean.factsheet.code2000}">
                        <span class="discreet">(code ${eunis:formatString(actionBean.factsheet.code2000, '')})</span>
                    </c:if>
                </li>
                <li>
                    Protected in <span class="bold">148</span> Natura 2000 sites
                    <%--todo: implement--%>
                </li>
                <li>
                    <span class="bold">8</span> associated species from Annex II and IV in EU Habitats Directive
                    <%--todo: implement--%>
                </li>
                <c:if test="${actionBean.factsheet.annexI}">
                    <span class="discreet">
                        Source: Interpretation Manual of European Union Habitats, version EUR 28 (2013)
                        <%--todo: data source?--%>
                        <%--todo: link--%>
                    </span>
                </c:if>

            </ul>
        </div>
    </div>

    <!-- END quick facts -->
</stripes:layout-definition>