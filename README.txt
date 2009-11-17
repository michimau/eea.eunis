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
    
