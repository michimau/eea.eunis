function chooseCountry( URL ) {
  var country = document.eunis.country.value;
  var URL2 = URL + "&country=" + country;
  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function choicepren( URL ) {
  var operand = document.eunis.relationOp.value;
  var str = document.eunis.englishName.value;
  var URL2 = URL + "?relationOp=" + operand;
  URL2 = URL2 + "&englishName=" + str
  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function choicepren2( URL ) {
  var operand = document.eunis.relationOp1.value;
  var str = document.eunis.searchString1.value;
  var URL2 = URL + "?relationOp1=" + operand;
  URL2 = URL2 + "&searchString1=" + str;

  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function choicepren2bis( URL ) {
  var operand = document.eunis.relationOp1.value;
  var str = document.eunis.searchString1.value;
  var URL2 = URL + "?relationOp1=" + operand;
  URL2 = URL2 + "&searchString1=" + str;
  var DB0 = false;
  var DB3 = false;
  var DB5 = false;
  var DB1 = false;
  var DB4 = false;
  var DB6 = false;

  if ( document.eunis.DB0.checked == true ) DBO = true;
  if ( document.eunis.DB3.checked == true ) DB3 = true;
  if ( document.eunis.DB5.checked == true ) DB5 = true;
  if ( document.eunis.DB1.checked == true ) DB1 = true;
  if ( document.eunis.DB4.checked == true ) DB4 = true;
  if ( document.eunis.DB6.checked == true ) DB6 = true;

  URL2 = URL2 + "&DB0=" + DB0;
  URL2 = URL2 + "&DB3=" + DB3;
  URL2 = URL2 + "&DB5=" + DB5;
  URL2 = URL2 + "&DB1=" + DB1;
  URL2 = URL2 + "&DB4=" + DB4;
  URL2 = URL2 + "&DB6=" + DB6;

  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}

function checkform() {
  var searchString = document.eunis.searchString.value;
  if ( searchString == "" ) {
    alert(sites_names2_1);
    return false;
  }
          else
          return true;
}

function MM_jumpMenu( targ, selObj, restore ) { //v3.0
  eval(targ + ".location='" + selObj.options[selObj.selectedIndex].value + "'");
  if ( restore ) selObj.selectedIndex = 0;
}

function setVariablesForMM_jump() {
  var u = "";
  if ( document.eunis.altitude1 != null ) altitude1 = escape(document.eunis.altitude1.value);
          else
          altitude1 = "";
  if ( document.eunis.altitude2 != null ) altitude2 = escape(document.eunis.altitude2.value);
          else
          altitude2 = "";
  if ( document.eunis.altitude21 != null ) altitude21 = escape(document.eunis.altitude21.value);
          else
          altitude21 = "";
  if ( document.eunis.altitude22 != null ) altitude22 = escape(document.eunis.altitude22.value);
          else
          altitude22 = "";
  if ( document.eunis.altitude31 != null ) altitude31 = escape(document.eunis.altitude31.value);
          else
          altitude31 = "";
  if ( document.eunis.altitude32 != null ) altitude32 = escape(document.eunis.altitude32.value);
          else
          altitude32 = "";
  if ( document.eunis.country != null ) country = escape(document.eunis.country.value);
          else
          country = "";

  u = u + "&country=" + country;
  u = u + "&altitude1=" + altitude1 + "&altitude2=" + altitude2;
  u = u + "&altitude21=" + altitude21 + "&altitude22=" + altitude22;
  u = u + "&altitude31=" + altitude31 + "&altitude32=" + altitude32;
  return u;
}

function MM_jumpMenuAlt( targ, selObj, restore ) { //v3.0
// alert(targ);
//alert(selObj.options[selObj.selectedIndex].value);
  var val = setVariablesForMM_jump();
  if ( val == null ) val = "";
  eval(targ + ".location='" + selObj.options[selObj.selectedIndex].value + val + "'");
  if ( restore ) selObj.selectedIndex = 0;
}

function check( noCriteria ) {
//alert(noCriteria);
  if ( noCriteria == 0 ) {
    var Name = trim(document.criteriaSearch.criteriaSearch.value);
    if ( Name == "" ) {
      alert(sites_names2_2);
      return false;
    }
    else
      return true;
  }
  else
  {
    var isSomeoneEmpty = 0;
    for ( i = 0; i <= noCriteria; i++ ) if ( trim(document.criteriaSearch.criteriaSearch[i].value) == "" ) isSomeoneEmpty = 1;
    if ( isSomeoneEmpty == 1 ) {
      alert(sites_names2_2);
      return false;
    }
            else
            return true;
  }
}


function openlink( URL ) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
}

function checkformHab() {
  var searchString1 = trim(document.eunis.searchString1.value);
  if ( searchString1 == "" ) {
    alert(sites_names2_2);
    return false;
  }
  else
    return checkValidSelection();
}

function choiceprec( URL )
{
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
}

function checkform1( s ) {
  if ( s == "" )
  {
    alert(sites_names2_0);
    return false;
  }
  return true;
}
