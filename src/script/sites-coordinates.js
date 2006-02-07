function chooseCountry(URL)
{
  var country = document.eunis.country.value
  var URL2 = URL+"&country=" + country;
  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function validateForm()
{
  var longMin = trim( document.eunis.longMin.value );
  var longMax = trim( document.eunis.longMax.value );
  var latMin = trim( document.eunis.latMin.value );
  var latMax = trim( document.eunis.latMax.value );

  if ( ( longMin == "" || longMax == "" ) && ( latMin == "" || latMax == "" ) )
  {
    alert( sites_coordinates0 );
    return false;
  }

  longMin = parseFloat( document.eunis.longMin.value );
  longMax = parseFloat( document.eunis.longMax.value )
  latMin = parseFloat( document.eunis.latMin.value );
  latMax = parseFloat( document.eunis.latMax.value );
  if ( ( isNaN( longMin ) || isNaN( longMax ) ) && ( isNaN( latMin ) || isNaN( latMax ) ) )
  {
    alert( sites_coordinates1 );
    return false;
  }

  // Check if minimum is smaller than maximum
  if (longMin > longMax)
  {
    alert( sites_coordinates2 );
    return false;
  }
  if ( latMin > latMax )
  {
    alert(sites_coordinates3);
    return false;
  }

  // Range check
  if ( longMin < -179.99999 || longMin > 179.999999 )
  {
    alert( sites_coordinates4 );
    return false;
  }
  if ( longMax < -179.99999 || longMax > 179.999999 )
  {
    alert( sites_coordinates5 );
    return false;
  }
  if ( latMin < -89.99999 || latMin > 89.999999 )
  {
    alert( sites_coordinates6 );
    return false;
  }
  if ( latMax < -89.99999 || latMax > 89.999999 )
  {
    alert( sites_coordinates7 );
    return false;
  }
   // Check if country is a valid country
   if (!validateCountry(countryListString,document.eunis.country.value))
   {
     alert(errInvalidCountry);
     return false;
   }
  return checkValidSelection(); // from sites-search-common.jsp
}

function chooseCoordinates(type)
{
  var URL = 'sites-coordinates-choice.jsp?callback=setCoordinatesCallback&type=' + type;
  eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,status=1,resizable=no, location=0,width=800,height=400,left=200,top=0');");
}

function openCalculator()
{
  var URL = 'sites-coordinates-calc.jsp';
  eval("page = window.open(URL, '', 'scrollbars=1,toolbar=0, resizable=no, location=0,width=430,height=160,left=400,top=100');");
}

function setCoordinatesCallback(minx, miny, maxx, maxy)
{
  if (minx.toFixed) { //if browser supports toFixed() method
    document.eunis.longMin.value = minx.toFixed(2);
    document.eunis.longMax.value = maxx.toFixed(2);
    document.eunis.latMin.value = miny.toFixed(2);
    document.eunis.latMax.value = maxy.toFixed(2);
  } else {
    document.eunis.longMin.value = minx;
    document.eunis.longMax.value = maxx;
    document.eunis.latMin.value = miny;
    document.eunis.latMax.value = maxy;
  }
}