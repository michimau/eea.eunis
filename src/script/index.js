function validateQS( natureObject )
{
  if ( natureObject == "species" )
  {
    if ( document.species_qs.scientificName.value == "" )
    {
      alert( "Before searching, please type a few letters from species name." );
      return false;
    }
  }
  else if ( natureObject == "habitats" )
  {
    if ( document.habitats_qs.searchString.value == "" )
    {
      alert( "Before searching, please type a few letters from habitat name." );
      return false;
    }
  }
  else if ( natureObject == "sites" )
  {
    if ( document.sites_qs.englishName.value == "" )
    {
      alert( "Before searching, please type a few letters from site name." );
      return false;
    }
  }
  return true;
}
