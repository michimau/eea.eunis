<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>


    <%--<c:if test="${actionBean.natureObjectAttributesMap['sameSynonymAnimalsWCMC'] == null && actionBean.natureObjectAttributesMap['sameSynonymPlantsWCMC'] == null}">--%>
        <%--<p>--%>
            <%--<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on UNEP-WCMC')}" href="http://www.unep-wcmc-apps.org/isdb/Taxonomy/tax-gs-search2.cfm?displaylanguage=ENG&amp;source=${actionBean.kingdomname}&amp;GenName=${actionBean.specie.genus}&amp;SpcName=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC search')}</a>--%>
        <%--</p>--%>
    <%--</c:if>--%>


    <%--<c:if test="${empty actionBean.itisTSN}">--%>
        <%--<p>--%>
            <%--<a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=Scientific_Name&amp;search_kingdom=every&amp;search_span=exactly_for&amp;search_value=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;categories=All&amp;source=html&amp;search_credRating=All">${eunis:cmsPhrase(actionBean.contentManagement, 'Search ITIS')}</a>--%>
        <%--</p>--%>
    <%--</c:if>--%>

    <%--<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on NCBI Taxonomy browser')}" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI Taxonomy search')}</a>--%>


    <table class="listing fullwidth">
    <c:forEach items="${actionBean.links}" var="link" varStatus="loop">
        <tr>
            <td>
                <c:choose>
                    <c:when test="${!empty link.url}">
                        <a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
                    </c:when>
                    <c:otherwise>
                        ${link.name}
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                ${link.description}
            </td>
        </tr>
    </c:forEach>
    </table>

    <%--todo: External Data goes here--%>
    <stripes:layout-render name="/stripes/species-factsheet/species-linkeddata.jsp"/>

</stripes:layout-definition>