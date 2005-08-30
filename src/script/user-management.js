function MM_jumpMenu(targ,selObj,restore,tab1,tab2)
{
  eval(targ+".location='users.jsp?tab1="+tab1+"&tab2="+tab2+"&userName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_jumpMenuRights(targ,selObj,restore,tab1,tab2)
{
  eval(targ+".location='users.jsp?tab1="+tab1+"&tab2="+tab2+"&rightName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_jumpMenuRoles(targ,selObj,restore,tab1,tab2)
{
  eval(targ+".location='users.jsp?tab1="+tab1+"&tab2="+tab2+"&roleName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
