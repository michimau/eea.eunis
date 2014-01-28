<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<%@ page import=
"ro.finsiel.eunis.WebContentManagement"
%>

<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
WebContentManagement cm = SessionManager.getWebContent();
%>
<div class="right-area">
	<div class="species-change-view">
		<div onclick="changeSpeciesView(0);" class="species-list">
			<i class="eea-icon eea-icon-align-justify"></i><br/>List
		</div>
		<div onclick="changeSpeciesView(1);" class="species-gallery">
			<i class="eea-icon eea-icon-th"></i><br/>Gallery
		</div>
	</div>
	<br/>
	<!-- ---------------------------------- LIST VIEW ------------------------------- -->
	<div id="sites-species-list" style="display: none;">
	<c:choose>
        <c:when test="${actionBean.totalSpeciesCount>0}">
            <c:if test="${actionBean.totalSpeciesCount>24}"><div class="scroll-auto" style="height: 700px; width: 100%; clear: both;"></c:if>
            <table summary="<%=cm.cms("ecological_information_fauna_flora")%>" class="listing fullwidth table-inline">
                <thead>
                <tr>
                    <th scope="col"><%=cm.cmsPhrase("Natura 2000 code")%></th>
                    <th scope="col"><%=cm.cmsPhrase("Species scientific name")%></th>
                    <th scope="col"><%=cm.cmsPhrase("Species group")%></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${actionBean.siteSpecies}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                            <a class="link-plain" href="species/${specie.source.idSpecies}">${specie.scientificName}</a>
                        </td>
                        <td align="center">
                                ${specie.group}
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${actionBean.siteSpecificSpecies}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                            <a href="http://www.google.com/search?q=${specie.scientificName}">
                                    ${specie.scientificName}
                            </a>
                        </td>
                        <td></td>
                    </tr>
                </c:forEach>
                <c:forEach items="${actionBean.eunisSpeciesListedAnnexesDirectives}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                            <a class="link-plain"
                               href="species/${specie.source.idSpecies}">${specie.scientificName}
                            </a>
                        </td>
                        <td>
                                ${specie.group}
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${actionBean.notEunisSpeciesListedAnnexesDirectives}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                                ${specie.scientificName}
                        </td>
                        <td align="center">
                                ${specie.group}
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${actionBean.eunisSpeciesOtherMentioned}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                            <a class="link-plain" href="species/${specie.source.idSpecies}">
                                ${specie.scientificName}
                            </a>
                        </td>
                        <td>
                                ${specie.group}
                        </td>
                    </tr>
                </c:forEach>

                <c:forEach items="${actionBean.notEunisSpeciesOtherMentioned}" var="specie">
                    <tr>
                        <td>${specie.natura2000Code}</td>
                        <td>
                                ${specie.scientificName}
                        </td>
                        <td>
                                ${specie.group}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        <c:if test="${actionBean.totalSpeciesCount>24}"></div></c:if>
        </c:when>
        <c:otherwise>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'There are no species to be displayed')}
        </c:otherwise>
	</c:choose>

	</div>
	<!-- ---------------------------------- GALERY VIEW ------------------------------- -->
	<div id="sites-species-gallery">
	<c:choose>
	<c:when test="${actionBean.totalSpeciesCount>0}">
		<div class="paginate">

            <c:forEach items="${actionBean.siteSpecies}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/species/${specie.source.idSpecies}/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                    ${specie.scientificName}
		                	<br/>
		                	${specie.commonName}
		                </span>
                    </a>
                </div>
            </c:forEach>
            <c:forEach items="${actionBean.siteSpecificSpecies}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/sites/${specie.source.idSite}/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                	${specie.scientificName}
		                	<br/>
		                	${specie.commonName}
		                </span>
                    </a>
                </div>
            </c:forEach>
            <c:forEach items="${actionBean.eunisSpeciesListedAnnexesDirectives}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/species/${specie.source.idSpecies}/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                    ${specie.scientificName}
		                	<br/>
		                	${specie.commonName}
		                </span>
                    </a>
                </div>
            </c:forEach>
            <c:forEach items="${actionBean.notEunisSpeciesListedAnnexesDirectives}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
			                <span class="photoAlbumEntryWrapper">
			                    <img src="images/sites/${specie.source.idSite}/thumbnail.jpg"/>
			                </span>
			                <span class="photoAlbumEntryTitle">
			                	${specie.scientificName}
			                	<br/>
			                	${specie.group}
			                </span>
                    </a>
                </div>
            </c:forEach>
            <c:forEach items="${actionBean.eunisSpeciesOtherMentioned}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
			                <span class="photoAlbumEntryWrapper">
			                    <img src="images/species/${specie.source.idSpecies}/thumbnail.jpg"/>
			                </span>
			                <span class="photoAlbumEntryTitle">
			                	${specie.commonName}
			                	<br/>
			                	${specie.scientificName}
			                </span>
                    </a>
                </div>
            </c:forEach>
            <c:forEach items="${actionBean.notEunisSpeciesOtherMentioned}" var="specie">
                <div class="photoAlbumEntry">
                    <a href="javascript:void(0);">
				                <span class="photoAlbumEntryWrapper">
				                    <img src="images/sites/${specie.source.idSite}/thumbnail.jpg"/>
				                </span>
				                <span class="photoAlbumEntryTitle">
				                	${specie.scientificName}
				                	<br/>
				                	 ${specie.group}
				                </span>
                    </a>
                </div>
            </c:forEach>

		</div>
    </c:when>
    <c:otherwise>
        ${eunis:cmsPhrase(actionBean.contentManagement, 'There are no species to be displayed')}
    </c:otherwise>
    </c:choose>
	</div>
</div>
	
<div class="right-area">
    <h3>Species summary</h3>
    Nature directives' species in this site (${actionBean.totalSpeciesCount})
		<table class="listing table-inline">
            <thead>
            <tr>
                <th scope="col"><%=cm.cmsPhrase("Species group")%></th>
                <th scope="col"><%=cm.cmsPhrase("Number")%></th>
            </tr>
            </thead>
            <c:forEach items="${actionBean.speciesStatisticsSorted}" var="ss" varStatus="loop">
                <tr>
                    <td>${ss.key}</td>
                    <td>${ss.value}</td>
                </tr>
            </c:forEach>
		</table>
</div>
</stripes:layout-definition>