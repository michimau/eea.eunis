<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <c:choose>
        <c:when test="${!empty actionBean.gbifLink}">
            <p>
                <a href="http://data.gbif.org/species/${actionBean.gbifLink}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF page')}</a>
            </p>
        </c:when>
        <c:otherwise>
            <p>
                <a href="http://data.gbif.org/species/${actionBean.gbifLink2}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF search')}</a>
            </p>
        </c:otherwise>
    </c:choose>
    <c:if test="${actionBean.natureObjectAttributesMap['sameSynonymAnimalsWCMC'] == null && actionBean.natureObjectAttributesMap['sameSynonymPlantsWCMC'] == null}">
        <p>
            <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on UNEP-WCMC')}" href="http://www.unep-wcmc-apps.org/isdb/Taxonomy/tax-gs-search2.cfm?displaylanguage=ENG&amp;source=${actionBean.kingdomname}&amp;GenName=${actionBean.specie.genus}&amp;SpcName=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC search')}</a>
        </p>
    </c:if>

    <c:if test="${actionBean.factsheet.speciesGroup == 'fishes'}">
        <p>
            <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fishbase')}" href="http://www.fishbase.de/Summary/SpeciesSummary.php?genusname=${actionBean.specie.genus}&amp;speciesname=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fishbase search')}</a>
        </p>
    </c:if>
    <c:if test="${!empty actionBean.wormsid}">
        <p>
            <a href="http://www.marinespecies.org/aphia.php?p=taxdetails&amp;id=${actionBean.wormsid}" title="World Register of Marine Species page">${eunis:cmsPhrase(actionBean.contentManagement, 'WoRMS page')}</a>
        </p>
    </c:if>
    <c:choose>
        <c:when test="${!empty actionBean.faeu}">
            <p>
                <a href="http://www.faunaeur.org/full_results.php?id=${actionBean.faeu}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fauna Europaea page')}</a>
            </p>
        </c:when>
        <c:otherwise>
            <c:if test="${actionBean.kingdomname == 'Animals'}">
                <p>
                    <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fauna Europaea')}" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus=${actionBean.specie.genus}&amp;species=${actionBean.speciesName}">${eunis:cmsPhrase(actionBean.contentManagement, 'Search Fauna Europaea')}</a>
                </p>
            </c:if>
        </c:otherwise>
    </c:choose>
    <c:if test="${empty actionBean.itisTSN}">
        <p>
            <a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=Scientific_Name&amp;search_kingdom=every&amp;search_span=exactly_for&amp;search_value=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;categories=All&amp;source=html&amp;search_credRating=All">${eunis:cmsPhrase(actionBean.contentManagement, 'Search ITIS')}</a>
        </p>
    </c:if>
    <c:choose>
        <c:when test="${!empty actionBean.ncbi}">
            <p>
                <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=${actionBean.ncbi}&amp;lvl=0">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI:')}${actionBean.ncbi}</a>
            </p>
        </c:when>
        <c:otherwise>
            <p>
                <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on NCBI Taxonomy browser')}" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI Taxonomy search')}</a>
            </p>
        </c:otherwise>
    </c:choose>
    <c:forEach items="${actionBean.links}" var="link" varStatus="loop">
        <p>
            <c:choose>
                <c:when test="${!empty link.url}">
                    <a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
                </c:when>
                <c:otherwise>
                    ${link.name}
                </c:otherwise>
            </c:choose>
        </p>
    </c:forEach>

    <%--todo: External Data goes here--%>
    <stripes:layout-render name="/stripes/species-factsheet/species-linkeddata.jsp"/>

</stripes:layout-definition>