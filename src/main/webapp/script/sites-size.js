var errRefineMessage = "Please enter the refine criteria correctly.";
function openlink(URL)
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
}

function chooseCountry(URL)
{
  var country = document.eunis.country.value
  var URL2 = URL + "&country=" + country;
  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function check(noCriteria)
{
  if(noCriteria == 0)
  {
    var Name = trim(document.criteriaSearch.criteriaSearch.value);
    if (Name == "")
    {
      alert(errRefineMessage);
      return false;
    } else {
      return true;
    }
  } else {
    isSomeoneEmpty = 0;
    for (i = 0; i <= noCriteria; i++)
    {
      if (trim(document.criteriaSearch.criteriaSearch[i].value) == "")
      {
        isSomeoneEmpty = 1;
      }
    }
    if (isSomeoneEmpty == 1)
    {
      alert(errRefineMessage);
      return false;
    } else {
      return true;
    }
  }
}

// This function removes all the elements of a list
function removeElementsFromList(operList) {
  for (i = operList.length - 1; i >= 0; i--) {
    operList.remove(i);
  }
}

function openRefineHint() {
  var criteriaType = document.getElementById("criteriaType0").options[document.getElementById("criteriaType0").selectedIndex].value;
  window.open("sites-refine-helper.jsp?search=size&criteria=" + criteriaType, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');
}
