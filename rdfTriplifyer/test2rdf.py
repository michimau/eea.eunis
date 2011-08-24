#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest
import ConfigParser
import mysql2rdf

class TestNameParser(unittest.TestCase):

    def setUp(self):
        config = ConfigParser.SafeConfigParser()
        config.read('db.conf')
        dbuser = config.get('database', 'user')
        dbpass = config.get('database', 'password')
        dbdb = config.get('database', 'database')
        self.t = mysql2rdf.Triplify(dbuser, dbpass, dbdb)

    def testObject(self):
        """ Test reference """
        r = self.t.parseName("hasRef->export")
        self.assertEqual(('hasRef','->export',''), r)

        self.assertEqual(('hasRef','->',''), self.t.parseName("hasRef->"))
        self.assertEqual(('price','xsd:decimal',''), self.t.parseName("price^^xsd:decimal"))
        self.assertEqual(('title','','de'), self.t.parseName("title@de"))
        self.assertEqual(('rdfs:label','','de'), self.t.parseName("rdfs:label@de"))
        self.assertEqual(('rdfs:label','',''), self.t.parseName("rdfs:label"))
        self.assertEqual(('title','xsd:string',''), self.t.parseName("title","xsd:string"))

if __name__ == '__main__':
    unittest.main()

