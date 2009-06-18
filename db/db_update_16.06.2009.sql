CREATE TABLE eunis_digir_stats (
	TotalSpecies INT default 0,
	DistinctSpecies INT default 0,
	SpeciesWithCountry INT default 0,
	SpeciesWithLatLong INT default 0,
	SpeciesFromHabitats INT default 0,
	SpeciesFromSites INT default 0,
	DateLastModified varchar(32) default NULL);