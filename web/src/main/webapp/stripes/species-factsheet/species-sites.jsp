<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



                <!-- species protection -->
                <a name="protected"></a>
                <h2 class="visualClear" id="protected">Where is the species protected?</h2>

	                <c:choose>
	                	<c:when test="${fn:length(actionBean.subSpeciesSitesTable) gt 0 }">
							<div id="protected_sites_table" class="left-area protected-sites" style="height:720px">
	                	</c:when>
	                	<c:otherwise>
							<div id="protected_sites_table" class="left-area protected-sites" style="height:460px">
	                	</c:otherwise>
	                </c:choose>
                
                    <h3>By Means of Protected Sites (Natura 2000)</h3>
                    <div class="scroll-auto" style="height: 400px">
                    <table id="listItem" summary="List of sites" class="sortable listing">
                        <thead>
                        <tr>
                            <th class="dt_sortable">Country</th>
                            <th class="dt_sortable">Site name</th>
                            <th class="dt_sortable" style="width: 165px">Action</th>
                        </tr>
                        </thead>
                        <tbody>

						<c:forEach items="${actionBean.speciesSitesTable}" var="site" varStatus="loop">
							<tr class="${loop.index % 2 == 0 ? 'zebraodd' : 'zebraeven'}">
								
								
								
                            	<td><a href="${ site.areaUrl }" title="Open factsheet for ${ site.areaNameEn }">${ site.areaNameEn }</a></td>
                            	<td><a href="${ site.siteNameUrl }">${ site.name }</a></td>
                            	<c:choose>
									<c:when test="${ site.natura2000 }">
										<td><a href="javascript:void(0);" onclick="setMapSiteId('${ site.IDSite }');">View ${ site.IDSite } on map</a></td>
									</c:when>
									<c:otherwise>
										<td>${ site.IDSite }</td>
									</c:otherwise>
								</c:choose>
							</tr>
						</c:forEach>
						
                        </tbody>
                    </table>
                    </div>
                    
                    <c:choose>
                    	<c:when test="${fn:length(actionBean.subSpeciesSitesTable) gt 0 }">
	                    <h3>Sites for subtaxa of this taxon</h3>
	                    <div class="scroll-auto" style="height: 200px">
	                    <table id="listItem" summary="List of sites" class="sortable listing">
	                        <thead>
	                        <tr>
	                            <th class="dt_sortable">Country</th>
	                            <th class="dt_sortable">Site name</th>
	                            <th class="dt_sortable" style="width: 165px">Action</th>
	                        </tr>
	                        </thead>
	                        <tbody>
	
							<c:forEach items="${actionBean.subSpeciesSitesTable}" var="site" varStatus="loop">
								<tr class="${loop.index % 2 == 0 ? 'zebraodd' : 'zebraeven'}">
									
									
									
	                            	<td><a href="${ site.areaUrl }" title="Open factsheet for ${ site.areaNameEn }">${ site.areaNameEn }</a></td>
	                            	<td><a href="${ site.siteNameUrl }">${ site.name }</a></td>
	                            	<c:choose>
										<c:when test="${ site.natura2000 }">
											<td><a href="javascript:void(0);" onclick="setMapSiteId('${ site.IDSite }');">View ${ site.IDSite } on map</a></td>
										</c:when>
										<c:otherwise>
											<td>${ site.IDSite }</td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:forEach>
							
	                        </tbody>
	                    </table>
	                    </div>
	                    </c:when>
                    </c:choose>
                    
                </div>
                

                <div class="right-area protected-sites-map">
                    <h3>Protected sites</h3>
                    <div id="sites-map" class="map-view" style="width:500px; height:400px; border:2px solid #050505;">
                    	<iframe id="protectionMap" src="http://discomap.eea.europa.eu/map/Filtermap/?webmap=0b2680c2bc544431a9a97119aa63d707&SpiecesName=${actionBean.scientificNameUrlEncoded}" width="500" height="400"></iframe>
                    
                    </div>
                </div>


				<script type="text/javascript">djConfig = { parseOnLoad:true };</script>
		        <script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.2"></script>
		
		        <script type="text/javascript">
		           		            
		            function setMapSiteId(sitecode){
		            	document.getElementById('protectionMap').src='http://discomap.eea.europa.eu/map/Filtermap/?webmap=0b2680c2bc544431a9a97119aa63d707&SiteCode='+sitecode+'&SpiecesName=${actionBean.scientificNameUrlEncoded}';
		            }

		        </script>


                <!-- END species protection -->
                
                
                
                
                
                
                
</stripes:layout-definition>
