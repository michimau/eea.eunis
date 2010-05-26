<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:if test="${!empty actionBean.vernNames}">
		<h2>
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Vernacular names')}
  		</h2>
  		<table summary="${eunis:cms(actionBean.contentManagement, 'vernacular_names')}" class="listing fullwidth">
    		<thead>
      			<tr>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Vernacular Name')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Language')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
    			<c:forEach items="${actionBean.vernNames}" var="vern" varStatus="loop">
    				<c:set var="ref" value="-1"></c:set>
    				<c:if test="${!empty vern.idDc}">
    					<c:set var="ref" value="${vern.idDc}"></c:set>
    				</c:if>
					<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
						<td xml:lang="${vern.languageCode}">
          					${eunis:treatURLSpecialCharacters(vern.name)}
        				</td>
        				<td>
          					${vern.language}
        				</td>
        				<td>
              				<a class="link-plain" href="documents/${ref}">${eunis:getAuthorAndUrlByIdDc(ref)}</a>
        				</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</c:if>
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'vernacular_names')}
</stripes:layout-definition>