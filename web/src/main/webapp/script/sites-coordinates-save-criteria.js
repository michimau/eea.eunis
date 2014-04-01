var source1="";
var source2="";
var database1="";
var database2="";
var database3="";

var attributesNames = new Array(4);
var formFieldAttributes = new Array(4);
var formFieldOperators = new Array(4);
var booleans = new Array(4);
var operators = new Array(4);

attributesNames[0] = "Longitude";
attributesNames[1] = "Latitude";
attributesNames[2] = "Country name";
attributesNames[3] = "sourceDB";

formFieldAttributes[0] = "longMin/longMax";
formFieldAttributes[1] = "latMin/latMax";
formFieldAttributes[2] = "country";
formFieldAttributes[3] = "DB_NATURA2000,DB_CDDA_NATIONAL,DB_DIPLOMA";

formFieldOperators[0] = "";
formFieldOperators[1] = "";
formFieldOperators[2] = "";
formFieldOperators[3] = "";


booleans[0] = "and";
booleans[1] = "and";
booleans[2] = "and";
booleans[3] = "";


operators[0] = "between";
operators[1] = "between";
operators[2] = "is";
operators[3] = "is";