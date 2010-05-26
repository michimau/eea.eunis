<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<h2>
		${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF observations')}
	</h2>
  	<div id="myMap">
    	<p>${eunis:cmsPhrase(actionBean.contentManagement, 'If GBIF has no information about this species, you will only see this text.')}</p>
    	<p>
			<noscript>
				${eunis:cmsPhrase(actionBean.contentManagement, 'Webbrowsers without Javascript can go directly to')} <a href="http://data.gbif.org/species/${eunis:encode(actionBean.specie.scientificName)}">GBIF's page on ${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}</a>
			</noscript>
		</p>
  	</div>
  	<script type="text/javascript">
    	function populateMap(obj) {
			document.getElementById('myMap').innerHTML = obj.Resultset.Result[0].mapHTML;
    	}
  	</script>
  	<script type="text/javascript" src="http://data.gbif.org/species/nameSearch?rank=species&amp;view=json&amp;callback=populateMap&amp;returnType=nameIdMap&amp;query=${eunis:encode(actionBean.specie.scientificName)}"></script>
  	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(actionBean.contentManagement, 'gbif')}
</stripes:layout-definition>