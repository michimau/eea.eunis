<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<h2>
    	${eunis:cmsPhrase(actionBean.contentManagement, 'Grid distribution') }
  	</h2>
  	<c:if test="${actionBean.gridDistSuccess}">
  		<table width="90%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				    <img alt="${eunis:cms(actionBean.contentManagement, 'grid_distribution')}" name="mmap" src="${actionBean.gridImage}" style="vertical-align:middle" />
				    ${eunis:cmsTitle(actionBean.contentManagement, 'grid_distribution')}
				</td>
				<td align="right" valign="top">
					<a href="${pageContext.request.contextPath}/species-factsheet-distribution-kml.jsp?idSpecies=${actionBean.factsheet.idSpecies}&amp;idSpeciesLink=${actionBean.factsheet.idSpeciesLink}">
						${eunis:cms(actionBean.contentManagement, 'header_download_kml')}
					</a>
				</td>
    		</tr>
    	</table>
    	<br />
    	<br />
  	</c:if>
  	<table summary="${eunis:cms(actionBean.contentManagement, 'table_of_results')}" class="listing fullwidth">
    	<thead>
      		<tr>
		        <th>
		          	${eunis:cmsPhrase(actionBean.contentManagement, 'Code cell')}
		          	${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
		        </th>
		        <th style="text-align:right">
		        	${eunis:cmsPhrase(actionBean.contentManagement, 'Latitude (dec. deg)')}
		          	${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
		        </th>
		        <th style="text-align:right">
		        	${eunis:cmsPhrase(actionBean.contentManagement, 'Longitude (dec. deg.)')}
		          	${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
		        </th>
		        <th>
		        	${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
		          	${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
		        </th>
		        <th>
		        	${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
		          	${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
		        </th>
      		</tr>
    	</thead>
    	<tbody>
    		<c:forEach items="${actionBean.speciesDistribution }" var="dist" varStatus="loop">
				<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
					<td>${eunis:treatURLSpecialCharacters(dist.name)}</td>
 					<td style="text-align:right">${eunis:formatArea(dist.latitude, 3, 4, "&nbsp;")}</td>
 					<td style="text-align:right">${eunis:formatArea(dist.longitude, 3, 4, "&nbsp;")}</td>
 					<td>${eunis:treatURLSpecialCharacters(dist.status)}</td>
 					<td>
 						<a class="link-plain" href="documents/${dist.reference}">
 							${eunis:getAuthorAndUrlByIdDc(dist.reference)}
 						</a>
 					</td>
				</tr>
			</c:forEach>
    	</tbody>
    </table>
    ${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'table_of_results')}
	<br />
</stripes:layout-definition>