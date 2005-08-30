//expand - expand or not list of saved searches on web page
//validationForm - value of validation form function
//pageName - name of page (ex: sites-names.jsp)
//numberCriteria - how many criteria will be insert into eunis_group_search_criterias table for this search
//formName - form name
//attributeNames - vector with attributes names elements witch will be insert into eunis_group_search_criteria table
//formfieldAttributes - vector with form field attributes elements witch will be insert into eunis_group_search_criteria table
//formfieldOperators - vector with form field operators elements witch will be insert into eunis_group_search_criteria table
//operators - vector with operators elements witch will be insert into eunis_group_search_criteria table
//booleans - vector with booleans elements witch will be insert into eunis_group_search_criteria table
//database1 - value of EUNIS_SEARCH from habitats searches domains
//database2 - value of ANNEX_SEARCH from habitats searches domains
//database3 - value of BOTH_SEARCH from habitats searches domains
//source1 - value of SOURCE_SEARCH from habitats-references searche domain
//source2 - value of OTHER_INFO_SEARCH from habitats-references searche domain
function composeParameterListForSaveCriteria(expand,validationForm,pageName,numberCriteria,formName,attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,URL){
 if(validationForm)
 {
 var URL2 = URL + '?numberCriteria=' + numberCriteria + '&pageName=' + pageName  + '&expandSearchCriteria=' + expand;
 URL2 +='&database1=' + database1 + '&database2=' + database2 + '&database3=' + database3;

 if (attributesNames !=null && attributesNames.length>0)
  {
    for(i=0;i<attributesNames.length;i++)
        {
          //exceptions by general shape
          if(trim(attributesNames[i])=="")
             {
                if (trim(pageName) == "sites-size.jsp") URL2= URL2 + '&_' + i + 'attributesNames' + '=' + trim(escape(document.forms[formName].elements["searchType"].value));
                else
                if (trim(pageName) == "habitats-species.jsp"
                     || trim(pageName) == "habitats-sites.jsp"
                     || trim(pageName) == "species-habitats.jsp"
                     || trim(pageName) == "species-sites.jsp"
                     || trim(pageName) == "sites-species.jsp"
                     || trim(pageName) == "sites-habitats.jsp") URL2= URL2 + '&_' + i + 'attributesNames' + '=' + trim(escape(document.forms[formName].elements["searchAttribute"].value));
                else
                URL2= URL2 + '&_' + i + 'attributesNames' + '=';
             }
          else //general shape
          {
          URL2= URL2 + '&_' + i + 'attributesNames' + '=' + attributesNames[i];
          }
        }
    for(i=0;i<formFieldAttributes.length;i++) URL2= URL2 + '&_' + i + 'formFieldAttributes' + '=' + formFieldAttributes[i];
    for(i=0;i<formFieldOperators.length;i++) URL2= URL2 + '&_' + i + 'formFieldOperators' + '=' + formFieldOperators[i];
    for(i=0;i<booleans.length;i++) URL2= URL2 + '&_' + i + 'booleans' + '=' + booleans[i];
    for(i=0;i<attributesNames.length;i++)
     {
      ///////// fill firstValue and lastValue vectors
      //if formFieldAttributes not contain '/' or ','
      if(formFieldAttributes[i].indexOf("/")==-1 && formFieldAttributes[i].indexOf(",")==-1)
        {
          //if attribute name is database like in habitats searches
           if (formFieldAttributes[i] == "database")
             {
               if (document.forms[formName].elements[formFieldAttributes[i]][0].checked == true) URL2= URL2 + '&_' + i + 'firstValues=' + database1; //eunis
               if (document.forms[formName].elements[formFieldAttributes[i]][1].checked == true) URL2= URL2 + '&_' + i + 'firstValues=' + database2; //annex
               if (document.forms[formName].elements[formFieldAttributes[i]][2].checked == true) URL2= URL2 + '&_' + i + 'firstValues=' + database3; //both
             }
           else
            {  //if attribute name is source like in habitats references search(only there)
               if (formFieldAttributes[i] == "source")
                  {
                    if (document.forms[formName].elements[formFieldAttributes[i]][0].checked == true) URL2= URL2 + '&_' + i + 'firstValues='+source1; //source
                    if (document.forms[formName].elements[formFieldAttributes[i]][1].checked == true) URL2= URL2 + '&_' + i + 'firstValues='+source2; //other information
                  }
               else
                 {
                   if(formFieldAttributes[i] == "searchSynonyms" && trim(pageName) == "species-names.jsp")
                   {
                     if(document.forms[formName].elements[formFieldAttributes[i]].type='checkbox')
                       if(document.forms[formName].elements[formFieldAttributes[i]].checked == true)
                          URL2= URL2 + '&_' + i + 'firstValues=true';
                       else
                          URL2= URL2 + '&_' + i + 'firstValues=false';
                   } else
                   {
                       if (document.forms[formName].elements[formFieldAttributes[i]] != null)
                          URL2= URL2 + '&_' + i + 'firstValues=' + trim(escape(document.forms[formName].elements[formFieldAttributes[i]].value));
                       else URL2= URL2 + '&_' + i + 'firstValues=';
                   }
                 }
            }
          URL2= URL2 + '&_' + i + 'lastValues=';
        }
      /////////
      //elements like operator "between" witch have first value and last value (witch have two form fields)
      if(formFieldAttributes[i].indexOf("/") != -1)
           {
            elementsArray = formFieldAttributes[i].split("/");
            if(elementsArray !=null && elementsArray.length>1)
               {
                 var firstVal = "";
                 var lastVal = "";
                 if (document.forms[formName].elements[elementsArray[0]] !=null ) 
                      firstVal = trim(escape(document.forms[formName].elements[elementsArray[0]].value));
                 if(elementsArray.length==3)
                   {  // like searchString/searchStringMin/searchStringMax from sites-size search
                      if(document.forms[formName].elements[elementsArray[2]] != null)
                        {
                           lastVal = trim(escape(document.forms[formName].elements[elementsArray[2]].value));
                           if (document.forms[formName].elements[elementsArray[1]] !=null ) firstVal = trim(escape(document.forms[formName].elements[elementsArray[1]].value));
                        }
                   }
                 if(elementsArray.length==2)
                   {  //like date/date2 from habitats-references search
                   if(document.forms[formName].elements[elementsArray[1]] != null) lastVal = trim(escape(document.forms[formName].elements[elementsArray[1]].value));
                   }
                 URL2= URL2 + '&_' + i + 'firstValues=' + firstVal;
                 URL2= URL2 + '&_' + i + 'lastValues=' + lastVal;
               }
           }
       /////////
       // elements like "sourceDB" on sites searches
       if(formFieldAttributes[i].indexOf(",") != -1)
         {
            elementsArray = formFieldAttributes[i].split(",");
            if(elementsArray !=null && elementsArray.length>1)
               {
                 var elem = "";
                 for(j=0;j<elementsArray.length;j++)
                    {
                       if (document.forms[formName].elements[elementsArray[j]].checked==true) elem = elem + elementsArray[j] +"=true,";
                    }
                 URL2= URL2 + '&_' + i + 'firstValues=' + elem;
                 URL2= URL2 + '&_' + i + 'lastValues=';
               }
         }
        //fill operators vector
                var val ="";
                if(formFieldOperators[i] != null && formFieldOperators[i].length > 0)
                 {
                    val = trim(escape(document.forms[formName].elements[formFieldOperators[i]].value));
                    if(isValueNumber(val)) { URL2= URL2 + '&_' + i + 'operators=' + val; }
                    else { URL2= URL2 + '&_' + i + 'operators=' + val.substring(val.length-1); }
                 }
                else  URL2= URL2 + '&_' + i + 'operators='+operators[i];
     }
 }
 eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=500,height=400,left=300,top=80');");
 }
}


function isValueNumber1(s)
{
var nr = parseInt(s);
if (isNaN(nr)) return false;
else return true;
}

function isValueNumber(s)
{
if(s==null) return false;
 else {
 var isGoodNumber = true;
 for (j=0;j<s.length;j++) if (isValueNumber1(s.charAt(j))==false) isGoodNumber = false;
 return isGoodNumber;
 }
}
