// Error message displayed if not text was entered in text fields.
var errMessageForm = habitat_name_type_msg;
var noCriteriaMsg = habitat_check_one__msg;

// Validate form
function validateForm()
{
  var deleteIndex = document.eunis.deleteIndex.value;
  if (deleteIndex == -1) {
    var useScientific = document.eunis.useScientific.checked;
    var useVernacular = document.eunis.useVernacular.checked;
    var useDescription = document.eunis.useDescription.checked;
    var searchString = trim(document.eunis.searchString.value);
    if (searchString == "") {
      alert(errMessageForm);
      return false;
    }
    if (useVernacular == false && useDescription == false && useScientific == false) {
      alert(noCriteriaMsg);
      return false;
    }
  }
  return true;
}

// Open popup for first form
function openHelper(URL) {
  var searchString = trim(document.eunis.searchString.value);
  if (validateForm() ==  true) {
    var currentDB = 0;
    var relationOp = document.eunis.relationOp.value;
    var database = document.eunis.database;
    var useScientific = document.eunis.useScientific.checked;
    var useVernacular = document.eunis.useVernacular.checked;
    var useDescription = document.eunis.useDescription.checked;
    if (database[0].checked == true) currentDB = 0; // EUNIS
    if (database[1].checked == true) currentDB = 1; // ANNEX I
    if (database[2].checked == true) currentDB = 2; // BOTH
    var URL2= URL + '?searchString=' + searchString + '&relationOp=' + relationOp + '&database=' + currentDB + '&useScientific=' + useScientific + '&useVernacular=' + useVernacular + '&useDescription=' + useDescription;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=450,height=500,left=490,top=0');");
  }
}
