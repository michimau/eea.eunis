function setVariablesForMM_jump() {
    var u = "";
    var showGroup = document.eunis.showGroup.checked;
    /*
    var showOrder = document.eunis.showOrder.checked;
    var showFamily = document.eunis.showFamily.checked;
    */
    var showVernacularNames = document.eunis.showVernacularNames.checked;
    if (showGroup == true) u += "&showGroup=true";
    if(document.eunis.showGeo != null) {
      var showGeo = document.eunis.showGeo.checked;
      if (showGeo == true) u += "&showGeo=true";
     }

     if(document.eunis.showCountry != null) {
      var showCountry = document.eunis.showCountry.checked;
      if (showCountry == true) u += "&showCountry=true";
     }

    if(document.eunis.showStatus != null) {
     var showStatus = document.eunis.showStatus.checked;
     if (showStatus == true) u += "&showStatus=true";
    }

    /*
    if (showOrder == true) u += "&showOrder=true";
    if (showFamily == true) u += "&showFamily=true";
    */
    if (showVernacularNames == true) u += "&showVernacularNames=true";
    if(document.eunis.saveCriteria!=null)
    {
      var saveCriteria = document.eunis.saveCriteria.checked;
      if (saveCriteria == true) u += "&saveCriteria=true";
    }
    u+= "&firstTime=true";
    return u;
    }

function MM_jumpMenu(targ,selObj,restore){ //v3.0
// alert(targ);
 //alert(selObj.options[selObj.selectedIndex].value);
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

 function MM_jumpMenuInternational(targ,selObj,restore){ //v3.0
// alert(targ);
 //alert(selObj.options[selObj.selectedIndex].value);
  var val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}

   function setVariablesForMM_jumpCountry() {
    var u = "";
    var saveCriteria = document.eunis.saveCriteria.checked;
    if (saveCriteria == true) u += "&saveCriteria=true";
    return u;
    }

 function MM_jumpMenuCountry(targ,selObj,restore){ //v3.0
// alert(targ);
 //alert(selObj.options[selObj.selectedIndex].value);
  var val = setVariablesForMM_jumpCountry();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}
