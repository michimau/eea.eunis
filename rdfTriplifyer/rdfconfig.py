
triplify = {}

triplify['baseurl'] = "http://eunis.eea.europa.eu/"

triplify['database'] = "eunisimport"
triplify['user'] = "eunisimp"
triplify['password'] = "monetmanet"

# Triplify uses URIs to identify objects. In order to simplify their handling
# you should define shortcuts (i.e. namespace prefixes) for all namespaces
# from which you want to use URIs.
# A 'vocabulary' entry entry is mandatory - it specifies, which default prefix
# should be used for vocabulary elements such as classes and properties. Other
# than the prefix for instances this prefix should be shared between different
# installations of a certain Web application on the Web.
#
triplify['namespaces']= {
        'vocabulary': 'http://eunis.eea.europa.eu/rdf/schema.rdf#',
        'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
        'rdfs': 'http://www.w3.org/2000/01/rdf-schema#',
        'geo': 'http://www.w3.org/2003/01/geo/wgs84_pos#',
        'owl': 'http://www.w3.org/2002/07/owl#',
        'foaf': 'http://xmlns.com/foaf/0.1/',
        'sioc': 'http://rdfs.org/sioc/ns#',
        'dwc': 'http://rs.tdwg.org/dwc/terms/',
        'dc': 'http://purl.org/dc/elements/1.1/',
        'dcterms': 'http://purl.org/dc/terms/',
        'skos': 'http://www.w3.org/2004/02/skos/core#',
        'xsd': 'http://www.w3.org/2001/XMLSchema#',
        'cc': 'http://creativecommons.org/ns#',
        'update': 'http://triplify.org/vocabulary/update#',
}

# The core of triplify are SQL queries, which select the information to be made
# available.
#
# You can provide a number of arbitrary queries. Each query, however, should
# select information about an object of a certain type. This type, which serves
# as an index in the associative queries configuration array, is also used to
# construct corresponding URIs for the objects returned by the query.
#
# The first column returned by the query represents the ID of the object and
# has to be named "id", all other columns represent characteristics (or
# properties of this object). As column identifier you should reuse existing
# vocabularies whenever possible. If your "user" table, for example, contains a
# column named "first_name" this can be easily mapped to the corresponding FOAF
# property using: "SELECT id,first_name AS 'foaf:firstName' FROM user".
#
# You can use the following column naming convention in order to inform
# Triplify about the datatype or language of a column:
#  SELECT id,price AS 'price^^xsd:decimal',desc AS 'rdf:label@en' FROM products
# However, Triplify tries to autodetect and convert timestamps appropriately.
#
# Similarly, you can indicate that a column represents an objectProperty
# pointing to other objects (foreign key):
#   SELECT id,user_id 'sioc:has_creator->user'
#
# Only select information, which does not contain sensitive information and
# can be made public. For example, email adresses and password (hashes) should
# never be exposed. However, you can use the database function SHA to
# mask email addresses, e.g.:
#  SELECT SHA(CONCAT('mailto:',email)) AS 'foaf:mbox_sha1sum' FROM users
#
# The following queries are example queries and have to be replaced by queries
# suitable for your database schema.
#
triplify['queries']= {
      'geoscope': """SELECT id_geoscope as id,
                    IF(id_geoscope_parent=-1,NULL,id_geoscope_parent) AS hasParentScope,
                    IF(id_dc=-1,NULL,id_dc) AS hasReference, area_type
                    FROM chm62edt_geoscope""",
      'biogeoregions':
                   (""" SELECT CODE AS id,
                       CODE_EEA AS codeEEA,
                       NAME AS areaName,
                       CONCAT('http://rdfdata.eionet.europa.eu/eea/biogeographic-regions/',RIGHT(CODE_EEA,3)) AS 'owl:sameAs->'
                       FROM chm62edt_biogeoregion WHERE CODE_EEA <>'nd'""",
                   """ SELECT CODE_BIOGEOREGION AS id,
                       CODE_COUNTRY AS hasCountry
                       FROM chm62edt_country_biogeoregion
                       WHERE CODE_BIOGEOREGION<>'nd'"""),


        'speciesgroup': """SELECT ID_GROUP_SPECIES AS id, common_name, scientific_name FROM chm62edt_group_species""",

        'countrybiogeo': """SELECT CONCAT(CODE_COUNTRY,':',CODE_BIOGEOREGION) AS id,
                        CODE_BIOGEOREGION AS forBioGeoRegion,
                        CODE_COUNTRY AS forCountry,
                        PERCENT AS coverage
                        FROM chm62edt_country_biogeoregion
                        WHERE CODE_BIOGEOREGION<>'nd'""",

        'countries': ("""SELECT eunis_area_code AS id, 
                    eunis_area_code AS eunisAreaCode,
                    area_name AS areaName,
                    area_name_en as 'areaName@en',
                    area_name_fr as 'areaName@fr',
                    iso_2l AS isoCode2,
                    IF(eunis_area_code IS NULL OR ISO_3_WCMC<>ISO_3_WCMC_PARENT, NULL, CONCAT('http://rdfdata.eionet.europa.eu/eea/countries/',eunis_area_code)) AS 'owl:sameAs->',
                    iso_3l AS isoCode3,
                    iso_n,
                    iso_2_wcmc, iso_3_wcmc, iso_3_wcmc_parent, tel_code, areucd, sort_number, country_type, surface,
                    ngo, number_design_area, source, political_status, population, pop_density, capital,
                    currency_code, currency_name,
                    lat_min, lat_max, long_min, long_max, alt_min, alt_max, selection FROM chm62edt_country""",
                    """SELECT CODE_COUNTRY AS id, CONCAT(CODE_COUNTRY,':',
                    CODE_BIOGEOREGION) AS hasBioGeoRegion
                    FROM chm62edt_country_biogeoregion
                    WHERE CODE_BIOGEOREGION<>'nd'"""),

}


# Some of the columns of the Triplify queries will contain references to other
# objects rather than literal values. The following configuration array
# specifies, which columns are references to objects of which type.
#
triplify['objectProperties']= {
        'hasReference': 'references',
        'hasParentScope': 'geoscope',
        'forBioGeoRegion': 'biogeoregions',
        'hasBioGeoRegion': 'countrybiogeo',
        'forCountry': 'countries',
        'hasCountry': 'countries',
}

# Objects are classified according to their type. However, you can specify
# a mapping here, if objects of a certain type should be associated with a
# different class (e.g. classify all users as 'foaf:person'). If you are
# unsure it is safe to leave this configuration array empty.
#
triplify['classMap']= {
        'abundance': 'Abundance',
        'countries': 'Country',
        'designations': 'Designation',
        'documents': 'Document',
        'geoscope': 'Geoscope',
        'site': 'Site',
        'source': 'Source',
        'taxon': 'Taxon',
}

# You can attach license information to your content.
# A popular license is Creative Commons Attribution, which allows sharing and
# remixing under the condition of attributing the original author.
#
triplify['license']='http://creativecommons.org/licenses/by/3.0/us/'

# Additional metadata
# You can add arbitrary metadata. The keys of the following array are
# properties, the values will be represented as respective property values.
#
triplify['metadata']= {
        'dcterms:title': 'ITIS',
        'dcterms:publisher': 'Integrated Taxonomic Information System'
}

# Linked Data Depth
#
# Specify on which URI level to expose the data - possible values are:
#  - Use 0 or ommit to expose all available content on the highest level
#    all content will be exposed when /triplify/ is accessed on your server
#    this configuration is recommended for small to medium websites.
#  - Use 1 to publish only links to the classes on the highest level and all
#    content will be exposed when for example /triplify/user/ is accessed.
#  - Use 2 to publish only links on highest and classes level and all
#    content will be exposed on the instance level, e.g. when /triplify/user/1/
#    is accessed.
#
triplify['LinkedDataDepth']='0'

# Callback Functions
#
# Some of the columns of the Triplify queries will contain data, which has to
# be processed before exposed as RDF (literals). This configuration array maps
# column names to respective functions, which have to take the data value as a
# parameter and return it processed.
#
triplify['CallbackFunctions']= {
}
