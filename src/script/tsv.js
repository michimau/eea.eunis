function updateText( txt )
{
  document.getElementById( "status" ).innerHTML = txt;
}

function showLoadingProgress( show )
{
  var img = document.getElementById( "loading" );
  if ( show )
  {
    img.style.display = "block";
  }
  else
  {
    img.style.display = "none";
  }
}
