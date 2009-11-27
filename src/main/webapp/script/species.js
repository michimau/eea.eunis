function MM_openBrWindow(theURL,winName,features)
{ //v2.0
  window.open(theURL,winName,features);
}
function openWindow(theURL,winName,features)
{
  window.open(theURL,winName,features);
}
function openLink(URL) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=300');");
}
function openGooglePics(URL) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
}
function openpictures(URL, width, height) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width="+width+",height="+height+",left=100,top=0');");
}
function openunepwcmc(URL, width, height)
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
}
function openGBIF(URL, width, height)
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
}
function openNewPage(URL)
{
  eval("page = window.open(URL, '', 'toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,copyhistory=yes, resizable=yes');");
}