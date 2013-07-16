-- clean up web content table from DiGiR records
update eunis_web_content set content_valid=0 where id_page like '%digir%' and  content_valid=1;