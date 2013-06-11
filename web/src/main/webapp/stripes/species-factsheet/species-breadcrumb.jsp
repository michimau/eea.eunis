<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <!-- breadcrumbs -->
    <div id="portal-breadcrumbs" class='species-taxonomy'>
        <span id="breadcrumbs-home">
            <a href="${actionBean.context.domainName}">EUNIS Home</a>
            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <!--  FIXME link -->
        <c:forEach items="${actionBean.classifications}" var="classif" varStatus="loop">
            <span id="breadcrumbs-${loop.index + 1}" dir="ltr">
                ${classif.level}:
                <a href="species-taxonomic-browser.jsp?expand=${actionBean.breadcrumbClassificationExpands[loop.index]}#level_${classif.id}">${classif.name}</a>
                <span class="breadcrumbSeparator">
                    &gt;
                </span>
            </span>
        </c:forEach>

        <!--  FIXME link -->
        <span id="breadcrumbs-${fn:length(actionBean.classifications)+1}" dir="ltr">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Genus')}:
            ${actionBean.specie.genus}
            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <!--  FIXME link -->
        <span id="breadcrumbs-current" dir="ltr">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Species')}:
            ${actionBean.scientificName }
            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <!--  FIXME link -->
        
        <span id="breadcrumbs-last" dir="ltr">
            See subspecies
        </span>
    </div>
    <!-- END breadcrumbs -->
</stripes:layout-definition>