<%@ include file="/stripes/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="${actionBean.context.sessionManager.currentLanguage}"
	xmlns="http://www.w3.org/1999/xhtml"
	xml:lang="${actionBean.context.sessionManager.currentLanguage}">
<head>
<title>Error</title>
</head>
<body>
${actionBean.errorMessage}
<br />
<div style="width: 100%; text-align: left;">
<form action=""><input type="button"
	onclick="javascript:window.close();" value="${eunis:cms(actionBean.contentManagement, 'close_btn')}"
	title="${eunis:cms(actionBean.contentManagement, 'pictures_upload_page_title')}" id="button2" name="button"
	class="standardButton" />
		${eunis:cmsTitle(actionBean.contentManagement, 'pictures_upload_page_title')}
       	${eunis:cmsInput(actionBean.contentManagement, 'pictures_upload_page_title')}
</form>
</div>
</body>
</html>