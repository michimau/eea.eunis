<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <div>
        <c:if test="${not empty actionBean.englishDescription}">
            <h4>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Description')} (English)
            </h4>
            <p>
                ${eunis:treatLineEndings(eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(actionBean.englishDescription)))}
            </p>
        </c:if>
    </div>
</stripes:layout-definition>