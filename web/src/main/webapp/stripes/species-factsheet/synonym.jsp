<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>


    <h1>
        <c:if test="${not empty actionBean.englishName}">${actionBean.englishName} -</c:if> <span class="italics">${actionBean.scientificName}</span> ${actionBean.author}
        <span class="redirection-msg">&#8213; Synonym of <a href="${pageContext.request.contextPath}/species/${actionBean.seniorIdSpecies}"><strong>${actionBean.seniorSpecies }</strong></a></span>
    </h1>

    <c:if test="${fn:length(actionBean.parentLegal) gt 0}">
        Mentioned in the following international legal instruments and agreements:
        <ul>
            <c:forEach var="legal" items="${actionBean.parentLegal}">
                <li>
                    ${legal.parentName}
                    <c:if test="${not empty legal.parentAlternative}">(${legal.parentAlternative})</c:if>
                    <c:if test="${not empty legal.detailedReference}"><br>${legal.detailedReference}</c:if>
                </li>
            </c:forEach>
        </ul>
        <c:if test="${not empty actionBean.parentN2k}">
            <p>Natura 2000 code: <span class="bold">${actionBean.parentN2k}</span></p>
        </c:if>
    </c:if>

    All the information associated to this invalid name can be found on the page of the species or subspecies with the valid name.
</stripes:layout-definition>