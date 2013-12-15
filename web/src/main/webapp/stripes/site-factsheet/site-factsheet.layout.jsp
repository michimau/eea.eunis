<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value=""/>
<c:set var="notExistErrMsg" value="${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}"/>
<c:choose>
    <c:when test="${eunis:exists(actionBean.factsheet)}">
        <c:set var="title" value="${actionBean.pageTitle }"></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="title" value="${notExistErrMsg}"></c:set>
    </c:otherwise>
</c:choose>
<%
    String btrail = "eea#" + application.getInitParameter( "EEA_HOME" ) + ",home#index.jsp,sites";
%>
<stripes:layout-render name="/stripes/common/template.jsp" hideMenu="true" pageTitle="${title}" btrail="<%= btrail %>">
    <stripes:layout-component name="head">
        <!-- Custom js needed for Species page -->
        <script type="text/javascript" src="<%=request.getContextPath()%>/script/init.js"></script>

        <style>
	        .cell-title {
				font-weight: bold;
	        }
	
	        .cell-effort-driven {
				text-align: center;
	        }
	        .table-inline {
	        	display: inline-table !important;
	        }
	        
			.species-change-view {
				text-align: right;
			}
			
			.species-list {
	       		background: url("sprite-eeaimages.png") no-repeat scroll left center rgba(0, 0, 0, 0);
	       		background-position: -447px -163px;
	       		
	       	}
	       	
	       	.species-gallery {
	       		background: url("sprite-eeaimages.png") no-repeat scroll left center rgba(0, 0, 0, 0);
	       		background-position: -427px -163px;
	       	}

	       	.species-gallery, .species-list {
	       		cursor: pointer;
	       		width: 10%;
	       		float:right;
	       		text-align: center;
	       	}
	       	
	       	.species-list:hover {
	       		background-position: -447px -145px;
	       	}
	       	
	       	.species-gallery:hover {
	       		background-position: -427px -145px;
	       	}
	       	
	       	.interactive-map-more {
	       		float: right;
			    font-size: 10px;
	       	}
	       	
	       	.site-tabs {
	       		float: left;
			    padding: 0 0 0 11px;
			    width: 98.1%;
	       	}
	       	
	       	.quickfact-number {
			    font-size: 150% !important;
			}
			
			.more-resources-container {
				border: 1px solid #808080;
			    padding-left: 5%;
			    width: 70%;
			    font-size: 10px;
			}
        </style>
		<script>
			var interactive_map_load_count = 0;
			function loadMapIframe(mapLink) {
				if(interactive_map_load_count == 0) {
					jQuery("#interactive-map-iframe").attr("src",mapLink);
					interactive_map_load_count++;
				}
			}
			
			/*
			@type,0 - list 1 - gallery
			*/
			function changeSpeciesView(type) {
				var gallery = jQuery("#sites-species-gallery");
				var list    = jQuery("#sites-species-list");
				if( (gallery.is(":visible") && type==0) || (list.is(":visible") && type==1) ) {
					jQuery("#sites-species-gallery").toggle();
					jQuery("#sites-species-list").toggle();
				}
			}
			
			function displayMoreResourcesSite() {
				jQuery("#more-resources-container").toggle();
			}
			
			function changeSiteTab() {
				var pathname = window.location.pathname;
				window.location.href = pathname+"#tab-interactive-map";	
			}
		</script>

        <link rel="alternate" type="application/rdf+xml" title="RDF"
            href="${pageContext.request.contextPath}/sites/${actionBean.idsite}/rdf" />
    </stripes:layout-component>

    <stripes:layout-component name="contents">
        <!-- MAIN CONTENT -->
        <c:choose>
            <c:when test="${eunis:exists(actionBean.factsheet)}">

<!-- TODO documentActions - PDF link ?? -->
<!-- TODO the old template added "Upload pictures" menu item to the left menu for logged in users -->

                <!-- TODO add name in English first and name in Latin in brackets. eg. Species: Iberian Lynx (Lynx pardinus) ?-->
                <!-- <h1>Site: ${actionBean.siteName}</h1> -->

				<%-- Site map --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-map.jsp"/>

                <%-- Quick facts --%>
                <stripes:layout-render name="/stripes/site-factsheet/site-quickfacts.jsp"/>
                
                <%-- Site tab --%>
                <br/>
                <stripes:layout-render name="/stripes/site-factsheet/site-tabs.jsp"/>

            </c:when>
            <c:otherwise>
                <div class="error-msg">${notExistErrMsg}</div>
            </c:otherwise>
        </c:choose>
        <!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>
