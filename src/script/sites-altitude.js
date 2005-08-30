var errMessageForm = "At least one altitude value must be entered.";
var errInvalidMeanAlt = "Mean altitude is not a number.";
var errInvalidMinAlt = "Minimum altitude is not a number.";
var errInvalidMaxAlt = "Maximum altitude is not a number.";

function validateForm()
{
  var altitude1 = "";
  var altitude2 = "";
  var altitude3 = "";

  if(document.eunis.altitude1!=null)
    altitude1 = trim(document.eunis.altitude1.value);
  if(document.eunis.altitude21!=null)
    altitude2 = trim(document.eunis.altitude21.value);
  if(document.eunis.altitude31!=null)
    altitude3 = trim(document.eunis.altitude31.value);

  if (altitude1 != "" || altitude2 != "" || altitude3 != "")
  {
    if(altitude1 !="" && !isNumber3(altitude1))
    {
      alert(errInvalidMeanAlt);
      return false;
    }
    if(altitude2 !="" && !isNumber3(altitude2))
    {
      alert(errInvalidMinAlt);
      return false;
    }
    if(altitude3 !="" && !isNumber3(altitude3))
    {
      alert(errInvalidMaxAlt);
      return false;
    }
     // Check if country is a valid country
   if (!validateCountry(countryListString,document.eunis.country.value))
   {
     alert(errInvalidCountry);
     return false;
   }
    return checkValidSelection();
  } else {
    alert(errMessageForm);
    return false;
  }
}

function isNumber2(s)
{
var nr = parseInt(s);
if (isNaN(nr)) return false;
else return true;
}

function isNumber3(s)
{
if(s==null) return false;
 else {
 var isGoodNumber = true;
 for (i=0;i<s.length;i++) if (isNumber2(s.charAt(i))==false) isGoodNumber = false;
 return isGoodNumber;
 }
}

function setVariablesForMM_jump() {
    var u ="";
    if(document.eunis.altitude1!=null) altitude1 = escape(document.eunis.altitude1.value);
    else altitude1="";
    if(document.eunis.altitude2!=null) altitude2 = escape(document.eunis.altitude2.value);
    else altitude2="";
    if(document.eunis.altitude21!=null) altitude21 = escape(document.eunis.altitude21.value);
    else altitude21="";
    if(document.eunis.altitude22!=null) altitude22 = escape(document.eunis.altitude22.value);
    else altitude22="";
    if(document.eunis.altitude31!=null) altitude31 = escape(document.eunis.altitude31.value);
    else altitude31="";
    if(document.eunis.altitude32!=null) altitude32 = escape(document.eunis.altitude32.value);
    else altitude32="";
    if(document.eunis.country!=null) country = escape(document.eunis.country.value);
    else country="";

    u = u + "&country="+ country;
    u = u + "&altitude1="+ altitude1 + "&altitude2=" +altitude2;
    u = u + "&altitude21="+ altitude21 + "&altitude22=" +altitude22;
    u = u + "&altitude31="+ altitude31 + "&altitude32=" +altitude32;
    return u;
    }

 function MM_jumpMenuAlt(targ,selObj,restore){ //v3.0
// alert(targ);
 //alert(selObj.options[selObj.selectedIndex].value);
  var val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}

function check(noCriteria) {
//alert(noCriteria);
if(noCriteria == 0) {
  var Name = trim(document.criteriaSearch.criteriaSearch.value);
  if (Name == "") {
    alert("WARNING: Empty selection is not allowed. Please fill the field.");
    return false;
  } else return true;
} else {
    var isSomeoneEmpty = 0;
    for (i=0;i<=noCriteria;i++) if (trim(document.criteriaSearch.criteriaSearch[i].value) == "") isSomeoneEmpty = 1;
    if (isSomeoneEmpty == 1) {
      alert("WARNING: Empty selection is not allowed. Please fill the field.");
      return false;
    } else return true;
  }
}

function chooseCountry(URL)
{
var country = document.eunis.country.value;
var URL2 = URL+"&country=" + country;
eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
}