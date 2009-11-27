// Error message displayed if not text was entered in text fields.
var errMessageForm = habitat_name_type_msg;
// Open popup
function openHelper(URL)
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  var habitatType = escape(document.eunis.habitatType.value);
  var searchString = trim(escape(document.eunis.searchString.value));
  var legalText = escape(document.eunis.legalText.value);
  if (searchString == "") {
  alert(errMessageForm);
  }
  else {
    var URL2 = URL + '?habitatType=' + habitatType + '&searchString=' + searchString + '&legalText=' + legalText;
    eval("page = window.open(URL2, '', 'scrollbars=yes,resizable=1,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
  }
}

function validateForm()
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  return true;
}
