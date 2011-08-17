CREATE  TABLE `dc_attributes` (
  `ID_DC` INT(11) NOT NULL ,
  `NAME` ENUM('abstract', 'accessRights', 'accrualMethod', 'accrualPeriodicity', 'accrualPolicy', 'alternative', 'audience', 'available', 'bibliographicCitation', 'conformsTo', 'contributor', 'coverage', 'created', 'creator', 'date', 'dateAccepted', 'dateCopyrighted', 'dateSubmitted', 'description', 'educationLevel', 'extent', 'format', 'hasFormat', 'hasPart', 'hasVersion', 'identifier', 'instructionalMethod', 'isFormatOf', 'isPartOf', 'isReferencedBy', 'isReplacedBy', 'isRequiredBy', 'issued', 'isVersionOf', 'language', 'license', 'mediator', 'medium', 'modified', 'provenance', 'publisher', 'references', 'relation', 'replaces', 'requires', 'rights', 'rightsHolder', 'source', 'spatial', 'subject', 'tableOfContents', 'temporal', 'title', 'type', 'valid','rdf:type') NOT NULL ,
  `OBJECT` VARCHAR(255) NOT NULL ,
  `OBJECTLANG` VARCHAR(10) NOT NULL ,
  `TYPE` ENUM('reference', '', 'string', 'integer', 'decimal', 'boolean', 'dateTime', 'date') NULL ,
  PRIMARY KEY (`ID_DC`, `NAME`, `OBJECT`, `OBJECTLANG`) 
);

ALTER TABLE `dc_index` ADD COLUMN `SOURCE` TEXT NULL DEFAULT NULL  AFTER `REFERENCE` , ADD COLUMN `EDITOR` VARCHAR(255) NULL DEFAULT NULL  AFTER `SOURCE` , ADD COLUMN `JOURNAL_TITLE` VARCHAR(255) NULL DEFAULT NULL  AFTER `EDITOR` , ADD COLUMN `BOOK_TITLE` VARCHAR(255) NULL DEFAULT NULL  AFTER `JOURNAL_TITLE` , ADD COLUMN `JOURNAL_ISSUE` VARCHAR(50) NULL DEFAULT NULL  AFTER `BOOK_TITLE` , ADD COLUMN `ISBN` VARCHAR(20) NULL DEFAULT NULL  AFTER `JOURNAL_ISSUE` , ADD COLUMN `URL` VARCHAR(255) NULL DEFAULT NULL  AFTER `ISBN` , ADD COLUMN `CREATED` YEAR NULL DEFAULT NULL  AFTER `URL` , ADD COLUMN `TITLE` VARCHAR(255) NULL DEFAULT NULL  AFTER `CREATED` , ADD COLUMN `ALTERNATIVE` VARCHAR(255) NULL DEFAULT NULL  AFTER `TITLE` , ADD COLUMN `PUBLISHER` TEXT NULL DEFAULT NULL  AFTER `ALTERNATIVE`;


-- Update DC_INDEX with values from old tables
UPDATE dc_index, dc_source
	SET 
		dc_index.SOURCE = dc_source.SOURCE,
		dc_index.EDITOR = dc_source.EDITOR,
		dc_index.JOURNAL_TITLE = dc_source.JOURNAL_TITLE,
		dc_index.BOOK_TITLE = dc_source.BOOK_TITLE,
		dc_index.JOURNAL_ISSUE = dc_source.JOURNAL_ISSUE,
		dc_index.ISBN = dc_source.ISBN,
		dc_index.URL = dc_source.URL
	WHERE 
		dc_index.ID_DC = dc_source.ID_DC;
		
UPDATE dc_index, dc_title
	SET 
		dc_index.TITLE = dc_title.TITLE, 
		dc_index.ALTERNATIVE = dc_title.ALTERNATIVE
	WHERE 
		dc_index.ID_DC = dc_title.ID_DC;
		
UPDATE dc_index, dc_publisher
	SET 
		dc_index.PUBLISHER = dc_publisher.PUBLISHER
	WHERE 
		dc_index.ID_DC = dc_publisher.ID_DC;

UPDATE dc_index, dc_date
	SET 
		dc_index.CREATED = dc_date.CREATED
	WHERE 
		dc_index.ID_DC = dc_date.ID_DC;

-- Update DC_ATTRIBUTES with values from old tables
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'date', MDATE, '', 'date' FROM DC_DATE WHERE MDATE IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'valid', VALID, '', 'date' FROM DC_DATE WHERE VALID IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'available', AVAILABLE, '', 'date' FROM DC_DATE WHERE AVAILABLE IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'issued', ISSUED, '', 'date' FROM DC_DATE WHERE ISSUED IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'modified', MODIFIED, '', 'date' FROM DC_DATE WHERE MODIFIED IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'contributor', CONTRIBUTOR, '', 'string' FROM DC_CONTRIBUTOR WHERE CONTRIBUTOR IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'coverage', COVERAGE, '', 'string' FROM DC_COVERAGE WHERE COVERAGE IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'spatial', `SPATIAL`, '', 'string' FROM DC_COVERAGE WHERE `SPATIAL` IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'temporal', TEMPORAL, '', 'string' FROM DC_COVERAGE WHERE TEMPORAL IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'creator', CREATOR, '', 'string' FROM DC_CREATOR WHERE CREATOR IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'description', DESCRIPTION, '', 'string' FROM DC_DESCRIPTION WHERE DESCRIPTION IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'tableOfContents', TOC, '', 'string' FROM DC_DESCRIPTION WHERE TOC IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'abstract', ABSTRACT, '', 'string' FROM DC_DESCRIPTION WHERE ABSTRACT IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'format', FORMAT, '', 'string' FROM DC_FORMAT WHERE FORMAT IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'extent', EXTENT, '', 'string' FROM DC_FORMAT WHERE EXTENT IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'medium', MEDIUM, '', 'string' FROM DC_FORMAT WHERE MEDIUM IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'identifier', IDENTIFIER, '', 'string' FROM DC_IDENTIFIER WHERE IDENTIFIER IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'language', `LANGUAGE`, '', 'string' FROM DC_LANGUAGE WHERE `LANGUAGE` IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'relation', RELATION, '', 'string' FROM DC_RELATION WHERE RELATION IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isVersionOf', IS_VERSION_OF, '', 'string' FROM DC_RELATION WHERE IS_VERSION_OF IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'hasVersion', HAS_VERSION, '', 'string' FROM DC_RELATION WHERE HAS_VERSION IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isReplacedBy', IS_REPLACED_BY, '', 'string' FROM DC_RELATION WHERE IS_REPLACED_BY IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isRequiredBy', IS_REQUIRED_BY, '', 'string' FROM DC_RELATION WHERE IS_REQUIRED_BY IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'requires', REQUIRES, '', 'string' FROM DC_RELATION WHERE REQUIRES IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isPartOf', IS_PART_OF, '', 'string' FROM DC_RELATION WHERE IS_PART_OF IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'hasPart', HAS_PART, '', 'string' FROM DC_RELATION WHERE HAS_PART IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isReferencedBy', IS_REFERENCED_BY, '', 'string' FROM DC_RELATION WHERE IS_REFERENCED_BY IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'references', `REFERENCES`, '', 'string' FROM DC_RELATION WHERE `REFERENCES` IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'isFormatOf', IS_FORMAT_OF, '', 'string' FROM DC_RELATION WHERE IS_FORMAT_OF IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'hasFormat', HAS_FORMAT, '', 'string' FROM DC_RELATION WHERE HAS_FORMAT IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'rights', RIGHTS, '', 'string' FROM DC_RIGHTS WHERE RIGHTS IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'subject', SUBJECT, '', 'string' FROM DC_SUBJECT WHERE SUBJECT IS NOT NULL);
INSERT INTO dc_attributes (ID_DC, `NAME`, `OBJECT`, OBJECTLANG, TYPE) (SELECT ID_DC, 'type', TYPE, '', 'string' FROM DC_TYPE WHERE TYPE IS NOT NULL);



DROP TABLE dc_contributor;
DROP TABLE dc_coverage;
DROP TABLE dc_creator;
DROP TABLE dc_date;
DROP TABLE dc_description;
DROP TABLE dc_format;
DROP TABLE dc_identifier;
DROP TABLE dc_language;
DROP TABLE dc_publisher;
DROP TABLE dc_relation;
DROP TABLE dc_rights;
DROP TABLE dc_source;
DROP TABLE dc_subject;
DROP TABLE dc_title;
DROP TABLE dc_type;








