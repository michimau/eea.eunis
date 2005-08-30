// Error message displayed if not text was entered in text fields.
var errMessageForm1 = "Please type a few letters from species scientific name.";
var errMessageForm2 = "Please type a few letters from species vernacular name.";
var noCheckedMsg = "Please choose where to search, either in terms or definitions.";

// Open second popup window - second form
function openHelper2(popupPage) {
  document.eunis2.vernacularName.value = trim(document.eunis2.vernacularName.value);
  var vernacularName = document.eunis2.vernacularName.value;
  if (vernacularName == "") {
    alert(errMessageForm2);
  } else {
    var relationOp = trim(document.eunis2.relationOp.value);
    var language=escape(document.eunis2.language.value);
    var URL = popupPage + '?typeForm=1&vernacularName=' + vernacularName + '&relationOp=' + relationOp + '&language='+language;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes,location=0,width=400,height=500,left=490,top=0');");
  }
}
// Check the first form. Assure that scientificName text field is not empty
function validateForm1()
{
  document.eunis1.scientificName.value = trim(document.eunis1.scientificName.value);
  var searchString = document.eunis1.scientificName.value;
  if (searchString == "")
  {
    alert(errMessageForm1);
    return false;
  }
  return true;
}
// Check the second form. Assure that vernacularName text field is not empty

function validateForm2()
{
  document.eunis2.vernacularName.value = trim(document.eunis2.vernacularName.value);
  var searchString = document.eunis2.vernacularName.value;
  if (searchString == "")
  {
    alert(errMessageForm2);
    return false;
  }
  return true;
}
