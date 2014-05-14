<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<c:choose>
    <c:when test="${actionBean.factsheet.code2000 != 'na'}">
        EU's Habitats Directive conservation status assesses if a habitat type has a favourable conservation status

        <div class="map-border" style="width: 600px;">
            <iframe id="habitatStatusMap" src="" height="400px" width="100%"></iframe>
        </div>

        <script>
            addReloadOnDisplay("conservationPane", "habitatStatusMap", "http://discomap.eea.europa.eu/map/Filtermap/?webmap=e7e4c618f20344a8a148c5f63ec8766b&Code=${actionBean.factsheet.code2000}");
        </script>

        <div class="discreet">
            <c:if test="${not empty actionBean.conservationStatusPDF or not empty actionBean.conservationStatus}">
                Sources:
                <ul>
                    <c:if test="${not empty actionBean.conservationStatusPDF}">
                        <li>
                            <a href="${actionBean.conservationStatusPDF.url}">Conservation status 2006 – summary (pdf)</a>
                        </li>
                    </c:if>
                    <c:if test="${not empty actionBean.conservationStatus}">
                        <li>
                            <a href="${actionBean.conservationStatus.url}">${actionBean.conservationStatus.name}</a>
                        </li>
                    </c:if>
                </ul>
            </c:if>
        </div>

    </c:when>
    <c:otherwise>
        ${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}
        <script>
        $("#conservation-accordion").addClass("nodata");
        </script>
    </c:otherwise>
</c:choose>

</stripes:layout-definition>
