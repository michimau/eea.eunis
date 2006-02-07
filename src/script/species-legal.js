// Check the form
function validateForm()
{
  document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
  var scientificName = document.eunis.scientificName.value;
  if (scientificName == "") {
    alert(species_legal_type_few_letters_msg);
    return false;
  }
  return true;
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function openHelper(URL) {
  document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
  var searchString = document.eunis.scientificName.value;
  var groupName = document.eunis.groupName.value;
  if(searchString=="")
  {
    alert(species_legal_type_few_letters_msg);
  } else {
    var URL2= URL + '?typeForm=0&groupName=' + groupName + '&scientificName=' + searchString;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }
}

function setVariablesForMM_jump()
{
 var u = "";
 var saveCriteria = document.eunis2.saveCriteria.checked;
 if (saveCriteria == true) u += "&saveCriteria=true";
 return u;
}

function MM_jumpMenuLegal2(targ,selObj,restore){ //v3.0
// alert(targ);
 //alert(selObj.options[selObj.selectedIndex].value);
  var val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}
