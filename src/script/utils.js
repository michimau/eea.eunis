var errInvalidCountry = country_invalid_msg;

function openTSVDownload( URL )
{
  open( URL, "", "scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0");
}

//
// Get screen width on the client machine.
// @return client screen width.
//
function getScreenWidth()
{
  var screenW = 640;
  if (parseInt(navigator.appVersion) > 3)
  {
    screenW = screen.width;
  } else if (navigator.appName == "Netscape" && parseInt(navigator.appVersion)==3 && navigator.javaEnabled()) {
    var jToolkit = java.awt.Toolkit.getDefaultToolkit();
    var jScreenSize = jToolkit.getScreenSize();
    screenW = jScreenSize.width;
  }
  return screenW;
}

//
// Get screen height on the client machine.
// @return client screen height.
//
function getScreenHeight()
{
  var screenH = 480;
  if (parseInt(navigator.appVersion) > 3)
  {
    screenH = screen.height;
  } else if (navigator.appName == "Netscape" && parseInt(navigator.appVersion)==3 && navigator.javaEnabled()) {
    var jToolkit = java.awt.Toolkit.getDefaultToolkit();
    var jScreenSize = jToolkit.getScreenSize();
    screenH = jScreenSize.height;
  }
  return screenH;
}

//
// Center window horizontally on the screen.
// @param windowWidth - The width of the window to be centered horizontaly on the screen.
// @return the X position of the left-top corner.
//
function centerHoriz(windowWidth)
{
  var screenWidth = getScreenWidth();
  return leftCorner = (screenWidth / 2) - (windowWidth / 2);
}

//
// Center window vertically on the screen.
// @param windowHeigth - The height of the window to be centered vertically on the screen.
// @return the Y position of the left-top corner.
//
function centerVert(windowH)
{
  var height = getScreenHeight();
  return (height / 2) - (windowH / 2);
}

//
// Removes leading and trailing spaces from the passed string. Also removes
// consecutive spaces and replaces it with one space. If something besides
// a string is passed in (null, custom object, etc.) then return the input.
// @param inputString - String to be parsed.
//
function trim(s) {
  try
  {
  while (s.substring(0,1) == ' ') {
    s = s.substring(1,s.length);
  }
  while (s.substring(s.length-1,s.length) == ' ') {
    s = s.substring(0,s.length-1);
  }
  }
  catch( e )
  {
  }
  return s;
}

function checkHabitats(noCriteria)
{
  if(noCriteria == 0)
  {
    Name = trim(document.resultSearch.criteriaSearch.value);
    if (Name == "")
    {
      alert(empty_msg);
      return false;
    } else {
      return true;
    }
  } else {
    isSomeoneEmpty = 0;
    for (i = 0; i <= noCriteria; i++) {
      if (trim(document.resultSearch.criteriaSearch[i].value) == "")
      {
        isSomeoneEmpty = 1;
      }
    }
    if (isSomeoneEmpty == 1)
    {
      alert(empty_msg);
      return false;
    } else {
      return true;
    }
  }
}

//
// Transform an string into a number.
// @param str - String to be returned.
// @param defValue - Default value if validation fails.
//
function str2Number(str, defValue)
{
  var ret = defValue;
  if (null != str)
  {
    ret = parseInt(str);
    if (isNaN(ret)) ret = defValue;
  }
  return ret;
}

//
// Check if an string is a valid year greater than 999 and length is 4 characters long.
// @param y - String representing the year to be checked.
//
function isYear(y)
{
  var ret = false;
  var year = str2Number(y, -1);
  if ( year > 999)
  {
    if (y.length > 4)
    {
      return false;
    }
    ret = true;
  } else {
    ret = false;
  }
  return ret;
}

/**
 * Open the diagram for habitat types
 */
function openDiagram(theURL, winName, features)
{
  var wnd = window.open(theURL,winName,features);
  wnd.moveTo(0,0);
  wnd.resizeTo(screen.width,screen.height);
}

/**
 * Method called when tab is changed, on tab navigation
 * Prior to using this method, tab array must be defined
 */
function OnTabChange( index )
{
  var stopannoying = false;
  for ( i = 0; i < tabs.length; i++ )
  {
    try
    {
      var name = tabs[ i ];
      var tab = document.getElementById( "tab_" + name );
      var div_content = document.getElementById( name );

      if ( name == index )
      {
        div_content.style.display = "block";
        tab.style.background = "#669ACC";
      }
      else
      {
        div_content.style.display = "none";
        tab.style.background = "#3759A3";
      }
    }
    catch( e )
    {
      if ( !stopannoying )
      {
        alert( e.message );
        stopannoying = true;
      }
    }
 }
}

 function validateCountry(countryListString,name)
{
  if (trim(name) == '') return true;
  if (trim(countryListString) == '') return true;
  var countries = new Array();
  countries = countryListString.split("|");
  ret = false;
  for (i = 0; i < countries.length; i++)
  {
    if (countries[i].toLowerCase() == name.toLowerCase())
    {
      return true;
    }
  }
 }

function validateRegion(regionListString,name)
{
  if (trim(name) == '') return true;
  if (trim(regionListString) == '') return true;
  var regions = new Array();
  regions = regionListString.split("|");
  ret = false;
  for (i = 0; i < regions.length; i++)
  {
    if (regions[i].toLowerCase() == name.toLowerCase())
    {
      return true;
    }
  }
 }

function goToCountryStatistics(countryName) {

      var frm = document.createElement( "FORM" );
      document.appendChild( frm );
      frm.method = "post";
      frm.action="sites-statistical-result.jsp";

      var c = document.createElement("input");
      c.type= "hidden";
      c.name = "country";
      c.value = countryName;
      frm.appendChild( c );

     var db1 = document.createElement("input");
     db1.type= "hidden";
     db1.name = "DB_NATURA2000";
     db1.value = true;
     frm.appendChild( db1 );

    var db2 = document.createElement("input");
    db2.type= "hidden";
    db2.name = "DB_CDDA_NATIONAL";
    db2.value = true;
    frm.appendChild( db2 );

    var db3 = document.createElement("input");
    db3.type= "hidden";
    db3.name = "DB_NATURE_NET";
    db3.value = false;
    frm.appendChild( db3 );

    var db4 = document.createElement("input");
    db4.type= "hidden";
    db4.name = "DB_CORINE";
    db4.value = true;
    frm.appendChild( db4 );

    var db5 = document.createElement("input");
    db5.type= "hidden";
    db5.name = "DB_CDDA_INTERNATIONAL";
    db5.value = true;
    frm.appendChild( db5 );

    var db6 = document.createElement("input");
    db6.type= "hidden";
    db6.name = "DB_DIPLOMA";
    db6.value = true;
    frm.appendChild( db6 );

    var db7 = document.createElement("input");
    db7.type= "hidden";
    db7.name = "DB_BIOGENETIC";
    db7.value = true;
    frm.appendChild( db7 );

    var db8 = document.createElement("input");
    db8.type= "hidden";
    db8.name = "DB_EMERALD";
    db8.value = true;
    frm.appendChild( db8 );

    frm.submit();
}


function goToSpeciesStatistics(countryName) {  

      var frm = document.createElement( "FORM" );
      document.appendChild( frm );
      frm.method = "post";
      frm.action="species-statistics-module.jsp";

      var c = document.createElement("input");
      c.type= "hidden";
      c.name = "countryName";
      c.value = countryName;
      frm.appendChild( c );

    frm.submit();
}

