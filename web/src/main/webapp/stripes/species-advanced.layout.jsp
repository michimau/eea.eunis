<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${actionBean.pageTitle}">
	<stripes:layout-component name="head">
		<script language="JavaScript" src="script/lib/jquery.js" type="text/javascript"></script>
		<script language="JavaScript" type="text/javascript">
		    //<![CDATA[
		    	function MM_jumpMenu(targ,selObj,restore)
		    	{ 
    				eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    				if (restore) selObj.selectedIndex=0;
  				}

  				function setCurrentSelected(val) 
  				{
    				current_selected = val;
    				return true;
  				}
		    	function choice(ctl, lov, natureobject, oper) 
		    	{
    				var cur_ctl = "window.document.criteria['"+ctl+"'].value";
    				var val = eval(cur_ctl);
    				URL = 'advanced-search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + oper;
    				eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  				}

		    	function getkey(e)
		    	{
		    	    if (window.event)
		    	       return window.event.keyCode;
		    	    else if (e)
		    	       return e.which;
		    	    else
		    	       return null;
		    	}

		    	function textChanged(e)
		    	{
		    	    var key, keychar;
		    	    key = getkey(e);
		    	    if (key == null) return true;

		    	    // get character
		    	    keychar = String.fromCharCode(key);
		    	    keychar = keychar.toLowerCase();

		    	    // control keys
		    	    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 ) {
		    	      return false;
		    	    }

		    	    enableSaveButton();
		    	    return true;
		    	}

		    	$(document).ready(function() {
		    	    $('#criterion').hide();

		    	$('#criteria a:first').toggle(function(){
		    	     $('img', this).attr('src','images/mini/delete.gif');
		    	     $('#root').html('<select name="Criteria" onchange="#" title="Criteria" id="Criteria">' +
		    	      '<option selected="selected" value="All">All</option>' +
		    	      '<option value="Any">Any</option>' +
		    	      '</select>  of following criteria are met:');
		    	    
		    		$('#criterion').fadeIn('slow');
		    	},function(){
		    	    $('img', this).attr('src','images/mini/add.gif');
		    	    $('#root').html('&nbsp;Add root criterion');
		    	    $('.criterion').fadeOut('slow');

		    	});
		    	  
		    	$('a[title=Add criterion]').click(function(){
		    	    var newElem = $('#criterion').clone(true).attr('id', 'criterion2').fadeIn('slow');
		    	    $(this).parent().after(newElem);
		    	});

		    	$('a[title=Delete criterion]').click(function(){
		    	    $(this).parent().fadeOut('slow');
		    	    });
		    	});
		    //]]>
		    </script>
	</stripes:layout-component>
	<stripes:layout-component name="contents">
		<!-- MAIN CONTENT -->

		<h1>${eunis:cmsPhrase(actionBean.contentManagement, 'Species advanced search')}</h1>
		<div class="documentActions">
			<h5 class="hiddenStructure">${eunis:cms(actionBean.contentManagement, 'Document Actions')}</h5>
			${eunis:cmsTitle(actionBean.contentManagement, 'Document Actions')}
			<ul>
				<li>
					<a href="javascript:this.print();"> 
						<img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
							 alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
							 title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" />
					</a>
				</li>
				<li><a href="javascript:toggleFullScreenMode();"> 
					<img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
						 alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
					 	 title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" />
					</a>
				</li>
			</ul>
		</div>
		${eunis:cmsPhrase(actionBean.contentManagement, 'Search species information using multiple characteristics')}
        <br />
		<br />
		<table summary="layout" border="0">
			<tr>
				<td id="status">
					${eunis:cmsPhrase(actionBean.contentManagement, 'Specify the search criteria:')}
				</td>
			</tr>
		</table>

		<form method="post" action="species-advanced.jsp" name="criteria" id="criteria">
            <input type="hidden" name="criteria" value="" />
            <input type="hidden" name="attribute" value="" />
            <input type="hidden" name="operator" value="" />
            <input type="hidden" name="firstvalue" value="" />
            <input type="hidden" name="lastvalue" value="" />
            <input type="hidden" name="oldfirstvalue" value="" />
            <input type="hidden" name="oldlastvalue" value="" />
            <input type="hidden" name="action" value="" />
            <input type="hidden" name="idnode" value="" />
            
            <a title="${eunis:cms(actionBean.contentManagement, 'add_root')}" href="#"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'add_root')}"/></a><div id="root">&nbsp;${eunis:cmsPhrase(actionBean.contentManagement, 'Add root criterion')}</div>
            
            <div id=criterion class="criterion">
            	<a title="${eunis:cms(actionBean.contentManagement, 'add_criterion')}" href="#"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'add_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement, 'add_criterion')}
            	<a title="${eunis:cms(actionBean.contentManagement, 'delete_criterion')}" href="#"><img border="0" src="images/mini/delete.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'delete_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement, 'delete_criterion')}
            	<a title="${eunis:cms(actionBean.contentManagement, 'compose_criterion')}" href="#"><img border="0" src="images/mini/compose.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'compose_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement,'compose_criterion')} 
		
				&nbsp;1.1 
				<select name="Attribute" onchange="#" title="Attribute" id="Attribute">
					<option selected="selected" value="ScientificName">Scientific name</option>
					<option value="VernacularName">Vernacular Name</option>
					<option value="Group">Group</option>
					<option value="ThreatStatus">Threat Status</option>
					<option value="InternationalThreatStatus">International	Threat Status</option>
					<option value="Country">Country</option>
					<option value="Biogeoregion">Biogeoregion</option>
					<option value="Author">Reference author</option>
					<option value="Title">Reference title</option>
					<option value="LegalInstrument">Legal instr. title</option>
					<option value="Taxonomy">Taxonomy</option>
					<option value="Abundance">Abundance</option>
					<option value="Trend">Trend</option>
					<option value="DistributionStatus">Distribution Status</option>
				</select> 
				&nbsp; 
				<select name="Operator" onchange="#" title="Operator"id="Operator">
					<option selected="selected" value="Equal">Equal</option>
					<option value="Contains">Contains</option>
					<option value="Between">Between</option>
					<option value="Regex">Regex</option>
				</select> 
				&nbsp; 
				<input type="text" title="List of values" name="First_Value" id="First_Value" size="25" value="enter value here..." /> <a title="List of values" href="#">
				<img border="0" src="images/mini/helper.gif" width="11" height="18"	alt="List of values" /></a>
	            <br />         	
            </div>
            
		</form>
		
		<br />
        <strong>${eunis:cmsPhrase(actionBean.contentManagement, 'Note: Advanced search might take a long time')}</strong>
        <br />

		<!-- END MAIN CONTENT -->

	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
		<div id="portal-column-one">
		<div class="visualPadding"><jsp:include
			page="/inc_column_left.jsp">
			<jsp:param name="page_name" value="sites" />
		</jsp:include></div>
		</div>
		<!-- end of the left (by default at least) column -->
		
		<!-- end of the main and left columns -->
		
		<!-- start of right (by default at least) column -->
		<div id="portal-column-two">
		<div class="visualPadding"><jsp:include
			page="/right-dynamic.jsp">
			<jsp:param name="mapLink" value="show" />
		</jsp:include></div>
		</div>
		<!-- end of the right (by default at least) column -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>