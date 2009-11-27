  function chooseCountry(URL)
  {
    var country = document.eunis.country.value
    URL2 = URL+"&country=" + country;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }