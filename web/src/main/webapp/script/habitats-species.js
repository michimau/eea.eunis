function choicepren(URL) {
      var searchString = trim(document.eunis.searchString.value);
      if(searchString=="") {
        alert(habitat_type_something_msg);
      } else {
          var operand=escape(document.eunis.operand.value);
          URL2= URL + '?searchString=' + searchString+'&operand='+operand;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
      }
}

function checkform()
{
  var searchString = trim(document.eunis.searchString.value);
  if (searchString == "")
  {
    alert(habitat_empty_msg);
    return false;
  }
  else return true;
}