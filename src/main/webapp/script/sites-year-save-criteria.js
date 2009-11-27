var source1="";
var source2="";
var database1="";
var database2="";
var database3="";

var attributesNames = new Array(3);
var formFieldAttributes = new Array(3);
var formFieldOperators = new Array(3);
var booleans = new Array(3);
var operators = new Array(3);

attributesNames[0] = "Year";
attributesNames[1] = "Country name";
attributesNames[2] = "sourceDB";

formFieldAttributes[0] = "searchString/searchStringMin/searchStringMax";
formFieldAttributes[1] = "country";
formFieldAttributes[2] = "DB_NATURA2000,DB_CDDA_NATIONAL,DB_NATURE_NET,DB_CORINE,DB_CDDA_INTERNATIONAL,DB_DIPLOMA,DB_BIOGENETIC,DB_EMERALD";

formFieldOperators[0] = "relationOp";
formFieldOperators[1] = "";
formFieldOperators[2] = "";

booleans[0] = "and";
booleans[1] = "and";
booleans[2] = "";

operators[0] = "";
operators[1] = "is";
operators[2] = "is";