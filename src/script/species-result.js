function openlink(URL) {
  //eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
  //alert('done');
  window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');
}

function getScreenHeight() {
var screenH = 480;
if (parseInt(navigator.appVersion) > 3) {
  screenH = screen.height;
} else if (navigator.appName == "Netscape" && parseInt(navigator.appVersion)==3 && navigator.javaEnabled()) {
  var jToolkit = java.awt.Toolkit.getDefaultToolkit();
  var jScreenSize = jToolkit.getScreenSize();
  screenH = jScreenSize.height;
}
return screenH;
}

function getScreenWidth() {
var screenW = 640;
if (parseInt(navigator.appVersion) > 3) {
  screenW = screen.width;
} else if (navigator.appName == "Netscape" && parseInt(navigator.appVersion)==3 && navigator.javaEnabled()) {
  var jToolkit = java.awt.Toolkit.getDefaultToolkit();
  var jScreenSize = jToolkit.getScreenSize();
  screenW = jScreenSize.width;
}
return screenW;
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

// Validate the 'Refine your search' form.
function validateRefineForm(noCriteria)
{
  var errMessage = "Please enter the refine criteria correctly.";
  var checkOK = true;
  if( noCriteria == 0 )
  {
    if ( trim( document.refineSearch.criteriaSearch.value ) == "" )
    {
      checkOK = false;
    }
  }
  else
  {
    for (i = 0; i <= noCriteria; i++)
    {
      if ( trim( document.refineSearch.criteriaSearch[i].value ) == "")
      {
        checkOK = false;
      }
    }
  }
  if ( !checkOK )
  {
    alert( errMessage );
  }
  return checkOK;
}
