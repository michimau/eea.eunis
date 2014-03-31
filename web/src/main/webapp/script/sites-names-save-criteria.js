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

attributesNames[0] = "Site name";
attributesNames[1] = "Country name";
attributesNames[2] = "Designation year";
attributesNames[3] = "sourceDB";

formFieldAttributes[0] = "englishName";
formFieldAttributes[1] = "country";
formFieldAttributes[2] = "yearMin/yearMax";
formFieldAttributes[3] = "DB_NATURA2000,DB_CDDA_NATIONAL,DB_DIPLOMA";

formFieldOperators[0] = "relationOp";
formFieldOperators[1] = "";
formFieldOperators[2] = "";
formFieldOperators[3] = "";

booleans[0] = "and";
booleans[1] = "and";
booleans[2] = "and";
booleans[3] = "";

operators[0] = "";
operators[1] = "is";
operators[2] = "between";
operators[3] = "is";