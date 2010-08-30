-- please see the wiki page located @ https://svn.eionet.europa.eu/projects/Biodiversity/wiki/LevenshteinUDFCompilation
-- for more information on how to apply this update.

-- linux
create function levenshtein returns int soname 'levenshtein.so';

-- windows
create function levenshtein returns int soname 'levenshtein.dll';