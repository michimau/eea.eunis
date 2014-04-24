<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<%--todo--%>
    <script>
        $("#conservation-accordion").addClass("nodata");
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
                    <a href="${actionBean.conservationStatus.url}">Conservation status 2006 - expert table</a>
                </li>
            </c:if>
        </ul>
    </c:if>
    </div>
</stripes:layout-definition>
