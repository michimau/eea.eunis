all:
	python mysql2rdf.py -t countries >countries.rdf
	python mysql2rdf.py -t countrybiogeo >countrybiogeo.rdf
	python mysql2rdf.py -t biogeoregions >biogeoregions.rdf
	python mysql2rdf.py -t speciesgroup >speciesgroup.rdf
	gzip *.rdf
