function validateQS( natureObject )
{
  if ( natureObject == "species" )
  {
    if ( document.species_qs.scientificName.value == "" )
    {
      alert( type_species_msg );
      return false;
    }
  }
  else if ( natureObject == "habitats" )
  {
    if ( document.habitats_qs.searchString.value == "" )
    {
      alert( type_habitat_msg );
      return false;
    }
  }
  else if ( natureObject == "sites" )
  {
    if ( document.sites_qs.englishName.value == "" )
    {
      alert( type_site_msg );
      return false;
    }
  }
  return true;
}