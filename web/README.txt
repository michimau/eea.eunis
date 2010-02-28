1. How to create Java documentation:
------------------------------------
Run 'ant javadoc' from the command prompt.


2.How to install:
-----------------
Copy the default.properties to build.properties and edit the values.
Run 'ant'. This will compile the classes and deploy the application within
tomcat's webapps directory.

3.How to use lowercase.sh script:
---------------------------------
'tolowercase.sh' is used to rename MySQL's database table file names
to correct name (from uppercase - default on Windows to lowercase, as used on Linux).
    - stop mysql
    - make a copy of this script into 'eunis' directory from MySQL's databases directory ( ex. /var/lib/mysql/eunis )
    - execute this script with the 'uppercase' command line argument ( without the quotes ).
                  linux_prompt$>./tolowercase.sh uppercase
    - start mysql
    - check if all files are now in lowercase.
    - remove the script from there.
    
4.How to build using maven:
---------------------------

a) Be sure to modify resources in {basedir}/src/main/resources/envSpecific/${env} to meet your environment.
	At build time those resources will be copied to the appropriate locations in the web app, replacing the old ones.
b) in the project root directory type: 
   mvn clean install -Denv=live
   
   this will take all the needed resources from /src/main/resources/envSpecific/live folder,
   build the application,
   install it into the local maven repository under eionet/eunis directory.
   

   
   
   
