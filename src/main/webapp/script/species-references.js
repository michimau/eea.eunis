function openHelper(URL,fromWhere,dateVal)
{
  if(validateForm())
  {
    var u = "";
    var _author = trim(escape(document.eunis.author.value));
    var _date = trim(escape(document.eunis.date.value));
    if (document.eunis.date1!=null) _date1 = trim(escape(document.eunis.date1.value));
    else _date1=null;
    var _title = trim(escape(document.eunis.title.value));
    var _editor = trim(escape(document.eunis.editor.value));
    var _publisher = trim(escape(document.eunis.publisher.value));

    var _relationOpAuthor=escape(document.eunis.relationOpAuthor.value);
    var _relationOpDate=escape(document.eunis.relationOpDate.value);
    var _relationOpEditor=escape(document.eunis.relationOpEditor.value);
    var _relationOpPublisher=escape(document.eunis.relationOpPublisher.value);
    var _relationOpTitle=escape(document.eunis.relationOpTitle.value);

    u = u + "&author="+ _author + "&relationOpAuthor=" +_relationOpAuthor;
    u = u + "&date="+ _date + "&date1="+ _date1 + "&relationOpDate="+_relationOpDate;
    u = u + "&title="+ _title + "&relationOpTitle=" +_relationOpTitle;
    u = u + "&editor="+ _editor + "&relationOpEditor=" +_relationOpEditor;
    u = u + "&publisher="+ _publisher +"&relationOpPublisher=" +_relationOpPublisher;
    u = u + "&dateVal="+dateVal;

        URL2= URL + '?fromWhere='+fromWhere+ u ;
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
  }
}

function setVariablesForMM_jump()
{
  var u = "";
  var _author = trim(escape(document.eunis.author.value));
  var _date = trim(escape(document.eunis.date.value));
  if (document.eunis.date1!=null) _date1 = trim(escape(document.eunis.date1.value));
  else _date1=null;
  var _title = trim(escape(document.eunis.title.value));
  var _editor = trim(escape(document.eunis.editor.value));
  var _publisher = trim(escape(document.eunis.publisher.value));

  var _relationOpAuthor=escape(document.eunis.relationOpAuthor.value);
  var _relationOpDate=escape(document.eunis.relationOpDate.value);
  var _relationOpEditor=escape(document.eunis.relationOpEditor.value);
  var _relationOpPublisher=escape(document.eunis.relationOpPublisher.value);
  var _relationOpTitle=escape(document.eunis.relationOpTitle.value);

  u = u + "&author="+ _author + "&relationOpAuthor=" +_relationOpAuthor;
  u = u + "&date="+ _date + "&date1="+ _date1 + "&relationOpDate="+_relationOpDate;
  u = u + "&title="+ _title + "&relationOpTitle=" +_relationOpTitle;
  u = u + "&editor="+ _editor + "&relationOpEditor=" +_relationOpEditor;
  u = u + "&publisher="+ _publisher +"&relationOpPublisher=" +_relationOpPublisher;

  return u;
}

function MM_jumpMenu(targ,selObj,restore)
{
  val = setVariablesForMM_jump();
  if (val == null) val = "";
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+val+"'");
  if (restore) selObj.selectedIndex=0;
}

// Using utils.js
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
    return confirm(species_references_leaving_all_fields_blank_msg);
  } else {
    // Validate the form fields
    if (date != "")
    {
      if (!isYear(date))
      {
        alert(species_reference0);
        return false;
      }
    }
    if (null != document.eunis.date1 && null != document.eunis.date1.value && document.eunis.date1.value != "")
    {   
      if (!isYear(document.eunis.date1.value))
      {
        alert(species_references_min_year_msg);
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
      alert(species_references_max_greater_min_msg);
      return false;
    } else {
      return true;
    }
  }
}
