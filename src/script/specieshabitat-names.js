function choicepren(URL)
{
  var searchString = escape(document.eunis.searchString.value);
  if(searchString=="")
  {
    alert(specieshabitat_names_type_at_least_one_character_msg);
  }
  else
  {
    var operand=escape(document.eunis.operand.value);
    var URL2= URL + '?&searchString=' + searchString+'&operand='+operand;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }
}

function checkform()
{
  var searchString = document.eunis.searchString.value;
  if (searchString == "")
  {
    alert(specieshabitat_names1);
    return false;
  }
  else return true;
}