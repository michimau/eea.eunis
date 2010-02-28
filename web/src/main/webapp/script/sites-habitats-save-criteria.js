var source1="";
var source2="";
var database1="0"; // 0 = EUNIS
var database2="1"; // 1 = ANNEX I
var database3="2"; // 2 = BOTH

var attributesNames = new Array(2);
var formFieldAttributes = new Array(2);
var formFieldOperators = new Array(2);
var booleans = new Array(2);
var operators = new Array(2);

attributesNames[0] = "";
attributesNames[1] = "Search database";

formFieldAttributes[0] = "searchString";
formFieldAttributes[1] = "database";

formFieldOperators[0] = "relationOp";
formFieldOperators[1] = "";

booleans[0] = "and";
booleans[1] = "";

operators[0] = "";
operators[1] = "is";