var errMessageForm = "Search criteria is mandatory.";

function validateForm()
{
  var  scientificName;
  scientificName = trim(document.eunis.scientificName.value);
  if (scientificName == "")
  {
    alert(errMessageForm);
    return false;
  }
  return true;
}
