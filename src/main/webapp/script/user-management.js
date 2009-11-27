function MM_jumpMenu(targ,selObj,restore,tab)
{
  eval(targ+".location='users.jsp?tab="+tab+"&userName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_jumpMenuRights(targ,selObj,restore,tab)
{
  eval(targ+".location='roles.jsp?tab="+tab+"&rightName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_jumpMenuRoles(targ,selObj,restore,tab)
{
  eval(targ+".location='roles.jsp?tab="+tab+"&roleName="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
