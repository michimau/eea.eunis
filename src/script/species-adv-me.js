function choiceprel(URL) {
      var criteria=escape(document.eunis._7criteriafor.value);
      var oper=escape(document.eunis._7operfor.value);
  if (!document.eunis._7searchStringfor.value=="") {
      var searchString=escape(document.eunis._7searchStringfor.value);
        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          var URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter a search criteria');
      }
  }



function choiceprelii(URL,i)
{

var criteria = null;
var oper = null;
var searchString = null;
alert(i);
alert(i);

switch (i) {
case '0' :  {criteria=escape(document.eunis._0criteriafor.value);
        oper=escape(document.eunis._0operfor.value);
        searchString=escape(document.eunis._0searchStringfor.value);
        }
        break;
case '1' :  {criteria=escape(document.eunis._1criteriafor.value);
        oper=escape(document.eunis._1operfor.value);
        searchString=escape(document.eunis._1searchStringfor.value);
        }
        break;
case '2' :  {criteria=escape(document.eunis._2criteriafor.value);
        oper=escape(document.eunis._2operfor.value);
        searchString=escape(document.eunis._2searchStringfor.value);
        }
        break;
case '3' :  {criteria=escape(document.eunis._3criteriafor.value);
        oper=escape(document.eunis._3operfor.value);
        searchString=escape(document.eunis._3searchStringfor.value);
        }
        break;
case '4' :  {criteria=escape(document.eunis._4criteriafor.value);
        oper=escape(document.eunis._4operfor.value);
        searchString=escape(document.eunis._4searchStringfor.value);
        }
        break;
           }

alert(criteria);
alert(oper);
alert(searchString);    

}


function choicepreli(URL,i) {
  var criteria = null;
  var oper = null;
  var searchString = null;

switch (i) {

     case '0' :
      criteria=escape(document.eunis._0criteriafor.value);
      oper=escape(document.eunis._0operfor.value);
  if (!document.eunis._0searchStringfor.value=="") {
      searchString=escape(document.eunis._0searchStringfor.value);
        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter something to search after');
      }


              break;
     case '1' :

      criteria=escape(document.eunis._1criteriafor.value);

      oper=escape(document.eunis._1operfor.value);

  if (!document.eunis._1searchStringfor.value=="") {
      searchString=escape(document.eunis._1searchStringfor.value);

        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;

          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter something to search after');
      }

              break;
     case '2' : {
      criteria=escape(document.eunis._2criteriafor.value);
      oper=escape(document.eunis._2operfor.value);
  if (!document.eunis._2searchStringfor.value=="") {
      searchString=escape(document.eunis._2searchStringfor.value);
        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter something to search after');
      }
              }
              break;
     case '3' : {
      criteria=escape(document.eunis._3criteriafor.value);
      oper=escape(document.eunis._3operfor.value);
  if (!document.eunis._3searchStringfor.value=="") {
      searchString=escape(document.eunis._3searchStringfor.value);
        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter something to search after');
      }
              }
              break;
     case '4' : {
      criteria=escape(document.eunis._4criteriafor.value);
      oper=escape(document.eunis._4operfor.value);
  if (!document.eunis._4searchStringfor.value=="") {
      searchString=escape(document.eunis._4searchStringfor.value);
        if (criteria=="") {
          alert('Please select at least one criteria to search after.');
        } else {
          URL2= URL + '&searchString=' + searchString + '&criteria=' + criteria + '&oper=' + oper;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      } else {
        alert('Please enter something to search after');
      }
              }
              break;
    }



}


function openlink(URL) {
  eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width=450,height=280,left=490,top=0');");
}

  function checkform() {
      var criteria="";
      if(document.eunis.criteriaS.checked==true) { criteria = "scientific";}
      if(document.eunis.criteriaV.checked==true) { criteria +=",vernacular"; }
      if(document.eunis.criteriaD.checked==true) { criteria +=",description"; }
      criteria = escape(criteria);
      if (criteria=="") {
          alert('Please select at least one criteria to search after.');
          return false;
      }
      var searchString = document.eunis.searchString.value;
      if (searchString == "") {
              alert("WARNING: Please enter something to search for.");
              return false;
      }
      else return true;
  }
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
