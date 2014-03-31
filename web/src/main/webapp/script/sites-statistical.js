  function validateForm()
  {
    document.eunis.country.value = trim(document.eunis.country.value);
    document.eunis.designation.value = trim(document.eunis.designation.value);
    if (document.eunis.country.value == "")
    {
      alert(sites_statistical0);
      return false;
    }
    // Validate designation years
    if (document.eunis.yearMin.value != "" && !isYear(document.eunis.yearMin.value))
    {
      alert(sites_statistical1);
      return false;
    }
    if (document.eunis.yearMax.value != "" && !isYear(document.eunis.yearMax.value))
    {
      alert(sites_statistical2);
      return false;
    }
    // Check if yearMin is smaller than yearMax
    if ((str2Number(document.eunis.yearMin.value)) > (str2Number(document.eunis.yearMax.value)))
    {
      alert(sites_statistical3);
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
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=350,height=500,left=490,top=0');");
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
      var DB_DIPLOMA = document.eunis.DB_DIPLOMA.checked;
//      var DB_EMERALD = document.eunis.DB_EMERALD.checked;

      var URL2=URL;
      URL2 += "?designation=" + designation;
      URL2 += "&country=" + country;
      if (DB_NATURA2000 == true) URL2 = URL2 + "&DB_NATURA2000=true";
      if (DB_CDDA_NATIONAL == true) URL2 = URL2 + "&DB_CDDA_NATIONAL=true";
      if (DB_DIPLOMA == true) URL2 = URL2 + "&DB_DIPLOMA=true";
//      if (DB_EMERALD == true) URL2 = URL2 + "&DB_EMERALD=true";

      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
//    }
  }
