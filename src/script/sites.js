function popIndicators(URL)
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=700,height=500,left=200,top=100')");
}
function validateQS()
{
  if( trim ( document.quick_search.englishName.value ) == '' || trim ( document.quick_search.englishName.value ) == 'Enter site name here...')
  {
    alert(sites0);
    return false;
  }
  else return true;
}