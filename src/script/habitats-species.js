function choicepren(URL) {
      var searchString = trim(document.eunis.searchString.value);
      if(searchString=="") {
        alert("Please type at least one character in the input field.");
      } else {
          var operand=escape(document.eunis.operand.value);
          URL2= URL + '?searchString=' + searchString+'&operand='+operand;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
      }
  }

function checkform()
  {
      var searchString = trim(document.eunis.searchString.value);
      if (searchString == "") {
              alert("WARNING: Empty selection is not allowed. Please fill in the scientific name field.");
              return false;
              }
      else return true;
  }
