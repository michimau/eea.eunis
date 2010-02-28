function openlink( URL ) {
//eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
//alert('done');
  window.open(URL, '', 'scrollbars=yes,toolbar=1,resizable=yes, location=0, left=0, top=0, maximize=1');
}

function openlink2( URL ) {
  var screenWidth = getScreenWidth();
  var screenHeight = getScreenHeight();
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=1,resizable=yes, location=1,width=" + screenWidth + ",height=" + screenHeight + ",left=0,top=0');");
}

function getScreenHeight() {
  var screenH = 480;
  if (parseInt(navigator.appVersion) > 3 )
  {
    screenH = screen.height;
  }
  else
    if ( navigator.appName == "Netscape" && parseInt(navigator.appVersion) == 3 && navigator.javaEnabled() ) {
      var jToolkit = java.awt.Toolkit.getDefaultToolkit();
      var jScreenSize = jToolkit.getScreenSize();
      screenH = jScreenSize.height;
    }
  return screenH;
}

function getScreenWidth() {
  var screenW = 640;
  if ( parseInt(navigator.appVersion) > 3 ) {
    screenW = screen.width;
  }
    else
    if ( navigator.appName == "Netscape" && parseInt(navigator.appVersion) == 3 && navigator.javaEnabled() ) {
      var jToolkit = java.awt.Toolkit.getDefaultToolkit();
      var jScreenSize = jToolkit.getScreenSize();
      screenW = jScreenSize.width;
    }
  return screenW;
}

function MM_openBrWindow( theURL, winName, features ) { //v2.0
  window.open(theURL, winName, features);
}

function check( noCriteria ) {
//alert(noCriteria);
  if ( noCriteria == 0 ) {
    Name = trim(document.criteriaSearch.criteriaSearch.value);
    if (Name == "") {
      alert(references_empty_msg);
      return false;
    } else
      return true;
    } else {
       isSomeoneEmpty = 0;
      for (i=0;i<=noCriteria;i++) if (trim(document.criteriaSearch.criteriaSearch[i].value) == "") isSomeoneEmpty = 1;
      if (isSomeoneEmpty == 1) {
        alert(references_empty_msg);
              return false;
      }
    }
  return true;
}
