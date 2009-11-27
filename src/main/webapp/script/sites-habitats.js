function check(noCriteria)
{
  if(noCriteria == 0)
  {
    var Name = trim(document.criteriaSearch.criteriaSearch.value);
    if (Name == "")
    {
      alert(sites_habitats0);
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
      alert(sites_habitats0);
      return false;
    } else {
      return true;
    }
  }
}