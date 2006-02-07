function validateForm()
{
  var  scientificName;
  scientificName = trim(document.eunis.scientificName.value);
  if (scientificName == "")
  {
    alert(species_criteria_mandatory_msg);
    return false;
  }
  return true;
}
