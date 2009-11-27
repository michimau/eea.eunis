function validateForm()
{
  document.eunis.englishName.value = trim(document.eunis.englishName.value);
  if (document.eunis.englishName.value == "" ||
      document.eunis.englishName.value == "Search term" )
  {
    alert(sites_names0);
    return false;
  }
    // Validate designation years
  if (document.eunis.yearMin.value != "" && !isYear(document.eunis.yearMin.value))
  {
    alert(sites_names2);
    return false;
  }
  if (document.eunis.yearMax.value != "" && !isYear(document.eunis.yearMax.value))
  {
    alert(sites_names3);
    return false;
  }
  // Check if yearMin is smaller than yearMax
  if ((str2Number(document.eunis.yearMin.value)) > (str2Number(document.eunis.yearMax.value)))
  {
    alert(sites_names5);
    return false;
  }
  // Check if country is a valid country
   if (!validateCountry(countryListString,document.eunis.country.value))
   {
     alert(errInvalidCountry);
     return false;
   }
  if (document.eunis.englishName.value.length < 2)
  {
    if (false == checkValidSelection()) return false;
    return confirm(sites_names1);
  }

  return checkValidSelection(); // from sites-search-common.jsp
}

function openHelper(URL)
{
  document.eunis.englishName.value = trim(document.eunis.englishName.value);
  var operand = document.eunis.relationOp.value;
  var str = document.eunis.englishName.value;
  var DB_NATURA2000 = document.eunis.DB_NATURA2000.checked;
  var DB_CDDA_NATIONAL = document.eunis.DB_CDDA_NATIONAL.checked;
  var DB_NATURE_NET = document.eunis.DB_NATURE_NET.checked;
  var DB_CORINE = document.eunis.DB_CORINE.checked;
  var DB_CDDA_INTERNATIONAL = document.eunis.DB_CDDA_INTERNATIONAL.checked;
  var DB_DIPLOMA = document.eunis.DB_DIPLOMA.checked;
  var DB_BIOGENETIC = document.eunis.DB_BIOGENETIC.checked;
  var DB_EMERALD = document.eunis.DB_EMERALD.checked;
  URL2 = URL+"?relationOp=" + operand;
  URL2 = URL2+"&englishName=" + str;
  if (DB_NATURA2000 == true) URL2 = URL2 + "&DB_NATURA2000=true";
  if (DB_CDDA_NATIONAL == true) URL2 = URL2 + "&DB_CDDA_NATIONAL=true";
  if (DB_NATURE_NET == true) URL2 = URL2 + "&DB_NATURE_NET=true";
  if (DB_CORINE == true) URL2 = URL2 + "&DB_CORINE=true";
  if (DB_CDDA_INTERNATIONAL == true) URL2 = URL2 + "&DB_CDDA_INTERNATIONAL=true";
  if (DB_DIPLOMA == true) URL2 = URL2 + "&DB_DIPLOMA=true";
  if (DB_BIOGENETIC == true) URL2 = URL2 + "&DB_BIOGENETIC=true";
  if (DB_EMERALD == true) URL2 = URL2 + "&DB_EMERALD=true";
  if (validateForm())
  {
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }
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
      alert(sites_names4);
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
      alert(sites_names4);
      return false;
    } else {
      return true;
    }
  }
}

function openlink(URL) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
}

function openRefineHint()
{
  var criteriaType = document.getElementById("criteriaType0").options[document.getElementById("criteriaType0").selectedIndex].value;
  window.open("sites-refine-helper.jsp?search=names&criteria=" + criteriaType, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');
}

function removeElementsFromList(operList)
{
  for ( i = operList.length - 1; i >= 0; i--)
  {
    operList.remove(i);
  }
}