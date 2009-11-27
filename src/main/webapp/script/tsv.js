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

function emailresults( cacheEmail )
{
  var email;
  email = prompt("Please enter e-mail address where reports will be sent", cacheEmail );
  if ( email != null )
  {
    if ( email == "" )
    {
      alert( "Please enter an valid e-mail address" );
      return false;
    }
    else
    {
      var frm = document.getElementById( "emailresults" );
      document.emailresults.email.value = email;
      frm.submit();
    }
  }
}
