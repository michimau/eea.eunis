#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

libpath=$eunis/lib

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@
cp=$cp:$libpath/log4j-1.2.13.jar:$libpath/jrf-ver.unknown.jar
cp=$cp:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Missing argument! Possible first arguments are: sites, empty_digir, digir, statistics, species_tab, sites_tab, habitats_tab, taxonomy_tree"
else
	$java -cp $cp eionet.eunis.scripts.PostImportScriptsCmd $@
fi;
