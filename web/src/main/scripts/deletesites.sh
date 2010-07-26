#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

libpath=$eunis/lib
cp=$cp:$libpath/log4j-1.2.13.jar
cp=$cp:$CLASSPATH

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@

if [ "$1" = "" ]; then
	echo "Usage: deletesites {site1ID} {site2ID} {site3ID} ..."
else
	$java -cp $cp eionet.eunis.scripts.DeleteSites $@
fi;
