var errMessageForm = "Please type a few letters from the habitat type name.";

function validateForm()
{
  var  scientificName;
  var  database;
  scientificName = trim(document.eunis.scientificName.value);
  if (scientificName == "")
  {
    alert(errMessageForm);
    return false;
  }
  database = document.eunis.database;
  var isSomeoneChecked = false;
  if (database != null)
  {
    if (database[0].checked == true) isSomeoneChecked=true; // EUNIS
    if (database[1].checked == true) isSomeoneChecked=true; // ANNEX I
    if (database[2].checked == true) isSomeoneChecked=true; // BOTH
  }
  if (!isSomeoneChecked)
  {
    alert("Please select the database.");
    return false;
  }
  return true;
}

function openHelper(URL)
{
  var scientificName = trim(document.eunis.scientificName.value);
  if(validateForm())
  {
    var relationOp=escape(document.eunis.relationOp.value);
    var currentDB = 0;
    var database = document.eunis.database;
    if (database[0].checked == true) currentDB = 0; // EUNIS
    if (database[1].checked == true) currentDB = 1; // ANNEX I
    if (database[2].checked == true) currentDB = 2; // BOTH
    var URL2= URL + '&saveThisCriteria=false&scientificName=' + scientificName+'&relationOp='+relationOp+'&database='+currentDB;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  } else {
    return;
  }
}
