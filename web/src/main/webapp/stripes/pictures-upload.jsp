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
      //]]>
    </script>
      <title>
      	${eunis:cms(actionBean.contentManagement, 'pictures_upload_page_title')}
        ${actionBean.scientificName}
      </title>
  </head>
  <body class="popup">
    <h1>
      ${eunis:cmsPhrase(actionBean.contentManagement, 'Upload new pictures for')} <strong>${actionBean.scientificName}</strong>.
    </h1>
    <p class="tip-msg">
      ${eunis:cmsPhrase(actionBean.contentManagement, 'Please select a picture from your computer. The picture must have a <em>Creative Commons</em> license.')}
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
        <label for="filename">
        ${eunis:cmsPhrase(actionBean.contentManagement, 'Filename:')}</label>
        <input id="filename" name="filename" type="file" size="50" />
      </p>
      <p>
      	<label for="main_picture">Make it the factsheet thumbnail</label>
      	<c:choose>
			<c:when test="${actionBean.hasMain}">
      			<input id="main_picture" name="main_picture" type="checkbox"/>
      		</c:when>
			<c:otherwise>
				<input id="main_picture" name="main_picture" type="checkbox" checked="checked" disabled="disabled"/>
			</c:otherwise>
		</c:choose>
      </p>
      <p><label for="description">
      	${eunis:cmsPhrase(actionBean.contentManagement, 'Picture description (max 255 characters)')}</label><br />
        <textarea
        	id="description"
        	name="description"
		style="width:100%"
        	cols="60" rows="5"></textarea>
      </p>
      <p>
        <label for="source">${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}: </label>
        <input type="text" name="source" id="source" size="30"/>
      </p>
      <p>
        <label for="sourceUrl">${eunis:cmsPhrase(actionBean.contentManagement, 'Source URL')}: </label>
        <input type="text" name="sourceUrl" id="sourceUrl" size="50"/>
      </p>
      <p>
        <label for="license">${eunis:cmsPhrase(actionBean.contentManagement, 'License')}: </label>
        <select name="license" id="license">
        	<option value="CC BY">CC BY</option>
        	<option value="CC BY-SA">CC BY-SA</option>
        	<option value="CC BY-ND">CC BY-ND</option>
        	<option value="CC BY-NC">CC BY-NC</option>
        	<option value="CC BY-NC-SA">CC BY-NC-SA</option>
        	<option value="CC BY-NC-ND">CC BY-NC-ND</option>
        	<option value="Copyrighted">Copyrighted</option>
        	<option value="Public domain">Public domain</option>
        </select>
      </p>
      <p>
        <input type="reset"
        		id="reset"
        		name="Reset"
        		value="${eunis:cmsPhrase(actionBean.contentManagement, 'Reset')}"
        		class="standardButton" />
         ${eunis:cmsTitle(actionBean.contentManagement, 'reset_values')}
         ${eunis:cmsInput(actionBean.contentManagement, 'reset')}

        <input type="submit"
        		id="submit"
        		name="Submit"
        		value="${eunis:cmsPhrase(actionBean.contentManagement, 'Upload')}"
        		class="submitSearchButton" />
         ${eunis:cmsTitle(actionBean.contentManagement, 'upload')}
         ${eunis:cmsInput(actionBean.contentManagement, 'upload')}

        <input type="button"
        		 onclick="javascript:window.close();"
           		 value="${eunis:cms(actionBean.contentManagement, 'Close')}"
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
