function validateForm()
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  if ( document.eunis.searchString.value == "" )
  {
    alert( sites_designated_codes1 );
    return false;
  }
  return checkValidSelection();
}

function openHelper(URL,displayWarning)
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  var searchStr = document.eunis.searchString.value;
  if(searchStr == null || searchStr == '') alert(sites_designated_codes1);
  else
  if (checkValidSelection()==true)
  {
    document.eunis.searchString.value = trim(document.eunis.searchString.value);
    var searchString = escape(document.eunis.searchString.value);
    var relationOp = document.eunis.relationOp.value;
    var URL2 = URL + '?searchString=' + searchString + '&relationOp=' + relationOp + '&displayWarning=' + displayWarning;

    var DB_NATURA2000 = false;
    var DB_CORINE = false;
    var DB_DIPLOMA = false;
    var DB_CDDA_NATIONAL = false;
    var DB_CDDA_INTERNATIONAL = false;
    var DB_BIOGENETIC = false;
    var DB_EMERALD = false;

    if (document.eunis.DB_NATURA2000.checked == true) DB_NATURA2000 = true;
    if (document.eunis.DB_DIPLOMA.checked == true) DB_DIPLOMA = true;
    if (document.eunis.DB_CDDA_NATIONAL.checked == true) DB_CDDA_NATIONAL = true;
//    if (document.eunis.DB_EMERALD.checked == true) DB_EMERALD = true;

    URL2 = URL2+"&DB_NATURA2000=" + DB_NATURA2000;
    URL2 = URL2+"&DB_DIPLOMA=" + DB_DIPLOMA;
    URL2 = URL2+"&DB_CDDA_NATIONAL=" + DB_CDDA_NATIONAL;
//    URL2 = URL2+"&DB_EMERALD=" + DB_EMERALD;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
  }
}

function check(noCriteria)
{
  if(noCriteria == 0)
  {
    var Name = trim(document.criteriaSearch.criteriaSearch.value);
    if (Name == "")
    {
      alert(sites_designated_codes0);
      return false;
    } else {
      return true;
    }
  } else {
    var isSomeoneEmpty = 0;
    for (i = 0; i <= noCriteria; i++)
    {
      if (trim(document.criteriaSearch.criteriaSearch[i].value) == "")
      {
        isSomeoneEmpty = 1;
      }
    }
    if (isSomeoneEmpty == 1)
    {
      alert(sites_designated_codes0);
      return false;
    } else {
      return true;
    }
  }
}

function openlink(URL)
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=400,height=280,left=490,top=0');");
}

function openRefineHint() {
  var criteriaType = document.getElementById("criteriaType0").options[document.getElementById("criteriaType0").selectedIndex].value;
  window.open("sites-refine-helper.jsp?search=names&criteria=" + criteriaType, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');
}
