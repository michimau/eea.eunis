<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



                <!-- species protection -->
                <a name="protected"></a>
                <h2 class="visualClear" id="protected">This species is being protected in Europe</h2>

                <div id="protected_sites_table" class="left-area protected-sites" style="height: 320px">
                    <h3>Protected Sites (Natura 2000) - Table</h3>
                    <div class="scroll-auto" style="height: 260px">
                    <table id="listItem" summary="List of sites" class="sortable listing">
                        <thead>
                        <tr>
                            <th class="dt_sortable">Site code</th>
                            <th class="dt_sortable">Source data set</th>
                            <th class="dt_sortable">Country</th>
                            <th class="dt_sortable">Site name</th>
                        </tr>
                        </thead>
                        <tbody>

						<c:forEach items="${actionBean.speciesSitesTable}" var="site" varStatus="loop">
							<tr class="${loop.index % 2 == 0 ? 'zebraodd' : 'zebraeven'}">
								<td>${ site.IDSite }</td>
                            	<td>${ site.sourceDB }</td>
                            	<td><a href="${ site.areaUrl }" title="Open factsheet for ${ site.areaNameEn }">${ site.areaNameEn }</a></td>
                            	<td><a href="${ site.siteNameUrl }">${ site.name }</a></td>
							</tr>
						</c:forEach>
						
                        </tbody>
                    </table>
                    </div>
                </div>
                

                <div class="right-area protected-sites-map">
                    <h3>Protected sites - Map</h3>
                    <div class="map-view">
                        <img src="protected-sites-dummy.jpg" />
                    </div>
                </div>
                
                
                <!-- END species protection -->
                
                
                
                
                
                
                
</stripes:layout-definition>
