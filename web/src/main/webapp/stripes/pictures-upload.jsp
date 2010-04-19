<%@ include file="/stripes/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="${actionBean.context.sessionManager.currentLanguage}" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xml:lang="${actionBean.context.sessionManager.currentLanguage}">
  <head>
    <jsp:include page="../header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        function validateForm() {
          if (document.uploadPicture.filename.value == "") {
            alert("${eunis:cms(actionBean.contentManagement, 'pictures_upload_click_browse')}");
            return false;
          }
          if (document.uploadPicture.description.value.length > 255) {
            alert("${eunis:cms(actionBean.contentManagement, 'pictures_upload_limit_description')}");
            return false;
          }
          return true;
        }
        function hideMeasures(){
        	if(document.getElementById('main_picture').checked == true){
        		document.getElementById('measures').style.visibility = "visible";
        		document.getElementById('width').style.visibility = "visible";
        		document.getElementById('height').style.visibility = "visible";
        	} else {
        		document.getElementById('measures').style.visibility = "hidden";
        		document.getElementById('width').style.visibility = "hidden";
        		document.getElementById('height').style.visibility = "hidden";
        	}
        }
      //]]>
    </script>
      <title>
      	${eunis:cms(actionBean.contentManagement, 'pictures_upload_page_title')}
        ${actionBean.scientificName}
      </title>
  </head>
  <body>
    <p>
      ${eunis:cmsPhrase(actionBean.contentManagement, 'This page allows to upload new pictures for')} <strong>${actionBean.scientificName}</strong>.
    </p>
    <p>
      ${eunis:cmsPhrase(actionBean.contentManagement, 'Please click browse and select the picture from your computer')}
      <br />
    </p>
    <form action="${pageContext.request.contextPath}/fileupload" 
    		method="post" 
    		enctype="multipart/form-data" 
    		name="uploadPicture" 
    		onsubmit="return validateForm();"
    		accept-charset="UTF-8">
      <input type="hidden" name="uploadType" value="picture" />
      <input type="hidden" name="natureobjecttype" value="${actionBean.natureobjecttype}" />
      <input type="hidden" name="idobject" value="${actionBean.idobject }"/>
      <p>
        <label for="filename" class="noshow">
        ${eunis:cms(actionBean.contentManagement, 'pictures_upload_filename_label')}</label>
        <input id="filename" name="filename" type="file" size="50" title="${eunis:cms(actionBean.contentManagement, 'pictures_upload_filename_label')}" />
      	${eunis:cmsLabel(actionBean.contentManagement, 'pictures_upload_filename_label')} <br/>
      	<label for="main_picture">Check to make it the factsheet picture</label>
      	<input id="main_picture" name="main_picture" type="checkbox" onChange="hideMeasures();"/>
      </p>
      <p>
      	${eunis:cmsPhrase(actionBean.contentManagement, 'Picture description (max 255 characters)')}
        <br />
        <label for="description" class="noshow">${eunis:cms(actionBean.contentManagement, 'pictures_upload_description_label')}</label>
        <textarea 
        	id="description"
        	name="description" 
        	cols="60" rows="5"></textarea>
        <br />
        <label for="source">${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}: </label><input type="text" name="source" id="source"/>
        <div id="measures" style="visibility:hidden;">
        	<label for="width">${eunis:cmsPhrase(actionBean.contentManagement, 'Max width')}: </label><input type="text" name="width" id="width" size="4" style="visibility:hidden;"/> ${eunis:cmsPhrase(actionBean.contentManagement, 'pixels')}
        	<br />
        	<label for="height">${eunis:cmsPhrase(actionBean.contentManagement, 'Max height')}: </label><input type="text" name="height" id="height" size="4" style="visibility:hidden;"/> ${eunis:cmsPhrase(actionBean.contentManagement, 'pixels')}
        </div>
        <br/>
      </p>
      <p>
        <input type="reset" 
        		id="reset" 
        		title="${eunis:cms(actionBean.contentManagement, 'reset_values')}" 
        		name="Reset" 
        		value="${eunis:cms(actionBean.contentManagement, 'reset')}" 
        		class="standardButton" />
         ${eunis:cmsTitle(actionBean.contentManagement, 'reset_values')}
         ${eunis:cmsInput(actionBean.contentManagement, 'reset')}

        <input type="submit" 
        		id="submit" 
        		title="${eunis:cms(actionBean.contentManagement, 'upload')}" 
        		name="Submit" 
        		value="${eunis:cms(actionBean.contentManagement, 'upload')}" 
        		class="submitSearchButton" />
         ${eunis:cmsTitle(actionBean.contentManagement, 'upload')}
         ${eunis:cmsInput(actionBean.contentManagement, 'upload')}

        <input type="button"
        		 onclick="javascript:window.close();"
           		 value="${eunis:cms(actionBean.contentManagement, 'close_btn')}" 
           		 title="${eunis:cms(actionBean.contentManagement, 'close_window')}"
           		 id="button0" name="button" class="standardButton" />
         ${eunis:cmsTitle(actionBean.contentManagement, 'close_window')}
         ${eunis:cmsInput(actionBean.contentManagement, 'close_btn')}
      </p>
    </form>
    <c:if test="${actionBean.message != null}">
    <div class="system-msg">
		${actionBean.message }
    </div>  
    </c:if>

    ${eunis:cmsMsg(actionBean.contentManagement, 'pictures_upload_click_browse')}
    ${eunis:br(actionBean.contentManagement)}
    ${eunis:cmsMsg(actionBean.contentManagement, 'pictures_upload_limit_description')}
    ${eunis:br(actionBean.contentManagement)}
    ${eunis:cmsMsg(actionBean.contentManagement, 'pictures_upload_page_title')}
    ${eunis:br(actionBean.contentManagement)}
    ${eunis:cmsMsg(actionBean.contentManagement, 'pictures_upload_success')}
    ${eunis:br(actionBean.contentManagement)}
    ${eunis:cmsMsg(actionBean.contentManagement, 'pictures_upload_error')}    
  </body>
</html>
