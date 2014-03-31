var source1="";
var source2="";
var database1="";
var database2="";
var database3="";

var attributesNames = new Array(5);
var formFieldAttributes = new Array(5);
var formFieldOperators = new Array(5);
var booleans = new Array(5);
var operators = new Array(5);

attributesNames[0] = "Country name";
attributesNames[1] = "Designation";
attributesNames[2] = "Designation category";
attributesNames[3] = "Designation year";
attributesNames[4] = "sourceDB";

formFieldAttributes[0] = "country";
formFieldAttributes[1] = "designation";
formFieldAttributes[2] = "designationCat";
formFieldAttributes[3] = "yearMin/yearMax";
formFieldAttributes[4] = "DB_NATURA2000,DB_CDDA_NATIONAL,DB_DIPLOMA";

formFieldOperators[0] = "";
formFieldOperators[1] = "";
formFieldOperators[2] = "";
formFieldOperators[3] = "";
formFieldOperators[4] = "";

booleans[0] = "and";
booleans[1] = "and";
booleans[2] = "and";
booleans[3] = "and";
booleans[4] = "";

operators[0] = "is";
operators[1] = "contains";
operators[2] = "is";
operators[3] = "between";
operators[4] = "is";