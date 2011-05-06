<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
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
		<table class="datatable fullwidth">
			<col style="width:10em"/>
			<col/>
			<col style="width:10em"/>
			<col/>
			<tr>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}</th><td>${actionBean.scientificName }</td>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Taxonomic rank')}</th><td>${actionBean.factsheet.speciesObject.typeRelatedSpecies}</td>
	      		</tr>
			<tr>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}</th><td>${actionBean.author}</td>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Valid name')}</th><td>${eunis:getYesNo(actionBean.factsheet.speciesObject.validName)}</td>
	      		</tr>
		</table>
		<table class="datatable fullwidth">
	    	<thead>
	      		<tr>
	        		<th colspan="2">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Taxonomic information')}
	        		</th>
	        		<th>
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
	        		</th>
	      		</tr>
	    	</thead>
	    	<tbody>
	    		<c:forEach items="${actionBean.classifications}" var="classif" varStatus="loop">
					<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
						<td width="20%">
	          				${classif.level}
	        			</td>
	        			<td width="40%">
	          				<strong>
		            			${classif.name}
	    	      			</strong>
	        			</td>
	        			<c:if test="${classif.level == 'Kingdom'}">
	        				<td rowspan="${fn:length(actionBean.classifications) + 1}" style="text-align:center; background-color:#EEEEEE; vertical-align:middle;">
	          					<strong>
	            					${eunis:treatURLSpecialCharacters(actionBean.authorDate)}
	          					</strong>
	        				</td>
	        			</c:if>
					</tr>
				</c:forEach>
				<tr class="zebraeven">
	        		<td width="20%">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Genus')}
	        		</td>
	        		<td width="40%">
	          			<strong>
	            			${actionBean.specie.genus}
	          			</strong>
	        		</td>
	      		</tr>
	    	</tbody>
	    </table>
	    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'External links')}</h2>
	  	<div id="linkcollection">
		    <div>
		        <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Pictures of the species on Google')}" href="http://images.google.com/images?q=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Pictures on Google')}</a>
			</div>
			<c:choose> 
				<c:when test="${!empty actionBean.gbifLink}">
					<div>
		        		<a href="http://data.gbif.org/species/${actionBean.gbifLink}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF page')}</a>
		      		</div>
				</c:when>
		  		<c:otherwise>
					<div>
		        		<a href="http://data.gbif.org/species/${actionBean.gbifLink2}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF search')}</a>
		      		</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${!empty actionBean.specie.genus && !empty actionBean.speciesName}">
				<div>
		        	<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on UNEP-WCMC')}" href="http://sea.unep-wcmc.org/isdb/species.cfm?source=${actionBean.kingdomname}&amp;genus=${actionBean.specie.genus}&amp;species=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC search')}</a>
		      	</div>
			</c:if>
			<c:choose> 
				<c:when test="${!empty actionBean.redlistLink}">
					<div>
		        		<a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/0">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List page')}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<div>
			  			<a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${actionBean.scientificNameURL}&amp;mode=">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List search')}</a>
			  		</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${actionBean.factsheet.speciesGroup == 'fishes'}">
				<div>
					<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fishbase')}" href="http://www.fishbase.de/Summary/SpeciesSummary.php?genusname=${actionBean.specie.genus}&amp;speciesname=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fishbase search')}</a>
				</div>
			</c:if>
			<c:if test="${!empty actionBean.wormsid}">
				<div>
					<a href="http://www.marinespecies.org/aphia.php?p=taxdetails&amp;id=${actionBean.wormsid}" title="World Register of Marine Species page">${eunis:cmsPhrase(actionBean.contentManagement, 'WorMS page')}</a>
				</div>
			</c:if>
			<div>
	        	<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on SCIRUS')}" href="http://www.scirus.com/srsapp/search?q=%22${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}%22&amp;ds=web&amp;g=s&amp;t=all">${eunis:cmsPhrase(actionBean.contentManagement, 'SCIRUS search')}</a>
			</div>
			<c:choose> 
				<c:when test="${!empty actionBean.faeu}">
					<div>
			        	<a href="http://www.faunaeur.org/full_results.php?id=${actionBean.faeu}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fauna Europaea page')}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<div>
						<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fauna Europaea')}" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus=${actionBean.specie.genus}&amp;species=${actionBean.speciesName}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fauna Europaea')}</a>
					</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${!empty actionBean.itisTSN}">
				<div>
	        		<a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&amp;search_value=${actionBean.itisTSN}">${eunis:cmsPhrase(actionBean.contentManagement, 'ITIS TSN:')}${actionBean.itisTSN}</a>
				</div>
			</c:if>
			<c:choose> 
				<c:when test="${!empty actionBean.ncbi}">
					<div>
			        	<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=${actionBean.ncbi}&amp;lvl=0">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI:')}${actionBean.ncbi}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<div>
						<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on NCBI Taxonomy browser')}" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI Taxonomy search')}</a>
					</div>
				</c:otherwise>
			</c:choose>
			<c:forEach items="${actionBean.links}" var="link" varStatus="loop">
				<div>
	        		<a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
				</div>
			</c:forEach>
		</div> <!-- linkcollection -->
	</div> <!-- allow-naturepic -->
	<c:if test="${!empty actionBean.consStatus}">
		<br/><br/><br/>
	  	<h2 style="clear: both">
		    ${eunis:cmsPhrase(actionBean.contentManagement, 'International Threat Status')}
	  	</h2>
	  	<table summary=" ${eunis:cms(actionBean.contentManagement, 'international_threat_status')}" class="listing fullwidth">
		    <col style="width: 20%"/>
	    	<col style="width: 20%"/>
	    	<col style="width: 20%"/>
	    	<col style="width: 40%"/>
	    	<thead>
	      		<tr>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Area')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'International threat code')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	      		</tr>
	    	</thead>
	    	<tbody>
	    	<c:forEach items="${actionBean.consStatus}" var="threat" varStatus="loop">
	    		<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    			<td>
	          			${eunis:treatURLSpecialCharacters(threat.country)}
	        		</td>
	        		<td>
	          			${eunis:treatURLSpecialCharacters(threat.status)}
	        		</td>
	        		<td>
	        			<span class="boldUnderline" title="${threat.statusDesc}">
	          				${eunis:treatURLSpecialCharacters(threat.threatCode)}
	        			</span>
	        		</td>
	        		<td>
	          			<a href="documents/${threat.idDc}">${eunis:treatURLSpecialCharacters(threat.reference)}</a>
	        		</td>
	      		</tr>
	    	</c:forEach>
	    	</tbody>
		</table>
	</c:if>
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'national_threat_status')}
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'international_threat_status')}
	<br />
  	<h2 style="clear: both">
	    ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
  	</h2>
  	<table summary="layout" class="datatable fullwidth">
	    <col style="width:20%"/>
	    <col style="width:80%"/>
	    <tbody>
	    	<tr>
        		<td>
          			${eunis:cmsPhrase(actionBean.contentManagement, 'Title')}:
        		</td>
        		<td>
          			<strong>
            			${eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.title)}
          			</strong>
        		</td>
      		</tr>
      		<tr class="zebraeven">
        		<td>
          			${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}:
        		</td>
        		<td>
          			<strong>
            			${eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.author)}
          			</strong>
        		</td>
      		</tr>
      		<tr>
        		<td>
          			${eunis:cmsPhrase(actionBean.contentManagement, 'Publisher')}:
        		</td>
        		<td>
          			<strong>
            			${eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.publisher)}
          			</strong>
        		</td>
      		</tr>
      		<tr class="zebraeven">
        		<td>
          			${eunis:cmsPhrase(actionBean.contentManagement, 'Publication date')}:
        		</td>
        		<td>
          			<strong>
            			${eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.date)}
          			</strong>
        		</td>
      		</tr>
      		<tr>
        		<td>
          			${eunis:cmsPhrase(actionBean.contentManagement, 'Url')}:
        		</td>
        		<td>
        			<c:choose> 
						<c:when test="${!empty actionBean.factsheet.speciesBook.URL}">
				        	<a href="${eunis:replaceAll(eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.URL),'#','')}">${eunis:replaceAll(eunis:treatURLSpecialCharacters(actionBean.factsheet.speciesBook.URL),'#','')}</a>
						</c:when>
				  		<c:otherwise>
				  			&nbsp;
						</c:otherwise>
					</c:choose>
				</td>
      		</tr>
    	</tbody>
  	</table>
  	<c:if test="${!empty actionBean.factsheet.synonymsIterator}">
  		<br />
  		<h2>
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Synonyms')}
  		</h2>
  		<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'species_factsheet_10_Sum')}" class="listing fullwidth">
    		<col style="width:40%"/>
    		<col style="width:60%"/>
    		<thead>
      			<tr>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
        			</th>
      			</tr>	
    		</thead>
    		<tbody>
	    		<c:forEach items="${actionBean.factsheet.synonymsIterator}" var="synonym" varStatus="loop">
	    			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    				<td>
	        				<a href="${pageContext.request.contextPath}/species/${synonym.idSpecies}">${eunis:treatURLSpecialCharacters(synonym.scientificName)}</a>
	      				</td>
	      				<td>
	          				${eunis:treatURLSpecialCharacters(synonym.author)}
	      				</td>
	    			</tr>
	    		</c:forEach>
    		</tbody>
  		</table>
  	</c:if>
  	<c:if test="${!empty actionBean.subSpecies}">
  		<br />
  		<h2>
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Valid subspecies in Europe')}
  		</h2>
  		<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'species_factsheet_11_Sum')}" class="listing fullwidth">
    		<col style="width:40%"/>
    		<col style="width:60%"/>
    		<thead>
      			<tr>
        			<th>
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th>
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>	
    		</thead>
    		<tbody>
	    		<c:forEach items="${actionBean.subSpecies}" var="subspecie" varStatus="loop">
	    			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    				<td>
	        				<a style="font-style : italic;" href="species/${subspecie.idSpecies}">${eunis:treatURLSpecialCharacters(subspecie.scientificName)}</a>
          					${eunis:treatURLSpecialCharacters(subspecie.author)}
	      				</td>
	      				<td>
	          				${eunis:treatURLSpecialCharacters(subspecie.bookAuthorDate)}
	      				</td>
	    			</tr>
	    		</c:forEach>
    		</tbody>
  		</table>
  	</c:if>
  	<br />
  	<br />
  	<c:choose>
  		<c:when test="${!empty actionBean.factsheet.picturesForSpecies}">
  			<a href="javascript:openpictures('${actionBean.domainName}/pictures.jsp?${actionBean.urlPic}',600,600)">${eunis:cmsPhrase(actionBean.contentManagement, 'View pictures')}</a>
  		</c:when>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.upload_pictures_RIGHT}">
			<a href="javascript:openpictures('${actionBean.domainName}/pictures-upload.jsp?operation=upload&amp;${actionBean.urlPic}',600,600)">${eunis:cmsPhrase(actionBean.contentManagement, 'Upload pictures')}</a>
		</c:when>
		<c:otherwise>
		</c:otherwise>
	</c:choose>
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'species_factsheet_10_Sum')}
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'species_factsheet_11_Sum')}
	<br />
  	<br />
</stripes:layout-definition>
