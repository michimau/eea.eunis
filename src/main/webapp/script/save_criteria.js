function choicepren5(fr,show,URL) {
    var val = new Array(show.length);
    for (i=0;i<val.length;i++) val[i]=true;
    /*
    alert(show.length);
    var t ="";
    for (i=0;i<show.length;i++){
    t=show[i];
    alert(t);
    if (fr.t.checked == true) val[i]  = true;
    }
    */
    var url1 = "";
    for (i=0;i<show.length;i++){
    url1+="&"+show[i]+"="+val[i];
    }

    URL2= URL + url1;
    self.location.href=URL2;

}

 function choicepren1(URL) {
    self.location.href=URL;
}
