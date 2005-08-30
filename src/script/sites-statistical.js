  // Error message displayed if not text was entered in text fields.
  var invalidInputMsg = "Please enter the full name of the country.";
  var errMinDesignationYear = "Please enter the minimum year in 'YYYY' format, and greater than 999";
  var errMaxDesignationYear = "Please enter the maximum year in 'YYYY' format, and greater than 999";
  var errInvalidYearCombination = "Minimum designation year cannot be greater than maximum designation year.";

  function validateForm()
  {
    document.eunis.country.value = trim(document.eunis.country.value);
    document.eunis.designation.value = trim(document.eunis.designation.value);
    if (document.eunis.country.value == "")
    {
      alert(invalidInputMsg);
      return false;
    }
    // Validate designation years
    if (document.eunis.yearMin.value != "" && !isYear(document.eunis.yearMin.value))
    {
      alert(errMinDesignationYear);
      return false;
    }
    if (document.eunis.yearMax.value != "" && !isYear(document.eunis.yearMax.value))
    {
      alert(errMaxDesignationYear);
      return false;
    }
    // Check if yearMin is smaller than yearMax
    if ((str2Number(document.eunis.yearMin.value)) > (str2Number(document.eunis.yearMax.value)))
    {
      alert(errInvalidYearCombination);
      return false;
    }
     // Check if country is a valid country
     if (!validateCountry(countryListString,document.eunis.country.value))
     {
       alert(errInvalidCountry);
       return false;
     }
    return checkValidSelection();
  }

  function openHelperCountry(URL)
  {
    var country = document.eunis.country.value
    var URL2 = URL+"&country=" + country;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }

  function openNewPage(URL)
  {
    eval("page = window.open(URL, '', 'toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,copyhistory=yes, resizable=yes');");
  }

  function openHelperDesignation(URL)
  {
//    if(checkValidSelection())
//    {
      var designation = document.eunis.designation.value;
      var country = document.eunis.country.value;

      var DB_NATURA2000 = document.eunis.DB_NATURA2000.checked;
      var DB_CDDA_NATIONAL = document.eunis.DB_CDDA_NATIONAL.checked;
      var DB_NATURE_NET = document.eunis.DB_NATURE_NET.checked;
      var DB_CORINE = document.eunis.DB_CORINE.checked;
      var DB_CDDA_INTERNATIONAL = document.eunis.DB_CDDA_INTERNATIONAL.checked;
      var DB_DIPLOMA = document.eunis.DB_DIPLOMA.checked;
      var DB_BIOGENETIC = document.eunis.DB_BIOGENETIC.checked;
      var DB_EMERALD = document.eunis.DB_EMERALD.checked;

      var URL2=URL;
      URL2 += "?designation=" + designation;
      URL2 += "&country=" + country;
      if (DB_NATURA2000 == true) URL2 = URL2 + "&DB_NATURA2000=true";
      if (DB_CDDA_NATIONAL == true) URL2 = URL2 + "&DB_CDDA_NATIONAL=true";
      if (DB_NATURE_NET == true) URL2 = URL2 + "&DB_NATURE_NET=true";
      if (DB_CORINE == true) URL2 = URL2 + "&DB_CORINE=true";
      if (DB_CDDA_INTERNATIONAL == true) URL2 = URL2 + "&DB_CDDA_INTERNATIONAL=true";
      if (DB_DIPLOMA == true) URL2 = URL2 + "&DB_DIPLOMA=true";
      if (DB_BIOGENETIC == true) URL2 = URL2 + "&DB_BIOGENETIC=true";
      if (DB_EMERALD == true) URL2 = URL2 + "&DB_EMERALD=true";

      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
//    }
  }