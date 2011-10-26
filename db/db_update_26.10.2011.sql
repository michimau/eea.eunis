ALTER TABLE chm62edt_nature_object_picture ADD COLUMN `SOURCE_URL` VARCHAR(1024) DEFAULT NULL;
ALTER TABLE chm62edt_nature_object_picture ADD COLUMN `LICENSE` ENUM ( '','CC BY', 'CC BY-SA','CC BY-ND', 'CC BY-NC', 'CC BY-NC-SA','CC BY-NC-ND', 'Copyrighted','Public domain') DEFAULT '';
