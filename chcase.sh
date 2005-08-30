#!/bin/sh

echo "";
echo "If you execute this script directly on MySQL database,";
echo "please STOP service before executing then restart it. ";
echo "                                           Thank you.";
echo "";

ARGS=1
E_BADARGS=65

function showUsage()
{
  echo "usage: $0 <lowercase | uppercase>";
  echo "  - lowercase - make all filenames to lowercase,";
  echo "                but extensions for .MYI, .MYD";
  echo "                will be uppercase and .frm lowercase;";
  echo "  - uppercase - make all filenames to uppercase,";
  echo "                extensions for .MYI, .MYD will";
  echo "                be uppercase and .frm lowercase.";
  echo ""
}

if [ "$#" -ne "$ARGS" ] || ( [ "$1" != "lowercase" ] && [ "$1" != "uppercase" ] )
  then
    showUsage;
    exit $E_BADARGS;
fi
for ext in myd MYD myi MYI frm FRM
do
  for filename in `ls -1 *.$ext | gawk -F'.' '{print $1}'`
  do
    if [ "$1" == "lowercase" ]; then
      n=`echo $filename | tr A-Z a-z`
    else
      n=`echo $filename | tr a-z A-Z`
    fi
    if [ "$filename" != "$n" ]; then
      if [ "$ext" == "FRM" ]; then
        mv `echo "$filename.$ext"` `echo "$n.frm"`;
      elif [ "$ext" == "myi" ]; then
        mv `echo "$filename.$ext"` `echo "$n.MYI"`;
      elif [ "$ext" == "myd" ]; then
        mv `echo "$filename.$ext"` `echo "$n.MYD"`;
      else
        mv `echo "$filename.$ext"` `echo "$n.$ext"`;
      fi
    fi
  done
done
exit 0
