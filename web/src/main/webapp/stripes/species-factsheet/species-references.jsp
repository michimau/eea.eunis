<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>
    <!-- detailed reference -->
    <a name="legal-instruments"></a>
    <h2 class="visualClear" id="legal-status">Legal status</h2>

    <%--todo: change the table according to http://taskman.eionet.europa.eu/issues/15649--%>

                <div class='detailed-reference'>
                    <h3 class="visualClear" id="legal-instruments">${eunis:cmsPhrase(actionBean.contentManagement, 'Mentioned in the following international legal instruments and agreements')}</h3>

                    <table summary="List of legal instruments"
                       class="listing fullwidth">
                        <thead>
                        <tr>
                            <th scope="col" style="cursor: pointer;"><img
                                    src="http://www.eea.europa.eu/arrowBlank.gif"
                                    height="6" width="9">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Detailed reference')}
                                <img src="http://www.eea.europa.eu/arrowUp.gif"
                                     height="6" width="9"></th>
                            <th scope="col" style="cursor: pointer;"><img
                                    src="http://www.eea.europa.eu/arrowBlank.gif"
                                    height="6" width="9">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Legal text')}
                                <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                     height="6" width="9"></th>
                            <th scope="col" style="cursor: pointer;"><img
                                    src="http://www.eea.europa.eu/arrowBlank.gif"
                                    height="6" width="9">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Comments')}
                                <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                     height="6" width="9"></th>
                            <th scope="col" style="cursor: pointer;"><img
                                    src="http://www.eea.europa.eu/arrowBlank.gif"
                                    height="6" width="9">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Url')}
                                <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                     height="6" width="9"></th>
                        </tr>
                        </thead>
                        <tbody>

						<c:forEach items="${actionBean.legalStatuses}" var="legal" varStatus="loop">
							<tr ${loop.index % 2 == 0 ? 'zebraodd' : 'class="zebraeven"'}>
								<td>
		          					<a href="references/${ legal.idDc }">${ legal.detailedReference }</a>
		        				</td>
		        				<td>
		          					${ legal.legalText }
		        				</td>
		        				<td>
		              				${ legal.comments }
		        				</td>
		        				<td>
		        					<a href="${ legal.url }" title="${ legal.url }">${ legal.formattedUrl }</a>
		        				</td>
							</tr>
						</c:forEach>
						</tbody>
					  </table>
                    
                  <%--<p>See also <a href="${ actionBean.unepWcmcPageLink }">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC page')}</a>--%>
                  <%--</p>--%>
                </div>
                <!-- END detailed reference -->
</stripes:layout-definition>
