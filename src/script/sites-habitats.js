// Error message displayed if not text was entered in text fields.
var errMessageForm = "Please type a few letters from habitat type name.";
function check(noCriteria)
{
  if(noCriteria == 0)
  {
    var Name = trim(document.criteriaSearch.criteriaSearch.value);
    if (Name == "")
    {
      alert(errMessageForm);
      return false;
    } else {
      return true;
    }
  } else {
    var isSomeoneEmpty = 0;
    for (i = 0; i <= noCriteria; i++)
    {
      if (trim(document.criteriaSearch.criteriaSearch[i].value) == "")
      {
        isSomeoneEmpty = 1;
      }
    }
    if (isSomeoneEmpty == 1)
    {
      alert(errMessageForm);
      return false;
    } else {
      return true;
    }
  }
}