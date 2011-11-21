#!/bin/sh

eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

cp=@MYSQL.JAR@

cp=$cp:@LOG4J.JAR@
cp=$cp:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Usage: deletesites {site1ID} {site2ID} {site3ID} ..."
else
	$java -cp $cp eionet.eunis.scripts.DeleteSites $@
fi;
