CREATE TABLE chm62edt_nature_object_links (
  ID_NATURE_OBJECT int(11) NOT NULL default '-1',
  LINK varchar(1024),
  LINKTEXT varchar(50),
  KEY (ID_NATURE_OBJECT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Nature object HTML links';


insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"BBC page" FROM chm62edt_nature_object_attributes WHERE NAME="hasBBCPage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Conservation status (art. 17)" FROM chm62edt_nature_object_attributes WHERE NAME="art17SummaryPage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Biolib page" FROM chm62edt_nature_object_attributes WHERE NAME="hasBioLibPage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Bug Guide page" FROM chm62edt_nature_object_attributes WHERE NAME="hasBugGuidePage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Bird action plan" FROM chm62edt_nature_object_attributes WHERE NAME="hasBirdActionPlan");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"UNEP-WCMC page" FROM chm62edt_nature_object_attributes WHERE NAME="hasWCMCPage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Encyclopedia of Life" FROM chm62edt_nature_object_attributes WHERE NAME="hasEOLPage");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Wikipedia article" FROM chm62edt_nature_object_attributes WHERE NAME="hasWikipediaArticle");
insert into chm62edt_nature_object_links (SELECT ID_NATURE_OBJECT,OBJECT,"Wikispecies article" FROM chm62edt_nature_object_attributes WHERE NAME="hasWikispeciesArticle");


delete from chm62edt_nature_object_attributes WHERE NAME IN ("hasBBCPage","art17SummaryPage","hasBioLibPage","hasBugGuidePage","hasBirdActionPlan","hasWCMCPage","hasEOLPage","hasWikipediaArticle","hasWikispeciesArticle");