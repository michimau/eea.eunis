INSERT INTO eunis_web_content (ID_PAGE, CONTENT, CONTENT_VALID) VALUES ('gbif', 'GBIF observations', 1);
ALTER TABLE chm62edt_tab_page_species ADD COLUMN GBIF VARCHAR(1) DEFAULT 'Y';