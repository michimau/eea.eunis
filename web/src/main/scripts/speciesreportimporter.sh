#!/bin/sh

eunis=@WEBAPP.HOME@/WEB-INF
java=/usr/bin/java

cp=$eunis/classes
cp=$cp:$eunis/lib/*

if [ $# -lt 1 ]; then
	echo "Usage: $0 {list of Excel files}"
else
	$java -cp "$cp" ro.finsiel.eunis.dataimport.legal.SpeciesReportsImporter $@
fi;
