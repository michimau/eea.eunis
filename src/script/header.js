function popSearch()
{
  var searchString = document.searchGoogle.q.value;
  URL = "http://www.google.com/search?q=" + searchString;
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=640,height=480,left=200,top=100')");
}

function editContent( idPage )
{
  var url = "web-content-inline-editor.jsp?idPage=" + idPage;
  window.open( url ,'', "width=540,height=500,status=0,scrollbars=1,toolbar=0,resizable=1,location=0");
}

function changeLanguage()
{
  try
  {
    var frm = document.createElement( "FORM" );
    document.appendChild( frm );
    frm.method = "POST";
    frm.action = "index.jsp";

    var op = document.createElement( "INPUT");
    op.type = "hidden";
    op.name = "operation"
    op.value = "changeLanguage";
    frm.appendChild( op );

    var language_intl = document.getElementById( "language_international" );

    var language = document.createElement( "INPUT");
    language.type = "hidden";
    language.name = "language_international"
    language.value =  language_intl.options[ language_intl.selectedIndex ].value;
    frm.appendChild( language );

    frm.submit();
  }
  catch ( e )
  {
    alert( "An error occurred while changing language.");
  }
}