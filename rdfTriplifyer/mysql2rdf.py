#!/usr/bin/python
# -*- coding: utf-8 -*-

# Script to dump a table in RDF
# http://www.python.org/dev/peps/pep-0249/

import MySQLdb
from cgi import escape
import sys, string, getopt, time
from rdfconfig import triplify

class Triplify(object):

    def __init__(self):
        self.db = MySQLdb.connect('localhost', triplify['user'], triplify['password'], triplify['database'],
                connect_timeout = 30, charset = "utf8")
        self.c = self.db.cursor()
        self.tablename = "Table"

    def output(self, s):
        sys.stdout.write(s.encode('utf-8'))

    def setTable(self, table):
        self.tablename = table

    def close(self):
        self.c.close()
        self.db.close()

    def writeProperty(self, name, value, fieldtype, datatype, langcode=''):
        """ Write a property.
        """
        ref_ns = triplify['objectProperties'].get(name)
        if ref_ns:
            self.output('<%s rdf:resource="%s/%s"/>\n' % (name, ref_ns, escape(str(value))))
        elif datatype[:2] == '->':
            if len(datatype) == 2:
                self.output('<%s rdf:resource="%s"/>\n' % (name, escape(str(value))))
            else:
                self.output('<%s rdf:resource="%s/%s"/>\n' % (name, datatype[2:], escape(str(value))))
        else:
            typelang_attr = ""
            if datatype != '':
                dt_ns = datatype.find(":")
                if dt_ns >= 0:
                    datatype = triplify['namespaces'].get(datatype[:dt_ns]) + datatype[dt_ns+1:]
                typelang_attr = ' rdf:datatype="%s"' % datatype
            elif langcode != '':
                typelang_attr = ' xml:lang="%s"' % langcode

            if fieldtype in (MySQLdb.FIELD_TYPE.SHORT, MySQLdb.FIELD_TYPE.INT24, MySQLdb.FIELD_TYPE.LONG):
                self.output('<%s%s>%d</%s>\n' % (name, typelang_attr, value, name))
            elif fieldtype in (MySQLdb.FIELD_TYPE.FLOAT, MySQLdb.FIELD_TYPE.DOUBLE):
                self.output('<%s%s>%s</%s>\n' % (name, typelang_attr, escape(str(value)), name))
            elif fieldtype in (MySQLdb.FIELD_TYPE.DATE, MySQLdb.FIELD_TYPE.TIME, MySQLdb.FIELD_TYPE.DATETIME):
                self.output('<%s%s>%s</%s>\n' % (name, typelang_attr, escape(str(value)), name))
            else:
                self.output('<%s%s>%s</%s>\n' % (name, typelang_attr, escape(value), name))

    def genrecords(self, query, addtype=False):
        """ Generate the records
        """
        if addtype:
            rdftype = triplify['classMap'].get(self.tablename, self.tablename.capitalize())
        else:
            rdftype = "rdf:Description"
        self.c.execute(query)
        datadefs = self.querystruct(self.c)
        row = self.c.fetchone()
        while row:
            self.output('<%s rdf:about="%s/%s">\n' % (rdftype, self.tablename, str(row[0])))
            row_inx = 1 # Row[0] is for the ID.
            for coldesc in datadefs[1:]:
                value = row[row_inx]
                if value is not None and value != "":
                    self.writeProperty(coldesc['Name'], value, coldesc['Type'], coldesc['Datatype'], coldesc['Language'])
                row_inx += 1
            self.output('</%s>\n\n' % rdftype)
            row = self.c.fetchone()

    def __base_record(self):
        self.output('<rdf:Description rdf:about="%s">\n' % triplify['baseurl'])
        self.writeProperty("cc:license", triplify['license'], MySQLdb.FIELD_TYPE.VAR_STRING, '->')
        for name, value in triplify['metadata'].items():
            self.writeProperty(name, value, MySQLdb.FIELD_TYPE.VAR_STRING, '', '')
        self.output('</rdf:Description>\n\n')
            

    def rdf(self):
        self.output('<?xml version="1.0" encoding="UTF-8"?>\n')
        self.output('<rdf:RDF')
        for ns, uri in triplify['namespaces'].items():
            if ns == 'vocabulary':
                self.output(' xmlns="%s"\n' % uri)
            else:
                self.output(' xmlns:%s="%s"\n' % (ns, uri))
        self.output(' xml:base="%s">\n' % triplify['baseurl'])

        #self.__base_record()

        queries = triplify['queries'].get(self.tablename)
        if isinstance(queries, list) or isinstance(queries, tuple):
            self.genrecords(queries[0],True)
            for query in queries[1:]:
                self.genrecords(query, False)
        else:
          self.genrecords(queries, True)

        self.output('</rdf:RDF>\n')

    # Mapping of Mysql types to XML Schema types
    xsd_types = {
        MySQLdb.FIELD_TYPE.DECIMAL : 'xsd:decimal',
        MySQLdb.FIELD_TYPE.TINY : 'xsd:integer',
        MySQLdb.FIELD_TYPE.SHORT : 'xsd:integer', # 2
        MySQLdb.FIELD_TYPE.LONG : 'xsd:integer',  # 3
        MySQLdb.FIELD_TYPE.FLOAT : 'xsd:float', # 4
        MySQLdb.FIELD_TYPE.DOUBLE : 'xsd:double', # 5
        MySQLdb.FIELD_TYPE.NULL : '',
        MySQLdb.FIELD_TYPE.TIMESTAMP : 'xsd:dateTime',
        MySQLdb.FIELD_TYPE.LONGLONG : 'xsd:integer',
        MySQLdb.FIELD_TYPE.INT24 : 'xsd:integer',
        MySQLdb.FIELD_TYPE.DATE : 'xsd:date',
        MySQLdb.FIELD_TYPE.TIME : 'xsd:time',
        MySQLdb.FIELD_TYPE.DATETIME : 'xsd:dateTime',
        MySQLdb.FIELD_TYPE.YEAR : 'xsd:gYear',
        MySQLdb.FIELD_TYPE.NEWDATE : 'xsd:date',
        MySQLdb.FIELD_TYPE.NEWDECIMAL : 'xsd:decimal',
        MySQLdb.FIELD_TYPE.ENUM : '',
        MySQLdb.FIELD_TYPE.SET : '',
        MySQLdb.FIELD_TYPE.TINY_BLOB : '',
        MySQLdb.FIELD_TYPE.MEDIUM_BLOB : '',
        MySQLdb.FIELD_TYPE.LONG_BLOB : '',
        MySQLdb.FIELD_TYPE.BLOB : '',  # 252
        MySQLdb.FIELD_TYPE.VAR_STRING : '',  # 253
        MySQLdb.FIELD_TYPE.STRING : '',
        MySQLdb.FIELD_TYPE.GEOMETRY : ''
    }

    quote_xlate = {
        MySQLdb.FIELD_TYPE.DECIMAL : False,
        MySQLdb.FIELD_TYPE.TINY : False,
        MySQLdb.FIELD_TYPE.SHORT : False, # 2
        MySQLdb.FIELD_TYPE.LONG : False,  # 3
        MySQLdb.FIELD_TYPE.FLOAT : False, # 4
        MySQLdb.FIELD_TYPE.DOUBLE : False, # 5
        MySQLdb.FIELD_TYPE.NULL : False,
        MySQLdb.FIELD_TYPE.TIMESTAMP : True,
        MySQLdb.FIELD_TYPE.LONGLONG : False,
        MySQLdb.FIELD_TYPE.INT24 : False,
        MySQLdb.FIELD_TYPE.DATE : True,
        MySQLdb.FIELD_TYPE.TIME : True,
        MySQLdb.FIELD_TYPE.DATETIME : True,
        MySQLdb.FIELD_TYPE.YEAR : True,
        MySQLdb.FIELD_TYPE.NEWDATE : True,
        MySQLdb.FIELD_TYPE.NEWDECIMAL : False,
        MySQLdb.FIELD_TYPE.ENUM : True,
        MySQLdb.FIELD_TYPE.SET : True,
        MySQLdb.FIELD_TYPE.TINY_BLOB : True,
        MySQLdb.FIELD_TYPE.MEDIUM_BLOB : True,
        MySQLdb.FIELD_TYPE.LONG_BLOB : True,
        MySQLdb.FIELD_TYPE.BLOB : True,  # 252
        MySQLdb.FIELD_TYPE.VAR_STRING : True,  # 253
        MySQLdb.FIELD_TYPE.STRING : True,
        MySQLdb.FIELD_TYPE.GEOMETRY : False
    }


    def parseName(self, complexname, datatype=""):
        """ Parses a column name. It can be parsed into three parts: name, type, language
            hasRef-> becomes "hasRef","->",""
            hasRef->expert becomes "hasRef","->expert",""
            price^^xsd:decimal becomes "price","xsd:decimal",""
            rdfs:label@fr becomes "rdfs:label","","fr"
        """
        name = complexname
        language = ""
        foundReference = complexname.find('->')
        if foundReference >= 0:
            name = complexname[:foundReference]
            datatype = complexname[foundReference:]
        else:
            foundDatatype = complexname.find('^^')
            if foundDatatype >= 0:
                name, datatype = complexname.split('^^')
            else:
                foundLanguage = complexname.find('@')
                if foundLanguage >= 0:
                    name, language = complexname.split('@')
                    datatype = ""
        return (name, datatype, language)

    def querystruct(self, cursor):
        rarray = []
        r = {}
        Field = 0
        for name, field_type, display_size, internal_size, precision, scale, null_ok in cursor.description:
            info = {}
            info['Type'] = field_type
            datatype = self.xsd_types.get(field_type, '')
            info['Name'], info['Datatype'], info['Language'] = self.parseName(name, datatype)
            info['Quote'] = self.quote_xlate.get(field_type, True)
            info['Nullable'] = null_ok
            r[Field] = info
            rarray.append(info)
            Field += 1
        return rarray

def exitwithusage(exitcode=2):
    """ Print out usage information and exit """
    print >>sys.stderr, "Usage: %s [-e] [-s] [-t table|-q query] [-a as-table] ..." % sys.argv[0]
    sys.exit(exitcode)

if __name__ == '__main__':
    query = None
    tablename = None
    operation = "rdf"

    try:
        opts, args = getopt.getopt(sys.argv[1:], "t:r")
    except getopt.GetoptError:
        exitwithusage()

    for o, a in opts:
        if o == "-t":
            tablename = a
        if o == "-r":
           operation = "rdf"

    d = Triplify()
    if tablename is not None:
        d.setTable(tablename)
        
    if operation == "rdf":
        d.rdf()
    else:
        print "Don't know what operation you want"
    d.close()

