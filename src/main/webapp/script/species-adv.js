function ecifra(n){
return ((n>="0") && (n<="9"));
}

function enumar(nr){
var isGoodNumber = true;
for(i=0;i<nr.length;i++) if(!ecifra(nr[i])) isGoodNumber = false;
return isGoodNumber;
}

function pagina (unde,nr){

  if (unde=='species-adv-search.jsp') {
       if (enumar(nr)) nr = nr + 1;
       cepun = "nimic";  
	   ce = 0;
       for(var i=0; i<document.eunis.legatura.length; i++)
       if(document.eunis.legatura[i].selected && document.eunis.legatura[i].value != "") ce=document.eunis.legatura[i].value;
	   if (ce == 1) cepun = "AND";
	   if (ce == 2) cepun = "OR";
	   alert('cepun=' + cepun);
       document.eunis.action = unde  + '?numar=' + nr + '&cepun=' + cepun;
	   alert('nn=' + document.eunis.action);
 } else document.eunis.action = unde + '?numar=' + nr;
 }
 
 
 