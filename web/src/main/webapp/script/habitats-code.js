// Error message displayed if not text was entered in text fields.
var invalidInputMsg = habitat_code_type_msg;

function validateForm()
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  var searchString = document.eunis.searchString.value;
  if (searchString == "")
  {
    alert(invalidInputMsg);
    return false;
  } else {
    return true;
  }
}
