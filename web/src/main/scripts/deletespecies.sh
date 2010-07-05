#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

libpath=$eunis/lib

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@

cp=$cp:$libpath/jrf-ver.unknown.jar
cp=$cp:$libpath/log4j-1.2.13.jar:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Usage: deletespecies {species1ID} {species2ID} {species3ID} ..."
else
	$java -cp $cp eionet.eunis.scripts.DeleteSpecies $@
fi;
