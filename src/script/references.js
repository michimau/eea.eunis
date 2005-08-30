 function choiceprenref(URL,fromWhere,dateVal) {
    if(checkformForDate()){
    u = "";
    _author = trim(document.eunis.author.value);
    _date = trim(document.eunis.date.value);
    if (document.eunis.date1!=null) _date1 = trim(document.eunis.date1.value);
    else _date1=null;
    _title = trim(document.eunis.title.value);
    _editor = trim(document.eunis.editor.value);
    _publisher = trim(document.eunis.publisher.value);

    _relationOpAuthor=escape(document.eunis.relationOpAuthor.value);
    _relationOpDate=escape(document.eunis.relationOpDate.value);
    _relationOpEditor=escape(document.eunis.relationOpEditor.value);
    _relationOpPublisher=escape(document.eunis.relationOpPublisher.value);
    _relationOpTitle=escape(document.eunis.relationOpTitle.value);


    u = u + "&author="+ _author + "&relationOpAuthor=" + _relationOpAuthor;
    u = u + "&date="+ _date + "&date1="+ _date1 + "&relationOpDate="+_relationOpDate;
    u = u + "&title="+ _title + "&relationOpTitle=" +_relationOpTitle;
    u = u + "&editor="+ _editor + "&relationOpEditor=" +_relationOpEditor;
    u = u + "&publisher="+ _publisher +"&relationOpPublisher=" +_relationOpPublisher;
    u = u + "&dateVal="+dateVal;

        URL2= URL + '?fromWhere='+fromWhere+ u ;
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
    }
    }

    function setVariablesForMM_jump() {
    u = "";
    author = trim(document.eunis.author.value);
    date = trim(document.eunis.date.value);
    if (document.eunis.date1!=null) {date1 = trim(document.eunis.date1.value);u = u + "&date1="+ date1;}

    title = trim(document.eunis.title.value);
    editor = trim(document.eunis.editor.value);
    publisher = trim(document.eunis.publisher.value);

    relationOpAuthor=escape(document.eunis.relationOpAuthor.value);
    relOpDate=escape(document.eunis.relOpDate.value);
    relationOpEditor=escape(document.eunis.relationOpEditor.value);
    relationOpPublisher=escape(document.eunis.relationOpPublisher.value);
    relationOpTitle=escape(document.eunis.relationOpTitle.value);


    u = u + "&author="+ author + "&relationOpAuthor=" +relationOpAuthor;
    u = u + "&date="+ date + "&relOpDate="+relOpDate;
    u = u + "&title="+ title + "&relationOpTitle=" +relationOpTitle;
    u = u + "&editor="+ editor + "&relationOpEditor=" +relationOpEditor;
    u = u + "&publisher="+ publisher +"&relationOpPublisher=" +relationOpPublisher;

    return u;
    }


function MM_jumpMenu(targ,selObj,restore){ //v3.0
  val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}

function isNumber1(s)
{
  var nr = parseInt(s);
  if (isNaN(nr)) return false;
  else return true;
}

function isNumber(s)
{
  if(s == null) return false;
  else
   {
     var isGoodNumber = true;
     for (i=0;i<s.length;i++) if (isNumber1(s.charAt(i)) == false) isGoodNumber = false;
     return isGoodNumber;
   }
}

function isYear(y){
if (!isNumber(y)) return false;
if(y.length!=4) return false;
if(y.charAt(0)==0) return false;
if(y.charAt(0)>2) return false;
return true;
}

function goodDate1() {
var isGoodDate = true;
if(document.eunis.date.value != null && trim(document.eunis.date.value) != "")
  if(isYear(document.eunis.date.value))
  {
      if(document.eunis.date1 != null
      && isYear(document.eunis.date1.value)
      && document.eunis.date.value > document.eunis.date1.value)
        {
         alert("You must insert a value smaller or equal that "+document.eunis.date1.value);
         document.eunis.date.value="";
         isGoodDate=false;
        }
  } else
  {
      alert("Your value is not a valid year(yyyy)!");
      document.eunis.date.value="";
      isGoodDate=false;
  }
  return isGoodDate;
}

function goodDate2() {
var isGoodDate = true;
if(document.eunis.date1.value != null && trim(document.eunis.date1.value) != "")
  if(isYear(document.eunis.date1.value))
  {
      if(document.eunis.date != null
      && isYear(document.eunis.date.value)
      && document.eunis.date.value > document.eunis.date1.value)
      {
          alert("You must insert a value grather or equal that " + document.eunis.date.value);
          document.eunis.date1.value = "";
          isGoodDate = false;
      }
  } else
  {
      alert("Your value is not a valid year(yyyy)!");
      document.eunis.date1.value = "";
      isGoodDate = false;
  }
  return isGoodDate;
}

function checkformForDate(){
var date = document.eunis.date;
var date1 = document.eunis.date1;
var isGoodDate = true;
if (date != null && trim(date.value) != "" && date.value != "null")
  {
    isGoodDate=goodDate1();
  }
if (date1 != null && trim(date1.value) != "" && date1.value != "null")
  {
    isGoodDate=goodDate2();
  }
return isGoodDate;
}
