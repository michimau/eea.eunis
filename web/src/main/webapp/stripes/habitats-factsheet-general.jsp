<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
	<c:if test="${!empty actionBean.pic && !empty actionBean.pic.filename}">
		<div class="naturepic-plus-container naturepic-right">
	  		<div class="naturepic-plus">
	    		<div class="naturepic-image">
			   		<a href="javascript:openpictures('${actionBean.pic.domain}/pictures.jsp?${actionBean.pic.url}',600,600)"">
				    	<img src="${actionBean.pic.path}/${actionBean.pic.filename}" alt="${actionBean.pic.description}" class="scaled" style="${actionBean.pic.style}"/>
				    </a>
			    </div>
			    <div class="naturepic-note">
              		${actionBean.pic.description}
	    		</div>
	    		<c:if test="${!empty actionBean.pic.source}">
					<div class="naturepic-source-copyright">
						${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}: ${actionBean.pic.source}
					</div>
	    		</c:if>
	  		</div>
  		</div>
	</c:if>
	<div class="allow-naturepic">
		<table class="tabledata fullwidth" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse;">
    		<col style="width:20%"/>
    		<col style="width:50%"/>
    		<col style="width:30%"/>
    		<tbody>
      			<tr>
        			<td>
          				${eunis:cmsPhrase(actionBean.contentManagement, 'English name')}
        			</td>
        			<td>
          				<strong>
          					${eunis:treatURLSpecialCharacters(actionBean.factsheet.habitatDescription)}
          				</strong>
        			</td>
        			<%-- Link to key navigation, taxonomic tree and diagram --%>
        			<td align="center">
        				<c:if test="${actionBean.factsheet.eunis && !empty actionBean.factsheet.habitatLevel}">
		        			<c:if test="${actionBean.factsheet.habitatLevel < 3}">
		        				<%-- Key navigation--%>
		          				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Open key navigation page')}" href="habitats-key.jsp?pageCode=${actionBean.factsheet.eunisHabitatCode}&amp;level=${actionBean.factsheet.habitatLevel + 1}">
		          					<img alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Key navigation')}" src="images/mini/key_in.png" width="20" height="20" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Go to habitat key navigation')}" border="0" />
		          				</a>&nbsp;&nbsp;
		        			</c:if>
		        			<c:if test="${actionBean.factsheet.habitatLevel > 1}">
		        				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Open code browser')}" href="habitats-code-browser.jsp?Code=${actionBean.factsheet.eunisHabitatCode}&amp;habID=${actionBean.idHabitat}&amp;fromFactsheet=yes">
		        					<img alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Open code browser')}" src="images/mini/tree.gif" width="20" height="20" border="0" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Show habitat in taxonomic tree')}" />
		        				</a>&nbsp;&nbsp;
		        			</c:if>
		        			<c:if test="${actionBean.factsheet.habitatLevel == 1}">
		        				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Open tree navigation')}" href="habitats-code-browser.jsp">
		        					<img alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Open tree navigation')}" src="images/mini/tree.gif" width="20" height="20" border="0" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Show habitat in taxonomic tree')}" />
		        				</a>&nbsp;&nbsp;
		        			</c:if>
		        			<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Show diagram image')}" href="habitats-diagram.jsp?habCode=${actionBean.factsheet.eunisHabitatCode}">
		        				<img alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Diagram icon')}" src="images/mini/diagram_out.png" width="20" height="20" border="0" />
		        			</a>
	        			</c:if>
	        		</td>
	        	</tr>
	        </tbody>
		</table>
		<br />
  		<%-- Habitat code and Level for EUNIS habitats, original code for NATURA --%>
  		<table class="tabledata fullwidth" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse;">
    		<col style="width:20%"/>
    		<col style="width:50%"/>
    		<col style="width:15%"/>
    		<col style="width:15%"/>
    		<tbody>
	    		<c:choose>
					<c:when test="${actionBean.factsheet.eunis}">
		    			<tr>
		        			<td>
		          				${eunis:cmsPhrase(actionBean.contentManagement, 'EUNIS habitat type code')}
		        			</td>
		        			<td>
		          				&nbsp;
		          				<strong>
		            				${eunis:formatString(actionBean.factsheet.eunisHabitatCode, '')}
		          				</strong>
		        			</td>
		        			<td bgcolor="#DDDDDD" align="right">
		          				${eunis:cmsPhrase(actionBean.contentManagement, 'Level')}
		        			</td>
		        			<td bgcolor="#DDDDDD">
		          				&nbsp;
		          				<strong>
		            				${eunis:formatString(actionBean.factsheet.habitatLevel, '')}
		          				</strong>
		        			</td>
		      			</tr>
		      		</c:when>
					<c:otherwise>
						<tr>
	        				<td>
	          					${eunis:cmsPhrase(actionBean.contentManagement, 'NATURA 2000 habitat type code')}
	        				</td>
	        				<td colspan="3">
	          					&nbsp;
	          					<strong>
	            					${eunis:formatString(actionBean.factsheet.code2000, '')}
	          					</strong>
	        				</td>
	      				</tr>
	      				<tr>
	        				<td>
	          					${eunis:cmsPhrase(actionBean.contentManagement, 'Originally published code')}
	        				</td>
	        				<td>
	          					<strong>
	            					&nbsp;
	            					<c:choose>
										<c:when test="${actionBean.factsheet.annexI}">
											${eunis:formatString(actionBean.factsheet.habitat.codeAnnex1, '')}
										</c:when>
										<c:otherwise>
											${eunis:formatString(actionBean.factsheet.habitat.originallyPublishedCode, '')}
										</c:otherwise>
									</c:choose>
	          					</strong>
	        				</td>
	        				<td style="text-align: right;">
	          					${eunis:cmsPhrase(actionBean.contentManagement, 'Priority')}
	          					&nbsp;
	        				</td>
	        				<td>
	          					<strong>
	            					&nbsp;
	            					<c:choose>
										<c:when test="${!empty actionBean.factsheet.priority && actionBean.factsheet.priority == 1}">
											${eunis:cmsPhrase(actionBean.contentManagement, 'Yes')}
										</c:when>
										<c:otherwise>
											${eunis:cmsPhrase(actionBean.contentManagement, 'No')}
										</c:otherwise>
									</c:choose>
	            					&nbsp;
	          					</strong>
	        				</td>
	      				</tr>
					</c:otherwise>
				</c:choose>
				<c:if test="${!empty actionBean.factsheet.edition}">
					<tr>
						<td>
							${eunis:cmsPhrase(actionBean.contentManagement, 'Edition')}
						</td>
						<td colspan="3">
				          	&nbsp;
				          	<strong>
				            	${actionBean.factsheet.edition}
				          	</strong>
				        </td>
					</tr>
				</c:if>
			</tbody>
  		</table>
  		<c:forEach items="${actionBean.descriptions}" var="desc" varStatus="loop">
  			<c:if test="${fn:toLowerCase(desc.language) == 'english'}">
  				<br />
  				<h2>
    				${eunis:cmsPhrase(actionBean.contentManagement, 'Description')} ( ${desc.language} )
  				</h2>
  				<p>
    				${eunis:treatURLSpecialCharacters(desc.description)}
  				</p>
  				<c:if test="${!empty desc.ownerText && !fn:toLowerCase(desc.ownerText) == 'n/a'}">
  					<h3>
      					${eunis:cmsPhrase(actionBean.contentManagement, 'Additional note')}
    				</h3>
    				<p>
      					${desc.ownerText}
    				</p>
  				</c:if>
  				<c:if test="${!empty desc.idDc}">
  					<c:set var="ssource" value="${eunis:execMethodParamInteger('ro.finsiel.eunis.factsheet.species.SpeciesFactsheet', 'getBookAuthorDate', desc.idDc)}"/>
  					<c:if test="${!empty ssource}">
  						<h3>
		  					${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
						</h3>
						<p>
		  					<a href="documents/${desc.idDc}">${eunis:treatURLSpecialCharacters(ssource)}</a>
						</p>
  					</c:if>
  				</c:if>
  			</c:if>
  		</c:forEach>
	</div>
	<h2>${eunis:cmsPhrase(actionBean.contentManagement, 'External links')}</h2>
	<div id="linkcollection">
		<div>
	        <a href="http://www.google.com/search?q=${actionBean.factsheet.habitat.scientificName}">${eunis:cmsPhrase(actionBean.contentManagement, 'Search on Google')}</a>
		</div>
		<c:if test="${!empty actionBean.art17link}">
			<div>
				<a href="${actionBean.art17link}">${eunis:cmsPhrase(actionBean.contentManagement, 'Article 17 Summary')}</a>
			</div>
		</c:if>
		<c:if test="${!empty actionBean.factsheet.code2000}">
			<div>
				<a href="http://natura2000.eea.europa.eu/#annexICode=${actionBean.factsheet.code2000}">${eunis:cmsPhrase(actionBean.contentManagement, 'Natura2000 mapviewer')}</a>
			</div>
		</c:if>
	</div>
	<c:if test="${!empty actionBean.factsheet.internationalNames}">
		<br />
    	<h2>
      		${eunis:cmsPhrase(actionBean.contentManagement, 'Name in other languages')}
    	</h2>
    	<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Name in other languages')}" class="listing fullwidth">
      		<thead>
        		<tr>
          			<th scope="col">
            			${eunis:cmsPhrase(actionBean.contentManagement, 'Language')}
          			</th>
          			<th scope="col">
            			${eunis:cmsPhrase(actionBean.contentManagement, 'Name')}
          			</th>
        		</tr>
      		</thead>
      		<tbody>
      		<c:forEach items="${actionBean.factsheet.internationalNames}" var="name" varStatus="loop">
      			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
      				<td>
          				${name.nameEn}
        			</td>
        			<td>
          				${name.name}
        			</td>
      			</tr>
      		</c:forEach>
      		</tbody>
    	</table>
	</c:if>
	<c:if test="${!empty actionBean.factsheet.otherClassifications || !empty actionBean.factsheet.otherHabitatsRelations}">
		<br />
    	<h2>
      		${eunis:cmsPhrase(actionBean.contentManagement, 'Relationships with other classifications')}
    	</h2>
    	<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Relationships with other classifications')}" class="listing fullwidth">
      		<col style="width:30%"/>
      		<col style="width:15%"/>
      		<col style="width:40%"/>
      		<col style="width:15%"/>
      		<thead>
	      		<tr>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Classification')}
	        		</th>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Code')}
	        		</th>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Title')}
	        		</th>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Relation type')}
	        		</th>
	      		</tr>
    		</thead>
    		<tbody>
	    		<c:if test="${!empty actionBean.factsheet.otherClassifications}">
	    			<c:forEach items="${actionBean.factsheet.otherClassifications}" var="classif" varStatus="loop">
						<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
							<td>
								${eunis:formatString(eunis:treatURLSpecialCharacters(classif.name), '&nbsp;')}
	        				</td>
	        				<td>
	          					${eunis:formatString(classif.code, '&nbsp;')}
	        				</td>
	        				<td>
	          					${eunis:formatString(classif.title, '&nbsp;')}
	        				</td>
	        				<td>
	          					${eunis:execMethodParamString('ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet', 'mapHabitatsRelations', classif.relationType)}
	        				</td>
						</tr>    				
	    			</c:forEach>
	    		</c:if>
	    		<c:if test="${!empty actionBean.factsheet.otherHabitatsRelations}">
	    			<c:forEach items="${actionBean.factsheet.otherHabitatsRelations}" var="other" varStatus="loop">
						<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
							<td>
	          					&nbsp;
	        				</td>
	        				<td>
	          					${other.eunisCode}
	        				</td>
	        				<td>
		        				<c:choose>
									<c:when test="${other.idHabitat != '10000'}">
		          						<a href="habitats/${other.idHabitat}">${other.scientificName}</a>
									</c:when>
									<c:otherwise>
							          	${other.scientificName}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:if test="${other.level < 3 && eunis:execMethodParamString('ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet', 'isEunis', other.idHabitat)}">
									<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Go to key navigator, starting with this habitat')}" href="habitats-key.jsp?pageCode=${other.eunisCode}&amp;level=${other.level + 1}">
										<img src="images/mini/key_out.png" alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Go to key navigator, starting with this habitat')}" border="0" />
									</a>
								</c:if>
								&nbsp;&nbsp;&nbsp;${other.relation}
							</td>
						</tr>
					</c:forEach>
	    		</c:if>
    		</tbody>
    	</table>
	</c:if>
	<c:choose>
		<c:when test="${!empty actionBean.factsheet.picturesForHabitats}">
			<a href="javascript:openpictures('${actionBean.domainName}/pictures.jsp?${actionBean.picsURL}',600,600)">
				${eunis:cmsPhrase(actionBean.contentManagement, 'View pictures')}
			</a>
		</c:when>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.upload_pictures_RIGHT}">
			<a href="javascript:openpictures('${actionBean.domainName}/pictures-upload.jsp?operation=upload&amp;${actionBean.picsURL}',600,600)">
				${eunis:cmsPhrase(actionBean.contentManagement, 'Upload pictures')}
			</a>
		</c:when>
		<c:otherwise>
		</c:otherwise>
	</c:choose>
</stripes:layout-definition>