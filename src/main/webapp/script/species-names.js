var errMessageForm1 = 'Please type a few letters from species scientific names.';
function openHelper2(popupPage) {
  document.eunis2.vernacularName.value = trim(document.eunis2.vernacularName.value);
  var vernacularName = document.eunis2.vernacularName.value;
  if (vernacularName == "") {
    alert(species_names_few_letters_vn_msg);
  } else {
    var relationOp = trim(document.eunis2.relationOp.value);
    var language=escape(document.eunis2.language.value);
    var URL = popupPage + '?typeForm=1&vernacularName=' + vernacularName + '&relationOp=' + relationOp + '&language='+language;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes,location=0,width=450,height=500,left=490,top=0');");
  }
}

function validateForm1()
{
  document.eunis1.scientificName.value = trim(document.eunis1.scientificName.value);
  var searchString = document.eunis1.scientificName.value;
  if (searchString == "")
  {
    alert(species_names_few_letters_sn_msg);
    return false;
  }
  return true;
}

function validateForm2()
{
  document.eunis2.vernacularName.value = trim(document.eunis2.vernacularName.value);
  var searchString = document.eunis2.vernacularName.value;
  if (searchString == "")
  {
    alert(species_names_few_letters_vn_msg);
    return false;
  }
  return true;
}
