function popSearch()
{
  var searchString = document.searchGoogle.q.value;
  URL = "http://www.google.com/search?q=" + searchString;
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=640,height=480,left=200,top=100')");
}

function openContentManager( idPage, type )
{
  var url = "web-content-editor.jsp?idPage=" + idPage + "&type=" + type;
  window.open( url ,'', "width=540,height=500,status=0,scrollbars=1,toolbar=0,resizable=1,location=0");
}

function changeLanguage()
{
  try
  {
    var frm = document.getElementById("intl_lang");
    frm.submit();
  }
  catch ( e )
  {
    alert(language_error_msg);
  }
}