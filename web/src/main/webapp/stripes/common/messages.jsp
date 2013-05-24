<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
                        <stripes:layout-component name="messages">
                            <c:choose>
                                <c:when test="${actionBean.context.severity == 1}">
                                    <div class="system-msg">
                                        <stripes:messages />
                                    </div>
                                </c:when>
                                <c:when test="${actionBean.context.severity == 2}">
                                    <div class="caution-msg">
                                        <strong>Caution ...</strong>
                                        <p>
                                            <stripes:messages />
                                        </p>
                                    </div>
                                </c:when>
                                <c:when test="${actionBean.context.severity == 3}">
                                    <div class="warning-msg">
                                        <strong>Warnings ...</strong>
                                        <p>
                                            <stripes:messages />
                                        </p>
                                    </div>
                                </c:when>
                                <c:when test="${actionBean.context.severity == 4}">
                                    <div class="error-msg">
                                        <strong>Errors ...</strong>
                                        <p>
                                            <stripes:messages />
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise/>
                            </c:choose>
                        </stripes:layout-component>
</stripes:layout-definition>
