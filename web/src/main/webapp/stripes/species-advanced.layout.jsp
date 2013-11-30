<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${actionBean.pageTitle}" bookmarkPageName="sites">
	<stripes:layout-component name="head">
		<script language="JavaScript" src="<%=request.getContextPath()%>/script/lib/jquery.js" type="text/javascript"></script>
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
		    	    $('#delete_root').hide();

		    	$('#add_root a').click(function(e){
		    		e.preventDefault();

		    	    $('#delete_root').fadeIn('slow');
		    	    $(this).parent().hide();
		    	    $('#criterion').fadeIn('slow');
		    	});

		    	$('#delete_root a').click(function(e){
		    		e.preventDefault();

		    	    $('#add_root').fadeIn('slow');
		    	    $(this).parent().hide();
		    	    $('.criterion').fadeOut('slow');
		    	});

		    	$('a[title=Add criterion]').click(function(e){
		    		e.preventDefault();

		    	    var newElem = $('#criterion').clone(true).attr('id', 'criterion2').fadeIn('slow');
		    	    $(this).parent().after(newElem);
		    	});

		    	$('a[title=Delete criterion]').click(function(e){
		    		e.preventDefault();

		    	    $(this).parent().fadeOut('slow');
		    	    });
		    	});
		    //]]>
		    </script>
	</stripes:layout-component>
	<stripes:layout-component name="contents">
		<!-- MAIN CONTENT -->

		<h1>${eunis:cmsPhrase(actionBean.contentManagement, 'Species advanced search')}</h1>

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

		<stripes:form method="post" action="species-advanced.jsp" name="criteria" id="criteria">
            <stripes:hidden name="criteria" value="" />
            <stripes:hidden name="attribute" value="" />
            <stripes:hidden name="operator" value="" />
            <stripes:hidden name="firstvalue" value="" />
            <stripes:hidden name="lastvalue" value="" />
            <stripes:hidden name="oldfirstvalue" value="" />
            <stripes:hidden name="oldlastvalue" value="" />
            <stripes:hidden name="action" value="" />
            <stripes:hidden name="idnode" value="" />

            <div id="add_root">
	            <a title="${eunis:cms(actionBean.contentManagement, 'add_root')}" href=""><img border="0" src="images/mini/add.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'add_root')}" /></a>&nbsp;${eunis:cmsPhrase(actionBean.contentManagement, 'Add root criterion')}
            </div>

            <div id="delete_root">
            	<a title="${eunis:cms(actionBean.contentManagement, 'delete_root_criterion')}" href=""><img alt="${eunis:cms(actionBean.contentManagement, 'delete_root_criterion')}" border="0" src="images/mini/delete.gif" width="13" height="13"/></a>${eunis:cmsTitle(actionBean.contentManagement, 'delete_root_criterion')}
            	<stripes:label for="Criteria" class="noshow">${eunis:cms(actionBean.contentManagement, 'criteria')}</stripes:label>
				<stripes:select name="Criteria" title="${eunis:cms(actionBean.contentManagement, 'criteria')}" id="Criteria">
                	<stripes:options-collection collection="${actionBean.listForCtriteria}"/>
                </stripes:select>
                ${eunis:cms(actionBean.contentManagement, 'of_following_criteria_are_met')}
                <br />
            </div>

            <div id=criterion class="criterion">
            	<a title="${eunis:cms(actionBean.contentManagement, 'add_criterion')}" href="#"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'add_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement, 'add_criterion')}
            	<a title="${eunis:cms(actionBean.contentManagement, 'delete_criterion')}" href="#"><img border="0" src="images/mini/delete.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'delete_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement, 'delete_criterion')}
            	<a title="${eunis:cms(actionBean.contentManagement, 'compose_criterion')}" href="#"><img border="0" src="images/mini/compose.gif" width="13" height="13" alt="${eunis:cms(actionBean.contentManagement, 'compose_criterion')}"/></a>${eunis:cmsTitle(actionBean.contentManagement,'compose_criterion')}

				&nbsp;1.1
				<stripes:label for="Attribute" class="noshow">${eunis:cms(actionBean.contentManagement, 'advanced_attribute')}</stripes:label>
				<stripes:select name="Attribute" title="${eunis:cms(actionBean.contentManagement, 'advanced_attribute')}" id="Attribute">
                	<stripes:options-collection collection="${actionBean.attributesList}"/>
                </stripes:select>
				&nbsp;
				<stripes:label for="Operator" class="noshow">${eunis:cms(actionBean.contentManagement, 'operator')}</stripes:label>
				<stripes:select name="Operator" title="${eunis:cms(actionBean.contentManagement, 'operator')}" id="Operator">
                	<stripes:options-collection collection="${actionBean.operatorsList}"/>
                </stripes:select>
				&nbsp;
				<stripes:label for="First_Value1" class="noshow">${eunis:cms(actionBean.contentManagement, 'list_of_values')}</stripes:label>
				<stripes:text title="${eunis:cms(actionBean.contentManagement, 'list_of_values')}" name="First_Value" id="First_Value" size="25" value="enter value here..." />
				${eunis:cmsTitle(actionBean.contentManagement,'list_of_values')}
				<a title="${eunis:cms(actionBean.contentManagement, 'list_of_values')}" href="javascript:choice('First_Value','','','')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="${eunis:cms(actionBean.contentManagement, 'list_of_values')}"/></a>
	            <br />

            </div>

		</stripes:form>

		<br />
        <strong>${eunis:cmsPhrase(actionBean.contentManagement, 'Note: Advanced search might take a long time')}</strong>
        <br />

		<!-- END MAIN CONTENT -->

	</stripes:layout-component>
	<stripes:layout-component name="foot">
	</stripes:layout-component>
</stripes:layout-render>
