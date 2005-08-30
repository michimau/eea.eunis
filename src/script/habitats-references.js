function openHelper(URL,fromWhere,witchDateUse,database,source)
{
  if(validateForm())
  {
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

    if (document.eunis.database[0].checked == true) u = u + "&database="+database[0];
    if (document.eunis.database[1].checked == true) u = u + "&database="+database[1];
    if (document.eunis.database[2].checked == true) u = u + "&database="+database[2];

    if (document.eunis.source[0].checked == true) u = u + "&source="+source[0];
    if (document.eunis.source[1].checked == true) u = u + "&source="+source[1];

    u = u + "&author="+ _author + "&relationOpAuthor=" +_relationOpAuthor;
    u = u + "&date="+ _date + "&date1="+ _date1 + "&relationOpDate="+_relationOpDate;
    u = u + "&title="+ _title + "&relationOpTitle=" +_relationOpTitle;
    u = u + "&editor="+ _editor + "&relationOpEditor=" +_relationOpEditor;
    u = u + "&publisher="+ _publisher +"&relationOpPublisher=" +_relationOpPublisher;
    u = u + "&witchDateUse="+witchDateUse;
    URL2= URL + '?fromWhere='+fromWhere+ u ;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }
}

function setVariablesForMM_jump()
{
  u = "";
  _author = trim(document.eunis.author.value);
  _date = trim(document.eunis.date.value);
  if (document.eunis.date1!=null) {_date1 = trim(document.eunis.date1.value);u = u + "&date1="+ _date1;}

  _title = trim(document.eunis.title.value);
  _editor = trim(document.eunis.editor.value);
  _publisher = trim(document.eunis.publisher.value);

  _relationOpAuthor=escape(document.eunis.relationOpAuthor.value);
  _relOpDate=escape(document.eunis.relOpDate.value);
  _relationOpEditor=escape(document.eunis.relationOpEditor.value);
  _relationOpPublisher=escape(document.eunis.relationOpPublisher.value);
  _relationOpTitle=escape(document.eunis.relationOpTitle.value);

  u = u + "&author="+ _author + "&relationOpAuthor=" +_relationOpAuthor;
  u = u + "&date="+ _date + "&relOpDate="+_relOpDate;
  u = u + "&title="+ _title + "&relationOpTitle=" +_relationOpTitle;
  u = u + "&editor="+ _editor + "&relationOpEditor=" +_relationOpEditor;
  u = u + "&publisher="+ _publisher +"&relationOpPublisher=" +_relationOpPublisher;

  return u;
}

function MM_jumpMenu(targ,selObj,restore)
{
  // alert(targ);
  //alert(selObj.options[selObj.selectedIndex].value);
  val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}

function validateForm()
{
  // Trim all the values
  document.eunis.date.value = trim(document.eunis.date.value);
  if (null != document.eunis.date1)
  {
    document.eunis.date1.value = trim(document.eunis.date1.value);
  }
  document.eunis.author.value = trim(document.eunis.author.value);
  document.eunis.title.value = trim(document.eunis.title.value);
  document.eunis.editor.value = trim(document.eunis.editor.value);
  document.eunis.publisher.value = trim(document.eunis.publisher.value);
  // Proceed with validation
  var date = document.eunis.date.value;
  var date1 = "";
  if (null != document.eunis.date1)
  {
    date1 = document.eunis.date1.value;
  }
  var author = document.eunis.author.value;
  var title = document.eunis.title.value;
  var editor = document.eunis.editor.value;
  var publisher = document.eunis.publisher.value;
  if (date == "" && date1 == "" && author == "" && title == "" && editor == "" && publisher == "")
  {
    return confirm("By leaving all the fields blank the search might take a long time. Are you sure you want to continue?");
  } else {
    // Validate the form fields
    if (date != "")
    {
      if (!isYear(date))
      {
        alert("Please enter the minimum year in 'YYYY' format, and greater than 1000");
        return false;
      }
    }
    if (null != document.eunis.date1 && document.eunis.date1.value != "")
    {
      if (!isYear(date1))
      {
        alert("Please enter the maximum year in 'YYYY' format and greater than 1000");
        return false;
      }
    }
    var yearMin = str2Number(date, -1);
    var yearMax = str2Number(date1, -1);
    if (null != document.eunis.date1
        && document.eunis.date.value != ""
        && document.eunis.date1.value != ""
        && (yearMax < yearMin))
    {
      alert("Maximum year must be greater or equal with minimum year");
      return false;
    } else {
      return true;
    }
  }
}
