<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        exclude-result-prefixes="xsi"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no"/>

  <xsl:param name="tablename" select="'unknown_table'"/>

  <xsl:template match="mysqldump">
    <dataset>
      <xsl:apply-templates select="database/table_data/row"/>
    </dataset>
  </xsl:template>

  <xsl:template match="resultset">
    <dataset>
      <xsl:apply-templates select="row"/>
    </dataset>
  </xsl:template>

  <xsl:template match="table_data/row">
    <xsl:element name="{../@name}">
       <xsl:apply-templates select="field"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="resultset/row">
    <xsl:element name="{$tablename}">
       <xsl:apply-templates select="field"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="field">
    <xsl:if test="not(@xsi:nil='true')">
      <xsl:attribute name="{@name}"><xsl:value-of select="text()"/></xsl:attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
