<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:if test="${actionBean.showGeoDistribution}">
		<h2>
	    	${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical distribution')}
	  	</h2>
	  	<table summary="layout" border="0" cellpadding="3" cellspacing="0" width="90%">
			<tr>
				<td>
					<c:if test="${!empty actionBean.colorURL}">
						<img alt="${eunis:cms(actionBean.contentManagement, 'map_image_eea')}" src="${actionBean.filename}" title="${eunis:cms(actionBean.contentManagement, 'map_image_eea')}" />
        				${eunis:cmsAlt(actionBean.contentManagement, 'map_image_eea')}
					</c:if>
					<br />
        			<a title="${eunis:cms(actionBean.contentManagement, 'open_new_window')}" href="javascript:openLink('${actionBean.mapserverURL}/getmap.asp?${actionBean.parameters}');">${eunis:cmsPhrase(actionBean.contentManagement, 'Open map in new window')}</a>
        			${eunis:cmsTitle(actionBean.contentManagement, 'open_new_window')}
      			</td>
      			<td>
        			${eunis:cmsPhrase(actionBean.contentManagement, 'Legend')}:
        			<br />
        			<c:forEach items="${actionBean.statusColorPair}" var="pair" varStatus="loop">
						<img alt="${eunis:cms(actionBean.contentManagement, 'map_image_eea')}" src="${actionBean.mapserverURL}/getLegend.asp?Color=H${pair.value}" title="${eunis:cms(actionBean.contentManagement, 'map_image_eea')}" />${eunis:cmsTitle(actionBean.contentManagement, 'map_image_eea')}&nbsp;${pair.key}
          				<br />
        			</c:forEach>
        		</td>
    		</tr>
    	</table>
    	<br />
    	<table summary="${eunis:cms(actionBean.contentManagement, 'geographical_distribution')}" class="listing fullwidth">
    		<thead>
      			<tr>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Country/Area')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic region')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
    			<c:forEach items="${actionBean.bioRegions}" var="region" varStatus="loop">
    				<c:set var="country" value="nbsp;"></c:set>
    				<c:if test="${!empty region.country}">
    					<c:set var="country" value="${region.country.areaNameEnglish}"></c:set>
    				</c:if>
    				<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
						<td>
							<c:choose> 
								<c:when test="${eunis:isCountry(region.country)}">
									<a href="sites-statistical-result.jsp?country=${eunis:treatURLSpecialCharacters(country)}&amp;DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=true&amp;DB_CORINE=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="${eunis:cms(actionBean.contentManagement, 'open_the_statistical_data_for')} ${eunis:treatURLSpecialCharacters(country)}">${eunis:treatURLSpecialCharacters(country)}</a>
          							${eunis:cmsTitle(actionBean.contentManagement, 'open_the_statistical_data_for')}
								</c:when>
						  		<c:otherwise>
									${eunis:treatURLSpecialCharacters(country)}
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							${eunis:treatURLSpecialCharacters(region.region)}&nbsp;
				        </td>
				        <td>
				          	${eunis:treatURLSpecialCharacters(region.status)}&nbsp;
				        </td>
				        <td>
							<a href="documents/${region.reference}&nbsp;">${eunis:getAuthorAndUrlByIdDc(region.reference)}</a>
				        </td>
    			</c:forEach>
    		</tbody>
    	</table>
	</c:if>
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'geographical_distribution')}
</stripes:layout-definition>