
--
-- create new table for DC attributes labels
--

CREATE TABLE dc_attribute_labels (
  NAME varchar(100) not null,
  LABEL varchar(100) default null,
  PRIMARY KEY (NAME)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- populate new table with name-label pairs used in Java so far
--

insert ignore into dc_attribute_labels values('abstract', 'Abstract');
insert ignore into dc_attribute_labels values('accessRights', 'Access Rights');
insert ignore into dc_attribute_labels values('accrualMethod', 'Accrual Method');
insert ignore into dc_attribute_labels values('accrualPeriodicity', 'Accrual Periodicity');
insert ignore into dc_attribute_labels values('accrualPolicy', 'Accrual Policy');
insert ignore into dc_attribute_labels values('alternative', 'Alternative Title');
insert ignore into dc_attribute_labels values('audience', 'Audience');
insert ignore into dc_attribute_labels values('available', 'Date Available');
insert ignore into dc_attribute_labels values('bibliographicCitation', 'Bibliographic Citation');
insert ignore into dc_attribute_labels values('conformsTo', 'Conforms To');
insert ignore into dc_attribute_labels values('contributor', 'Contributor');
insert ignore into dc_attribute_labels values('coverage', 'Coverage');
insert ignore into dc_attribute_labels values('created', 'Date Created');
insert ignore into dc_attribute_labels values('creator', 'Creator');
insert ignore into dc_attribute_labels values('date', 'Date');
insert ignore into dc_attribute_labels values('dateAccepted', 'Date Accepted');
insert ignore into dc_attribute_labels values('dateCopyrighted', 'Date Copyrighted');
insert ignore into dc_attribute_labels values('dateSubmitted', 'Date Submitted');
insert ignore into dc_attribute_labels values('description', 'Description');
insert ignore into dc_attribute_labels values('educationLevel', 'Audience Education Level');
insert ignore into dc_attribute_labels values('extent', 'Extent');
insert ignore into dc_attribute_labels values('format', 'Format');
insert ignore into dc_attribute_labels values('hasFormat', 'Has Format');
insert ignore into dc_attribute_labels values('hasPart', 'Has Part');
insert ignore into dc_attribute_labels values('hasVersion', 'Has Version');
insert ignore into dc_attribute_labels values('identifier', 'Identifier');
insert ignore into dc_attribute_labels values('instructionalMethod', 'Instructional Method');
insert ignore into dc_attribute_labels values('isFormatOf', 'Is Format Of');
insert ignore into dc_attribute_labels values('isPartOf', 'Is Part Of');
insert ignore into dc_attribute_labels values('isReferencedBy', 'Is Referenced By');
insert ignore into dc_attribute_labels values('isReplacedBy', 'Is Replaced By');
insert ignore into dc_attribute_labels values('isRequiredBy', 'Is Required By');
insert ignore into dc_attribute_labels values('issued', 'Date Issued');
insert ignore into dc_attribute_labels values('isVersionOf', 'Is Version Of');
insert ignore into dc_attribute_labels values('language', 'Language');
insert ignore into dc_attribute_labels values('license', 'License');
insert ignore into dc_attribute_labels values('mediator', 'Mediator');
insert ignore into dc_attribute_labels values('medium', 'Medium');
insert ignore into dc_attribute_labels values('modified', 'Date Modified');
insert ignore into dc_attribute_labels values('provenance', 'Provenance');
insert ignore into dc_attribute_labels values('publisher', 'Publisher');
insert ignore into dc_attribute_labels values('references', 'References');
insert ignore into dc_attribute_labels values('relation', 'Relation');
insert ignore into dc_attribute_labels values('replaces', 'Replaces');
insert ignore into dc_attribute_labels values('requires', 'Requires');
insert ignore into dc_attribute_labels values('rights', 'Rights');
insert ignore into dc_attribute_labels values('rightsHolder', 'Rights Holder');
insert ignore into dc_attribute_labels values('source', 'Source');
insert ignore into dc_attribute_labels values('spatial', 'Spatial Coverage');
insert ignore into dc_attribute_labels values('subject', 'Subject');
insert ignore into dc_attribute_labels values('tableOfContents', 'Table Of Contents');
insert ignore into dc_attribute_labels values('temporal', 'Temporal Coverage');
insert ignore into dc_attribute_labels values('title', 'Title');
insert ignore into dc_attribute_labels values('type', 'Type');
insert ignore into dc_attribute_labels values('valid', 'Date Valid');
insert ignore into dc_attribute_labels values('rdf:type', 'Type');
insert ignore into dc_attribute_labels values('owl:sameAs', 'Same As');

--
-- ensure the new table has absolutely all names already present in dc_attributes
--

insert ignore into dc_attribute_labels select NAME, IF(LOCATE(':',NAME)<=0, NAME, substr(NAME,LOCATE(':',NAME)+1)) from dc_attributes;

--
-- convert dc_attributes into InnoDb, so we can use foreign jey relations
--

alter table dc_attributes ENGINE=InnoDB;

--
-- remove the enum constraint from dc_attributes.name
--

alter table dc_attributes change column NAME NAME varchar(100) not null;

--
-- add foriegn key from dc_attribute.name to dc_attribute_labels.name
--

alter table dc_attributes add foreign key (NAME) references dc_attribute_labels(name) ON DELETE CASCADE ON UPDATE CASCADE;


